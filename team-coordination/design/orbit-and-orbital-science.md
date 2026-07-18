# Design: Orbit + Orbital Science (M1 + M2)

Author: Employee-3 (content design). Status: design + one staged scaffolding
file. NOT verified in-game — no in-game claims here. Guards base edits; keeps
files ~150 lines; original mechanics (no SE clone).

This replaces the dev `/jjt-orbit` command (M1) and adds the first space-made
science (M2). It reuses the existing runtime-surface core
(`scripts/orbit.lua`, `scripts/planet-gen.lua`) and the existing prototype
style (`prototypes/survey-satellite.lua`).

---

## Why this is NOT a Space Exploration clone

SE's signatures we deliberately avoid:
- **No 4-science stack + deep-space science.** JJtorio ships ONE orbital
  science pack, not astronomic/biological/energy/material color tiers.
- **No piloted spaceships.** You never fly a vehicle. Orbit is reached through
  *fixed infrastructure you build once and leave running* — a tether lift —
  matching the project's "colonies you set up, not piloted ships" framing.
- **No data/energy beaming, no data cards.** The orbital science loop is a
  plain crafting loop; its difficulty is **logistics + relocation**, not a
  beaming minigame.

JJtorio's own identity instead: **orbit is a resource-free, space-limited
place.** To make orbital science you must physically *relocate a slice of your
factory off-world* and import every ingredient up the tether. That is the same
"a place forces a different production paradigm" idea that defines the mod's
planets — applied to orbit as the first, gentlest example of it.

---

## M1 — Real ascent to orbit

### Player flow
1. Research the rocket silo (already gated behind megabase techs) and the
   existing `jjt-planetary-survey` tech.
2. Research **`jjt-orbital-access`** (new; prereq `rocket-silo`). Unlocks the
   `jjt-station-core` payload and the `jjt-station-tile` (space flooring).
3. Craft a **`jjt-station-core`** and launch it from the rocket silo. The
   launch *establishes your orbit station*: it creates the orbit surface (a
   real tiled space platform surrounded by void) and places one
   `jjt-descent-pad` up there. This is a one-time bootstrap — after it, orbit
   exists permanently for that force.
4. On the ground, build a **`jjt-ascent-lift`** (a powered tower). Stand on its
   base tile and press the **Ascend** custom hotkey to teleport up to the
   station's `jjt-descent-pad`; press it again in orbit to come back down.
5. In orbit you stand on a small starter platform of `jjt-station-tile`. Craft
   more `jjt-station-tile` on the ground, carry them up, and lay them to grow
   the station outward over the void — this is your build space for M2.

### The transport mechanic (original)
- The tether lift is **fixed infrastructure**, not a vehicle: it teleports the
  *character* between two fixed pads, powered and gated on the built lift. No
  cargo piloting, no flight.
