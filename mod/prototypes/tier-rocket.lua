-- Tier 1, Rocket Science. The bridge from 0.1.x, turned from a gateway into a
-- real tier (see team-coordination/design/late-game-roadmap.md).
--
-- science-tree.lua generates the skeleton for every tier, the pack, the gateway
-- tech, and the boost chain, and owns the science pack superset rule. This file
-- owns the rocket tier's actual content. It runs after the generator and fills
-- the skeleton in, so the superset logic stays in one place.
--
-- What the tier is about, launch capability. A real ground chain feeds the pack,
-- and the three boost techs pay out in cheaper rockets and a bigger silo.
-- Every base name here was checked against base 2.0.77.

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

-- Thrust assembly, the tier intermediate. Rocket fuel and structure, made on
-- the ground, so the pack is a production chain rather than a two item craft.
local thrust = items({ { "rocket-fuel", 4 }, { "steel-plate", 10 }, { "pipe", 6 } })
if thrust then
  add[#add + 1] = {
    type = "item", name = "jjt-thrust-assembly",
    localised_name = { "", "Thrust assembly" },
    icon = ICON, icon_size = 64,
    subgroup = "intermediate-product", order = "z[jjt]-a[thrust-assembly]",
    stack_size = 100,
  }
  add[#add + 1] = {
    type = "recipe", name = "jjt-thrust-assembly", enabled = false,
    energy_required = 8, ingredients = thrust,
    results = { { type = "item", name = "jjt-thrust-assembly", amount = 1 } },
    allow_productivity = true,
  }
  made["jjt-thrust-assembly"] = true
  own["jjt-thrust-assembly"] = true
end

-- Heavy silo, the tier's building payoff. Half the rocket parts and a faster
-- build, for a lot more power. Cloned from the base silo so it needs no art and
-- keeps every field the engine expects on a rocket-silo entity.
local silo = data.raw["rocket-silo"] and data.raw["rocket-silo"]["rocket-silo"]
local silo_item = data.raw.item["rocket-silo"]
local silo_cost = made["jjt-thrust-assembly"] and items({
  { "rocket-silo", 1 }, { "jjt-thrust-assembly", 20 },
  { "processing-unit", 100 }, { "concrete", 200 },
})
if silo and silo_item and silo_cost then
  local e = util.copy(silo)
  e.name = "jjt-heavy-silo"
  e.localised_name = { "", "Heavy silo" }
  e.next_upgrade = nil
  if e.minable and e.minable.result then e.minable.result = "jjt-heavy-silo" end
  e.rocket_parts_required = math.max(1, math.floor((e.rocket_parts_required or 100) / 2))
  e.crafting_speed = (e.crafting_speed or 1) * 1.5
  e.energy_usage = "400kW"
  e.active_energy_usage = "6000kW"

  local it = util.copy(silo_item)
  it.name = "jjt-heavy-silo"
  it.localised_name = { "", "Heavy silo" }
  it.place_result = "jjt-heavy-silo"
  it.order = (it.order or "z") .. "-jjt"

  add[#add + 1] = e
  add[#add + 1] = it
  add[#add + 1] = {
    type = "recipe", name = "jjt-heavy-silo", enabled = false,
    energy_required = 60, ingredients = silo_cost,
    results = { { type = "item", name = "jjt-heavy-silo", amount = 1 } },
  }
  made["jjt-heavy-silo"] = true
end

data:extend(add)

-- The real pack recipe. Replaces the generated placeholder in place, so the
-- pack item, the lab inputs, and every downstream tech cost stay untouched.
local pack = data.raw.recipe["jjt-rocket-science-pack"]
local pack_cost = made["jjt-thrust-assembly"] and items({
  { "jjt-thrust-assembly", 1 }, { "low-density-structure", 3 },
  { "processing-unit", 2 },
})
if pack and pack_cost then
  pack.ingredients = pack_cost
  pack.energy_required = 30
  pack.results = { { type = "item", name = "jjt-rocket-science-pack", amount = 2 } }
end

-- Real effects on the generated techs. Productivity on a base recipe is only
-- legal where the recipe opts in, so check before asking for it.
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
local gateway = data.raw.technology["jjt-rocket-science"]
if gateway and made["jjt-thrust-assembly"] then
  table.insert(gateway.effects, { type = "unlock-recipe", recipe = "jjt-thrust-assembly" })
end

payout("jjt-rocket-boost-1", "Launch throughput", {
  productivity("rocket-part", 0.1),
})
payout("jjt-rocket-boost-2", "Heavy lift", {
  unlock("jjt-heavy-silo"),
})
payout("jjt-rocket-boost-3", "Ascent refinement", {
  productivity("rocket-part", 0.1),
  productivity("rocket-fuel", 0.1),
})
