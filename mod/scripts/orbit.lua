-- Orbit: a space platform you reach after the rocket silo. It is a real
-- separate surface. We void the terrain to out-of-map so it reads as space
-- rather than Nauvis, and lay a small platform to stand on. Placeholder until
-- real space tiles and a proper ascent exist.

local M = {}

local ORBIT = "jjt-orbit"
local PLATFORM_TILE = "refined-concrete"
local VOID_TILE = "out-of-map"
local HALF = 16       -- platform half extent, in tiles
local GEN_RADIUS = 2  -- chunks generated around the origin

M.name = ORBIT

local function on_platform(x, y)
  return x >= -HALF and x <= HALF and y >= -HALF and y <= HALF
end

-- Turn an area into space: void every tile outside the platform, lay the
-- platform floor inside it, and clear terrain clutter (trees, rocks, cliffs).
function M.space_area(surface, area)
  local lt, rb = area.left_top, area.right_bottom
  local void, floor = {}, {}
  for x = lt.x, rb.x - 1 do
    for y = lt.y, rb.y - 1 do
      if on_platform(x, y) then
        floor[#floor + 1] = { name = PLATFORM_TILE, position = { x, y } }
      else
        void[#void + 1] = { name = VOID_TILE, position = { x, y } }
      end
    end
  end
  if #void > 0 then surface.set_tiles(void) end
  if #floor > 0 then surface.set_tiles(floor) end
  local clutter = surface.find_entities_filtered({
    area = area,
    type = { "tree", "cliff", "simple-entity", "resource" },
  })
  for _, e in pairs(clutter) do
    if e.valid then e.destroy() end
  end
end

function M.ensure()
  local surface = game.surfaces[ORBIT]
  if surface then return surface end
  local base = game.surfaces["nauvis"] or game.surfaces[1]
  surface = game.create_surface(ORBIT, base.map_gen_settings)
  surface.request_to_generate_chunks({ 0, 0 }, GEN_RADIUS)
  surface.force_generate_chunk_requests()
  local r = GEN_RADIUS * 32
  M.space_area(surface, { left_top = { x = -r, y = -r }, right_bottom = { x = r, y = r } })
  return surface
end

return M
