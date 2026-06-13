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
```powershell
$stage = Join-Path $env:TEMP 'jjt_pkg'; Remove-Item $stage -Recurse -Force -ErrorAction Ignore
Copy-Item mod (Join-Path $stage 'JJtorio') -Recurse
Compress-Archive (Join-Path $stage 'JJtorio') dist\JJtorio_0.1.0.zip -Force
```

## Regenerate placeholder icons
```powershell
powershell -File tools\gen-placeholder-icons.ps1
```
