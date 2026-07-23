-- content-tiers.lua: new tiers of buildings, logistics, and gear that the tech
-- tree unlocks. Built by cloning base prototypes and bumping stats, so they
-- reuse base graphics (no new art) and stay safe to load. Draft balance. Every
-- clone is guarded, so a missing base prototype is skipped, not a crash.

local util = require("util")
local add = {}
local made = {}

local function clone(cat, base, name)
  local p = data.raw[cat] and data.raw[cat][base]
  if not p then return nil end
  local c = util.copy(p)
  c.name = name
  c.next_upgrade = nil
  if c.minable and c.minable.result then c.minable.result = name end
  return c
end

local function clone_item(base, name, place)
  local it = data.raw.item[base]
  if not it then return nil end
  local c = util.copy(it)
  c.name = name
  if place then c.place_result = name end
  c.order = (c.order or "z") .. "-jjt"
  return c
end

local function recipe(name, ingredients, count)
  add[#add + 1] = {
    type = "recipe", name = name, enabled = false, energy_required = 5,
    ingredients = ingredients, results = { { type = "item", name = name, amount = count or 1 } },
  }
  made[name] = true
end

-- Assembling machine 4
local am = clone("assembling-machine", "assembling-machine-3", "jjt-assembling-machine-4")
local ami = clone_item("assembling-machine-3", "jjt-assembling-machine-4", true)
if am and ami then
  am.crafting_speed = (am.crafting_speed or 1.25) * 1.6
  am.localised_name = { "", "Assembling Machine 4" }
  ami.localised_name = { "", "Assembling Machine 4" }
  add[#add + 1] = am; add[#add + 1] = ami
  recipe("jjt-assembling-machine-4", { { type = "item", name = "assembling-machine-3", amount = 1 }, { type = "item", name = "jjt-reinforced-frame", amount = 4 }, { type = "item", name = "jjt-exotic-circuit", amount = 4 } })
end

-- Turbo belt set
local belt = clone("transport-belt", "express-transport-belt", "jjt-turbo-transport-belt")
local ug = clone("underground-belt", "express-underground-belt", "jjt-turbo-underground-belt")
local sp = clone("splitter", "express-splitter", "jjt-turbo-splitter")
local belti = clone_item("express-transport-belt", "jjt-turbo-transport-belt", true)
local ugi = clone_item("express-underground-belt", "jjt-turbo-underground-belt", true)
local spi = clone_item("express-splitter", "jjt-turbo-splitter", true)
if belt and ug and sp and belti and ugi and spi then
  local speed = (belt.speed or 0.09375) * 1.5
  belt.speed = speed; ug.speed = speed; sp.speed = speed
  belt.related_underground_belt = "jjt-turbo-underground-belt"
  ug.max_distance = (ug.max_distance or 9) + 2
  belt.localised_name = { "", "Turbo Transport Belt" }
  ug.localised_name = { "", "Turbo Underground Belt" }
  sp.localised_name = { "", "Turbo Splitter" }
  belti.localised_name = { "", "Turbo Transport Belt" }
  ugi.localised_name = { "", "Turbo Underground Belt" }
  spi.localised_name = { "", "Turbo Splitter" }
  add[#add + 1] = belt; add[#add + 1] = ug; add[#add + 1] = sp
  add[#add + 1] = belti; add[#add + 1] = ugi; add[#add + 1] = spi
  recipe("jjt-turbo-transport-belt", { { type = "item", name = "express-transport-belt", amount = 1 }, { type = "item", name = "processing-unit", amount = 1 } })
  recipe("jjt-turbo-underground-belt", { { type = "item", name = "express-underground-belt", amount = 1 }, { type = "item", name = "processing-unit", amount = 2 } }, 2)
  recipe("jjt-turbo-splitter", { { type = "item", name = "express-splitter", amount = 1 }, { type = "item", name = "processing-unit", amount = 4 } })
end

-- Turbo inserter
local ins = clone("inserter", "bulk-inserter", "jjt-turbo-inserter")
local insi = clone_item("bulk-inserter", "jjt-turbo-inserter", true)
if ins and insi then
  ins.rotation_speed = (ins.rotation_speed or 0.04) * 1.4
  ins.extension_speed = (ins.extension_speed or 0.07) * 1.4
  ins.localised_name = { "", "Turbo Inserter" }
  insi.localised_name = { "", "Turbo Inserter" }
  add[#add + 1] = ins; add[#add + 1] = insi
  recipe("jjt-turbo-inserter", { { type = "item", name = "bulk-inserter", amount = 1 }, { type = "item", name = "processing-unit", amount = 2 } })
end

-- Intermediates
local frame = clone_item("low-density-structure", "jjt-reinforced-frame")
if frame then
  frame.place_result = nil
  frame.localised_name = { "", "Reinforced Frame" }
  add[#add + 1] = frame
  recipe("jjt-reinforced-frame", { { type = "item", name = "low-density-structure", amount = 2 }, { type = "item", name = "steel-plate", amount = 4 } })
end
local circuit = clone_item("processing-unit", "jjt-exotic-circuit")
if circuit then
  circuit.localised_name = { "", "Exotic Circuit" }
  add[#add + 1] = circuit
  recipe("jjt-exotic-circuit", { { type = "item", name = "processing-unit", amount = 2 }, { type = "item", name = "advanced-circuit", amount = 4 } })
end

-- Upgraded magazine
local ammo = data.raw.ammo and data.raw.ammo["uranium-rounds-magazine"]
if ammo then
  local a = util.copy(ammo)
  a.name = "jjt-exotic-rounds-magazine"
  a.localised_name = { "", "Exotic Rounds Magazine" }
  a.magazine_size = (a.magazine_size or 10) * 2
  a.order = (a.order or "z") .. "-jjt"
  add[#add + 1] = a
  recipe("jjt-exotic-rounds-magazine", { { type = "item", name = "uranium-rounds-magazine", amount = 2 } })
end

data:extend(add)

-- Unlock techs. Prereqs are non-military base techs, cost the five base packs,
-- so the science pack rule holds. A tech is added only if it has real unlocks.
local VANILLA = {
  { "automation-science-pack", 1 }, { "logistic-science-pack", 1 },
  { "chemical-science-pack", 1 }, { "production-science-pack", 1 },
  { "utility-science-pack", 1 },
}

local function tech(name, label, prereq, recipes)
  local effects = {}
  for _, r in ipairs(recipes) do
    if made[r] then effects[#effects + 1] = { type = "unlock-recipe", recipe = r } end
  end
  if #effects == 0 then return end
  local prereqs = (prereq and data.raw.technology[prereq]) and { prereq } or nil
  data:extend({ {
    type = "technology", name = name, localised_name = { "", label },
    icon = "__JJtorio__/graphics/icons/jjt-placeholder-machine.png", icon_size = 64,
    prerequisites = prereqs, effects = effects,
    unit = { count = 300, time = 45, ingredients = VANILLA },
  } })
end

tech("jjt-advanced-fabrication", "Advanced Fabrication", "automation-3",
  { "jjt-assembling-machine-4", "jjt-reinforced-frame", "jjt-exotic-circuit" })
tech("jjt-turbo-logistics", "Turbo Logistics", "logistics-3",
  { "jjt-turbo-transport-belt", "jjt-turbo-underground-belt", "jjt-turbo-splitter", "jjt-turbo-inserter" })
tech("jjt-exotic-munitions", "Exotic Munitions", "rocket-silo",
  { "jjt-exotic-rounds-magazine" })
