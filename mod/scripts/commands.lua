-- Developer console commands for exercising planet generation before the
-- real travel loop (rocket silo) exists. Marked dev.

local gen = require("scripts.planet-gen")
local orbit = require("scripts.orbit")

local M = {}

local function describe(facts)
  return string.format(
    "[%s] %s - %s | ore x%.2f, day %dm, gravity x%.2f",
    facts.class_label, facts.name, facts.description,
    facts.ore_richness, facts.day_minutes, facts.gravity)
end

function M.register()
  commands.add_command("new-planet", "Generate a new procedural planet (dev).", function(event)
    local player = event.player_index and game.get_player(event.player_index)
    if not player then return end
    local facts = gen.generate()
    player.print("Generated " .. describe(facts))
    player.print("Travel there with: /goto " .. facts.name)
  end)

  commands.add_command("planets", "List generated planets (dev).", function(event)
    local player = event.player_index and game.get_player(event.player_index)
    if not player then return end
    if not next(storage.planets) then
      player.print("No planets yet. Generate one with /new-planet")
      return
    end
    for _, facts in pairs(storage.planets) do
      player.print(describe(facts))
    end
  end)

  commands.add_command("goto", "Teleport to a planet by name (dev).", function(event)
    local player = event.player_index and game.get_player(event.player_index)
    if not player then return end
    local facts = event.parameter and storage.planets[event.parameter]
    if not facts then
      player.print("Unknown planet. Use /planets to list them.")
      return
    end
    local surface = gen.create_surface(facts)
    -- Land on solid ground near the origin rather than possibly in water.
    local pos = surface.find_non_colliding_position("character", { 0, 0 }, 64, 1)
      or { 0, 0 }
    player.teleport(pos, surface)
    player.print("Arrived on " .. facts.name)
  end)

  commands.add_command("orbit", "Go to orbit (dev).", function(event)
    local player = event.player_index and game.get_player(event.player_index)
    if not player then return end
    local surface = orbit.ensure()
    local pos = surface.find_non_colliding_position("character", { 0, 0 }, 64, 1)
      or { 0, 0 }
    player.teleport(pos, surface)
    player.print("Entered orbit.")
  end)
end

return M