- **Cargo** up/down (for M2's imports) rides the same spine: a
  `jjt-lift-cargo-request` — a chest at the lift base whose contents are moved
  to a paired chest at the descent pad on a slow timer (a "freight cycle").
  This keeps SE's "ship stuff to space" shape while being a dumb belt-like
  chest pair, not a spaceship. (Smallest version can defer cargo and just let
  the player hand-carry, since inventory is already enlarged.)

### Orbit as a proper space surface (visuals)
Replace the placeholder `refined-concrete` slab in `scripts/orbit.lua`:
- New tile **`jjt-space-floor`** — a dark metal/starfield platform tile (art
  task; see Art below).
- The station is a small patch of `jjt-space-floor`; everything else is
  `out-of-map` (base tile) so orbit reads as a platform floating in the void.
- Set the orbit surface map-gen to generate nothing (no ores/water/decoratives)
  so it never looks like recolored Nauvis. Optionally give it a dark/starry
  space daytime via `surface.brightness_visual_weights` / a fixed dark
  daylight so it *feels* like space without new shaders.

### Prototypes (jjt- names)
| name | type | notes |
|---|---|---|
| `jjt-orbital-access` | technology | prereq `rocket-silo`; unlocks below |
| `jjt-station-core` | item + recipe | rocket payload; consumed on launch |
| `jjt-station-tile` | item + recipe + tile | space flooring you place |
| `jjt-space-floor` | tile | the visual floor (art) |
| `jjt-ascent-lift` | item + recipe + entity | powered ground tower |
| `jjt-descent-pad` | entity | auto-placed in orbit on bootstrap |
| `jjt-ascend` | custom-input | the teleport hotkey |

### Base edits (guarded)
- Extend the rocket silo's launchable payloads: `jjt-station-core` is a normal
  `rocket-silo` payload item (`rocket_launch_product` not needed; we hook
  `on_rocket_launched` like the existing `scripts/discovery.lua` does). No base
  prototype is mutated for M1 beyond adding new prototypes.

---

## M2 — Orbital science tier

### The pack and its constraint
- New science pack **`jjt-orbital-science-pack`** (a `tool` item, like vanilla
  packs), added to the base lab's `inputs` (guarded base edit) so it is
  researched in ordinary labs on the ground — you carry finished packs *down*.
- It is crafted **only in orbit**, in a new machine
  **`jjt-orbital-fabricator`**, via a dedicated recipe category
  `jjt-orbital-fabrication`. Because the recipe has no other machine, it simply
  cannot be made on the ground — the gate is the *place*, not a lock flag.
- **"Only in orbit" enforcement** (original, robust on base 2.0): a light
  `control.lua` check refunds/blocks a `jjt-orbital-fabricator` placed on any
  surface other than the orbit surface, with a message "Only functions in
  orbit." No dependence on Space Age `surface_conditions`.

### The loop (logistics, not beaming)
- Ingredients are **imported intermediates** you already make on Nauvis —
  e.g. `processing-unit`, `low-density-structure`, `battery` (all guarded: only
  used if present in the running game) — plus lots of **energy_required**,
  representing the long fabrication in microgravity.
- You must haul those up the tether (hand-carry or the freight cycle), craft
  packs in orbit, then carry finished packs down to your labs. The whole
  difficulty is the *off-world supply line + limited platform space*, which is
  the mod's paradigm-shift identity in miniature.
- No new raw resource is invented in orbit (keeps it honest and avoids a
  free-energy exploit); the novelty is *where* you must build, not a new ore.

### Gating the next tier
- Research **`jjt-orbital-science`** (prereq `jjt-orbital-access`) to unlock the
  fabricator + the pack recipe.
- Future techs (M3 travel-to-planets, M4 paradigms) put
  `jjt-orbital-science-pack` in their `unit.ingredients`, so the orbital tier
  is a hard gate on everything past orbit — exactly the role SE's orbital
  science plays, with none of SE's mechanics.

### Prototypes (jjt- names)
| name | type | notes |
|---|---|---|
| `jjt-orbital-science` | technology | prereq `jjt-orbital-access` |
| `jjt-orbital-science-pack` | tool item + recipe | made only in orbit |
| `jjt-orbital-fabricator` | item + recipe + entity | orbit-only machine |
| `jjt-orbital-fabrication` | recipe-category | isolates the recipe |

---

## Smallest first implementable slice

Ordered by build order and by risk (lowest first). Each is independently
shippable and each ends with a concrete in-game check.

1. **Space floor + orbit visuals (M1 core, needs art).** Add the
   `jjt-space-floor` tile; change `scripts/orbit.lua`'s `PLATFORM_TILE` to it
   and surround the platform with `out-of-map`; disable orbit map-gen.
   *Check:* `/jjt-orbit` lands you on a platform in the void, not on concrete
   over Nauvis terrain.
2. **Ascent lift + station bootstrap (M1 transport).** Add `jjt-orbital-access`
   tech, `jjt-station-core` payload, `jjt-ascent-lift`/`jjt-descent-pad`
   entities, and the `jjt-ascend` hotkey + teleport script. Retire `/jjt-orbit`
   to a dev-only fallback. *Check:* launch a core, build a lift, hotkey up and
   down.
3. **Orbital science (M2).** The staged file below. *Check:* build a
   fabricator in orbit, craft `jjt-orbital-science-pack`, research a test tech
   with it in a ground lab.

**Recommended actual first PR:** slice 3's *safe subset* is already staged as
`mod/prototypes/orbital-science.lua` (see below) because it mirrors the
proven-safe `survey-satellite.lua` pattern (item/recipe/tech + guarded lab
edit) and needs no new art or control-flow changes. It is **not yet required**
by `data.lua` — wiring it in is a one-line follow-up once M0 verifies the
foundation loads. Slices 1–2 need art (tile + entity graphics) and a new
`scripts/ascent.lua`, so they follow once M0 is green.

---

## New files added by this task
- `design/orbit-and-orbital-science.md` — this document.
- `mod/prototypes/orbital-science.lua` — staged M2 scaffolding (item, recipe,
  recipe-category, tech, guarded lab-input edit). NOT wired into `data.lua`
  yet, so it cannot affect the unverified foundation until deliberately
  required.

## Deferred to the Art task (Employee-4)
- `jjt-space-floor` tile spritesheet/variants.
- `jjt-ascent-lift`, `jjt-descent-pad`, `jjt-orbital-fabricator` entity
  graphics. Until then these can reuse the placeholder icon for their item
  faces, but entities need real pictures before they load cleanly.
