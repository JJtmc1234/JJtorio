# Mini report, JJtorio 0.1.x foundation and early game

For Miss Candi and Hunter, per issue #3. This is the report after the 0.1.x
project. Keep one of these per project. It says what got done, what we learned,
and how to present it in a few minutes.

## The project in one line
Ship a standalone Factorio 2.0 space overhaul foundation, a light early game
now, with the depth staged for space later. Shipped through 0.1.24.

## What we did
1. The mod loads on base Factorio 2.0. Standalone, not Space Age and not Space
   Exploration.
2. Lighter faster early game. More reach, cheaper and faster research, quicker
   tier 1 machines, and a bigger starting inventory.
3. The rocket silo is earned. Its research is gated behind a mature base, the
   full science line, electric furnaces, bots, express belts, and nuclear.
4. Planets and orbit are runtime surfaces built with the base game API, so they
   work without custom planet prototypes. Each planet rolls fixed facts from a
   per save seed. Dev commands make and visit planets and orbit.
5. Per class placeholder tiles, so frozen, volcanic, rocky, and barren read as
   distinct. Orbit reads as space.
6. The full late game tech tree is drafted in game, tiers 1 to 8, each a science
   pack plus a gateway tech plus per tier boost techs. We removed an earlier
   1000 tech placeholder web that was empty filler.
7. Tech unlocked content tiers, Advanced Fabrication, Turbo Logistics, and
   Exotic Munitions, built by cloning base prototypes at draft balance.
8. An art polish pass on placeholder icons, tiles, and the mod thumbnail.

## What we learned
1. Runtime surfaces keep the mod on base 2.0. Prototype planets were not needed
   for the foundation, so the load stays clean.
2. Guard every base game edit so a missing prototype cannot crash the load.
3. Factorio read our per tier boost techs as leveled techs and warned about non
   contiguous levels. Renaming them cleared the warning. Naming carries meaning
   to the engine.
4. We cannot run the game, so we verify statically with luac and reasoning, and
   mark runtime behavior unverified until a human tests it. Only JJ can launch.
5. Several Claude processes share this repo. Work goes on branches, releases go
   through the main session only, and the live status stays in progress-report.md.

## What is next
1. Confirm the mod still loads after the large tech tree additions. This is a
   human load check and it blocks the rest.
2. Give the drafted tiers real effects and balance beyond placeholder costs.
3. Build Orbital Science as the first original in orbit tier.
4. Polish, real tile art and oceanic water tuning, both deferred.

## Present it in five minutes
1. The idea and why. An endless procedural space overhaul, originality over
   copying Space Exploration systems.
2. What plays today in 0.1.x, the light early game and the earned rocket silo.
3. A quick tour, load the mod, run the dev commands, visit a planet, reach orbit,
   open the drafted tech tree.
4. What we learned, the five points above.
5. What is next toward 0.2, orbit ascent and orbital science.
