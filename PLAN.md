# JJtorio — Project Plan

Concise plan. Living status is in `what-im-doing.txt`; stable facts in
`context.txt`.

## Vision
An endless, procedurally generated space overhaul for Factorio 2.0. Light,
fast early game; the depth begins once you *earn* the rocket silo and head to
orbit and the planets. Inspired by the **shape** of Space Exploration, but
with its own mechanics. Standalone — incompatible with Space Age and SE.

## Core differentiator
Each procedural planet forces a **different production paradigm** — a real
constraint (heat, gravity, intermittent power, …) that breaks blueprint
copy-paste. That is the identity, not "more ore patches".

## Current state (v0.1.x, on the portal)
- Light early game: faster mining/machines/labs, more reach, cheaper research,
  bigger inventory, cheaper first science packs. *(done, unverified in-game)*
- Rocket-silo tech gated behind megabase techs. *(done, unverified)*
- Procedural planet engine: runtime surfaces + random facts; dev commands
  `/jjt-new-planet`, `/jjt-goto`, `/jjt-orbit`. *(done, unverified)*
- Placeholder: Survey Satellite discovery — too SE-like, to be replaced.

## Milestones
- **M0 — Verify the foundation** *(BLOCKING; needs an in-game test)*
  Load in Factorio, fix load/runtime errors, confirm surfaces + commands work
  on base 2.0 without Space Age.
- **M1 — Real ascent to orbit**
  Replace `/jjt-orbit` with an in-game way to reach orbit after the silo;
  orbit as a proper tiled space surface (space tiles + visuals).
- **M2 — Orbital science tier**
  A JJtorio-original science made in orbit that gates the next tier (items,
  recipes, lab support, technologies).
- **M3 — Travel to planets**
  Reach discovered planets from orbit via an original mechanic (retire the
  SE-like satellite) — colonies you set up, not piloted ships.
- **M4 — Planet paradigms (the differentiator)**
  First distinct constraint (e.g. heat/vacuum), then gravity, storms, …; make
  planet facts (gravity, day length, class) mechanically matter.
- **M5 — Content + polish**
  Real art to replace placeholders, balance pass, locale, docs.

## Working rules
- Verify in-game before claiming anything works.
- Keep files focused (~150 lines); guard base-game edits.
- Don't clone SE systems (4 sciences, piloted ships, data/energy beaming).
- Two-doc state: `context.txt` (stable) + `what-im-doing.txt` (live).
