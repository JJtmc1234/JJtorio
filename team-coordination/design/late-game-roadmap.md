# Late Game Roadmap

The late game is a chain of science tiers, a long tree that branches then
converges to one final science. Each tier is a pack you make, and making it
unlocks the next batch of features. There is always a clear next science, and
each one changes how you build.

Aspirational, v0.2 and beyond. Tier 1 Rocket Science is built as the first real
slice, see progress-report.md. Everything past it is still a draft skeleton in
mod/prototypes/science-tree.lua. Original, not SE. Endless
procedural planets, each forcing a different way to build, and you plan self
running colonies rather than pilot a ship.

## Shape
Vanilla science leads into a JJtorio chain. Rocket, then orbital, then a
branching row of one science per planet paradigm, then converging tiers, then a
final science. Wide in the middle, narrow at the end.

## The chain

### Tier 0. Vanilla base
The six vanilla packs plus the rocket silo. This is 0.1.x today.

### Tier 1. Rocket Science, the first step off world
Gate the rocket silo tech. Made from rocket parts and early space materials on
the ground. Unlocks sending cargo up and reaching orbit.

### Tier 2. Orbital Science, build in orbit
Gate reaching orbit. Made only in orbit from lifted materials. Unlocks orbital
construction and the survey of nearby worlds.

### Tier 3. Planet sciences, a branching row of six
One per planet paradigm, made by operating a colony under that constraint, so
you must hold diverse worlds. They branch from orbital science, any order.
- Vacuum Science. Airless worlds where heat cannot dissipate.
- Cryo Science. Frozen worlds that shed heat too fast.
- Magma Science. Volcanic worlds with free heat but corrosion.
- Tide Science. Oceanic worlds with little land and floating builds.
- Gravity Science. High or low gravity logistics.
- Verdant Science. Fertile worlds and biological processing.
Each unlocks the tools to tame its paradigm.

### Tier 4. Resonance Science, the logistics web
Gate all six planet sciences, so mastering every planet type is the price of
resonance. Made from a balanced multi world freight network. Unlocks bulk
interworld logistics and colony autonomy.

### Tier 5. Core Science, deep extraction
Gate Resonance plus a dense crust colony. Made from refined Core Tap fragments.
Unlocks the Core Tap line and exotic materials.

### Tier 6. Exotic Science, materials with no vanilla analogue
Gate Core Science. Made from cross planet fragment blends. Unlocks advanced
buildings and the force sciences below.

### Tier 7. Force sciences, a short branch
Earned by using a paradigm as a tool, not just surviving it. Gravitic, Thermal,
and Flux Science. Unlock megastructure parts and light terraforming.

### Tier 8. Stellar Science, harness the star
Gate the force sciences. Made from stellar collectors. Unlocks system scale
power and large megastructures.

### Tier 9. Ascendant Science, the frontier
Gate Stellar plus compound paradigm colonies. Made from several extreme world
outputs at once. Unlocks the hardest worlds and the endgame build.

### Tier 10. Convergence Science, the final science, the white sphere
Gate Ascendant plus a broad autonomous empire. Made from the whole network
running as one closed loop. Unlocks the victory build, a Genesis Forge that seeds
a new world you design or a quieter Long Signal ending, plus infinite post
victory research.

## How this drives features
Every mid and late game feature lands as the payoff of a tier, so there is always
a next target. Planets, orbit, core tap, colonies, and megastructures each enter
as a tier unlock rather than all at once.

## Build order for us
Ship one tier at a time as a vertical slice. Rocket Science first, the bridge
from 0.1.x. Then Orbital Science. Then one planet science to prove the paradigm
pattern. Widen only after each slice works in game.
