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
-- the class look distinct. trees is forest coverage (0 to 1). ground is a
-- palette of tiles blended by smooth noise, so repeated names weight a tile
-- heavier. tree_kinds are the species planted, scatter are decoratives strewn
-- for texture, and water_world drives the noise sea and islands in planet-gen.
M.classes = {
  { id = "rocky",    label = "Rocky",    ore_bias = 1.0, desc = "A cratered world of bare stone.",
    terrain = {
      trees = 0.05,
      ground = { "jjt-basalt", "jjt-basalt", "jjt-basalt", "dirt-7", "dirt-6" },
      tree_kinds = { "dead-grey-trunk", "dry-tree", "dead-tree-desert" },
      scatter = { "medium-rock", "small-rock", "tiny-rock", "dark-mud-decal" },
    } },
  { id = "volcanic", label = "Volcanic", ore_bias = 1.4, desc = "Lava plains, metal rich and hostile.",
    terrain = {
      trees = 0.0,
      ground = { "jjt-ash", "jjt-ash", "jjt-ash", "jjt-basalt", "dirt-6" },
      scatter = { "medium-rock", "small-rock", "cracked-mud-decal" },
    } },
  { id = "frozen",   label = "Frozen",   ore_bias = 0.8, desc = "An ice world. Ore is locked beneath frost.",
    terrain = {
      trees = 0.12,
      ground = { "jjt-snow", "jjt-snow", "jjt-snow", "dirt-7" },
      tree_kinds = { "tree-09", "tree-09-brown", "dead-grey-trunk" },
      scatter = { "small-rock", "tiny-rock" },
    } },
  { id = "barren",   label = "Barren",   ore_bias = 0.6, desc = "Wind scoured and resource poor.",
    terrain = {
      trees = 0.0,
      ground = { "jjt-sand", "jjt-sand", "sand-1", "sand-3", "red-desert-0", "red-desert-1" },
      scatter = { "sand-decal", "sand-dune-decal", "brown-fluff-dry", "red-desert-decal", "small-sand-rock", "medium-sand-rock" },
    } },
  { id = "oceanic",  label = "Oceanic",  ore_bias = 0.9, desc = "Shallow seas dotted with islands.",
    terrain = {
      trees = 0.25,
      water_world = true,
      ground = { "grass-1", "grass-3", "sand-1" },
      tree_kinds = { "tree-02", "tree-04", "tree-05" },
      scatter = { "green-carpet-grass", "green-bush-mini", "green-small-grass", "garballo" },
    } },
  { id = "fertile",  label = "Fertile",  ore_bias = 1.1, desc = "Unusually green, temperate and teeming.",
    terrain = {
      trees = 0.55,
      ground = { "grass-1", "grass-1", "grass-3", "grass-2", "dirt-4" },
      tree_kinds = { "tree-02", "tree-04", "tree-05", "tree-06", "tree-08" },
      scatter = { "green-carpet-grass", "green-bush-mini", "green-small-grass", "green-hairy-grass", "garballo", "green-pita" },
    } },
}

return M
