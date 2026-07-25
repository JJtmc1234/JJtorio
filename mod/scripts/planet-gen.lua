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
    terrain = class.terrain,
  }
end

-- Copy nauvis' map gen settings and bias the ores by the planet's richness.
local function map_gen_for(facts)
  local base = game.surfaces["nauvis"] or game.surfaces[1]
  local settings = base.map_gen_settings
  settings.seed = facts.seed % 0x100000000
  settings.autoplace_controls = settings.autoplace_controls or {}
  for _, ore in ipairs({ "iron-ore", "copper-ore", "coal", "stone", "uranium-ore", "crude-oil" }) do
    settings.autoplace_controls[ore] = {
      frequency = 1,
      size = 1,
      richness = facts.ore_richness,
    }
  end
  -- Trees are planted per class during painting (see plant_trees), so Nauvis'
  -- own green forest never bleeds onto alien worlds. Suppress the map-gen tree
  -- pass entirely and let the paint stage own every tree.
  settings.autoplace_controls["trees"] = { frequency = 0, size = 0, richness = 0 }
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

-- Look up a planet's facts from its surface name (jjt-<name>).
function M.facts_for_surface(sname)
  local name = sname:match("^jjt%-(.+)$")
  return name and storage.planets and storage.planets[name] or nil
end

-- Smooth value noise, deterministic per planet seed and position. hash01 is a
-- cheap sine hash, vnoise bilinearly blends the four lattice corners of a cell
-- with a smoothstep so features are coherent blobs, not per-tile static. This
-- is what breaks up the flat "one stamped tile" and checkerboard look.
local floor = math.floor
local sin = math.sin

local function hash01(seed, x, y)
  local n = sin(x * 12.9898 + y * 78.233 + seed * 0.0009) * 43758.5453
  return n - floor(n)
end

local function vnoise(seed, x, y, cell)
  local fx, fy = x / cell, y / cell
  local ix, iy = floor(fx), floor(fy)
  local tx, ty = fx - ix, fy - iy
  tx = tx * tx * (3 - 2 * tx)
  ty = ty * ty * (3 - 2 * ty)
  local a = hash01(seed, ix, iy)
  local b = hash01(seed, ix + 1, iy)
  local c = hash01(seed, ix, iy + 1)
  local d = hash01(seed, ix + 1, iy + 1)
  local top = a + (b - a) * tx
  local bot = c + (d - c) * tx
  return top + (bot - top) * ty
end

local function pick_by(list, v)
  return list[floor(v * #list) + 1]
end

-- Oceanic tile: elevation noise gives deep water, shallow water, a sand beach
-- ring, then an island interior drawn from the ground palette. Two octaves keep
-- coastlines organic instead of the old mod-6 checkerboard.
local function water_tile(seed, x, y, ground)
  local e = vnoise(seed, x, y, 26) * 0.7 + vnoise(seed + 11, x, y, 11) * 0.3
  if e < 0.42 then return "deepwater"
  elseif e < 0.52 then return "water"
  elseif e < 0.57 then return "sand-1"
  else return pick_by(ground, vnoise(seed + 3, x, y, 8)) end
end

-- Scatter class decoratives on a coarse jittered grid, gated by noise so they
-- cluster into drifts and patches rather than an even sprinkle.
local function scatter_decoratives(surface, area, t, seed)
  local list = t.scatter
  if not list then return end
  local lt, rb = area.left_top, area.right_bottom
  local decs, n = {}, 0
  for x = lt.x, rb.x - 1, 2 do
    for y = lt.y, rb.y - 1, 2 do
      if vnoise(seed + 5, x, y, 3) > 0.7 then
        local jx = hash01(seed + 1, x, y) - 0.5
        local jy = hash01(seed + 2, x, y) - 0.5
        n = n + 1
        decs[n] = {
          name = pick_by(list, hash01(seed + 8, x, y)),
          position = { x + jx, y + jy },
          amount = 1,
        }
      end
    end
  end
  if n > 0 then surface.create_decoratives({ check_collision = true, decoratives = decs }) end
end

-- Plant class trees. Forest coverage noise below the class density becomes
-- woodland, thinned so trunks do not fill solid, and can_place_entity keeps
-- trees off water and off anything already placed.
local function plant_trees(surface, area, t, seed)
  local kinds = t.tree_kinds
  if not kinds or (t.trees or 0) <= 0 then return end
  local lt, rb = area.left_top, area.right_bottom
  for x = lt.x, rb.x - 1, 2 do
    for y = lt.y, rb.y - 1, 2 do
      if vnoise(seed + 4, x, y, 14) < t.trees and hash01(seed + 6, x, y) < 0.6 then
        local pos = { x + hash01(seed + 1, x, y) - 0.5, y + hash01(seed + 2, x, y) - 0.5 }
        local name = pick_by(kinds, hash01(seed + 9, x, y))
        if surface.can_place_entity({ name = name, position = pos }) then
          surface.create_entity({ name = name, position = pos })
        end
      end
    end
  end
end

-- Paint a chunk into its planet class: ground tiles blended by noise (or a noise
-- sea for water worlds), then class decoratives and trees on top, so each class
-- reads as real varied terrain instead of one stamped tile.
function M.paint_planet_chunk(surface, area, facts)
  local t = facts.terrain
  if not (t and (t.ground or t.water_world)) then return end
  local seed = facts.seed
  local ground = t.ground
  local lt, rb = area.left_top, area.right_bottom
  local tiles, n = {}, 0
  for x = lt.x, rb.x - 1 do
    for y = lt.y, rb.y - 1 do
      local name
      if t.water_world then
        name = water_tile(seed, x, y, ground)
      else
        name = pick_by(ground, vnoise(seed, x, y, 9))
      end
      n = n + 1
      tiles[n] = { name = name, position = { x, y } }
    end
  end
  surface.set_tiles(tiles)
  -- Clear Nauvis decoratives, rocks, and cliffs so the painted ground starts
  -- clean, then lay down this class's own decoratives and trees.
  surface.destroy_decoratives({ area = area })
  for _, e in pairs(surface.find_entities_filtered({ area = area, type = { "cliff", "simple-entity" } })) do
    if e.valid then e.destroy() end
  end
  scatter_decoratives(surface, area, t, seed)
  plant_trees(surface, area, t, seed)
end

-- Generate the next planet in this save's sequence. Only rolls and records the
-- facts. The surface itself is created lazily on first visit (see create_surface,
-- called from /goto), so discovering many planets does not balloon the save with
-- surfaces the player never sets foot on.
function M.generate()
  storage.planet_counter = (storage.planet_counter or 0) + 1
  -- Knuth multiplicative hash spreads consecutive counters across the seed
  -- space so successive planets are not near-identical.
  local seed = (storage.universe_seed + storage.planet_counter * 2654435761) % 0x100000000
  if seed == 0 then seed = 1 end
  local facts = M.roll_facts(seed)
  -- Avoid a name collision overwriting an existing planet.
  local base = facts.name
  local n = 2
  while storage.planets[facts.name] do
    facts.name = base .. " " .. n
    n = n + 1
  end
  storage.planets[facts.name] = facts
  return facts
end

return M
