# Action items for JJ

What needs a human or a dedicated Claude to move JJtorio forward. Written 0.1.30.

## Do first, only you can
Run the 0.1.30 in game load check. Follow jjtest.md, the 10 quick checks. This is
the one thing no Claude can do, and it closes GitHub issue 6, never ship without a
quality check. Report each item back as done or error, and I will fix from there.
Everything from 0.1.10 onward has only had code and API review, not a real launch,
so this test matters.

## Dedicated Claudes worth starting
Each in its own git worktree or branch so the main tree is never left with
uncommitted edits blocking a release. Commit promptly, one lane per process.

1. Content lane. Turn the drafted tiers into real vertical slices for 0.2, in
   order, Rocket Science first then Orbital then one planet science. Guardrail,
   prototypes/orbital-science.lua shares prototype names with the generated tree
   in science-tree.lua, so it will crash if wired as is, it must be reconciled
   first.
2. Art lane. Replace the placeholder tiles and icons with real art. Snow, ash,
   sand, basalt tiles and the machine and intermediate icons.
3. Coordination lane. Keep the four doc layout tight and write one mini report per
   finished project. This carries GitHub issues 2, 3, and 4.

## GitHub issues status
1. No dashes or semicolons in docs. Done and ongoing.
2. Concise docs, four file layout plus team-coordination. Done.
3. Mini report per project. One exists for 0.1.x, keep one per project going.
4. Lowercase names and md format. Mostly done, spot check remaining files.
5. Analyze the agentic team design pattern. Not written yet. Assign to a Claude or
   tell me to write it. A good first draft is what worked, one lane per worktree,
   and what failed, many Claudes on the main tree leaving stale uncommitted edits.
6. Never ship without a quality check. The standing rule is no release without at
   least a load check, and your in game test is what truly closes it.

## Decisions already made this session
Exotic magazine kept strong on purpose. Heavy turret range set to plus 4. Kept
all six planet sciences as the Resonance gate and updated the roadmap to match.
