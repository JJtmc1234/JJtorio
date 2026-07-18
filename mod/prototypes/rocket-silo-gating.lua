-- Push reaching space to the late game: the rocket-silo TECH now requires a
-- MATURE base first. Launching is meant to come after you have all six science
-- packs and solid infrastructure -- but not after "complete the whole game".
-- The mod's actual identity begins in space, so the gate should mark a real
-- milestone without demanding pure end-game optimization (all three module-3
-- tiers, beacons, kovarex, personal equipment) that would delay the fun.
--
-- Deliberately EXCLUDED (optimization / personal QoL, not base maturity):
--   effect-transmission (beacons), speed/productivity/efficiency-module-3,
--   kovarex-enrichment-process, personal-roboport-2, exoskeleton-equipment.
-- The human may re-add any of these for a harsher gate, or drop nuclear/
-- uranium for a faster route to orbit -- flagged for playtest.
--
-- Names that don't exist in the running game are skipped automatically below,
-- so this list is safe to keep generous.
local GATES = {
  "bulk-inserter",
  "logistics-3",              -- express (blue) belts
  "logistic-system",          -- logistic network / bots
  "automation-3",             -- assembling machine 3
  "advanced-material-processing-2", -- electric furnace tier
  "uranium-processing",
  "nuclear-power",            -- power milestone (borderline: drop for faster orbit)
  "refined-concrete",
  "production-science-pack",  -- purple: forces the full science base
  "utility-science-pack",     -- yellow: forces the full science base
}

local silo = data.raw.technology["rocket-silo"]
if silo then
  silo.prerequisites = silo.prerequisites or {}

  local have = {}
  for _, p in ipairs(silo.prerequisites) do have[p] = true end

  -- Track the science packs the silo already requires. Factorio errors if a
  -- prerequisite needs a pack the dependent tech lacks, so we extend the
  -- silo's ingredient list to cover any new prerequisite's packs.
  local packs = {}
  if silo.unit and silo.unit.ingredients then
    for _, ing in ipairs(silo.unit.ingredients) do
      packs[ing[1] or ing.name] = true
    end
  end

  for _, name in ipairs(GATES) do
    local gate = data.raw.technology[name]
    if gate and not have[name] then
      table.insert(silo.prerequisites, name)
      have[name] = true
      if gate.unit and gate.unit.ingredients and silo.unit and silo.unit.ingredients then
        for _, ing in ipairs(gate.unit.ingredients) do
          local pack = ing[1] or ing.name
          if pack and not packs[pack] then
            packs[pack] = true
            table.insert(silo.unit.ingredients, { pack, 1 })
          end
        end
      end
    end
  end
end
