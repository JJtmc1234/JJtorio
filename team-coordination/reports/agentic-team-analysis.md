# Agentic team analysis

GitHub issue 5. How the multi Claude team worked on JJtorio, what held up, and what to change.

## The pattern
One human driver, JJ, plus several Claude Code processes. Each Claude takes a
lane, content, art, coordination, or a one off analysis, and keeps its diff
small. The lanes and their paste ready prompts live in
team-coordination/action-items.md. Only JJ can launch Factorio, so any claim
about runtime behavior stays unverified until he runs jjtest.md.

One session is the main session. It owns bump, commit, push, and the mod portal
publish. Workers never publish. The intended isolation is a git worktree or
branch per lane, made with git worktree add, so a worker edits its own tree and
the main tree is never left dirty at release time.

## What worked
Lanes in separate worktrees held up. A worker in its own tree could edit, parse
check with luac, and commit without touching what the main session was shipping.
The review lanes paid off. Multi agent code and API passes landed real fixes
before a release went out, visible at 4c84e4d, b78cafe, and 6c66a2a, each a two
or three agent review batch.

Splitting by concern kept diffs legible. The content lane drove the rocket tier
slices, the coordination lane kept the four root docs and reports tight, and the
generated science tree stayed the single source for the pack superset rule so
lanes did not fight over it.

## What failed
Several Claudes editing the main tree at once was the recurring failure. Stale
uncommitted edits from parallel workers blocked a release for about an hour
while the main session sorted out whose changes were whose. The cleanup shows in
the history as af2071e, 0.1.30 commit settled team edits, and again at bae83b4,
0.1.37 followup, commit the rocket refine and doc merge that shipped.

Worse, a git add once aborted on a stale pathspec, a file the index expected but
that a worker had moved or removed. The release went out anyway, so that
version's repo commit was incomplete relative to what shipped. The root cause was
the same, more than one process mutating one working tree.

The fix went into the build. tools/build-release.ps1 now zips only git tracked
files, taken straight from git ls-files mod, and throws if that list is empty. A
tracked file deleted on disk is skipped, and nothing untracked can enter the zip.
Uncommitted or half written work can no longer leak into a release even when the
tree is dirty.

## Rules for next time
1. One tree per lane. Every worker runs in its own worktree or branch. No two
   processes edit the main tree at the same time.
2. The main session is the only writer of the main tree, and the only one that
   bumps, commits, pushes, and publishes.
3. A worker hands off by committing on its own branch, not by leaving edits in a
   shared tree for someone else to find.
4. Build from git, not from disk. Keep the tracked files only rule so a dirty
   tree cannot ship.
5. Before any release, confirm the tree is clean and the index matches, so a
   stale pathspec cannot slip a partial commit into a published version.
6. No release without at least a parse check, and mark anything needing a real
   Factorio launch as unverified for JJ.
