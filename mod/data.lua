-- JJtorio data stage entry point.
-- Prototype definitions and tweaks are split into focused files under
-- prototypes/ and required here.

require("prototypes.tiles")
require("prototypes.tweaks")
require("prototypes.early-boost")
require("prototypes.rocket-silo-gating")
require("prototypes.survey-satellite")
require("prototypes.science-tree")
require("prototypes.content-tiers")
require("prototypes.trigger-techs")
-- Last, so the research discount reaches the jjt techs too (it iterates
-- data.raw.technology at require time).
require("prototypes.tech-costs")
