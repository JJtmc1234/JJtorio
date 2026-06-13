# JJtorio

A Space-Exploration-style overhaul mod for Factorio 2.0: procedurally
generated planets (as runtime surfaces), a light early game, and depth in
space. Standalone — incompatible with Space Age and Space Exploration.

> Status: early foundation. The procedural planet core exists but has not
> yet been verified in-game. See `context.txt` (stable facts) and
> `what-im-doing.txt` (live status).

## Layout
- `mod/` — the shippable Factorio mod (this is what gets zipped/published).
- `tools/` — dev scripts (placeholder-graphics generator, etc.).
- `dist/` — built `JJtorio_<version>.zip` (gitignored).
- `context.txt` / `what-im-doing.txt` — the two-document project state.

## Develop & test
A directory junction at `%APPDATA%\Factorio\mods\JJtorio` points to `mod/`,
so edits here are live in-game. Recreate it with:

```powershell
$mods = Join-Path $env:APPDATA 'Factorio\mods'
New-Item -ItemType Junction -Path "$mods\JJtorio" -Target "$PWD\mod"
```

In-game, try: `/jjt-new-planet`, `/jjt-planets`, `/jjt-goto <name>`.

## Build a release zip
Reads name + version from `mod/info.json`:
```powershell
powershell -File tools\build-release.ps1
```

## Publish an update to the portal
The **first** publish must be done on the website — the API can only update a
mod that already exists. After that, updates go up with:
```powershell
$env:FACTORIO_API_KEY = '<key from https://factorio.com/profile>'
powershell -File tools\publish.ps1 -NewVersion 0.1.1
```
This bumps the version, rebuilds the zip, and uploads it. The key is read
from the env var and is never written to disk or git.

## Regenerate placeholder icons
```powershell
powershell -File tools\gen-placeholder-icons.ps1
```
