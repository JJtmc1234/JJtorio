# Progress Report

Last updated 2026-07-18.

## Where we are
Shipped through 0.1.13. The mod loads in game, the early game works, planets
generate with per class tiles, and orbit reads as space. The full late game
tech tree is drafted, tiers 1 to 8, with intermediate techs between the tiers.

## Verified in game
Mod loads on base Factorio 2.0. Dev commands run. Red and green science craft 2.
Orbit reads as space. Custom placeholder tiles load and planet classes look
distinct. This covers the state up to 0.1.9.

## New since 0.1.9 (needs a load check)
Rocket Science tier and then the full science tree drafted in game, tiers 1 to
8. Rocket, Orbital, six planet sciences, Resonance, Core, Exotic, three force
sciences, and Stellar. Each is a new pack plus a gateway tech. 0.1.13 added
intermediate techs per tier that consume the pack and grant real bonuses, and
varied pack recipes per tier. Bug fixes from the QC pass in 0.1.10 and 0.1.11.
A rocket launch crash from a wrong cargo pod call, planet name collisions
overwriting a world, and a Rocket Science pack load error from a missing
durability field.

## Next
Give the drafted tiers real effects and balance beyond placeholder costs, then
Orbital Science as the first original in orbit tier. Real tile art and oceanic
water tuning are polish items.

## Open
The full science tree adds many prototypes drafted since the last verified load,
so confirm the mod still loads in game. Costs and recipes are placeholder draft
balance. Oceanic water tuning needs a property expression, deferred.
