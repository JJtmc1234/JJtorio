# Infrastructure

A holistic view of the system, the parts, and how they connect.

## Repo layout
mod/ is the shippable Factorio mod. tools/ holds the build, publish, and art
scripts. dist/ holds the built zip and is gitignored. team-coordination/ holds
the coordination and design docs. The four planning docs live at the root.

## The mod (mod/)
info.json is the manifest, name JJtorio, Factorio 2.0.
data.lua loads the data stage tweaks from prototypes/.
control.lua sets up storage and registers the runtime handlers from scripts/.
prototypes/ holds the early game tweaks, cheaper research, silo gating, and the
survey satellite. orbital-science.lua exists but is not wired in yet.
scripts/ holds planet generation, dev commands, discovery, and orbit.
graphics/ and thumbnail.png hold placeholder art.

## How it runs
Planets and orbit are runtime surfaces made with the base game API, not
prototypes, so they work on base Factorio 2.0. Each planet rolls fixed facts
from a per save seed and stores them in storage.planets. Dev commands let you
make and visit planets and orbit while the real travel loop is built.

## Build and release
tools/build-release.ps1 builds a portal ready zip with forward slash paths.
tools/publish.ps1 publishes to the mod portal using an API key held in an
environment variable. A directory junction links the Factorio mods folder to
mod/ for live testing.

## Coordination
Several Claude processes work on this repo. Releases go through the main session
only. Workers use branches. The live coordination channel is MANAGER-COMMS.txt
at the repo root. It stays a .txt because a second process writes to it there,
so like mod/changelog.txt it is a documented exception to the all .md rule. The
other coordination and design docs are in team-coordination/.
