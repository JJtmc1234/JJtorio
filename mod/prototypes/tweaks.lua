-- Early-game pacing + quality-of-life tweaks (data stage).
-- The design keeps the early game close to vanilla with light tweaks to make
-- it faster and less fiddly; the overhaul depth lives later, in space.

local character = data.raw["character"]["character"]

-- Add `delta` to a field only if it already exists, so an unexpected base
-- change can't turn this into an arithmetic-on-nil load error.
local function bump(key, delta)
  if character[key] then character[key] = character[key] + delta end
end

-- Faster start: double starting hand-mining speed.
if character.mining_speed then character.mining_speed = character.mining_speed * 2 end

-- More reach: place, interact, mine, and pick up from further away.
bump("build_distance", 4)
bump("reach_distance", 4)
bump("reach_resource_distance", 2)
bump("item_pickup_distance", 1)
bump("loot_pickup_distance", 1)
