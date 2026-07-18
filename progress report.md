# Progress Report

Last updated 2026-07-18.

## Where we are
Shipped through 0.1.20. The mod loads in game, the early game works, planets
generate with per class tiles, and orbit reads as space. The full late game
tech tree is drafted, tiers 1 to 8, with per tier upgrade techs between the
tiers that grant real bonuses. Techs now unlock new tiers of content.

## Verified in game
Mod loads on base Factorio 2.0. Dev commands run. Red and green science craft 2.
Orbit reads as space. Custom placeholder tiles load and planet classes look
distinct. This covers the state up to 0.1.9.

## New since 0.1.9 (needs a load check)
Rocket Science tier and then the full science tree drafted in game, tiers 1 to
8. Rocket, Orbital, six planet sciences, Resonance, Core, Exotic, three force
sciences, and Stellar. Each is a new pack plus a gateway tech. 0.1.13 added
intermediate techs per tier that consume the pack and grant real bonuses, and
varied pack recipes per tier. 0.1.17 removed an earlier 1000 tech placeholder
web as empty filler, so the late game is now the tier chain plus fuller per
tier upgrade techs, a genuine progression. 0.1.16 fixed a non-contiguous
technology levels warning by renaming per tier intermediate techs so Factorio
no longer reads them as levels of the gateway. 0.1.14 and 0.1.18 improved
placeholder art with lit item icons, a finer tile grain, and a matching inner
shadow so icons read as rounded lit forms. Bug fixes from the QC pass in 0.1.10
and 0.1.11. A rocket launch crash from a wrong cargo pod call, planet name
collisions overwriting a world, and a Rocket Science pack load error from a
missing durability field. 0.1.19 added tech unlocked content tiers. Advanced
Fabrication, Turbo Logistics, and Exotic Munitions, built by cloning base
prototypes and bumping stats, draft balance. 0.1.20 gave the placeholder tiles
a coarse mottle pass so they read as natural material instead of uniform noise.

## Next
Give the drafted tiers real effects and balance beyond placeholder costs, then
Orbital Science as the first original in orbit tier. Real tile art and oceanic
water tuning are polish items.

## Open
The science tree and per tier upgrade techs add many prototypes drafted since
the last verified load, so confirm the mod still loads in game. Costs, recipes,
and upgrade effects are placeholder draft balance. Oceanic water tuning needs a
property expression, deferred.
