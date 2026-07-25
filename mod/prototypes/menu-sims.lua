-- Menu simulations. Replaces the whole main menu background rotation with a set
-- of JJtorio scenes, so the old vanilla sims no longer play. Base entities only
-- and no mods list, which avoids the known crash from adding a mod to a menu
-- simulation. Every runtime call is pcall guarded so a bad call degrades the
-- scene instead of crashing the menu. Placeholder scenes to tune. The init runs
-- as a silent console command at menu time, so it cannot be verified by a data
-- stage load, only by looking at the menu.

local uc = data.raw["utility-constants"] and data.raw["utility-constants"]["default"]
if not uc then return end

-- Fresh table, so the vanilla menu simulations are dropped.
uc.main_menu_simulations = {
  ["jjt-reach-space"] = {
    length = 1200,
    init = [[
      local s = game.surfaces[1]
      local f = game.forces.player
      pcall(function() s.create_entity{ name = "rocket-silo", position = {0, 0}, force = f } end)
      for i = -3, 3 do
        pcall(function() s.create_entity{ name = "assembling-machine-2", position = {i * 3, 11}, force = f } end)
      end
      pcall(function() s.create_entity{ name = "lab", position = {-9, 4}, force = f } end)
      pcall(function() s.create_entity{ name = "lab", position = {9, 4}, force = f } end)
      pcall(function() game.camera_position = {0, 3} end)
      pcall(function() game.camera_zoom = 0.4 end)
    ]],
  },
  ["jjt-factory"] = {
    length = 1200,
    init = [[
      local s = game.surfaces[1]
      local f = game.forces.player
      for i = -4, 4 do
        pcall(function() s.create_entity{ name = "assembling-machine-3", position = {i * 3, 0}, force = f } end)
      end
      for x = -12, 12 do
        pcall(function() s.create_entity{ name = "transport-belt", position = {x, 5}, direction = defines.direction.east, force = f } end)
      end
      pcall(function() game.camera_position = {0, 2} end)
      pcall(function() game.camera_zoom = 0.5 end)
    ]],
  },
  ["jjt-mining"] = {
    length = 1200,
    init = [[
      local s = game.surfaces[1]
      local f = game.forces.player
      for i = -4, 4 do
        pcall(function() s.create_entity{ name = "electric-mining-drill", position = {i * 3, 0}, force = f } end)
      end
      for x = -12, 12 do
        pcall(function() s.create_entity{ name = "transport-belt", position = {x, 4}, direction = defines.direction.east, force = f } end)
      end
      pcall(function() game.camera_position = {0, 1} end)
      pcall(function() game.camera_zoom = 0.5 end)
    ]],
  },
  ["jjt-defense"] = {
    length = 1200,
    init = [[
      local s = game.surfaces[1]
      local f = game.forces.player
      for i = -4, 4 do
        pcall(function() s.create_entity{ name = "gun-turret", position = {i * 2, 0}, force = f } end)
      end
      for i = -8, 8 do
        pcall(function() s.create_entity{ name = "stone-wall", position = {i, 3}, force = f } end)
      end
      pcall(function() game.camera_position = {0, 1} end)
      pcall(function() game.camera_zoom = 0.6 end)
    ]],
  },
}
