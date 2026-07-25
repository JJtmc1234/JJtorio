# Progress Report

Last updated 2026-07-24.

## 0.2 vertical slices
Tier 1 Rocket Science is built, the first drafted tier turned into real content.
It is a ground chain, not a gateway. A new Thrust assembly intermediate feeds the
pack, and the three tier techs pay out for real. Launch throughput gives rocket
part productivity, Heavy lift unlocks a Heavy silo that needs 50 rocket parts
instead of 100 and builds them half again as fast, and Ascent refinement adds
more rocket part and rocket fuel productivity. Lives in
mod/prototypes/tier-rocket.lua, which fills in the skeleton science-tree.lua
generates so the science pack superset rule stays in one place.

Next slice is Orbital Science, then one planet science. Orbital first has to
reconcile prototypes/orbital-science.lua, which defines the same two names
science-tree.lua already generates, so requiring it as is would crash on a
duplicate prototype.

## Where we are
Shipped through 0.1.30. The mod loads on base 2.0, the early game works, planets
generate with per class tiles, and orbit reads as space. The full late game tech
tree is drafted, tiers 1 to 8, with per tier upgrade techs that grant real
bonuses. Techs unlock new tiers of content, and there are 24 trigger techs plus a
tier of new gear.

## Recent batches (need an in game load check)
- 0.1.27 fixes from test feedback. Painted planets drop the Nauvis grass, rocks,
  and cliffs but keep trees. Oceanic is a sea with sand islands. Fertile paints
  green. The exotic magazine got double round damage on top of double size.
- 0.1.27 added 24 trigger techs that self research on a milestone like crafting
  2000 belts, each granting a small bonus.
- 0.1.27 added new gear cloned and buffed. Heavy tank, heavy turret, exo armor
  with a bigger grid, exo shield, and exo legs, behind three techs.
- 0.1.28 sentence case item labels, dev commands lost the jjt prefix (/new-planet,
  /planets, /goto, /orbit), and info.json declares incompatibility with the major
  overhauls.
- 0.1.29 three agent review cleanups. Reordered the machine 4 intermediates and
  guarded on them, removed dead terrain data, dropped an unreachable trigger
  branch, and pushed the Recon Network milestone to 40 radars.
- 0.1.30 trimmed the heavy turret range to plus 4 so it does not match the laser
  turret. The exotic magazine was kept strong on purpose per JJ.

## Verified in game (through 0.1.9)
Mod loads on base 2.0. Dev commands run. Red and green science craft 2. Orbit
reads as space. Custom placeholder tiles load and planet classes look distinct.
Everything from 0.1.10 on still needs an in game load check, see jjtest.md.

## Verified at the data stage (0.1.31 plus the rocket slice)
A headless run of factorio.exe with dump data, against an isolated mods folder
holding only JJtorio on base 2.0.77, loads the whole data stage with no errors.
The dump confirms the rocket tier prototypes are correct. This covers prototypes
only. Runtime, control.lua, and anything you have to look at still need a real in
game check.

## Next
Give the drafted tiers real effects and balance, then Orbital Science as the
first original in orbit tier. Wire some trigger techs into the rocket silo gate
so the milestones actually gate space (open item from test feedback). Real tile
art and oceanic water tuning are polish.

## Open
Confirm the mod still loads after the recent batches. Costs, recipes, and upgrade
effects are placeholder draft balance. Oceanic water tuning needs a property
expression, deferred. Trigger techs are standalone achievements, not yet wired
into the silo gate.
