-- gear-tiers.lua: a new vehicle, turret, armor, and two equipments, cloned from
-- base prototypes and buffed. Reuses base graphics (no new art) and every clone
-- is guarded, so a missing base prototype is skipped rather than crashing.
-- Recipes use base ingredients only, so they never point at a skipped intermediate.

local util = require("util")
local add, made = {}, {}
local ICON = "__JJtorio__/graphics/icons/jjt-placeholder-machine.png"

local function clone(cat, base, name)
  local p = data.raw[cat] and data.raw[cat][base]
  if not p then return nil end
  local c = util.copy(p)
  c.name = name
  c.next_upgrade = nil
  if c.minable and c.minable.result then c.minable.result = name end
  return c
end

local function clone_item(base, name)
  local it = data.raw.item[base]
  if not it then return nil end
  local c = util.copy(it)
  c.name = name
  c.order = (c.order or "z") .. "-jjt"
  return c
end

local function recipe(name, ings)
  add[#add + 1] = {
    type = "recipe", name = name, enabled = false, energy_required = 10,
    ingredients = ings, results = { { type = "item", name = name, amount = 1 } },
  }
  made[name] = true
end

-- Heavy tank (vehicles are type car).
local tank, tanki = clone("car", "tank", "jjt-heavy-tank"), clone_item("tank", "jjt-heavy-tank")
if tank and tanki then
  tank.max_health = (tank.max_health or 2000) * 1.5
  if tank.inventory_size then tank.inventory_size = tank.inventory_size + 20 end
  tanki.place_result = "jjt-heavy-tank"
  tank.localised_name = { "", "Heavy Tank" }; tanki.localised_name = { "", "Heavy Tank" }
  add[#add + 1] = tank; add[#add + 1] = tanki
  recipe("jjt-heavy-tank", { { type = "item", name = "tank", amount = 1 }, { type = "item", name = "processing-unit", amount = 20 }, { type = "item", name = "low-density-structure", amount = 20 } })
end

-- Heavy turret (more health and range).
local tur, turi = clone("ammo-turret", "gun-turret", "jjt-heavy-turret"), clone_item("gun-turret", "jjt-heavy-turret")
if tur and turi then
  tur.max_health = (tur.max_health or 400) * 1.5
  if tur.attack_parameters and tur.attack_parameters.range then
    tur.attack_parameters.range = tur.attack_parameters.range + 6
  end
  turi.place_result = "jjt-heavy-turret"
  tur.localised_name = { "", "Heavy Turret" }; turi.localised_name = { "", "Heavy Turret" }
  add[#add + 1] = tur; add[#add + 1] = turi
  recipe("jjt-heavy-turret", { { type = "item", name = "gun-turret", amount = 1 }, { type = "item", name = "steel-plate", amount = 20 }, { type = "item", name = "processing-unit", amount = 5 } })
end

-- Exo armor with a larger equipment grid. Armor is its own item, no clone_item.
local pa = data.raw.armor["power-armor-mk2"]
if pa and data.raw["equipment-grid"][pa.equipment_grid] then
  local g = util.copy(data.raw["equipment-grid"][pa.equipment_grid])
  g.name = "jjt-exo-grid"
  g.width = (g.width or 0) + 2; g.height = (g.height or 0) + 2
  add[#add + 1] = g
  local arm = util.copy(pa)
  arm.name = "jjt-exo-armor"
  arm.equipment_grid = "jjt-exo-grid"
  arm.inventory_size_bonus = (arm.inventory_size_bonus or 0) + 30
  arm.order = (arm.order or "z") .. "-jjt"
  arm.localised_name = { "", "Exo Armor" }
  add[#add + 1] = arm
  recipe("jjt-exo-armor", { { type = "item", name = "power-armor-mk2", amount = 1 }, { type = "item", name = "processing-unit", amount = 30 }, { type = "item", name = "low-density-structure", amount = 40 } })
end

-- Exo shield equipment (bigger shield pool).
local sh, shi = clone("energy-shield-equipment", "energy-shield-mk2-equipment", "jjt-exo-shield"), clone_item("energy-shield-mk2-equipment", "jjt-exo-shield")
if sh and shi then
  if sh.max_shield then sh.max_shield = sh.max_shield * 1.5 end
  shi.placed_as_equipment_result = "jjt-exo-shield"
  sh.localised_name = { "", "Exo Shield" }; shi.localised_name = { "", "Exo Shield" }
  add[#add + 1] = sh; add[#add + 1] = shi
  recipe("jjt-exo-shield", { { type = "item", name = "energy-shield-mk2-equipment", amount = 1 }, { type = "item", name = "processing-unit", amount = 10 } })
end

-- Exo legs (faster exoskeleton).
local legs, legsi = clone("movement-bonus-equipment", "exoskeleton-equipment", "jjt-exo-legs"), clone_item("exoskeleton-equipment", "jjt-exo-legs")
if legs and legsi then
  if legs.movement_bonus then legs.movement_bonus = legs.movement_bonus * 1.5 end
  legsi.placed_as_equipment_result = "jjt-exo-legs"
  legs.localised_name = { "", "Exo Legs" }; legsi.localised_name = { "", "Exo Legs" }
  add[#add + 1] = legs; add[#add + 1] = legsi
  recipe("jjt-exo-legs", { { type = "item", name = "exoskeleton-equipment", amount = 1 }, { type = "item", name = "processing-unit", amount = 10 } })
end

data:extend(add)

-- Unlock techs. Six base packs (including military) so the science pack superset
-- rule holds against any combat or armor prereq. A tech is added only if it has
-- real unlocks and its prereq exists.
local GEAR_UNIT = {
  count = 500, time = 60,
  ingredients = {
    { "automation-science-pack", 1 }, { "logistic-science-pack", 1 },
    { "military-science-pack", 1 }, { "chemical-science-pack", 1 },
    { "production-science-pack", 1 }, { "utility-science-pack", 1 },
  },
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
    icon = ICON, icon_size = 64, prerequisites = prereqs, effects = effects,
    unit = GEAR_UNIT,
  } })
end

tech("jjt-heavy-vehicles", "Heavy Vehicles", "tank", { "jjt-heavy-tank" })
tech("jjt-advanced-defenses", "Advanced Defenses", "military-3", { "jjt-heavy-turret" })
tech("jjt-exo-suit", "Exo Suit", "power-armor-mk2", { "jjt-exo-armor", "jjt-exo-shield", "jjt-exo-legs" })
