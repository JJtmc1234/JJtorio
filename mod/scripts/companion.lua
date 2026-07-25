-- Project BRAIN companion. Spawns a companion character next to the player at
-- game start, a body on the map with no in game driver. The intelligence is the
-- external Claude Agentic Player bridge, which drives this character over RCON
-- using the Claude API. Without the bridge running it simply stands with you.

local M = {}

local function spawn_for(player)
  if not (player and player.valid) then return nil end
  storage.brain = storage.brain or {}
  local cur = storage.brain[player.index]
  if cur and cur.valid then return cur end
  local surface = player.surface
  local anchor = (player.character and player.character.position) or player.position
  local pos = surface.find_non_colliding_position("character", { anchor.x + 2, anchor.y }, 12, 0.5)
    or { anchor.x + 2, anchor.y }
  local c = surface.create_entity({ name = "character", position = pos, force = player.force })
  if c then
    storage.brain[player.index] = c
    player.print("[BRAIN] Companion online. It is driven by the external agent bridge over RCON.")
  end
  return c
end

function M.register()
  script.on_event(defines.events.on_player_created, function(event)
    spawn_for(game.get_player(event.player_index))
  end)
  -- Dev command so it can be (re)spawned in an already running save, since
  -- on_player_created only fires for a fresh character.
  commands.add_command("brain", "Spawn or respawn your BRAIN companion (dev).", function(event)
    local player = event.player_index and game.get_player(event.player_index)
    if not player then return end
    local cur = storage.brain and storage.brain[player.index]
    if cur and cur.valid then cur.destroy() end
    if storage.brain then storage.brain[player.index] = nil end
    local c = spawn_for(player)
    player.print(c and "[BRAIN] Companion (re)spawned." or "[BRAIN] Could not place a companion.")
  end)
end

return M
