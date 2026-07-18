# test-list.md, what JJ should test, in priority order

Living doc. Manager-Claude and Main-Claude keep this CURRENT. When a testable slice
lands (a fix, a wired feature, a new command), add or update its line here FIRST. JJ
reads this to know exactly what to launch Factorio and check. Mark each item's status
as you learn it.

Status key:  [ ] not tested   [~] partially or issue found   [x] passes   [!] blocker or broken

Target build: JJtorio 0.1.17 (published). Load in Factorio 2.0 BASE GAME. NO Space Age, NO SE.

--------------------------------------------------------------------------
## P0. M0, does the foundation load and run (blocks everything else)
[x] 1. Mod LOADS: enable JJtorio, start a new base 2.0 save. No error at data stage
       and no error at control stage.
[x] 2. Dev commands run without error and do what they say:
         /jjt-new-planet     -> creates a planet (a new surface plus rolled facts)
         /jjt-planets        -> lists the planets you have generated
         /jjt-goto <name>    -> teleports you to that planet's surface
         /jjt-orbit          -> the orbit surface, reads as space now (confirmed working)
[x] 3. Rocket-silo GATE: the rocket-silo tech shows the intended prerequisites and IS
       researchable once you have them. Gate is a mature base, the six pack science
       base, electric furnaces, bots, express belts, and nuclear.

## P1. early game balance sanity (only meaningful once P0 loads)
[x] 4. RESOLVED: early red and green science craft 2 per craft, confirmed in game.
[x] 5. Feel check: research light but not trivial, inventory about 100 and reach
       comfortable, asm-1 (0.65) still worth upgrading to asm-2 (0.75).

## P2. art render check (cosmetic)
[x] 6. New placeholder icons render in game (distinct per item, the survey satellite
       has its own icon) and the 144x144 thumbnail shows on the mod.

--------------------------------------------------------------------------
[x] 7. Planet terrain per class. CONFIRMED working. The mod loads with the custom
       tiles, and frozen, volcanic, rocky, and barren use their own tiles (snow,
       ash, sand, basalt). Oceanic has land, fertile is green. Real tile art is a
       future polish item, not a bug.

[ ] 8. Full late game tech tree. Tiers 1 to 8, each with a science pack, a gateway
       tech, and several boost techs, so the tree fills out between tiers. Confirm
       the tech tree shows the chain after the rocket silo, Rocket, Orbital, the six
       planet sciences, Resonance, Core, Exotic, the three force sciences, and
       Stellar. Recipes vary per pack.

[x] 9. The 1000 placeholder tech web was REMOVED in 0.1.17. It was empty filler,
       not real progression. The real progression is item 8, the science tier
       chain with per tier upgrade techs that grant bonuses.

[ ] 10. Non-contiguous technology levels warning (0.1.16). Per-tier boost techs were
        renamed so the gateway is not read as a leveled tech. Confirm the warning is
        gone.

## Known issues
Tiles work. The textures are flat stand-ins, real art is a future polish item.
Oceanic water tuning is deferred, 2.0 needs a property expression for water.

## NOT testable yet, v0.2 groundwork (designed and staged, NOT wired, do NOT test)
Orbit ascent plus orbital science, break copy paste "Divergent Foundation", Core Tap.
All un-wired in data.lua by design until P0 passes. Nothing to test.

Last updated: 2026-07-18.
