-- Push reaching space to the late game: the rocket-silo TECH now requires the
-- "megabase" staples first. Launching is meant to come after a mature base,
-- since the real depth begins in space.

-- Names that don't exist in the running game are skipped automatically below,
-- so this list can be generous.
local GATES = {
  "bulk-inserter",
  "logistics-3",              -- express (blue) belts
  "effect-transmission",      -- beacons
  "speed-module-3",
  "productivity-module-3",
  "efficiency-module-3",
  "logistic-system",          -- logistic network / bots
  "personal-roboport-2",
  "exoskeleton-equipment",
  "automation-3",             -- assembling machine 3
  "advanced-material-processing-2", -- electric furnace tier
  "nuclear-power",
  "kovarex-enrichment-process",
  "uranium-processing",
  "refined-concrete",
  "production-science-pack",
  "utility-science-pack",
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
