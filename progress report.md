# Progress Report

Last updated 2026-07-18.

## Where we are
Shipped 0.1.5 to the mod portal. This is the foundation and early game. Nothing
has been run in Factorio yet, so all of it is unverified in game.

## Done
The early game is lighter and faster, with more reach, cheaper and faster
research, a bigger inventory, and quicker tier one machines. The rocket silo
research is gated behind a mature base of about ten techs. A procedural planet
engine and dev commands exist. Placeholder art and a thumbnail are in. Four
worker branches were merged. The public description was corrected so it no
longer implies planets are playable.

## Blocking
M0 in game load test. Only JJ can launch Factorio. Please load 0.1.5, watch for
load errors, and check whether red and green science packs craft two or one.

## Next
The main session builds planet terrain per class and new tiles. The team
designs the blueprint break and the Core Tap. After M0 passes we wire in
orbital science and build the real orbit ascent.

## Open question
JJ reported that red and green science craft one, not two. The code looks
correct to two audits. This needs an in game check to resolve.
