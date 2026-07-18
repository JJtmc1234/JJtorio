-- JJtorio control stage: runtime logic.
-- Planets are created at runtime as surfaces (the SE approach), so the core
-- of the mod lives here rather than in the data stage.

local dev_commands = require("scripts.commands")
local discovery = require("scripts.discovery")
local orbit = require("scripts.orbit")

local function init_storage()
  storage.planets = storage.planets or {}
  storage.planet_counter = storage.planet_counter or 0
  -- Derive the universe seed once from the starting surface so the same save
  -- always rolls the same sequence of planets.
  if not storage.universe_seed then
    local nauvis = game.surfaces["nauvis"]
    storage.universe_seed = (nauvis and nauvis.map_gen_settings.seed) or 1
  end
end

script.on_init(init_storage)
script.on_configuration_changed(init_storage)

-- Keep the orbit surface looking like space: void any newly generated chunk.
script.on_event(defines.events.on_chunk_generated, function(event)
  if event.surface and event.surface.valid and event.surface.name == orbit.name then
    orbit.space_area(event.surface, event.area)
  end
end)

-- Handlers must be (re)registered on every load, so register at top level.
dev_commands.register()
discovery.register()
