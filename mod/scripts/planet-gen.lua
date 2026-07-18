-- Procedural planet generation: roll a planet's immutable "facts" from a
-- seed, then create its surface. SE-style — planets are runtime surfaces,
-- not prototypes, so this works on base Factorio 2.0 without Space Age.

local pdata = require("scripts.planet-data")

local M = {}

local function pick(rng, list)
  return list[rng(1, #list)]
end

local function make_name(rng)
  return pick(rng, pdata.name_prefixes)
    .. pick(rng, pdata.name_middles)
    .. pick(rng, pdata.name_suffixes)
end

-- Roll the fixed properties of a planet from a 32-bit seed. Same seed in,
-- same planet out, so a save always regenerates identical worlds.
function M.roll_facts(seed)
  local rng = game.create_random_generator(seed)
  local class = pick(rng, pdata.classes)
  return {
    seed = seed,
    name = make_name(rng),
    class = class.id,
    class_label = class.label,
    description = class.desc,
    ore_richness = class.ore_bias * (rng(70, 140) / 100),
    day_minutes = rng(8, 30),
    gravity = rng(60, 160) / 100,
    terrain = class.terrain,
  }
end

-- Copy nauvis' map gen settings and bias the ores by the planet's richness.
local function map_gen_for(facts)
  local settings = game.surfaces["nauvis"].map_gen_settings
  settings.seed = facts.seed % 0x100000000
  settings.autoplace_controls = settings.autoplace_controls or {}
  for _, ore in ipairs({ "iron-ore", "copper-ore", "coal", "stone" }) do
    settings.autoplace_controls[ore] = {
      frequency = 1,
      size = 1,
      richness = facts.ore_richness,
    }
  end
  -- Class terrain: control trees, water, and the biome bias so a barren world
  -- actually looks barren instead of grassy.
  local t = facts.terrain
  if t then
    settings.autoplace_controls["trees"] = { frequency = t.trees or 1, size = t.trees or 1, richness = 1 }
    if t.water ~= nil then settings.water = t.water end
    settings.property_expression_names = settings.property_expression_names or {}
    if t.moisture ~= nil then settings.property_expression_names["moisture"] = tostring(t.moisture) end
    if t.aux ~= nil then settings.property_expression_names["aux"] = tostring(t.aux) end
  end
  return settings
end

local function surface_name(facts)
  return "jjt-" .. facts.name
end

-- Create (or fetch) the surface for a planet and kick off chunk generation
-- around the origin so there is ground to arrive on.
function M.create_surface(facts)
  local sname = surface_name(facts)
  if game.surfaces[sname] then return game.surfaces[sname] end
  local surface = game.create_surface(sname, map_gen_for(facts))
  surface.request_to_generate_chunks({ 0, 0 }, 3)
  surface.force_generate_chunk_requests()
  return surface
end

M.surface_name = surface_name

-- Generate the next planet in this save's sequence.
function M.generate()
  storage.planet_counter = (storage.planet_counter or 0) + 1
  -- Knuth multiplicative hash spreads consecutive counters across the seed
  -- space so successive planets are not near-identical.
  local seed = (storage.universe_seed + storage.planet_counter * 2654435761) % 0x100000000
  local facts = M.roll_facts(seed)
  storage.planets[facts.name] = facts
  M.create_surface(facts)
  return facts
end

return M
