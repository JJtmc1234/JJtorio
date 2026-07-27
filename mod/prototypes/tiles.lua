-- Custom placeholder tiles for planet biomes. Minimal on purpose. Each uses a
-- 4-variant 128x32 strip (count 4, size 1) from tools/gen-placeholder-tiles.ps1,
-- empty transitions to skip transition art, and an empty collision mask so they
-- are walkable and buildable. Placed on planets by scripts/planet-gen at chunk
-- generation. Real art replaces these later.

-- Reuse base tile sound tables (walking/build) verbatim so footsteps and tile
-- placement match the material they stand in for.
local tile_sounds = require("__base__/prototypes/tile/tile-sounds")

-- Looping wind ambience for open terrain. Modeled on the base water ambient
-- (it counts nearby tiles of this kind), so wind rises as the surface fills the
-- view. Only real base wind files are used.
local base_wind = "__base__/sound/world/world_base_wind.ogg"
local desert_wind = "__base__/sound/wind/wind.ogg"

local function wind(file, volume)
  return {
    sound = { filename = file, volume = volume },
    radius = 8,
    min_entity_count = 2,
    max_entity_count = 20,
    entity_to_sound_ratio = 0.3,
    average_pause_seconds = 2,
  }
end

local function jjt_tile(name, r, g, b, layer, walking, build, ambient)
  return {
    type = "tile",
    name = name,
    collision_mask = { layers = {} },
    layer = layer,
    variants = {
      main = {
        {
          picture = "__JJtorio__/graphics/tiles/" .. name .. ".png",
          count = 4,
          size = 1,
        },
      },
      empty_transitions = true,
    },
    map_color = { r = r, g = g, b = b },
    walking_sound = walking,
    build_sound = build,
    ambient_sounds = ambient,
  }
end

-- space: the starfield around and beyond the orbit platform. One 512x512 image
-- from the community covers an 8x8 block of tiles (64 px per tile, the base 2.0
-- size), so the large variant is size 8 count 1. A size 1 variant reads the top
-- left patch as the fallback the engine uses for fringe tiles that cannot fill a
-- full 8x8 block. Empty collision so it is walkable and buildable, empty
-- transitions, and no ambient sound because space is silent.
data:extend({
  {
    type = "tile",
    name = "jjt-space",
    collision_mask = { layers = {} },
    layer = 60,
    variants = {
      main = {
        {
          picture = "__JJtorio__/graphics/space-parallax.png",
          count = 1,
          size = 1,
        },
        {
          picture = "__JJtorio__/graphics/space-parallax.png",
          count = 1,
          size = 8,
        },
      },
      empty_transitions = true,
    },
    map_color = { r = 0.02, g = 0.02, b = 0.06 },
    walking_sound = tile_sounds.walking.concrete,
    build_sound = tile_sounds.building.landfill,
  },
})

data:extend({
  -- snow: granular crunch underfoot, cold low wind.
  jjt_tile("jjt-snow", 0.86, 0.90, 0.96, 61,
    tile_sounds.walking.sand, tile_sounds.building.landfill, wind(base_wind, 0.45)),
  -- ash: muffled powdery step, low volcanic wind.
  jjt_tile("jjt-ash", 0.14, 0.12, 0.12, 62,
    tile_sounds.walking.dirt, tile_sounds.building.landfill, wind(base_wind, 0.3)),
  -- sand: dry desert wind.
  jjt_tile("jjt-sand", 0.78, 0.70, 0.51, 63,
    tile_sounds.walking.sand, tile_sounds.building.landfill, wind(desert_wind, 0.5)),
  -- basalt: hard stone footsteps, exposed gusty wind.
  jjt_tile("jjt-basalt", 0.33, 0.33, 0.36, 64,
    tile_sounds.walking.pebble, tile_sounds.building.concrete, wind(desert_wind, 0.4)),
})
