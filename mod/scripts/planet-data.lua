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
-- the class look distinct. moisture and aux bias the biome tiles, trees sets
-- forest density, and water scales lakes. Frozen and volcanic will get real
-- custom tiles later. For now they use the closest base biome.
M.classes = {
  { id = "rocky",    label = "Rocky",    ore_bias = 1.0, desc = "A cratered world of bare stone.",
    terrain = { moisture = 0.15, aux = 0.5,  trees = 0.05, water = 0.2, ground = "jjt-basalt" } },
  { id = "volcanic", label = "Volcanic", ore_bias = 1.4, desc = "Lava plains, metal rich and hostile.",
    terrain = { moisture = 0.0,  aux = 0.95, trees = 0.0,  water = 0.0, ground = "jjt-ash" } },
  { id = "frozen",   label = "Frozen",   ore_bias = 0.8, desc = "An ice world. Ore is locked beneath frost.",
    terrain = { moisture = 0.6,  aux = 0.05, trees = 0.15, water = 0.4, ground = "jjt-snow" } },
  { id = "barren",   label = "Barren",   ore_bias = 0.6, desc = "Wind scoured and resource poor.",
    terrain = { moisture = 0.02, aux = 0.5,  trees = 0.0,  water = 0.05, ground = "jjt-sand" } },
  { id = "oceanic",  label = "Oceanic",  ore_bias = 0.9, desc = "Shallow seas dotted with islands.",
    terrain = { moisture = 0.8,  aux = 0.5,  trees = 0.2,  water = 1.5, water_world = true } },
  { id = "fertile",  label = "Fertile",  ore_bias = 1.1, desc = "Unusually green, temperate and teeming.",
    terrain = { moisture = 0.95, aux = 0.5,  trees = 0.6,  water = 0.6, ground = "grass-1" } },
}

return M
