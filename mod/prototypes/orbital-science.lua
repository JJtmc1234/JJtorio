-- M2 scaffolding: the orbital science tier (see design/orbit-and-orbital-
-- science.md). ONE new science pack, made only in orbit, that gates the next
-- tier. Deliberately NOT Space Exploration: a single pack, no data beaming,
-- no piloted ships -- the difficulty is relocating production off-world.
--
-- STAGED, NOT WIRED: this file is intentionally not required by data.lua yet,
-- so it cannot affect the unverified foundation. Add `require(
-- "prototypes.orbital-science")` to data.lua once M0 confirms the mod loads.
-- Mirrors the proven-safe survey-satellite.lua pattern (item/recipe/tech +
-- guarded base edit) and adds no new art dependency (reuses the placeholder).

local ICON = "__JJtorio__/graphics/icons/jjt-placeholder-machine.png"

-- Ingredients are intermediates you already make on the ground and must haul
-- up the tether. Only names present in the running game are used, so a missing
-- base prototype can't crash the load.
local WANT = {
  { name = "processing-unit",       amount = 4 },
  { name = "low-density-structure", amount = 4 },
  { name = "battery",               amount = 8 },
}
local ingredients = {}
for _, ing in ipairs(WANT) do
  if data.raw.item[ing.name] then
    ingredients[#ingredients + 1] =
      { type = "item", name = ing.name, amount = ing.amount }
  end
end
-- Fallback so the recipe is always valid even on an unexpectedly stripped game.
if #ingredients == 0 then
  ingredients = { { type = "item", name = "iron-plate", amount = 10 } }
end

data:extend({
  -- Isolate the recipe to a category no ground machine has, so the pack can
  -- only be crafted by the (orbit-only) jjt-orbital-fabricator. The gate is
  -- the PLACE, not a lock flag.
  {
    type = "recipe-category",
    name = "jjt-orbital-fabrication",
  },
  -- The science pack itself: a tool item, like the vanilla packs.
  {
    type = "tool",
    name = "jjt-orbital-science-pack",
    icon = ICON,
    icon_size = 64,
    subgroup = "science-pack",
    order = "z[jjt]-b[orbital-science-pack]",
    stack_size = 200,
    durability = 1,       -- consumed one-per-research like other packs
    durability_description_key = "description.science-pack-remaining-amount",
  },
  {
    type = "recipe",
    name = "jjt-orbital-science-pack",
    enabled = false,
    category = "jjt-orbital-fabrication",
    energy_required = 30,   -- long, microgravity fabrication
    ingredients = ingredients,
    results = { { type = "item", name = "jjt-orbital-science-pack", amount = 4 } },
  },
  -- Research this on the ground (packs carried down) to unlock the orbital
  -- fabricator + the pack recipe. Fabricator entity is defined with the M1
  -- entities once art exists; this tech is forward-compatible with it.
  {
    type = "technology",
    name = "jjt-orbital-science",
    icon = ICON,
    icon_size = 64,
    prerequisites = { "jjt-planetary-survey" },
    effects = {
      { type = "unlock-recipe", recipe = "jjt-orbital-science-pack" },
    },
    unit = {
      count = 300,
      time = 45,
      ingredients = {
        { "automation-science-pack", 1 },
        { "logistic-science-pack",   1 },
        { "chemical-science-pack",   1 },
        { "utility-science-pack",    1 },
      },
    },
  },
})

-- Guarded base edit: let ordinary labs consume the new pack, so research still
-- happens on the ground. Skip silently if the lab prototype is unexpectedly
-- absent.
local lab = data.raw.lab and data.raw.lab["lab"]
if lab and lab.inputs then
  local have = {}
  for _, name in ipairs(lab.inputs) do have[name] = true end
  if not have["jjt-orbital-science-pack"] then
    table.insert(lab.inputs, "jjt-orbital-science-pack")
  end
end
