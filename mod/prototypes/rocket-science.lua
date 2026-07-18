-- Rocket Science tier: a DRAFT in-game tech tree, the first custom science.
-- The rocket silo unlocks the Rocket Science pack, and a first branch of techs
-- runs off it. Effects on the branch are placeholders for now, so this only
-- draws the tree shape in game. Names are set inline so they read without a
-- locale file yet. Uses a placeholder icon.

local ICON = "__JJtorio__/graphics/icons/jjt-placeholder-fluid.png"

local PACKS = {
  { "automation-science-pack", 1 },
  { "logistic-science-pack", 1 },
  { "chemical-science-pack", 1 },
  { "production-science-pack", 1 },
  { "utility-science-pack", 1 },
}

-- A draft branch tech: requires Rocket Science and costs the new pack. Empty
-- effects for now, it just shapes the tree.
local function draft_tech(name, label, order)
  local ingredients = {}
  for _, p in ipairs(PACKS) do ingredients[#ingredients + 1] = p end
  ingredients[#ingredients + 1] = { "jjt-rocket-science-pack", 1 }
  return {
    type = "technology",
    name = name,
    localised_name = { "", label },
    icon = ICON,
    icon_size = 64,
    prerequisites = { "jjt-rocket-science" },
    effects = {},
    unit = { count = 400, time = 60, ingredients = ingredients },
    order = "z[jjt]-" .. order,
  }
end

data:extend({
  {
    type = "tool",
    name = "jjt-rocket-science-pack",
    localised_name = { "", "Rocket Science" },
    icon = ICON,
    icon_size = 64,
    subgroup = "science-pack",
    order = "z[jjt]-a[rocket-science]",
    stack_size = 200,
  },
  {
    type = "recipe",
    name = "jjt-rocket-science-pack",
    enabled = false,
    energy_required = 15,
    ingredients = {
      { type = "item", name = "rocket-fuel", amount = 1 },
      { type = "item", name = "processing-unit", amount = 1 },
      { type = "item", name = "low-density-structure", amount = 1 },
    },
    results = { { type = "item", name = "jjt-rocket-science-pack", amount = 1 } },
  },
  {
    type = "technology",
    name = "jjt-rocket-science",
    localised_name = { "", "Rocket Science" },
    icon = ICON,
    icon_size = 64,
    prerequisites = { "rocket-silo" },
    effects = { { type = "unlock-recipe", recipe = "jjt-rocket-science-pack" } },
    unit = { count = 300, time = 45, ingredients = PACKS },
  },
  draft_tech("jjt-cargo-lift", "Cargo Lift", "a"),
  draft_tech("jjt-orbital-access", "Orbital Access", "b"),
  draft_tech("jjt-heat-shielding", "Heat Shielding", "c"),
})

-- Let vanilla labs research with the new pack.
local lab = data.raw.lab and data.raw.lab["lab"]
if lab and lab.inputs then
  table.insert(lab.inputs, "jjt-rocket-science-pack")
end
