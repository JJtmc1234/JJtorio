-- Menu simulation. Adds a small reach for space scene to the main menu
-- background rotation, a rocket silo with a feeder line. It uses only base
-- entities and does not set a mods list, which avoids the known crash from
-- adding a mod to a menu simulation. Every runtime call is wrapped in pcall so a
-- bad call degrades the scene instead of crashing the menu. Placeholder scene,
-- tune after an in game check. init runs as a silent console command at menu
-- time, so it cannot be verified by a data stage load.

local uc = data.raw["utility-constants"] and data.raw["utility-constants"]["default"]
if not uc then return end

uc.main_menu_simulations = uc.main_menu_simulations or {}
uc.main_menu_simulations["jjt-reach-space"] = {
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
}
