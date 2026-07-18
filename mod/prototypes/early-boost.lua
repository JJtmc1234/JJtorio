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
scale("assembling-machine", "assembling-machine-1", "crafting_speed", 1.3)

-- Cheaper: the first two science packs craft in batches of 2 (handles both the
-- {name=,amount=} and {"name", count} result forms).
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
