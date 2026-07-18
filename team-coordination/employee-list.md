# JJtorio Worker Agent Guide

The employees on this project are Claude processes, not humans. This is what a
worker agent should do when assigned to JJtorio.

## Onboarding (read first, every time)
1. CLAUDE.md, the working principles.
2. brainstorm.md, the idea and the why.
3. planning.md, the plan, milestones, and versioning.
4. infrastructure.md, the system overview.
5. progress report.md, the live status. Update it as you work.
Coordination and design docs live in team-coordination.

## Working rules
Action discipline. Local reversible edits are fine. Releases are centralized, so
a worker does NOT publish to the mod portal. The main session owns bump, commit,
push, and publish.
Less code is more. Nothing beyond the assigned task.
Keep files focused, about 150 lines. Guard base game edits so a missing
prototype cannot crash the load.
Do not clone SE systems, its four sciences, piloted ships, or data and energy
beaming.
Verify what you can with luac. You cannot run Factorio, so never claim runtime
behavior works. Mark it unverified.
No dashes and no semicolons in any doc or report. Keep docs concise.

## Coordination
Take one area. Keep the diff small. Parallel work uses a git branch or worktree,
then hand it back for the main session to review, merge, and release. Note what
you did in progress report.md.

## Tasks by area
Code review. Audit Lua and prototypes against the 2.0 API for load and runtime
bugs. Report concrete fixes.
Testing. Static checks and reasoning, plus draft in game test steps for a human.
Art. Replace the flat placeholder icons and tiles.
Balance. Early game numbers and the rocket silo gate.
Content. See planning.md M1 to M4. Rocket science, orbital science, planet
paradigms, the Core Tap.
Docs. Keep planning.md, infrastructure.md, progress report.md, and this file
current.

## Community feedback
Player feedback arrives by email with the subject JJtorio. Triage it into
planning.md.
