-- Full late game tech tree, tiers 1 to 8, drafted in game (see
-- team-coordination/design/late-game-roadmap.md). Data driven. Each tier has a
-- science pack, a gateway tech that unlocks it, and several intermediate techs
-- that consume the pack and grant real bonuses, filling the tree between tiers.
-- Recipes vary per tier. Placeholder draft balance. Original, not SE.

local ICON = "__JJtorio__/graphics/icons/jjt-placeholder-fluid.png"

local VANILLA = {
  "automation-science-pack", "logistic-science-pack", "chemical-science-pack",
  "production-science-pack", "utility-science-pack",
}

-- Safe built-in modifier effects handed out on intermediate techs.
local BONUSES = {
  { type = "laboratory-speed", modifier = 0.15 },
  { type = "mining-drill-productivity-bonus", modifier = 0.1 },
  { type = "character-inventory-slots-bonus", modifier = 6 },
}

-- id, label, gateway prereqs, per-tier recipe ingredients, and how many
-- intermediate techs to fill the tree at this tier.
local TIERS = {
  { id = "rocket",    label = "Rocket Science",    prereqs = { "rocket-silo" },        recipe = { "rocket-fuel", "processing-unit" },                    techs = 3 },
  { id = "orbital",   label = "Orbital Science",   prereqs = { "jjt-rocket-science" },  recipe = { "low-density-structure", "battery" },                  techs = 3 },
  { id = "vacuum",    label = "Vacuum Science",    prereqs = { "jjt-orbital-science" }, recipe = { "processing-unit", "steel-plate" },                    techs = 2 },
  { id = "cryo",      label = "Cryo Science",      prereqs = { "jjt-orbital-science" }, recipe = { "battery", "pipe" },                                   techs = 2 },
  { id = "magma",     label = "Magma Science",     prereqs = { "jjt-orbital-science" }, recipe = { "steel-plate", "stone-brick" },                        techs = 2 },
  { id = "tide",      label = "Tide Science",      prereqs = { "jjt-orbital-science" }, recipe = { "pipe", "electronic-circuit" },                        techs = 2 },
  { id = "gravity",   label = "Gravity Science",   prereqs = { "jjt-orbital-science" }, recipe = { "concrete", "advanced-circuit" },                      techs = 2 },
  { id = "verdant",   label = "Verdant Science",   prereqs = { "jjt-orbital-science" }, recipe = { "wood", "electronic-circuit" },                        techs = 2 },
  { id = "resonance", label = "Resonance Science", prereqs = { "jjt-vacuum-science", "jjt-cryo-science", "jjt-magma-science", "jjt-tide-science", "jjt-gravity-science", "jjt-verdant-science" }, recipe = { "processing-unit", "accumulator" }, techs = 3 },
  { id = "core",      label = "Core Science",      prereqs = { "jjt-resonance-science" }, recipe = { "uranium-238", "steel-plate" },                      techs = 3 },
  { id = "exotic",    label = "Exotic Science",    prereqs = { "jjt-core-science" },    recipe = { "processing-unit", "low-density-structure", "battery" }, techs = 3 },
  { id = "gravitic",  label = "Gravitic Science",  prereqs = { "jjt-exotic-science" },  recipe = { "advanced-circuit", "concrete" },                      techs = 2 },
  { id = "thermal",   label = "Thermal Science",   prereqs = { "jjt-exotic-science" },  recipe = { "steel-plate", "pipe" },                               techs = 2 },
  { id = "flux",      label = "Flux Science",      prereqs = { "jjt-exotic-science" },  recipe = { "accumulator", "copper-cable" },                       techs = 2 },
  { id = "stellar",   label = "Stellar Science",   prereqs = { "jjt-gravitic-science", "jjt-thermal-science", "jjt-flux-science" }, recipe = { "processing-unit", "low-density-structure", "accumulator" }, techs = 4 },
}

local function pack_name(id) return "jjt-" .. id .. "-science-pack" end
local function tech_name(id) return "jjt-" .. id .. "-science" end

local by_id = {}
for _, t in ipairs(TIERS) do by_id[t.id] = t end

local function tier_of(prereq)
  local id = prereq:match("^jjt%-(.+)%-science$")
  return id and by_id[id]
end

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

local function ingredients_from(names)
  local out = {}
  for _, name in ipairs(names) do
    if data.raw.item[name] then out[#out + 1] = { type = "item", name = name, amount = 2 } end
  end
  if #out == 0 then out = { { type = "item", name = "iron-plate", amount = 2 } } end
  return out
end

-- Tech unit ingredients: vanilla plus ancestor packs, and optionally this tier's
-- own pack (for intermediate techs that come after the gateway).
local function units(ids, own)
  local u = {}
  for _, p in ipairs(VANILLA) do u[#u + 1] = { p, 1 } end
  for _, id in ipairs(ids) do u[#u + 1] = { pack_name(id), 1 } end
  if own then u[#u + 1] = { pack_name(own), 1 } end
  return u
end

local protos, pack_names = {}, {}

for _, t in ipairs(TIERS) do
  local anc = ancestors(t)
  local depth = #anc

  protos[#protos + 1] = {
    type = "tool", name = pack_name(t.id), localised_name = { "", t.label },
    icon = ICON, icon_size = 64, subgroup = "science-pack",
    order = "z[jjt]-" .. string.format("%02d", depth) .. "[" .. t.id .. "]",
    stack_size = 200, durability = 1,
    durability_description_key = "description.science-pack-remaining-amount",
  }
  pack_names[#pack_names + 1] = pack_name(t.id)

  protos[#protos + 1] = {
    type = "recipe", name = pack_name(t.id), enabled = false, energy_required = 20,
    ingredients = ingredients_from(t.recipe),
    results = { { type = "item", name = pack_name(t.id), amount = 2 } },
  }

  protos[#protos + 1] = {
    type = "technology", name = tech_name(t.id), localised_name = { "", t.label },
    icon = ICON, icon_size = 64, prerequisites = t.prereqs,
    effects = { { type = "unlock-recipe", recipe = pack_name(t.id) } },
    unit = { count = 200 + 150 * depth, time = 45, ingredients = units(anc) },
  }

  -- Intermediate techs use their own base name, NOT the gateway name plus a
  -- number. Naming them jjt-<id>-science-<n> made Factorio read them as levels
  -- of the gateway and warn about non-contiguous levels.
  local prev = tech_name(t.id)
  for i = 1, (t.techs or 0) do
    local bonus = BONUSES[((i - 1) % #BONUSES) + 1]
    local name = "jjt-" .. t.id .. "-boost-" .. i
    protos[#protos + 1] = {
      type = "technology", name = name, localised_name = { "", t.label .. " " .. i },
      icon = ICON, icon_size = 64, prerequisites = { prev },
      effects = { { type = bonus.type, modifier = bonus.modifier } },
      unit = { count = 300 + 150 * depth + 100 * i, time = 50, ingredients = units(anc, t.id) },
    }
    prev = name
  end
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
