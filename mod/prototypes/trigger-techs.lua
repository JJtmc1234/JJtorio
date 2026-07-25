-- Trigger techs: 2.0 research_trigger technologies that complete by crafting a
-- milestone count rather than spending science. Each grants a small bonus, so
-- they read as achievements that reward scaling up. Each is gated behind the
-- base tech that unlocks its item, so they slot into the tree near related
-- content instead of all cluttering the root. The prereq is guarded, so an
-- unknown tech name falls back to no prereq rather than crashing.

local ICON = "__JJtorio__/graphics/icons/jjt-placeholder-machine.png"

-- Small bonuses, kept low because 24 of them stack.
local BONUSES = {
  { type = "laboratory-speed", modifier = 0.04 },
  { type = "mining-drill-productivity-bonus", modifier = 0.03 },
  { type = "laboratory-productivity", modifier = 0.02 },
  { type = "character-inventory-slots-bonus", modifier = 2 },
}

-- id, label, craft target, milestone count, and the base tech it hangs off.
local TECHS = {
  { id = "belt-logistics",     label = "Belt Logistics",       craft = "transport-belt",           count = 2000, prereq = "logistics" },
  { id = "fast-logistics",     label = "Fast Logistics",       craft = "fast-transport-belt",      count = 1000, prereq = "logistics-2" },
  { id = "express-logistics",  label = "Express Logistics",    craft = "express-transport-belt",   count = 500,  prereq = "logistics-3" },
  { id = "inserter-mastery",   label = "Inserter Mastery",     craft = "inserter",                 count = 1000, prereq = "fast-inserter" },
  { id = "bulk-handling",      label = "Bulk Handling",        craft = "bulk-inserter",            count = 200,  prereq = "bulk-inserter" },
  { id = "blue-chips",         label = "Blue Chips",           craft = "processing-unit",          count = 500,  prereq = "processing-unit" },
  { id = "low-density",        label = "Low Density",          craft = "low-density-structure",    count = 500,  prereq = "low-density-structure" },
  { id = "fuel-depot",         label = "Fuel Depot",           craft = "rocket-fuel",              count = 200,  prereq = "rocket-fuel" },
  { id = "power-cells",        label = "Power Cells",          craft = "battery",                  count = 500,  prereq = "battery" },
  { id = "steelworks",         label = "Steelworks",           craft = "steel-plate",              count = 5000, prereq = "steel-processing" },
  { id = "paving",             label = "Paving",               craft = "concrete",                 count = 2000, prereq = "concrete" },
  { id = "speed-tuning",       label = "Speed Tuning",         craft = "speed-module-3",           count = 50,   prereq = "speed-module-3" },
  { id = "prod-tuning",        label = "Productivity Tuning",  craft = "productivity-module-3",    count = 50,   prereq = "productivity-module-3" },
  { id = "eff-tuning",         label = "Efficiency Tuning",    craft = "efficiency-module-3",      count = 50,   prereq = "efficiency-module-3" },
  { id = "munitions",          label = "Munitions",            craft = "piercing-rounds-magazine", count = 1000, prereq = "military-2" },
  { id = "mass-assembly",      label = "Mass Assembly",        craft = "assembling-machine-2",     count = 200,  prereq = "automation-2" },
  { id = "advanced-assembly",  label = "Advanced Assembly",    craft = "assembling-machine-3",     count = 100,  prereq = "automation-3" },
  { id = "smelting-scale",     label = "Smelting Scale",       craft = "electric-furnace",         count = 100,  prereq = "advanced-material-processing-2" },
  { id = "solar-farm",         label = "Solar Farm",           craft = "solar-panel",              count = 200,  prereq = "solar-energy" },
  { id = "storage-bank",       label = "Storage Bank",         craft = "accumulator",              count = 100,  prereq = "electric-energy-accumulators" },
  { id = "research-campus",    label = "Research Campus",      craft = "lab",                      count = 50,   prereq = "research-speed-1" },
  { id = "beacon-grid",        label = "Beacon Grid",          craft = "beacon",                   count = 50,   prereq = "effect-transmission" },
  { id = "defense-line",       label = "Defense Line",         craft = "gun-turret",               count = 100,  prereq = "military" },
  { id = "recon-network",      label = "Recon Network",        craft = "radar",                    count = 40,   prereq = "radar" },
}

local protos = {}
for i, t in ipairs(TECHS) do
  local prereqs = (t.prereq and data.raw.technology[t.prereq]) and { t.prereq } or nil
  local bonus = BONUSES[((i - 1) % #BONUSES) + 1]
  protos[#protos + 1] = {
    type = "technology",
    name = "jjt-trigger-" .. t.id,
    localised_name = { "", t.label },
    icon = ICON,
    icon_size = 64,
    prerequisites = prereqs,
    research_trigger = { type = "craft-item", item = t.craft, count = t.count },
    effects = { { type = bonus.type, modifier = bonus.modifier } },
    order = "z[jjt-trigger]-" .. string.format("%02d", i),
  }
end

data:extend(protos)
