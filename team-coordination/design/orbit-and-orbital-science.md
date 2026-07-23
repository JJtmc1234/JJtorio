# Design: Orbit and Orbital Science (M1 and M2)

Author Employee-3, content design. Status is design plus one staged scaffolding
file. Nothing here is verified in game, so there are no in game claims. It guards
base edits, keeps files near 150 lines, and stays original with no SE clone.

This replaces the dev `/jjt-orbit` command (M1) and adds the first space made
science (M2). It reuses the runtime surface core in `scripts/orbit.lua` and
`scripts/planet-gen.lua` and the prototype style in
`prototypes/survey-satellite.lua`.

## Why this is not a Space Exploration clone
We avoid the SE signatures. No four science stack and no deep space science,
JJtorio ships one orbital pack. No piloted spaceships, you reach orbit through
fixed infrastructure you build once and leave running, a tether lift, matching
the colonies you set up rather than ships you pilot. No data or energy beaming
and no data cards, the orbital loop is a plain crafting loop whose difficulty is
logistics and relocation.

JJtorio identity instead. Orbit is a resource free, space limited place. To make
orbital science you physically relocate a slice of your factory off world and
import every ingredient up the tether. That is the same "a place forces a
different production paradigm" idea that defines the planets, applied to orbit as
the first and gentlest example.

## M1, real ascent to orbit

Player flow.
1. Research the rocket silo, already gated behind megabase techs, and the
   existing `jjt-planetary-survey` tech.
2. Research `jjt-orbital-access`, new, prereq `rocket-silo`. It unlocks the
   `jjt-station-core` payload and the `jjt-station-tile` space flooring.
3. Craft a `jjt-station-core` and launch it from the rocket silo. The launch
   establishes your orbit station. It creates the orbit surface, a real tiled
   space platform surrounded by void, and places one `jjt-descent-pad`. This is
   a one time bootstrap, after it orbit exists permanently for that force.
4. On the ground, build a `jjt-ascent-lift`, a powered tower. Stand on its base
   tile and press the Ascend hotkey to teleport up to the descent pad. Press it
   again in orbit to come back down.
5. In orbit you stand on a small starter platform of `jjt-station-tile`. Craft
   more on the ground, carry it up, and lay it to grow the station outward over
   the void. This is your build space for M2.

Transport mechanic, original. The tether lift is fixed infrastructure, not a
vehicle. It teleports the character between two fixed pads, powered and gated on
the built lift, with no cargo piloting and no flight. Cargo up and down for the
M2 imports rides the same spine. A `jjt-lift-cargo-request` chest at the lift
base moves its contents to a paired chest at the descent pad on a slow freight
cycle. This keeps the ship stuff to space shape while staying a dumb chest pair
rather than a spaceship. The smallest version can defer cargo and let the player
hand carry, since inventory is already enlarged.

Orbit as a proper space surface. Replace the placeholder `refined-concrete` slab
in `scripts/orbit.lua`. Add a new tile `jjt-space-floor`, a dark metal and
starfield platform tile, an art task below. The station is a small patch of
`jjt-space-floor` and everything else is `out-of-map`, so orbit reads as a
platform floating in the void. Set the orbit map gen to generate nothing, no
ores, water, or decoratives, so it never looks like recolored Nauvis. Optionally
give it a fixed dark daylight so it feels like space without new shaders.

Prototypes, jjt names.
- `jjt-orbital-access`, technology, prereq `rocket-silo`, unlocks the items below.
- `jjt-station-core`, item and recipe, rocket payload consumed on launch.
- `jjt-station-tile`, item, recipe, and tile, the space flooring you place.
- `jjt-space-floor`, tile, the visual floor, art.
- `jjt-ascent-lift`, item, recipe, and entity, the powered ground tower.
- `jjt-descent-pad`, entity, auto placed in orbit on bootstrap.
- `jjt-ascend`, custom input, the teleport hotkey.

Base edits, guarded. `jjt-station-core` is a normal rocket silo payload item. We
hook `on_rocket_launched` like the existing `scripts/discovery.lua` does, so no
base prototype is mutated for M1 beyond adding new prototypes.

## M2, orbital science tier

