-- Static data tables for procedural planet generation.
-- Pure data, no side effects — safe to require anywhere.

local M = {}

-- Name parts, combined as prefix + middle + suffix.
M.name_prefixes = {
  "Xa", "Vor", "Ten", "Kry", "Mor", "Zel", "Aur", "Pyr",
  "Nyx", "Cae", "Hel", "Obi", "Ish", "Tha", "Vex", "Quor",
}
M.name_middles = {
  "la", "ro", "mi", "tu", "ke", "sa", "di", "no", "va", "ze",
}
M.name_suffixes = {
  "n", "s", "x", "th", "ra", "is", "or", "ad", "um", "ix", "ar", "eon",
}

-- Planet classes. Each sets an ore richness bias plus terrain knobs that make
-- the class look distinct. trees sets forest density, ground is the base tile,
-- and water_world paints a sea with sand islands.
M.classes = {
  { id = "rocky",    label = "Rocky",    ore_bias = 1.0, desc = "A cratered world of bare stone.",
    terrain = { trees = 0.05, ground = "jjt-basalt" } },
  { id = "volcanic", label = "Volcanic", ore_bias = 1.4, desc = "Lava plains, metal rich and hostile.",
    terrain = { trees = 0.0,  ground = "jjt-ash" } },
  { id = "frozen",   label = "Frozen",   ore_bias = 0.8, desc = "An ice world. Ore is locked beneath frost.",
    terrain = { trees = 0.15, ground = "jjt-snow" } },
  { id = "barren",   label = "Barren",   ore_bias = 0.6, desc = "Wind scoured and resource poor.",
    terrain = { trees = 0.0,  ground = "jjt-sand" } },
  { id = "oceanic",  label = "Oceanic",  ore_bias = 0.9, desc = "Shallow seas dotted with islands.",
    terrain = { trees = 0.2,  water_world = true } },
  { id = "fertile",  label = "Fertile",  ore_bias = 1.1, desc = "Unusually green, temperate and teeming.",
    terrain = { trees = 0.6,  ground = "grass-1" } },
}

return M
