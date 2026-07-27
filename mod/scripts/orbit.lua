-- Orbit: a space platform you reach after the rocket silo. It is a real
-- separate surface. Base Factorio 2.0 has no Space Age starfield, so "space"
-- is built from base parts: a dark metal deck ringed by a hazard rim, shaped
-- as a disc so there is no hard square edge, sitting in a jjt-space starfield
-- under frozen night light. Placeholder until a proper ascent exists.

local M = {}

local ORBIT = "jjt-orbit"
local DECK_A = "lab-dark-1"                    -- dark deck panel
local DECK_B = "lab-dark-2"                    -- alternating panel, reads as a grid
local RIM_TILE = "refined-hazard-concrete-left" -- bright edge warning at the drop
local VOID_TILE = "jjt-space"                   -- the starfield around and beyond the platform
local RADIUS = 22     -- platform radius in tiles
local RIM = 2         -- rim thickness in tiles
local GEN_RADIUS = 2  -- chunks generated around the origin

local R2 = RADIUS * RADIUS
local INNER2 = (RADIUS - RIM) * (RADIUS - RIM)

M.name = ORBIT

-- Which tile a point gets: starfield outside the disc, a hazard rim near the edge,
-- and an alternating dark deck inside. A disc has no straight boundary, so the
-- platform reads as an intentional station rather than a raw chunk square.
local function tile_at(x, y)
  local d2 = x * x + y * y
  if d2 > R2 then return VOID_TILE end
  if d2 > INNER2 then return RIM_TILE end
  if (x + y) % 2 == 0 then return DECK_A end
  return DECK_B
end

-- Turn an area into space: retile it by the disc shape and clear any terrain
-- clutter (decoratives, trees, rocks, cliffs) the base gen left behind.
function M.space_area(surface, area)
  local lt, rb = area.left_top, area.right_bottom
  local tiles = {}
  for x = lt.x, rb.x - 1 do
    for y = lt.y, rb.y - 1 do
      tiles[#tiles + 1] = { name = tile_at(x, y), position = { x, y } }
    end
  end
  surface.set_tiles(tiles)
  surface.destroy_decoratives({ area = area })
  local clutter = surface.find_entities_filtered({
    area = area,
    type = { "tree", "cliff", "simple-entity", "resource" },
  })
  for _, e in pairs(clutter) do
    if e.valid then e.destroy() end
  end
end

-- Map gen that generates as little as possible, so no Nauvis water, ore, or
-- cliffs bleed through before the retile runs.
local function orbit_map_gen(base)
  local s = base.map_gen_settings
  s.water = 0
  s.autoplace_controls = {}
  s.cliff_settings = s.cliff_settings or {}
  s.cliff_settings.richness = 0
  return s
end

function M.ensure()
  local surface = game.surfaces[ORBIT]
  if surface then return surface end
  local base = game.surfaces["nauvis"] or game.surfaces[1]
  surface = game.create_surface(ORBIT, orbit_map_gen(base))
  -- Freeze a dark sky so the starfield reads as space, not an unlit pad.
  surface.freeze_daytime = true
  surface.daytime = 0.5
  surface.request_to_generate_chunks({ 0, 0 }, GEN_RADIUS)
  surface.force_generate_chunk_requests()
  local r = GEN_RADIUS * 32
  M.space_area(surface, { left_top = { x = -r, y = -r }, right_bottom = { x = r, y = r } })
  return surface
end

return M
