# test-list.txt — what JJ should test, in priority order

Living doc. Manager-Claude + Main-Claude keep this CURRENT: when a testable slice lands
(a fix, a wired feature, a new command), add/update its line here FIRST. JJ reads this to
know exactly what to launch Factorio and check. Mark each item's status as you learn it.

Status key:  [ ] not tested   [~] partially / issue found   [x] passes   [!] BLOCKER/broken

Target build: JJtorio 0.1.12 (published). Load in Factorio 2.0 BASE GAME — NO Space Age, NO SE.

--------------------------------------------------------------------------
## P0 — M0: does the foundation even load + run? (BLOCKING everything else)
[x] 1. Mod LOADS: enable JJtorio 0.1.10, start a new base-2.0 save. No error at data stage
       and no error at control stage. (E1 fixed a definite crash bug — defines.inventory
       .rocket didn't exist in 2.0; confirm nothing else trips.)
[x] 2. Dev commands run without error and do what they say:
         /jjt-new-planet     -> creates a planet (a new surface + rolled facts)
         /jjt-planets        -> lists the planets you've generated
         /jjt-goto <name>    -> teleports you to that planet's surface
         /jjt-orbit          -> the orbit surface, reads as space now (confirmed working)
[x] 3. Rocket-silo GATE: the rocket-silo tech shows the intended ~10 prerequisites and IS
       researchable once you have them (unknown gate names are skipped silently, so confirm
       the gate you wanted actually applied). Gate = mature-base techs (6-pack science base,
       electric furnaces, bots, express belts, nuclear).

## P1 — early-game balance sanity (only meaningful once P0 loads)
[x] 4. RESOLVED: early red and green science craft 2 per craft, confirmed in game
       by JJ on 0.1.5.
[x] 5. Feel check: research light-but-not-trivial; inventory ~100 + reach comfortable, not
       silly; asm-1 (0.65) still worth upgrading to asm-2 (0.75).

## P2 — art render check (cosmetic)
[x] 6. New placeholder icons render in-game (distinct per item; the survey satellite has its
       own icon) and the 144x144 thumbnail shows on the mod.

--------------------------------------------------------------------------
[x] 7. Planet terrain per class. CONFIRMED working on 0.1.9. The mod loads with
       the custom tiles, and frozen, volcanic, rocky, and barren use their own
       tiles (snow, ash, sand, basalt). Oceanic has land, fertile is green.
       Real tile art is a future polish item, not a bug.

[ ] 8. Late game science tree (0.1.12). Tiers 1 to 8 are drafted in the tech
       tree, folding in the old Rocket Science draft. First confirm the mod
       still LOADS, since it adds many new packs and techs. Then open the tech
       tree and confirm the chain appears after the rocket silo. Rocket,
       Orbital, the six planet sciences, Resonance, Core, Exotic, the three
       force sciences, and Stellar. Research Rocket then Orbital to sanity check.

## Known issues
Tiles work. The textures are flat stand-ins, real art is a future polish item.
Oceanic water tuning is deferred, 2.0 needs a property expression for water.

## NOT testable yet — v0.2 groundwork (designed + staged, NOT wired; do NOT test)
- Orbit ascent + orbital science (E3), Break-copy-paste "Divergent Foundation" (E5),
  Core Tap (E6). All un-wired in data.lua by design until P0 passes. Nothing to test.

Last updated: 2026-07-18 by Manager-Claude.
