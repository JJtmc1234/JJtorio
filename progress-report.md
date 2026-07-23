# Progress Report

Last updated 2026-07-22.

## Where we are
Shipped through 0.1.27. The mod loads, the early game works, planets generate
with per class tiles, and orbit reads as space. The full late game tech tree is
drafted, tiers 1 to 8, with per tier upgrade techs that grant real bonuses.
Techs unlock new tiers of content.

## 0.1.27 batch (needs a load check in game)
Shipped as one version so JJ tests the whole thing at once.
- Stage 1 fixes from testing feedback. Painted planets drop Nauvis grass
  decoratives, rocks, and cliffs but keep trees. Oceanic is a sea with sand
  islands. Fertile paints green. The exotic magazine got double round damage.
- Stage 2, 24 trigger techs that research themselves on a milestone like
  crafting 2000 belts, each granting a small bonus.
- Stage 3, new gear cloned and buffed. Heavy Tank, Heavy Turret, Exo Armor with
  a bigger grid, Exo Shield, Exo Legs, behind three new techs.
- A two agent API check before publish caught two silent breaks and fixed them.
  Build-entity triggers ignore count in 2.0 so those milestones now use craft
  triggers, and place_as_equipment_result was renamed to the 2.0 spelling.

## Verified in game (through 0.1.9)
Mod loads on base 2.0. Dev commands run. Red and green science craft 2. Orbit
reads as space. Custom placeholder tiles load and planet classes look distinct.

## New since 0.1.9 (needs a load check)
- Full science tree drafted in game, tiers 1 to 8. Rocket, Orbital, six planet
  sciences, Resonance, Core, Exotic, three force sciences, and Stellar. Each is a
  pack plus a gateway tech.
- 0.1.13 added per tier intermediate techs that consume the pack and grant real
  bonuses, and varied pack recipes.
- 0.1.16 fixed a non-contiguous levels warning by renaming per tier techs so
  Factorio stops reading them as levels of the gateway.
- 0.1.17 removed the earlier 1000 tech placeholder web as empty filler. The late
  game is now the tier chain plus per tier upgrade techs.
- 0.1.19 added tech unlocked content tiers, Advanced Fabrication, Turbo
  Logistics, and Exotic Munitions, cloned from base prototypes at draft balance.
- 0.1.10 and 0.1.11 QC fixes. A rocket launch crash from a wrong cargo pod call,
  planet name collisions overwriting a world, and a Rocket Science pack load
  error from a missing durability field.
- Art polish 0.1.14 through 0.1.24. Lit item icons with inner shadow and beveled
  frames, finer tile grain and coarse mottle, and a lit planet with an ascent
  streak on the thumbnail.

## Next
Give the drafted tiers real effects and balance, then Orbital Science as the
first original in orbit tier. Real tile art and oceanic water tuning are polish.

## Open
The science tree adds many prototypes since the last verified load, so confirm
the mod still loads. Costs, recipes, and upgrade effects are placeholder draft
balance. Oceanic water tuning needs a property expression, deferred.