The pack and its constraint. A new science pack `jjt-orbital-science-pack`, a
tool item like the vanilla packs, added to the base lab inputs as a guarded edit
so it is researched in ordinary ground labs. You carry finished packs down. It is
crafted only in orbit, in a new machine `jjt-orbital-fabricator`, via a dedicated
recipe category `jjt-orbital-fabrication`. Because the recipe has no other
machine it simply cannot be made on the ground, so the gate is the place, not a
lock flag. A light `control.lua` check refunds or blocks a
`jjt-orbital-fabricator` placed on any surface other than orbit, with the message
"Only functions in orbit." This needs no Space Age surface conditions.

The loop, logistics not beaming. Ingredients are imported intermediates you
already make on Nauvis, for example `processing-unit`, `low-density-structure`,
and `battery`, all guarded so they are only used if present, plus a large
`energy_required` for the long fabrication in microgravity. You haul those up the
tether by hand or freight cycle, craft packs in orbit, then carry finished packs
down to your labs. The whole difficulty is the off world supply line and the
limited platform space, the mod paradigm shift in miniature. No new raw resource
is invented in orbit, which keeps it honest and avoids a free energy exploit. The
novelty is where you must build, not a new ore.

Gating the next tier. Research `jjt-orbital-science`, prereq `jjt-orbital-access`,
to unlock the fabricator and the pack recipe. Future techs for M3 travel to
planets and M4 paradigms put `jjt-orbital-science-pack` in their ingredients, so
the orbital tier is a hard gate on everything past orbit, the role SE orbital
science plays with none of its mechanics.

Prototypes, jjt names.
- `jjt-orbital-science`, technology, prereq `jjt-orbital-access`.
- `jjt-orbital-science-pack`, tool item and recipe, made only in orbit.
- `jjt-orbital-fabricator`, item, recipe, and entity, orbit only machine.
- `jjt-orbital-fabrication`, recipe category, isolates the recipe.

## Smallest first implementable slice
Ordered by build order and by risk, lowest first. Each is independently shippable
and ends with a concrete in game check.
1. Space floor and orbit visuals, M1 core, needs art. Add the `jjt-space-floor`
   tile, change the `PLATFORM_TILE` in `scripts/orbit.lua` to it, surround the
   platform with `out-of-map`, and disable orbit map gen. Check that `/jjt-orbit`
   lands you on a platform in the void, not on concrete over Nauvis.
2. Ascent lift and station bootstrap, M1 transport. Add the `jjt-orbital-access`
   tech, the `jjt-station-core` payload, the `jjt-ascent-lift` and
   `jjt-descent-pad` entities, and the `jjt-ascend` hotkey and teleport script.
   Retire `/jjt-orbit` to a dev only fallback. Check that you can launch a core,
   build a lift, and hotkey up and down.
3. Orbital science, M2, the staged file below. Check that you can build a
   fabricator in orbit, craft `jjt-orbital-science-pack`, and research a test
   tech with it in a ground lab.

Recommended first PR. The safe subset of slice 3 is already staged as
`mod/prototypes/orbital-science.lua` because it mirrors the proven safe
`survey-satellite.lua` pattern, an item, recipe, and tech plus a guarded lab
edit, and needs no new art or control flow. It is not yet required by `data.lua`,
so wiring it in is a one line follow up once M0 verifies the foundation loads.
Slices 1 and 2 need art, a tile and entity graphics, and a new
`scripts/ascent.lua`, so they follow once M0 is green.

## New files added by this task
- `team-coordination/design/orbit-and-orbital-science.md`, this document.
- `mod/prototypes/orbital-science.lua`, staged M2 scaffolding, an item, recipe,
  recipe category, tech, and guarded lab input edit. Not wired into `data.lua`
  yet, so it cannot affect the unverified foundation until deliberately required.

## Deferred to the art task, Employee-4
- The `jjt-space-floor` tile spritesheet and variants.
- The `jjt-ascent-lift`, `jjt-descent-pad`, and `jjt-orbital-fabricator` entity
  graphics. Until then they can reuse the placeholder icon for their item faces,
  but entities need real pictures before they load cleanly.
