# JJtorio — Worker Agent Guide

The "employees" on this project are Claude processes (agents / subagents), not
humans. This is what a worker agent should do when assigned to JJtorio.

## Onboarding (read first, every time)
1. `CLAUDE.md` — working principles (authoritative).
2. `context.txt` — stable project facts + the runtime model.
3. `PLAN.md` — vision, the core differentiator, milestones M0–M5.
4. `what-im-doing.txt` — live status; update it as you work.
5. Project memory (`MEMORY.md`) — standing preferences (e.g. always publish).

## Working rules (non-negotiable)
- Action discipline: make local, reversible edits freely. Releases are
  centralized — a worker agent does NOT publish to the mod portal (avoids
  version collisions). The main session owns bump → commit → push → publish.
- Less code is more: nothing beyond the assigned task.
- Files stay focused (~150 lines); guard base-game edits so a missing
  prototype can't crash the load.
- Don't clone SE systems (its 4 sciences, piloted ships, data/energy beaming).
- Verify what you can: run `luac -p` on changed Lua (syntax only). You CANNOT
  run Factorio — never claim runtime behavior "works"; mark it unverified.
- Keep `context.txt` / `what-im-doing.txt` in lockstep with your changes.

## Coordination (multiple agents)
- Take one area/task; keep the diff small and self-contained.
- Parallel work uses a git branch or worktree; hand the branch back for the
  main session to review, merge, and release.
- Note what you did in `what-im-doing.txt` so other agents can see it.

## Tasks by area
### Code review (high value now)
The mod is written but unverified in-game. Review the Lua + prototypes against
the Factorio 2.0 API for likely load/runtime errors — the rocket-silo gating,
the survey-satellite item/recipe/tech, the `on_rocket_launched` hook, and
surface creation. Report concrete fixes.

### Testing / QA
- Static checks + reasoning about base-2.0 behavior (surfaces, tech gating).
- Draft in-game test steps for a human to run (no agent can launch Factorio).

### Art (placeholders)
- Replace the flat placeholder icons/thumbnail; the generator is a stopgap.

### Balance
- Early-game numbers and the rocket-silo prerequisite gate.

### Content (PLAN.md, M1–M4)
- Ascent to orbit + space tiles; the orbital science tier; planet production
  paradigms (the differentiator).

### Docs
- Keep PLAN.md / context.txt / README / this file current.

## Community feedback (humans, separate)
Player feedback arrives by email (subject "JJtorio"); triage it and fold
useful items into PLAN.md.
