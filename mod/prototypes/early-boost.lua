-- Cheaper + faster early game. Speeds up the tier-1 workhorses and labs, and
-- makes the first two science packs go further. Guarded so a missing base
-- prototype can't crash the load.

local function scale(category, name, key, factor)
  local proto = data.raw[category] and data.raw[category][name]
  if proto and proto[key] then proto[key] = proto[key] * factor end
end

-- Faster: research throughput and the tier-1 machines.
scale("lab", "lab", "researching_speed", 1.5)
scale("mining-drill", "burner-mining-drill", "mining_speed", 1.5)
scale("mining-drill", "electric-mining-drill", "mining_speed", 1.5)
scale("furnace", "stone-furnace", "crafting_speed", 1.5)
scale("furnace", "steel-furnace", "crafting_speed", 1.5)
-- asm-1 only 1.3x (0.5 -> 0.65): stays below asm-2's 0.75 so upgrading still
-- pays off; the rest go 1.5x since they have no same-role successor to protect.
scale("assembling-machine", "assembling-machine-1", "crafting_speed", 1.3)

-- Cheaper: ONLY the first two science packs craft in batches of 2 -- this makes
-- the opening (red/green) research light and fast; chemical packs onward are
-- left at vanilla yield so the mid game keeps its weight. Handles both the
-- {name=,amount=} and {"name", count} result forms.
local function set_pack_yield(recipe_name, pack_name, amount)
  local recipe = data.raw.recipe[recipe_name]
  if not (recipe and recipe.results) then return end
  for _, r in ipairs(recipe.results) do
    if r.name == pack_name then
      r.amount = amount
    elseif r[1] == pack_name then
      r[2] = amount
    end
  end
end

set_pack_yield("automation-science-pack", "automation-science-pack", 2)
set_pack_yield("logistic-science-pack", "logistic-science-pack", 2)
