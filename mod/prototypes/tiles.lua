-- Custom placeholder tiles for planet biomes. Minimal on purpose. Each uses a
-- 4-variant 128x32 strip (count 4, size 1) from tools/gen-placeholder-tiles.ps1,
-- empty transitions to skip transition art, and an empty collision mask so they
-- are walkable and buildable. Placed on planets by scripts/planet-gen at chunk
-- generation. Real art replaces these later.

local function jjt_tile(name, r, g, b, layer)
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
  }
end

data:extend({
  jjt_tile("jjt-snow", 0.86, 0.90, 0.96, 61),
  jjt_tile("jjt-ash", 0.14, 0.12, 0.12, 62),
  jjt_tile("jjt-sand", 0.78, 0.70, 0.51, 63),
  jjt_tile("jjt-basalt", 0.33, 0.33, 0.36, 64),
})
