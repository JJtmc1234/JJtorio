-- Menu simulations. Replaces the whole vanilla menu rotation with a set of lively
-- JJtorio scenes, so the old scenes no longer play. Base entities only and no mods
-- list, which avoids the known crash from adding a mod to a menu simulation.
--
-- Techniques copied from the base sims (data/base/menu-simulations and the tips and
-- factoriopedia sims):
--   * the real camera fields are game.simulation.camera_position and camera_zoom,
--     and game.tick_paused must be set false (the old file used game.camera_position
--     which silently failed under pcall so nothing moved).
--   * animation is driven by script.on_nth_tick and on_event closures registered in
--     init, exactly like the base biter and chase sims, so update stays empty.
--   * burner machines are run by setting entity.energy directly (base burner refuel
--     trick), belts are kept full with LuaTransportLine.insert_at_back, and combat
--     uses entity.commandable.set_command to march biters into turret range.
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
game.tick_paused = false
if S then pcall(function() S.daytime = 0 end) end
local function cam(x, y, z)
  pcall(function() game.simulation.camera_position = {x, y} end)
  pcall(function() game.simulation.camera_zoom = z end)
end
local function make(name, x, y, dir)
  local e
  pcall(function() e = S.create_entity{name = name, position = {x, y}, direction = dir, force = F} end)
  return e
end
local function power(cells, ex, ey)
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
local function drift(cx, cy, ax, ay, sp)
  local n = 0
  script.on_nth_tick(1, function()
    n = n + 1
    pcall(function()
      game.simulation.camera_position = {cx + math.sin(n / sp) * ax, cy + math.cos(n / (sp * 1.4)) * ay}
    end)
  end)
end
]]

