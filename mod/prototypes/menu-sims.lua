-- Menu simulations. Replaces the whole vanilla menu rotation with a set of lively
-- JJtorio scenes, so the old scenes no longer play. Base entities only and no mods
-- list, which avoids the known crash from adding a mod to a menu simulation.
--
-- What makes the base sims read well, and what this file copies:
--   * they load real bases on real ground at camera_zoom 1, so the frame is full and
--     grounded. We have no save, so each scene lays its own ground tiles first (kills
--     the lab checkerboard) and builds a dense block that fills the frame at zoom near
--     one. The old file zoomed out to 0.7 to 0.9, so sparse entities floated in an
--     empty void, which is why it looked off.
--   * the real camera fields are game.simulation.camera_position and camera_zoom, and
--     game.tick_paused must be false. Camera motion is slow or absent, letting the
--     action carry the scene, so drifts here are small amplitude over long periods.
--   * animation runs from script.on_nth_tick closures registered in init, like the base
--     biter and chase sims. Burner machines run by setting entity.energy directly,
--     belts stay full with LuaTransportLine.insert_at_back, inserters and assemblers do
--     real work off filled belts, and biters march in with commandable.set_command.
-- Every runtime call is guarded so a bad call degrades the scene instead of crashing
-- the menu. These init scripts run only at menu time and cannot be checked by a data
-- stage load, so they still need an in game look.

local uc = data.raw["utility-constants"] and data.raw["utility-constants"]["default"]
if not uc then return end

