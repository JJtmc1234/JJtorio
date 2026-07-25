-- JJtorio data stage entry point.
-- Prototype definitions and tweaks are split into focused files under
-- prototypes/ and required here.

require("prototypes.tiles")
require("prototypes.tweaks")
require("prototypes.early-boost")
require("prototypes.rocket-silo-gating")
require("prototypes.survey-satellite")
require("prototypes.science-tree")
-- Per tier vertical slices. Each fills in the skeleton science-tree.lua
-- generated for that tier, so it must come after it.
require("prototypes.tier-rocket")
require("prototypes.tier-orbital")
require("prototypes.content-tiers")
require("prototypes.trigger-techs")
require("prototypes.gear-tiers")
require("prototypes.menu-sims")
-- Last, so the research discount reaches the jjt techs too (it iterates
-- data.raw.technology at require time).
require("prototypes.tech-costs")
