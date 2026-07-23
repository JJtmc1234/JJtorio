-- Trigger techs: 2.0 research_trigger technologies that complete by DOING a
-- thing (crafting or building a milestone count) rather than spending science.
-- Each grants a small bonus, so they read as achievements that reward scaling
-- up. Standalone (no prerequisites). Names are base 2.0 items and entities.

local ICON = "__JJtorio__/graphics/icons/jjt-placeholder-machine.png"

-- Small bonuses, kept low because 24 of them stack.
local BONUSES = {
  { type = "laboratory-speed", modifier = 0.04 },
  { type = "mining-drill-productivity-bonus", modifier = 0.03 },
  { type = "laboratory-productivity", modifier = 0.02 },
  { type = "character-inventory-slots-bonus", modifier = 2 },
}

-- id, label, the craft target, and the milestone count.
local TECHS = {
  { id = "belt-logistics",     label = "Belt Logistics",       craft = "transport-belt",         count = 2000 },
  { id = "fast-logistics",     label = "Fast Logistics",       craft = "fast-transport-belt",    count = 1000 },
  { id = "express-logistics",  label = "Express Logistics",    craft = "express-transport-belt", count = 500 },
  { id = "inserter-mastery",   label = "Inserter Mastery",     craft = "inserter",               count = 1000 },
  { id = "bulk-handling",      label = "Bulk Handling",        craft = "bulk-inserter",          count = 200 },
  { id = "blue-chips",         label = "Blue Chips",           craft = "processing-unit",        count = 500 },
  { id = "low-density",        label = "Low Density",          craft = "low-density-structure",  count = 500 },
  { id = "fuel-depot",         label = "Fuel Depot",           craft = "rocket-fuel",            count = 200 },
  { id = "power-cells",        label = "Power Cells",          craft = "battery",                count = 500 },
  { id = "steelworks",         label = "Steelworks",           craft = "steel-plate",            count = 5000 },
  { id = "paving",             label = "Paving",               craft = "concrete",               count = 2000 },
  { id = "speed-tuning",       label = "Speed Tuning",         craft = "speed-module-3",         count = 50 },
  { id = "prod-tuning",        label = "Productivity Tuning",  craft = "productivity-module-3",  count = 50 },
  { id = "eff-tuning",         label = "Efficiency Tuning",    craft = "efficiency-module-3",    count = 50 },
  { id = "munitions",          label = "Munitions",            craft = "piercing-rounds-magazine", count = 1000 },
  { id = "mass-assembly",      label = "Mass Assembly",        craft = "assembling-machine-2",   count = 200 },
  { id = "advanced-assembly",  label = "Advanced Assembly",    craft = "assembling-machine-3",   count = 100 },
  { id = "smelting-scale",     label = "Smelting Scale",       craft = "electric-furnace",       count = 100 },
  { id = "solar-farm",         label = "Solar Farm",           craft = "solar-panel",            count = 200 },
  { id = "storage-bank",       label = "Storage Bank",         craft = "accumulator",            count = 100 },
  { id = "research-campus",    label = "Research Campus",      craft = "lab",                    count = 50 },
  { id = "beacon-grid",        label = "Beacon Grid",          craft = "beacon",                 count = 50 },
  { id = "defense-line",       label = "Defense Line",         craft = "gun-turret",             count = 100 },
  { id = "recon-network",      label = "Recon Network",        craft = "radar",                  count = 40 },
}

local protos = {}
for i, t in ipairs(TECHS) do
  local trigger = { type = "craft-item", item = t.craft, count = t.count }
  local bonus = BONUSES[((i - 1) % #BONUSES) + 1]
  protos[#protos + 1] = {
    type = "technology",
    name = "jjt-trigger-" .. t.id,
    localised_name = { "", t.label },
    icon = ICON,
    icon_size = 64,
    research_trigger = trigger,
    effects = { { type = bonus.type, modifier = bonus.modifier } },
    order = "z[jjt-trigger]-" .. string.format("%02d", i),
  }
end

data:extend(protos)
