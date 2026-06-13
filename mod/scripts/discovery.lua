-- Connects the rocket silo to the mod's core: launching a Survey Satellite
-- discovers a new procedurally generated planet.
--
-- Heavily nil-guarded: the exact rocket-launch flow on base 2.0 (without
-- Space Age) is unverified, so if anything is missing this no-ops rather than
-- erroring, and dev travel (/jjt-goto) still works.

local gen = require("scripts.planet-gen")

local M = {}

local function announce(force, facts)
  for _, player in pairs(game.connected_players) do
    if player.force == force then
      player.print("Survey satellite reached orbit. Discovered planet "
        .. facts.name .. " (" .. facts.class_label .. "). Travel with: /jjt-goto "
        .. facts.name)
    end
  end
end

local function on_rocket_launched(event)
  local rocket = event.rocket
  if not (rocket and rocket.valid) then return end
  local inv = rocket.get_inventory(defines.inventory.rocket)
  if not inv then return end
  local count = inv.get_item_count("jjt-survey-satellite")
  if count == 0 then return end

  local force = rocket.force
  for _ = 1, count do
    local facts = gen.generate()
    announce(force, facts)
  end
end

function M.register()
  script.on_event(defines.events.on_rocket_launched, on_rocket_launched)
end

return M
