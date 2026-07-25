# Design: Orbit and Orbital Science (M1 and M2)

Author Employee-3, content design. Status is design plus one staged scaffolding
file. Nothing here is verified in game, so no in game claims. It guards base
edits, keeps files near 150 lines, and stays original with no SE clone.

This replaces the dev `/orbit` command (M1) and adds the first space made
science (M2). It reuses the runtime surface core in `scripts/orbit.lua` and
`scripts/planet-gen.lua` and the prototype style in
`prototypes/survey-satellite.lua`.

## Why this is not a Space Exploration clone
No four science stack and no deep space science, JJtorio ships one orbital pack.
No piloted spaceships, you reach orbit through fixed infrastructure you build
once and leave running, a tether lift. No data or energy beaming and no data
cards, the orbital loop is a plain crafting loop whose difficulty is logistics
and relocation.

The identity instead. Orbit is a resource free, space limited place. To make
orbital science you relocate a slice of your factory off world and import every
ingredient up the tether. That is the planets' "a place forces a different
paradigm" idea, applied to orbit as the first and gentlest example.

## M1, real ascent to orbit

Player flow.
1. Research the rocket silo, already gated behind megabase techs, and the
   existing `jjt-planetary-survey` tech.
2. Research `jjt-orbital-access`, prereq `rocket-silo`. It unlocks the
   `jjt-station-core` payload and the `jjt-station-tile` space flooring.
3. Craft a `jjt-station-core` and launch it from the silo. The launch creates
   the orbit surface, a real tiled platform surrounded by void, and places one
   `jjt-descent-pad`. A one time bootstrap, after it orbit exists permanently for
   that force.
4. On the ground, build a `jjt-ascent-lift`, a powered tower. Stand on its base
   and press the Ascend hotkey to teleport to the descent pad. Press again in
   orbit to come back down.
5. In orbit you stand on a starter platform of `jjt-station-tile`. Craft more on
   the ground, carry it up, and lay it to grow the station over the void. Your
   build space for M2.

Transport mechanic. The tether lift is fixed infrastructure, not a vehicle. It
teleports the character between two fixed pads, powered and gated on the built
lift, with no cargo piloting. Cargo for M2 imports rides the same spine. A
`jjt-lift-cargo-request` chest at the base moves its contents to a paired chest
at the descent pad on a slow freight cycle. The smallest version can defer cargo
and let the player hand carry, since inventory is already enlarged.

Orbit as a proper space surface. Replace the placeholder `refined-concrete` slab
in `scripts/orbit.lua`. Add a tile `jjt-space-floor`, a dark metal and starfield
platform tile (art below). The station is a small patch of it, everything else
`out-of-map`, so orbit reads as a platform in the void. Set orbit map gen to
generate nothing, so it never looks like recolored Nauvis. Optionally give it a
fixed dark daylight.

Prototypes, jjt names.
- `jjt-orbital-access`, technology, prereq `rocket-silo`, unlocks the items below.
- `jjt-station-core`, item and recipe, rocket payload consumed on launch.
- `jjt-station-tile`, item, recipe, and tile, the space flooring you place.
- `jjt-space-floor`, tile, the visual floor, art.
- `jjt-ascent-lift`, item, recipe, and entity, the powered ground tower.
- `jjt-descent-pad`, entity, auto placed in orbit on bootstrap.
- `jjt-ascend`, custom input, the teleport hotkey.

Base edits, guarded. `jjt-station-core` is a normal silo payload item. We hook
`on_rocket_launched` like `scripts/discovery.lua` does, so no base prototype is
mutated for M1 beyond adding new prototypes.

## M2, orbital science tier

The pack and its constraint. A new pack `jjt-orbital-science-pack`, a tool item
added to the base lab inputs as a guarded edit so it is researched in ground
labs. It is crafted only in orbit, in `jjt-orbital-fabricator`, via the recipe
category `jjt-orbital-fabrication`. Because no other machine has the category it
cannot be made on the ground, so the gate is the place, not a lock flag. A light
`control.lua` check refunds a `jjt-orbital-fabricator` placed off orbit, message
"Only functions in orbit." No Space Age surface conditions needed.

The loop, logistics not beaming. Ingredients are imported intermediates you
already make on Nauvis, for example `processing-unit`, `low-density-structure`,
and `battery`, all guarded so they are only used if present, plus a large
`energy_required`. You haul them up the tether, craft packs in orbit, then carry
finished packs down to your labs. The difficulty is the off world supply line
and the limited platform space. No new raw resource is invented in orbit, which
avoids a free energy exploit. The novelty is where you must build, not a new ore.

Gating the next tier. Research `jjt-orbital-science`, prereq
`jjt-orbital-access`, to unlock the fabricator and pack recipe. Future M3 and M4
techs put `jjt-orbital-science-pack` in their ingredients, so the orbital tier is
a hard gate on everything past orbit.

Prototypes, jjt names.
- `jjt-orbital-science`, technology, prereq `jjt-orbital-access`.
- `jjt-orbital-science-pack`, tool item and recipe, made only in orbit.
- `jjt-orbital-fabricator`, item, recipe, and entity, orbit only machine.
- `jjt-orbital-fabrication`, recipe category, isolates the recipe.

## Smallest first implementable slice
Ordered by risk, lowest first. Each is independently shippable and ends with a
concrete in game check.
1. Space floor and orbit visuals, M1 core, needs art. Add `jjt-space-floor`,
   change `PLATFORM_TILE` in `scripts/orbit.lua` to it, surround with
   `out-of-map`, disable orbit map gen. Check that `/orbit` lands you on a
   platform in the void, not concrete over Nauvis.
2. Ascent lift and station bootstrap, M1 transport. Add `jjt-orbital-access`,
   the `jjt-station-core` payload, the `jjt-ascent-lift` and `jjt-descent-pad`
   entities, and the `jjt-ascend` hotkey and teleport script. Retire `/orbit`
   to a dev fallback. Check you can launch a core, build a lift, and hotkey up
   and down.
3. Orbital science, M2, the staged file below. Check you can build a fabricator
   in orbit, craft `jjt-orbital-science-pack`, and research a test tech with it
   in a ground lab.

Recommended first PR. The safe subset of slice 3 is staged as
`mod/prototypes/orbital-science.lua` because it mirrors the proven
`survey-satellite.lua` pattern, an item, recipe, and tech plus a guarded lab
edit, and needs no art or control flow. It is not yet required by `data.lua`, so
wiring it in is a one line follow up once M0 verifies the load. Slices 1 and 2
need art and a new `scripts/ascent.lua`, so they follow once M0 is green.

## New files added by this task
- `team-coordination/design/orbit-and-orbital-science.md`, this document.
- `mod/prototypes/orbital-science.lua`, staged M2 scaffolding. Not wired into
  `data.lua` yet, so it cannot affect the unverified foundation.

## Deferred to the art task, Employee-4
- The `jjt-space-floor` tile spritesheet and variants.
- The `jjt-ascent-lift`, `jjt-descent-pad`, and `jjt-orbital-fabricator` entity
  graphics. Until then they can reuse the placeholder icon for item faces, but
  entities need real pictures before they load cleanly.
