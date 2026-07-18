# JJtorio — Employee / Contributor Task List

How to help build JJtorio. Read `context.txt` (stable facts), `PLAN.md`
(milestones), and `what-im-doing.txt` (current status) before starting.

## Ground rules
- Don't clone Space Exploration's systems (its 4 sciences, piloted ships,
  data/energy beaming). SE inspires the *shape*, not the mechanics.
- Verify in Factorio before saying something works.
- Keep source files focused (~150 lines); guard base-game edits so a missing
  prototype can't crash the load.
- Keep the two docs current: `context.txt` when the project shape changes,
  `what-im-doing.txt` every meaningful step.

## Workflow
- Code: branch off `main`, open a pull request at
  https://github.com/JJtmc1234/JJtorio. Keep PRs small and focused.
- Ideas / bugs / feedback (non-code): email jjtmcmultiversal@gmail.com with
  the subject "JJtorio".
- Releases are handled centrally (version bump + mod-portal publish). Please
  don't publish to the portal yourself.

## Right now — top priority (M0: verify the foundation)
The whole mod is written but UNVERIFIED in-game. Highest-value task:
1. Load JJtorio in Factorio 2.0 (base game — no Space Age, no SE).
2. Fix any load errors (likely spots: the rocket-silo tech gating, the new
   item/recipe/tech, the `on_rocket_launched` hook).
3. Run `/jjt-new-planet`, `/jjt-goto <name>`, `/jjt-orbit` and report results.

## Areas of work
### Testing / QA
- Confirm planet and orbit surfaces generate on base 2.0.
- Confirm the rocket-silo prerequisites show up and are researchable.
- Regression-check the early-game tweaks (reach, inventory, speeds, costs).

### Art (replace placeholders)
- `mod/graphics/icons/*.png` and `mod/thumbnail.png` are flat placeholders.
- Need real icons (starting with the Survey Satellite) and a proper 144x144
  thumbnail. `tools/gen-placeholder-icons.ps1` is only a stopgap.

### Balance
- Early-game numbers: mining/lab/machine speeds, science batch sizes, and the
  research cost factor — tune for "light and fast, not trivial".
- The rocket-silo prerequisite list — is it the right gate?

### Content (see PLAN.md, M1–M4)
- Real ascent to orbit + space tiles/visuals.
- The orbital science tier (original — not SE's).
- Planet "production paradigms" — the core differentiator. Propose concrete
  constraints (heat, gravity, storms) and how they change how you build.

### Docs
- Keep PLAN.md / context.txt / README current; help triage emailed feedback.
