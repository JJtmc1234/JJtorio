-- Cheaper research across the board, to keep the (vanilla-ish) early and mid
-- game moving. Progression is paced by the rocket-silo gating (see
-- rocket-silo-gating.lua), not by grindy science counts.

local COST_FACTOR = 0.6 -- ~40% cheaper

for _, tech in pairs(data.raw.technology) do
  local unit = tech.unit
  if unit then
    if unit.count then
      unit.count = math.max(1, math.floor(unit.count * COST_FACTOR))
    elseif unit.count_formula then
      -- Wrap the existing formula so infinite/late techs scale too.
      unit.count_formula = "(" .. unit.count_formula .. ") * " .. COST_FACTOR
    end
  end
end