-- Shared Lua prelude, prepended to each scene. Each init is an isolated console
-- command, so helpers cannot be shared at runtime and are injected as source here.
local prelude = [[
local S = game.surfaces[1]
local F = game.forces.player
local D = defines.direction
game.tick_paused = false
if S then pcall(function() S.daytime = 0 end) end
local function cam(x, y, z)
  pcall(function() game.simulation.camera_position = {x, y} end)
  pcall(function() game.simulation.camera_zoom = z end)
end
local function ground(x1, y1, x2, y2, tile)
  if not (S and S.valid) then return end
  pcall(function()
    local t = {}
    for x = x1, x2 do
      for y = y1, y2 do t[#t + 1] = {name = tile, position = {x, y}} end
    end
    S.set_tiles(t)
  end)
end
local function make(name, x, y, dir)
  local e
  pcall(function() e = S.create_entity{name = name, position = {x, y}, direction = dir, force = F} end)
  return e
end
local function powered(cells, ex, ey)
  for _, c in pairs(cells) do make("substation", c[1], c[2]) end
  local eei = make("electric-energy-interface", ex, ey)
  if eei then
    pcall(function() eei.electric_buffer_size = 1e15 end)
    pcall(function() eei.power_production = 1e12 end)
    pcall(function() eei.power_usage = 0 end)
    pcall(function() eei.energy = 1e15 end)
  end
  return eei
end
local function fill(belt, item)
  if belt and belt.valid then
    pcall(function() belt.get_transport_line(1).insert_at_back{name = item} end)
    pcall(function() belt.get_transport_line(2).insert_at_back{name = item} end)
  end
end
-- Gentle sinusoidal drift that starts exactly on center, so there is no first-frame jump.
local function drift(cx, cy, ax, ay, sp)
  local n = 0
  script.on_nth_tick(1, function()
    n = n + 1
    pcall(function()
      game.simulation.camera_position = {cx + math.sin(n / sp) * ax, cy + math.sin(n / (sp * 1.6)) * ay}
    end)
  end)
end
]]

-- Fresh table, so the vanilla menu simulations are dropped.
uc.main_menu_simulations = {

  -- Assembly hall. A central iron-plate belt feeds two mirrored rows of assemblers
  -- through inserters, so the machines actually craft gears, with product belts above
  -- and below. Concrete floor on a grass field, gentle drift.
  ["jjt-assembly-hall"] = {
    checkboard = false,
    length = 60 * 20,
    init = prelude .. [[
    pcall(function()
      cam(0, 0, 1.0)
      ground(-26, -15, 26, 15, "grass-1")
      ground(-20, -9, 20, 9, "concrete")
      powered({{-16, -8}, {-8, -8}, {0, -8}, {8, -8}, {16, -8}, {-8, 8}, {8, 8}}, 0, 22)
      local xs = {}
      for x = -12, 12, 4 do xs[#xs + 1] = x end
      local asms = {}
      local feed = make("transport-belt", 0, 0, D.east)
      local feedrow = {}
      for x = -16, 16 do
        local b = make("transport-belt", x, 0, D.east)
        if b then feedrow[#feedrow + 1] = b end
      end
      for _, x in pairs(xs) do
        local up = make("assembling-machine-2", x, -3)
        local dn = make("assembling-machine-2", x, 3)
        make("fast-inserter", x, -1, D.north)
        make("fast-inserter", x, 1, D.south)
        for _, a in pairs({up, dn}) do
          if a then
            pcall(function() a.set_recipe("iron-gear-wheel") end)
            asms[#asms + 1] = a
          end
        end
      end
      local topb, botb = {}, {}
      for x = -16, 16 do
        local t = make("transport-belt", x, -6, D.east)
        local b = make("transport-belt", x, 6, D.east)
        if t then topb[#topb + 1] = t end
        if b then botb[#botb + 1] = b end
      end
      for _, b in pairs(feedrow) do fill(b, "iron-plate") end
      for _, b in pairs(topb) do fill(b, "iron-gear-wheel") end
      for _, b in pairs(botb) do fill(b, "iron-gear-wheel") end
      script.on_nth_tick(6, function()
        if feedrow[1] then fill(feedrow[1], "iron-plate") end
        if topb[1] then fill(topb[1], "iron-gear-wheel") end
        if botb[1] then fill(botb[1], "iron-gear-wheel") end
      end)
      script.on_nth_tick(120, function()
        for _, a in pairs(asms) do
          if a.valid then
            pcall(function() a.insert{name = "iron-plate", count = 20} end)
            pcall(function() a.get_output_inventory().clear() end)
          end
        end
      end)
      drift(0, 0, 2.5, 1, 520)
    end)
    ]],
  },

  -- Smelting bank. Two long solid rows of burner furnaces glow between an ore infeed
  -- and a plate outfeed, fed directly so the fires never die. Slow lateral pan across
  -- the line.
  ["jjt-smelting"] = {
    checkboard = false,
    length = 60 * 20,
    init = prelude .. [[
    pcall(function()
      cam(0, 0, 0.9)
      ground(-26, -12, 26, 12, "grass-1")
      ground(-22, -8, 22, 8, "stone-path")
      local belts = {}
      for _, y in pairs({-8, -1, 6}) do
        local row = {}
        local item = (y == 6) and "iron-plate" or "iron-ore"
        for x = -20, 20 do
          local b = make("transport-belt", x, y, D.east)
          if b then row[#row + 1] = b end
        end
        for _, b in pairs(row) do fill(b, item) end
        belts[#belts + 1] = {row = row, item = item}
      end
      local furnaces = {}
      for _, y in pairs({-4, 3}) do
        for x = -20, 20, 2 do
          local fur = make("stone-furnace", x, y)
          if fur then furnaces[#furnaces + 1] = fur end
        end
      end
      local function feed()
        for _, fur in pairs(furnaces) do
          if fur.valid then
            pcall(function() fur.energy = 1e9 end)
            pcall(function() fur.insert{name = "coal", count = 5} end)
            pcall(function() fur.insert{name = "iron-ore", count = 10} end)
            pcall(function() fur.get_output_inventory().clear() end)
          end
        end
      end
      feed()
      script.on_nth_tick(90, feed)
      script.on_nth_tick(9, function()
        for _, B in pairs(belts) do
          if B.row[1] then fill(B.row[1], B.item) end
        end
      end)
      drift(0, 0, 4, 0.6, 560)
    end)
    ]],
  },

  -- Holding the line. Two staggered ranks of indestructible gun turrets behind a wall
  -- shred repeating biter waves marching in from the left. Ammo is topped up so the
  -- fight never ends. Dark grass battlefield.
  ["jjt-defense"] = {
    checkboard = false,
    length = 60 * 20,
    init = prelude .. [[
    pcall(function()
      cam(2, 0, 0.9)
      ground(-26, -15, 30, 15, "grass-2")
      for y = -12, 12 do
        local w = make("stone-wall", 6, y)
        if w then pcall(function() w.destructible = false end) end
      end
      local turrets = {}
      for _, spot in pairs({{9, -9}, {9, -3}, {9, 3}, {9, 9}, {13, -6}, {13, 0}, {13, 6}}) do
        local t = make("gun-turret", spot[1], spot[2])
        if t then
          pcall(function() t.destructible = false end)
          pcall(function() t.insert{name = "firearm-magazine", count = 20} end)
          turrets[#turrets + 1] = t
        end
      end
      local function wave()
        for k = 1, 12 do
          local name = (math.random(2) == 1) and "small-biter" or "medium-biter"
          local b = make(name, -20 - math.random(0, 6), math.random(-12, 12))
          if b then
            pcall(function() b.commandable.set_command{type = defines.command.attack_area, destination = {7, 0}, radius = 10} end)
          end
        end
      end
      wave()
      script.on_nth_tick(140, wave)
      script.on_nth_tick(120, function()
        for _, t in pairs(turrets) do
          if t.valid then pcall(function() t.insert{name = "firearm-magazine", count = 20} end) end
        end
      end)
      drift(2, 0, 2.5, 1, 500)
    end)
    ]],
  },

  -- Reaching space. A powered rocket silo on a concrete pad, ringed by support
  -- assemblers and fuel belts, fed rocket parts and launched on repeat. Camera holds
  -- high and steady so the launch carries the motion.
  ["jjt-rocket-launch"] = {
    checkboard = false,
    length = 60 * 22,
    init = prelude .. [[
    pcall(function()
      cam(0, -2, 0.82)
      ground(-28, -18, 28, 16, "grass-1")
      ground(-20, -14, 20, 12, "concrete")
      local eei = powered({{-16, -12}, {0, -12}, {16, -12}, {-16, 10}, {0, 10}, {16, 10}}, 0, 20)
      local silo = make("rocket-silo", 0, 0)
      if silo then pcall(function() silo.auto_launch = true end) end
      local recipes = {"iron-gear-wheel", "copper-cable"}
      local coords = {{-15, -6}, {-15, 0}, {-15, 6}, {15, -6}, {15, 0}, {15, 6}}
      local asms = {}
      for i, c in ipairs(coords) do
        local a = make("assembling-machine-3", c[1], c[2])
        if a then
          pcall(function() a.set_recipe(recipes[((i - 1) % 2) + 1]) end)
          asms[#asms + 1] = a
        end
      end
      local top, bot = {}, {}
      for x = -10, 10 do
        local t = make("transport-belt", x, -8, D.east)
        local b = make("transport-belt", x, 8, D.east)
        if t then top[#top + 1] = t end
        if b then bot[#bot + 1] = b end
      end
      for _, b in pairs(top) do fill(b, "low-density-structure") end
      for _, b in pairs(bot) do fill(b, "rocket-fuel") end
      script.on_nth_tick(60, function()
        if eei and eei.valid then pcall(function() eei.energy = 1e15 end) end
        for _, a in pairs(asms) do
          if a.valid then
            pcall(function() a.insert{name = "iron-plate", count = 20} end)
            pcall(function() a.insert{name = "copper-plate", count = 20} end)
            pcall(function() a.get_output_inventory().clear() end)
          end
        end
        if silo and silo.valid then
          pcall(function() silo.insert{name = "low-density-structure", count = 10} end)
          pcall(function() silo.insert{name = "rocket-fuel", count = 10} end)
          pcall(function() silo.insert{name = "processing-unit", count = 10} end)
        end
      end)
      script.on_nth_tick(30, function()
        if silo and silo.valid then pcall(function() silo.launch_rocket() end) end
      end)
      script.on_nth_tick(9, function()
        if top[1] then fill(top[1], "low-density-structure") end
        if bot[1] then fill(bot[1], "rocket-fuel") end
      end)
      drift(0, -2, 1.5, 0.8, 620)
    end)
    ]],
  },
}
