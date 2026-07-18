# JJtorio — Late-Game Roadmap (in-game progression)

> This is a DESIGN VISION for the player's late game — the long arc after the
> rocket silo. It is aspirational and sequenced *behind* the dev milestones in
> PLAN.md (M0 verify → M1 orbit → M2 orbital science → …). Nothing here is
> implemented yet. It is deliberately very long: a north star to carve slices
> from, not a promise of scope for any one release.
>
> Design rules it obeys (see context.txt): inspired by the SHAPE of Space
> Exploration, never its systems (no 4-way specialized science, no piloted
> spaceships, no data/energy beaming). The identity is: **endless procedural
> planets, each forcing a different way to build**, tied to the planet facts
> we already roll (class, gravity, day length, ore richness). You are a
> *planner of many self-running colonies*, not a pilot of one ship.

---

## The spine in one breath
Earn the silo → reach orbit → make Orbital Science → drop your first colony →
learn that every planet breaks your blueprints in a different way → build a
logistics web between worlds → tap planetary cores for exotic matter → master
gravity, heat, and storms as engineering problems → raise megastructures →
push into the deep frontier → and finally run a self-sustaining interplanetary
organism large enough to attempt the Convergence. Then keep going forever.

## The seven eras (with sub-stages)

Each era = a science tier + a signature mechanic + a new class of planet
paradigm to conquer. Gates are *capabilities earned*, not just tech unlocks.

---

## ERA I — ORBIT (the threshold)
*Theme: leaving the ground. Small, disorienting, exciting.*

- **Gate in:** the trimmed rocket-silo tech (mature base).
- **New science:** **Orbital Science** — assembled only *in orbit*, from
  materials you must lift up. Forces your first off-world factory.
- **Stages:**
  1. **First Ascent.** A one-way lift puts you on a bare orbital platform
     (tiled space surface). Everything must be shipped up; nothing grows here.
  2. **The Platform Economy.** Space has no ground resources — orbit is a
     *processing* layer, not an extraction one. You import intermediates, make
     Orbital Science, and ship science back down (or research in orbit).
  3. **Return Logistics.** Establish a reliable up/down cargo loop (automated
     pods — not a piloted ship). This loop is the backbone of everything later.
- **Paradigm introduced:** *vacuum* — no convection. Heat-producing machines
  in orbit need radiators/coolant loops or they stall. First taste of "your
  ground blueprint does not work here."
- **Exit when:** Orbital Science sustains itself and you can see (survey) other
  worlds.

## ERA II — FIRST COLONIES (the shattering of blueprints)
*Theme: every world is a fresh puzzle. This is the heart of the mod.*

- **Gate in:** Orbital Science → **Colony Pod** tech.
- **New mechanic:** **Colony Pods.** You commit a pod to a planet; it lands,
  auto-deploys a starter foothold, and thereafter runs semi-autonomously,
  shipping a resource stream back. You plan it, you don't fly it. Losing a
  colony (see hazards) costs the pod + its buildup — real stakes.
- **The paradigm library** (each planet CLASS + FACTS decides which apply):
  - **Vacuum / airless** — heat won't dissipate; build radiator networks.
  - **High-gravity** — belts crawl, but fluids flow fast and free; you pivot
    to fluid/pipe logistics and short belt runs. Tall structures cost more.
  - **Low-gravity** — ballistic/launched logistics become cheap; structures
    are fragile; dust and drift.
  - **Storm world** — intermittent power (tie to `day_minutes` + weather);
    you buffer hard, go modular, or ride it with flywheels/capacitors.
  - **Frozen** — the inverse of vacuum: everything sheds heat too fast;
    machines must be *kept warm* or they seize; fluids freeze in pipes.
  - **Volcanic** — free heat, but corrosive; buildings degrade and need
    material upkeep (a slow maintenance economy).
  - **Toxic atmosphere** — production must be sealed/scrubbed; open belts
    corrode; workers/bots need life support.
  - **Tidal-locked / extreme day** — solar is useless or god-tier depending
    where you land; thermal day/night swings you must engineer around.
  - **Ocean** — little land; floating platforms, foundation-building, depth.
  - **Dense-crust** — surface ore is poor but the CORE is rich (feeds Era IV).
