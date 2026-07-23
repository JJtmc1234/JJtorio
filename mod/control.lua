-- JJtorio control stage: runtime logic.
-- Planets are created at runtime as surfaces (the SE approach), so the core
-- of the mod lives here rather than in the data stage.

local dev_commands = require("scripts.commands")
local discovery = require("scripts.discovery")
local orbit = require("scripts.orbit")
local gen = require("scripts.planet-gen")

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

-- On chunk generation: orbit becomes space, and planet classes with a ground
-- tile get painted so they stop borrowing the Nauvis biome.
script.on_event(defines.events.on_chunk_generated, function(event)
  local surface = event.surface
  if not (surface and surface.valid) then return end
  -- Bound the retiling to a region around the origin so map expansion cannot
  -- trigger unbounded per-chunk set_tiles forever.
  local lt = event.area.left_top
  if math.abs(lt.x) > 256 or math.abs(lt.y) > 256 then return end
  if surface.name == orbit.name then
    orbit.space_area(surface, event.area)
    return
  end
  local facts = gen.facts_for_surface(surface.name)
  if facts then gen.paint_planet_chunk(surface, event.area, facts) end
end)

-- Handlers must be (re)registered on every load, so register at top level.
dev_commands.register()
discovery.register()
