-- Tier 2, Orbital Science. Built in orbit from lifted materials (see
-- team-coordination/design/orbit-and-orbital-science.md and the late game
-- roadmap). science-tree.lua generates the skeleton, the pack, the gateway tech
-- jjt-orbital-science, and a three tech boost chain, and owns the science pack
-- superset rule. This file fills that skeleton with real content: a lifted
-- structural intermediate, a real pack recipe, and boost payouts that unlock
-- orbital construction and a deeper survey of nearby worlds.
--
-- It MODIFIES the already generated prototypes in place, exactly like
-- tier-rocket.lua, and never redefines jjt-orbital-science or its pack. The
-- un-wired prototypes/orbital-science.lua defines those same names and stays
-- un-required on purpose, so wiring it in would crash on duplicates. Every base
-- name here was checked against base 2.0.77.

local util = require("util")

local ICON = "__JJtorio__/graphics/icons/jjt-placeholder-machine.png"

local add = {}
local made = {}
-- Items this file adds. They are not in data.raw until the data:extend below,
-- so ingredient checks have to know about them separately.
local own = {}

-- Build an ingredient list, returning nil if any item is missing, so a recipe
-- is either fully correct or not touched at all.
local function items(list)
  local out = {}
  for _, e in ipairs(list) do
    if not (data.raw.item[e[1]] or own[e[1]]) then return nil end
    out[#out + 1] = { type = "item", name = e[1], amount = e[2] }
  end
  return out
end

-- Orbital truss, the tier intermediate. Structural framework crafted on the
-- ground from space materials and hauled up the tether, so the pack is a real
-- lifted supply chain rather than a two item craft.
local truss = items({ { "low-density-structure", 4 }, { "steel-plate", 8 }, { "battery", 4 } })
if truss then
  add[#add + 1] = {
    type = "item", name = "jjt-orbital-truss",
    localised_name = { "", "Orbital truss" },
    icon = ICON, icon_size = 64,
    subgroup = "intermediate-product", order = "z[jjt]-a[orbital-truss]",
    stack_size = 100,
  }
  add[#add + 1] = {
    type = "recipe", name = "jjt-orbital-truss", enabled = false,
    energy_required = 8, ingredients = truss,
    results = { { type = "item", name = "jjt-orbital-truss", amount = 1 } },
    allow_productivity = true,
  }
  made["jjt-orbital-truss"] = true
  own["jjt-orbital-truss"] = true
end

-- Clone a base entity and its item so the tier's buildings reuse base graphics
-- and need no new art. Returns nil if the base prototype is missing, so a clone
-- is either whole or skipped.
local function clone_pair(cat, base, name, label)
  local e = data.raw[cat] and data.raw[cat][base]
  local it = data.raw.item[base]
  if not (e and it) then return nil, nil end
  e = util.copy(e)
  it = util.copy(it)
  e.name = name
  it.name = name
  e.localised_name = { "", label }
  it.localised_name = { "", label }
  e.next_upgrade = nil
  if e.minable and e.minable.result then e.minable.result = name end
  it.place_result = name
  it.order = (it.order or "z") .. "-jjt"
  return e, it
end

-- Orbital construction hub, the orbital construction payoff. A roboport with a
-- wider reach, cloned from the base roboport so it keeps every field the engine
-- expects and needs no art.
local hub, hub_item = clone_pair("roboport", "roboport", "jjt-orbital-hub", "Orbital construction hub")
local hub_cost = made["jjt-orbital-truss"] and items({
  { "roboport", 1 }, { "jjt-orbital-truss", 4 }, { "processing-unit", 20 },
})
if hub and hub_item and hub_cost then
  hub.logistics_radius = (hub.logistics_radius or 25) + 10
  hub.construction_radius = (hub.construction_radius or 55) + 20
  add[#add + 1] = hub
  add[#add + 1] = hub_item
  add[#add + 1] = {
    type = "recipe", name = "jjt-orbital-hub", enabled = false,
    energy_required = 30, ingredients = hub_cost,
    results = { { type = "item", name = "jjt-orbital-hub", amount = 1 } },
  }
  made["jjt-orbital-hub"] = true
end

-- Deep survey array, the survey of nearby worlds payoff. A long range radar,
-- cloned from the base radar so it reuses base art.
local array, array_item = clone_pair("radar", "radar", "jjt-deep-survey-array", "Deep survey array")
local array_cost = made["jjt-orbital-truss"] and items({
  { "radar", 1 }, { "jjt-orbital-truss", 2 }, { "processing-unit", 10 },
})
if array and array_item and array_cost then
  array.max_distance_of_sector_revealed = (array.max_distance_of_sector_revealed or 14) + 6
  array.max_distance_of_nearby_sector_revealed = (array.max_distance_of_nearby_sector_revealed or 3) + 2
  add[#add + 1] = array
  add[#add + 1] = array_item
  add[#add + 1] = {
    type = "recipe", name = "jjt-deep-survey-array", enabled = false,
    energy_required = 20, ingredients = array_cost,
    results = { { type = "item", name = "jjt-deep-survey-array", amount = 1 } },
  }
  made["jjt-deep-survey-array"] = true
end

data:extend(add)

-- The real pack recipe. Replaces the generated placeholder in place, so the pack
-- item, the lab inputs, and every downstream tech cost stay untouched. Made from
-- the lifted truss plus imported electronics and power cells.
local pack = data.raw.recipe["jjt-orbital-science-pack"]
local pack_cost = made["jjt-orbital-truss"] and items({
  { "jjt-orbital-truss", 1 }, { "processing-unit", 2 }, { "battery", 4 },
})
if pack and pack_cost then
  pack.ingredients = pack_cost
  pack.energy_required = 30
  pack.results = { { type = "item", name = "jjt-orbital-science-pack", amount = 2 } }
  pack.allow_productivity = true
end

-- Real effects on the generated techs. Productivity on a recipe is only legal
-- where the recipe opts in, so check before asking for it.
local function productivity(recipe, change)
  local r = data.raw.recipe[recipe]
  if not (r and r.allow_productivity) then return nil end
  return { type = "change-recipe-productivity", recipe = recipe, change = change }
end

local function unlock(recipe)
  if not made[recipe] then return nil end
  return { type = "unlock-recipe", recipe = recipe }
end

-- Rewrite a generated tech's payout. Effects that could not be built are
-- dropped, and a tech left with nothing keeps the generic bonus it came with.
local function payout(name, label, effects)
  local tech = data.raw.technology[name]
  if not tech then return end
  local real = {}
  for _, effect in ipairs(effects) do
    if effect then real[#real + 1] = effect end
  end
  if #real == 0 then return end
  tech.localised_name = { "", label }
  tech.effects = real
end

-- Gateway. Keep the pack unlock the generator gave it, add the intermediate.
local gateway = data.raw.technology["jjt-orbital-science"]
if gateway and made["jjt-orbital-truss"] then
  table.insert(gateway.effects, { type = "unlock-recipe", recipe = "jjt-orbital-truss" })
end

payout("jjt-orbital-boost-1", "Orbital construction", {
  unlock("jjt-orbital-hub"),
  productivity("jjt-orbital-truss", 0.2),
})
payout("jjt-orbital-boost-2", "Survey of nearby worlds", {
  unlock("jjt-deep-survey-array"),
  productivity("low-density-structure", 0.1),
})
payout("jjt-orbital-boost-3", "Station fabrication", {
  productivity("jjt-orbital-science-pack", 0.1),
  productivity("jjt-orbital-truss", 0.1),
  productivity("processing-unit", 0.1),
})