- **Stages:**
  1. **First Foothold.** Survive one paradigm end-to-end on one planet.
  2. **Second, Different World.** Deliberately pick a *different* class — prove
     to the player the puzzle really changes. No copy-paste.
  3. **Adaptation Science.** A science earned by *running* colonies under
     hazard for a sustained time — you are rewarded for mastering conditions,
     not just building.
- **Exit when:** you hold ≥2 colonies of different classes, each net-positive.

## ERA III — THE LOGISTICS WEB (worlds become one factory)
*Theme: no planet is self-sufficient; the game becomes routing.*

- **Gate in:** Adaptation Science + a stable 2-colony network.
- **New mechanic:** **Interworld Freight.** Bulk automated freight between
  surfaces (orbit ↔ planet, planet ↔ planet via orbit). Throughput, scheduling,
  and buffering across worlds is the new challenge — like trains, but the
  "stations" are gravity wells with launch costs.
- **Stages:**
  1. **Specialization.** Refine where it's cheap, assemble where it's possible;
     ship intermediates. Each world becomes a *stage* in one giant recipe.
  2. **Freight Networks.** Priorities, capacity, and lost-shipment risk.
  3. **Resonance Science** — earned from a *balanced, humming* multi-world
     network (a throughput/uptime reward, JJtorio-original).
- **Cross-cutting system unlocked:** **Colony Autonomy tiers** — upgrade
  colonies from "needs babysitting" to "self-repairing" to "self-expanding,"
  so you can hold more worlds without micromanaging each.
- **Exit when:** a 3+ world network produces something no single world could.

## ERA IV — DEEP EXTRACTION (the Core Tap era)
*Theme: stop scratching the surface; drink from the mantle.*

- **Gate in:** Resonance Science + a dense-crust colony.
- **Signature mechanic:** **Core Tap** (already scoped) — a slow, *infinite*
  extractor whose OUTPUT depends on the planet's class and whose RATE is driven
  by its facts (gravity/day length). Every planet's core yields a different
  **Core Fragment**.
- **Stages:**
  1. **First Tap.** One slow tap, one fragment type. Fragments refine into
     resources the surface can't provide.
  2. **Tap Arrays + Resonance.** Multiple taps interfere; you tune spacing and
     the planet's resonance for yield — an original mini-optimization layer.
  3. **Mantle Siphon.** A huge late tap that *destabilizes* the planet: more
     yield, but rising instability (quakes, hazard events) you must manage or
     eventually abandon the world. Risk/reward at planetary scale.
  4. **Exotic Matter Science** — from refined, cross-planet fragment blends.
- **Exit when:** exotic matter flows and you can make materials with no vanilla
  analogue.

## ERA V — MASTERING THE FORCES (engineering, not enduring)
*Theme: the paradigms stop being obstacles and become tools.*

- **Gate in:** Exotic Matter Science.
- **New idea:** you now *weaponize* each paradigm instead of merely surviving:
  - **Gravitics** — build under high-g on purpose for dense fluid reactors;
    use low-g worlds as cheap mass-drivers/launch hubs for the whole network.
  - **Thermal engineering** — pair a volcanic world (heat source) logic with a
    frozen world (heat sink) across freight; heat becomes a traded resource.
  - **Storm harvesting** — capture storm energy on storm worlds as a power
    export, turning the worst planets into the best batteries.
