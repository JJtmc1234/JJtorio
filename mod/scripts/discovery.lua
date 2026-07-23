-- Connects rockets to the mod's core: once Planetary Survey is researched,
-- launching a rocket discovers a new procedurally generated planet.
--
-- Payload-agnostic on purpose. Base Factorio 2.0 has no cargo pod to inspect
-- (that is a Space Age system), and two QC passes disagreed on the exact pod
-- API, so instead of reading the launch payload we gate on the Planetary
-- Survey technology. This cannot error on any 2.0.

local gen = require("scripts.planet-gen")

local M = {}

local function announce(force, facts)
  for _, player in pairs(game.connected_players) do
    if player.force == force then
      player.print("Survey reached orbit. Discovered planet " .. facts.name
        .. " (" .. facts.class_label .. "). Travel with: /goto " .. facts.name)
    end
  end
end

local function on_rocket_launched(event)
  local rocket = event.rocket
  if not (rocket and rocket.valid) then return end
  local force = rocket.force
  local tech = force.technologies and force.technologies["jjt-planetary-survey"]
  if not (tech and tech.researched) then return end
  announce(force, gen.generate())
end

function M.register()
  script.on_event(defines.events.on_rocket_launched, on_rocket_launched)
end

return M
