# Progress Report

Last updated 2026-07-25.

## Where we are
Shipped through 0.1.40 on base Factorio 2.0. The mod loads, the early game is
lighter and faster, planets generate as varied procedural surfaces, and orbit
reads as space. The late game tech tree is drafted tiers 1 to 8, and the first
two tiers are now real content.

## 0.2 vertical slices
Two tiers are built as real content, each filling the skeleton science-tree.lua
generates so the science pack superset rule stays in one place.
- Tier 1 Rocket Science (tier-rocket.lua). A thrust assembly intermediate feeds
  the pack. Boosts pay out in rocket part and fuel productivity and a Heavy silo.
- Tier 2 Orbital Science (tier-orbital.lua). An orbital truss intermediate feeds
  the pack. Boosts unlock an orbital construction hub and a deep survey array
  plus real productivity.
Next slice is one planet science to prove the paradigm pattern.

## Content and feel
- Planets paint per class with noise blended tiles, class trees, and scatter, and
  now carry wind and tile ambience. Oceanic is organic sea and islands. Orbit is
  a round platform in a starfield, a community space tile is landing next.
- 24 trigger techs that self research on a milestone, each gated under the base
  tech that unlocks its item.
- New gear, heavy tank and turret, exo armor, shield, legs, and a 100 range exo
  flamethrower. Content tiers, assembling machine 4, turbo belts and inserter,
  exotic circuit and magazine, with their own resprited icons.
- Main menu simulations rebuilt on real ground with tight framing.
- A BRAIN companion character spawns with the player and exposes a jjt_brain
  locate interface, so the external Claude Agentic Player bridge can drive it as
  a co-op teammate. A separate JJtorio dedicated server is set up for that.

## Verification
Every release is gated on a headless factorio.exe dump-data load against an
isolated base 2.0 mod set. JJ play tested 0.1.36 in game, items 4 to 11 passed.
Runtime feel that a dump cannot check still needs an in game look, the menu
framing, planet audio, the orbital tier, and the orbit space tile.

## Next
One planet science tier. Wire some trigger techs into the rocket silo gate.
Real tile art beyond placeholders. Point the brain at the jjt_brain companion.

## Open
Issue 11, the discovery hook will collide with the planned station core launch,
priced into the M1 slice. Costs and balance are draft.
