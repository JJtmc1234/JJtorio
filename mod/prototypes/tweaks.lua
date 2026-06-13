-- Early-game pacing tweaks (data stage).
-- The design keeps the early game close to vanilla with only light tweaks
-- to make it faster; the overhaul depth lives later, in space.

local character = data.raw["character"]["character"]

-- Faster start: double starting hand-mining speed.
character.mining_speed = character.mining_speed * 2