- **New sciences (pick-your-path, but NOT SE's fixed four):**
  - **Gravitic Science**, **Thermal Science**, **Storm/Flux Science** — each
    earned by *using* a paradigm productively. You need a blend of them to
    advance, so you're pushed to hold diverse worlds.
- **Cross-cutting:** **Terraforming (light)** — slowly shift a planet's facts
  (nudge moisture, temperature, atmosphere) at great cost, to make a brutal
  world merely hard. Deliberately expensive so procedural variety still matters.
- **Exit when:** you can turn a "bad" planet into an asset on purpose.

## ERA VI — MEGASTRUCTURES (building at planetary scale)
*Theme: the factory outgrows the factory floor.*

- **Gate in:** the Era-V science blend + exotic matter at scale.
- **Megaprojects (each a long build with upkeep):**
  1. **Orbital Ring** — a full ring around a world: massive throughput up/down,
     retires per-launch freight costs for that planet.
  2. **Space Elevator** — the per-planet continuous lift; the payoff for the
     early one-way pods.
  3. **Planetary Shield / Climate Cap** — neutralizes a paradigm hazard
     (storms, toxicity) for a whole world, at a permanent power cost.
  4. **Stellar Collector** — begin harvesting the system's star for power and
     **Stellar Science** (original framing: a lattice of collectors, not a
     literal Dyson clone; scales with how many you sustain).
- **Exit when:** at least one megastructure changes how a whole world plays.

## ERA VII — THE FRONTIER (deep, hostile, far)
*Theme: the endless part gets teeth.*

- **Gate in:** Stellar Science + a self-expanding colony tier.
- **What's out there:** procedural generation cranks difficulty the farther you
  go — rarer classes, extreme facts (crushing gravity, decade-long days,
  compound paradigms: "frozen + storm + toxic" on one world).
- **Stages:**
  1. **Compound Paradigms.** Worlds that combine two/three constraints. The
     ultimate blueprint-breakers; require everything you've learned at once.
  2. **Rogue / Dark Worlds.** No star nearby — power must be imported or made;
     Core Tap is your lifeline.
  3. **Ascendant Science** — the top pre-endgame science, only makeable using
     outputs from several compound-paradigm colonies at once.
- **Exit when:** you sustain a colony a new player literally could not.

## ERA VIII — THE CONVERGENCE (endgame megaproject)
*Theme: make the whole network one living machine — then transcend it.*

- **Gate in:** Ascendant Science + a broad, autonomous, multi-paradigm empire.
- **The final build:** **The Convergence** — link N self-running colonies,
  megastructures, and stellar collectors into a single closed-loop
  interplanetary organism that produces the endgame material/output on its own.
  It is less "launch one rocket" and more "prove your civilization runs itself."
- **Two flavored victory paths (player chooses):**
  1. **Genesis Forge** — spend the Convergence's output to *seed a brand-new
     procedural planet of your own design* (choose its class/facts). Creation as
     the win: you started as a castaway; you end as a world-maker.
  2. **The Long Signal** — power a structure that "completes," a quieter,
     legacy-style ending. For players who want a finish line, not a new world.
- **Exit:** victory screen — but the save keeps going.

## ERA IX — POST-VICTORY / INFINITE
*Theme: the sandbox never closes.*

- **Infinite sciences** (efficiency, autonomy, yield, terraform cost-down) keep
  scaling — always a next target, never a wall.
- **Endless frontier** — the universe keeps generating harder worlds.
- **Self-replication** — top-tier colonies can found *other* colonies with less
  input, so the challenge shifts from "can I hold this?" to "how big, how
  elegant, how automated?" — the classic Factorio megabase itch, in space.
- **Optional escalations** — a "harder universe" toggle, prestige-style resets
  that carry forward a little, or seasonal procedural-modifier runs.

---

## Cross-cutting systems (span all eras)
- **Colony Autonomy ladder:** babysat → self-repairing → self-expanding →
  self-replicating. The real "power curve" of the late game.
- **Hazard/upkeep economy:** corrosion, freezing, quakes, storms — soft
  pressure that makes colonies living things you maintain, not fire-and-forget.
- **Science-by-doing:** most late sciences are earned by *operating* under
  conditions (uptime, hazard-survival, network balance), not just by crafting a
  pack — this is a core originality lever vs. SE's craftable science tiers.
- **Planet facts matter everywhere:** gravity, day length, class, ore richness,
  and any future facts feed paradigms, Core Tap rate, solar viability, freight
  cost, terraform difficulty. Keep the fact schema stable; extend, don't break.

## Pacing guidance (so this doesn't become Pyanodons-by-accident)
- Each era should be *reachable* by a determined player in a sane time; depth
  comes from *breadth of worlds*, not from grind walls.
- Introduce exactly ONE big new idea per era; let players master it before the
  next lands.
- Every era must contain at least one "your blueprint doesn't work here" beat —
  that surprise is the product.
- Keep an early, satisfying *first* off-world win (Era I–II) so players who
  never reach Era VIII still had a complete arc.

## Build order for US (how to carve slices from this)
Follows PLAN.md: verify (M0) → Era I (orbit + Orbital Science) → Era II (one
Colony Pod + one paradigm) → prove the paradigm variety with a second world →
then Core Tap (Era IV mechanic) → and only then reach for the big eras. Ship a
playable vertical slice of each era before widening it.
