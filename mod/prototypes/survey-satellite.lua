-- Immediate post-rocket-silo progression: the Survey Satellite.
-- Launch one to discover a new procedurally generated planet (see
-- scripts/discovery.lua). Unlocked by the Planetary Survey tech, which sits
-- directly after the rocket silo.

local ICON = "__JJtorio__/graphics/icons/jjt-placeholder-machine.png"

data:extend({
  {
    type = "item",
    name = "jjt-survey-satellite",
    icon = ICON,
    icon_size = 64,
    subgroup = "intermediate-product",
    order = "z[jjt]-a[survey-satellite]",
    stack_size = 1,
  },
  {
    type = "recipe",
    name = "jjt-survey-satellite",
    enabled = false,
    energy_required = 20,
    ingredients = {
      { type = "item", name = "processing-unit",        amount = 100 },
      { type = "item", name = "low-density-structure",  amount = 100 },
      { type = "item", name = "radar",                  amount = 5 },
      { type = "item", name = "accumulator",            amount = 20 },
    },
    results = { { type = "item", name = "jjt-survey-satellite", amount = 1 } },
  },
  {
    type = "technology",
    name = "jjt-planetary-survey",
    icon = ICON,
    icon_size = 64,
    prerequisites = { "rocket-silo" },
    effects = {
      { type = "unlock-recipe", recipe = "jjt-survey-satellite" },
    },
    unit = {
      count = 500,
      time = 60,
      ingredients = {
        { "automation-science-pack", 1 },
        { "logistic-science-pack",   1 },
        { "chemical-science-pack",   1 },
        { "production-science-pack", 1 },
        { "utility-science-pack",    1 },
      },
    },
  },
})
