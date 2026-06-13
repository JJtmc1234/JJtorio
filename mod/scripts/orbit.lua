-- Orbit: a tiled space surface you reach after the rocket silo, where the
-- orbital science tier will be built.
--
-- Placeholder for now: real ascent, space-platform tiles and visuals, and the
-- orbital science come next. This just creates the surface and lays a small
-- platform of an existing tile so the "go to orbit" step is testable.

local M = {}

local ORBIT = "jjt-orbit"
local PLATFORM_TILE = "refined-concrete" -- stand-in floor until real space tiles exist
local HALF = 16                          -- platform half-extent in tiles

function M.ensure()
  local surface = game.surfaces[ORBIT]
  if surface then return surface end

  -- Copy nauvis' settings for a valid MapGenSettings; the platform is laid on
  -- top regardless of what generates underneath.
  surface = game.create_surface(ORBIT, game.surfaces["nauvis"].map_gen_settings)
  surface.request_to_generate_chunks({ 0, 0 }, 2)
  surface.force_generate_chunk_requests()

  local tiles = {}
  for x = -HALF, HALF do
    for y = -HALF, HALF do
      tiles[#tiles + 1] = { name = PLATFORM_TILE, position = { x, y } }
    end
  end
  surface.set_tiles(tiles)
  return surface
end

M.name = ORBIT

return M
