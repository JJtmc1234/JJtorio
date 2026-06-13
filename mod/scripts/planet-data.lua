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

-- Planet "classes". Each rolls different flavor and an ore-richness bias.
-- ore_bias multiplies the random richness roll in planet-gen.
M.classes = {
  { id = "rocky",    label = "Rocky",    ore_bias = 1.0, desc = "A cratered world of bare stone." },
  { id = "volcanic", label = "Volcanic", ore_bias = 1.4, desc = "Lava plains, metal-rich and hostile." },
  { id = "frozen",   label = "Frozen",   ore_bias = 0.8, desc = "An ice world; ore locked beneath frost." },
  { id = "barren",   label = "Barren",   ore_bias = 0.6, desc = "Wind-scoured and resource-poor." },
  { id = "oceanic",  label = "Oceanic",  ore_bias = 0.9, desc = "Shallow seas dotted with islands." },
  { id = "fertile",  label = "Fertile",  ore_bias = 1.1, desc = "Unusually green, temperate and teeming." },
}

return M
