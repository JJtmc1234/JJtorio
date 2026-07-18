-- Late game science tree, tiers 1 to 8, drafted in game (see
-- team-coordination/design/late-game-roadmap.md). Data driven. Each tier is a
-- science pack plus a gateway tech that unlocks its recipe, with prerequisites
-- forming the tree. Costs and recipes are placeholder draft balance. Original,
-- not SE. Each tech automatically includes every science pack its prerequisites
-- use, which is the rule Factorio enforces, so the tree loads without a mismatch.

local ICON = "__JJtorio__/graphics/icons/jjt-placeholder-fluid.png"

-- Base packs. No military, matching the proven-safe survey-satellite gate.
local VANILLA = {
  "automation-science-pack", "logistic-science-pack", "chemical-science-pack",
  "production-science-pack", "utility-science-pack",
}

-- Tiers in tree order. prereqs are tech names. rocket-silo is the base entry.
local TIERS = {
  { id = "rocket",    label = "Rocket Science",    prereqs = { "rocket-silo" } },
  { id = "orbital",   label = "Orbital Science",   prereqs = { "jjt-rocket-science" } },
  { id = "vacuum",    label = "Vacuum Science",    prereqs = { "jjt-orbital-science" } },
  { id = "cryo",      label = "Cryo Science",      prereqs = { "jjt-orbital-science" } },
  { id = "magma",     label = "Magma Science",     prereqs = { "jjt-orbital-science" } },
  { id = "tide",      label = "Tide Science",      prereqs = { "jjt-orbital-science" } },
  { id = "gravity",   label = "Gravity Science",   prereqs = { "jjt-orbital-science" } },
  { id = "verdant",   label = "Verdant Science",   prereqs = { "jjt-orbital-science" } },
  { id = "resonance", label = "Resonance Science", prereqs = { "jjt-vacuum-science", "jjt-cryo-science", "jjt-magma-science", "jjt-tide-science", "jjt-gravity-science", "jjt-verdant-science" } },
  { id = "core",      label = "Core Science",      prereqs = { "jjt-resonance-science" } },
  { id = "exotic",    label = "Exotic Science",    prereqs = { "jjt-core-science" } },
  { id = "gravitic",  label = "Gravitic Science",  prereqs = { "jjt-exotic-science" } },
  { id = "thermal",   label = "Thermal Science",   prereqs = { "jjt-exotic-science" } },
  { id = "flux",      label = "Flux Science",      prereqs = { "jjt-exotic-science" } },
  { id = "stellar",   label = "Stellar Science",   prereqs = { "jjt-gravitic-science", "jjt-thermal-science", "jjt-flux-science" } },
}

local function pack_name(id) return "jjt-" .. id .. "-science-pack" end
local function tech_name(id) return "jjt-" .. id .. "-science" end

local by_id = {}
for _, t in ipairs(TIERS) do by_id[t.id] = t end

local function tier_of(prereq)
  local id = prereq:match("^jjt%-(.+)%-science$")
  return id and by_id[id]
end

-- Ancestor tier ids whose packs a tier's tech must consume (every pack its
-- prerequisites introduced or themselves consumed).
local cache = {}
local function ancestors(t)
  if cache[t.id] then return cache[t.id] end
  cache[t.id] = {}
  local set = {}
  for _, pr in ipairs(t.prereqs) do
    local pt = tier_of(pr)
    if pt then
      set[pt.id] = true
      for _, id in ipairs(ancestors(pt)) do set[id] = true end
    end
  end
  local list = {}
  for id in pairs(set) do list[#list + 1] = id end
  table.sort(list)
  cache[t.id] = list
  return list
end

local function recipe_ingredients()
  local out = {}
  for _, name in ipairs({ "processing-unit", "low-density-structure" }) do
    if data.raw.item[name] then out[#out + 1] = { type = "item", name = name, amount = 1 } end
  end
  if #out == 0 then out = { { type = "item", name = "iron-plate", amount = 1 } } end
  return out
end

local protos, pack_names = {}, {}

for _, t in ipairs(TIERS) do
  local anc = ancestors(t)
  local depth = #anc

  local unit_ingredients = {}
  for _, p in ipairs(VANILLA) do unit_ingredients[#unit_ingredients + 1] = { p, 1 } end
  for _, id in ipairs(anc) do unit_ingredients[#unit_ingredients + 1] = { pack_name(id), 1 } end

  protos[#protos + 1] = {
    type = "tool",
    name = pack_name(t.id),
    localised_name = { "", t.label },
    icon = ICON,
    icon_size = 64,
    subgroup = "science-pack",
    order = "z[jjt]-" .. string.format("%02d", depth) .. "[" .. t.id .. "]",
    stack_size = 200,
    durability = 1,
    durability_description_key = "description.science-pack-remaining-amount",
  }
  pack_names[#pack_names + 1] = pack_name(t.id)

  protos[#protos + 1] = {
    type = "recipe",
    name = pack_name(t.id),
    enabled = false,
    energy_required = 20,
    ingredients = recipe_ingredients(),
    results = { { type = "item", name = pack_name(t.id), amount = 2 } },
  }

  protos[#protos + 1] = {
    type = "technology",
    name = tech_name(t.id),
    localised_name = { "", t.label },
    icon = ICON,
    icon_size = 64,
    prerequisites = t.prereqs,
    effects = { { type = "unlock-recipe", recipe = pack_name(t.id) } },
    unit = { count = 200 + 150 * depth, time = 45, ingredients = unit_ingredients },
  }
end

data:extend(protos)

local lab = data.raw.lab and data.raw.lab["lab"]
if lab and lab.inputs then
  local have = {}
  for _, name in ipairs(lab.inputs) do have[name] = true end
  for _, name in ipairs(pack_names) do
    if not have[name] then table.insert(lab.inputs, name) end
  end
end