-- Fresh table, so the vanilla menu simulations are dropped.
uc.main_menu_simulations = {

  -- Scaling factory. Powered assembling machines craft while product belts stream
  -- underneath and the camera drifts across the hall.
  ["jjt-assembly-hall"] = {
    length = 60 * 20,
    init = prelude .. [[
    pcall(function()
      cam(0, -3, 0.85)
      local eei = power({{-8, -12}, {8, -12}}, 0, -12)
      local asms = {}
      for i = -3, 3 do
        local a = make("assembling-machine-2", i * 4, -6)
        if a then
          pcall(function() a.set_recipe("iron-gear-wheel") end)
          asms[#asms + 1] = a
        end
      end
      local items = {"iron-gear-wheel", "electronic-circuit", "copper-cable"}
      local lanes = {}
      for lane = 1, 3 do
        local row = {}
        for x = -16, 16 do
          local b = make("transport-belt", x, -3 + lane * 2, defines.direction.east)
          if b then row[#row + 1] = b end
        end
        for _, b in pairs(row) do fill(b, items[lane]) end
        lanes[lane] = row
      end
      script.on_nth_tick(120, function()
        for _, a in pairs(asms) do
          if a.valid then
            pcall(function() a.insert{name = "iron-plate", count = 40} end)
            pcall(function() a.get_output_inventory().clear() end)
          end
        end
        if eei and eei.valid then pcall(function() eei.energy = 1e15 end) end
      end)
      script.on_nth_tick(12, function()
        for lane = 1, 3 do
          local row = lanes[lane]
          if row and row[1] then fill(row[1], items[lane]) end
        end
      end)
      drift(0, -3, 6, 1.5, 320)
    end)
    ]],
  },

  -- Smelting sprawl. A long row of burner furnaces smelting ore into plates, fed by
  -- an ore belt on top and an output plate belt below, with a slow lateral pan.
  ["jjt-smelting"] = {
    length = 60 * 20,
    init = prelude .. [[
    pcall(function()
      cam(0, 0, 0.9)
      local infeed, outfeed, furnaces = {}, {}, {}
      for x = -16, 16 do
        local b = make("transport-belt", x, -6, defines.direction.east)
        if b then infeed[#infeed + 1] = b end
      end
      for x = -16, 16 do
        local b = make("transport-belt", x, 6, defines.direction.east)
        if b then outfeed[#outfeed + 1] = b end
      end
      for i = -7, 7 do
        local fur = make("stone-furnace", i * 2, 0)
        if fur then furnaces[#furnaces + 1] = fur end
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
      for _, b in pairs(infeed) do fill(b, "iron-ore") end
      for _, b in pairs(outfeed) do fill(b, "iron-plate") end
      script.on_nth_tick(90, feed)
      script.on_nth_tick(12, function()
        if infeed[1] then fill(infeed[1], "iron-ore") end
        if outfeed[1] then fill(outfeed[1], "iron-plate") end
      end)
      drift(0, 0, 7, 1, 340)
    end)
    ]],
  },

  -- Logistics superhighway. Six alternating express belt lanes packed with different
  -- goods, kept flowing from their upstream ends, under a slow diagonal drift.
  ["jjt-belt-superhighway"] = {
    length = 60 * 18,
    init = prelude .. [[
    pcall(function()
      cam(0, 0, 0.75)
      local items = {"iron-plate", "copper-plate", "electronic-circuit", "iron-gear-wheel", "steel-plate", "copper-cable"}
      local lanes = {}
      for lane = 1, 6 do
        local y = -10 + (lane - 1) * 4
        local dir = (lane % 2 == 0) and defines.direction.west or defines.direction.east
        local row = {}
        for x = -18, 18 do
          local b = make("transport-belt", x, y, dir)
          if b then row[#row + 1] = b end
        end
        for _, b in pairs(row) do fill(b, items[lane]) end
        lanes[lane] = {row = row, dir = dir, item = items[lane]}
      end
      script.on_nth_tick(9, function()
        for lane = 1, 6 do
          local L = lanes[lane]
          if L and L.row and #L.row > 0 then
            local head = (L.dir == defines.direction.east) and L.row[1] or L.row[#L.row]
            fill(head, L.item)
          end
        end
      end)
      drift(0, 0, 4, 3, 380)
    end)
    ]],
  },

  -- Holding the line. Indestructible gun turrets behind a wall shred repeating waves
  -- of biters that march in from the left. Ammo is topped up so the fight never ends.
  ["jjt-defense"] = {
    length = 60 * 20,
    init = prelude .. [[
    pcall(function()
      cam(-2, 0, 0.75)
      for y = -10, 10 do
        local w = make("stone-wall", 5, y)
        if w then pcall(function() w.destructible = false end) end
      end
      local turrets = {}
      for _, ty in pairs({-8, -4, 0, 4, 8}) do
        local t = make("gun-turret", 8, ty)
        if t then
          pcall(function() t.destructible = false end)
          pcall(function() t.insert{name = "firearm-magazine", count = 20} end)
          turrets[#turrets + 1] = t
        end
      end
      local function wave()
        for k = 1, 7 do
          local name = (math.random(2) == 1) and "small-biter" or "medium-biter"
          local b = make(name, -18, math.random(-10, 10))
          if b then
            pcall(function() b.commandable.set_command{type = defines.command.attack_area, destination = {6, 0}, radius = 8} end)
          end
        end
      end
      wave()
      script.on_nth_tick(150, wave)
      script.on_nth_tick(120, function()
        for _, t in pairs(turrets) do
          if t.valid then pcall(function() t.insert{name = "firearm-magazine", count = 20} end) end
        end
      end)
      drift(-2, 0, 3, 1.5, 300)
    end)
    ]],
  },

  -- Reaching space. A powered rocket silo ringed by support assemblers and a fuel
  -- belt. The silo is fed rocket parts and set to auto launch, with best effort
  -- launch attempts, while the camera slowly rises toward it.
  ["jjt-rocket-launch"] = {
    length = 60 * 22,
    init = prelude .. [[
    pcall(function()
      cam(0, 2, 0.7)
      local eei = power({{-14, -8}, {0, -8}, {14, -8}, {-14, 10}, {0, 10}, {14, 10}}, 0, -12)
      local silo = make("rocket-silo", 0, 0)
      if silo then pcall(function() silo.auto_launch = true end) end
      local recipes = {"iron-gear-wheel", "copper-cable"}
      local coords = {{-14, -4}, {-14, 0}, {-14, 4}, {14, -4}, {14, 0}, {14, 4}}
      local asms = {}
      for i, c in ipairs(coords) do
        local a = make("assembling-machine-3", c[1], c[2])
        if a then
          pcall(function() a.set_recipe(recipes[((i - 1) % 2) + 1]) end)
          asms[#asms + 1] = a
        end
      end
      local belt = {}
      for x = -12, 12 do
        local b = make("transport-belt", x, 6, defines.direction.east)
        if b then belt[#belt + 1] = b; fill(b, "rocket-fuel") end
      end
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
      script.on_nth_tick(12, function()
        if belt[1] then fill(belt[1], "rocket-fuel") end
      end)
      drift(0, 1, 3, 4, 360)
    end)
    ]],
  },
}
