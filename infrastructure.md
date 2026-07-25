# Infrastructure

The system, its parts, and how they connect.

## Repo layout
mod/ is the shippable mod. tools/ holds build, publish, and art scripts. dist/
holds the built zip and is gitignored. team-coordination/ holds coordination and
design docs. The four planning docs live at the root.

## File conventions
Docs use lowercase hyphenated .md names. Exceptions are the tool required
CLAUDE.md and README.md, and mod/changelog.txt because Factorio requires that
name. Source and config files keep the names their tools expect.

## The mod (mod/)
info.json is the manifest, name JJtorio, Factorio 2.0.
data.lua loads the data stage tweaks from prototypes/.
control.lua sets up storage and registers runtime handlers from scripts/.
prototypes/ holds early game tweaks, cheaper research, silo gating, and the
survey satellite. orbital-science.lua exists but is not wired in yet.
scripts/ holds planet generation, dev commands, discovery, and orbit.
graphics/ and thumbnail.png hold placeholder art.

## How it runs
Planets and orbit are runtime surfaces made with the base game API, not
prototypes, so they run on base 2.0. Each planet rolls fixed facts from a per
save seed into storage.planets. Dev commands make and visit planets and orbit
while the real travel loop is built.

## Build and release
tools/build-release.ps1 builds a portal ready zip with forward slash paths.
tools/publish.ps1 publishes to the portal using an API key from an environment
variable. A directory junction links the Factorio mods folder to mod/ for live
testing.

## Coordination
Several Claude processes work here. Releases go through the main session only.
Workers use their own branches or git worktrees. Coordination and design docs
live in team-coordination/, with per lane prompts and next steps in
team-coordination/action-items.md.
