# jjtest

Quick checks for 0.1.30, about 30 seconds each. Mark done, or error: <what>, or
skip. Tip: use /editor to jump straight to items and surfaces, no need to play up
to them.

1. load: enable JJtorio, start a new base 2.0 save, no red error.
2. /new-planet then /goto <name>: teleports you onto a planet (commands lost the
   jjt prefix this version).
3. /orbit: drops you on a platform that reads as space.
4. glance at planet ground per class: frozen pale, volcanic dark, barren sand,
   rocky grey. Trees stay but the old grass and rocks and cliffs are gone.
5. /new-planet a few times until you get an oceanic one, /goto it: it should be
   sea with sand islands, not a grass field.
6. press T: the science chain shows after the rocket silo, rocket through stellar.
7. item names read in sentence case, so Assembling machine 4 not Assembling
   Machine 4.
8. in /editor, search the inventory for the new gear: heavy tank, heavy turret,
   exo armor, exo shield, exo legs. Grab exo armor and confirm the grid is bigger.
9. in /editor, search techs for the trigger techs (type jjt-trigger). There should
   be 24. Craft the trigger item for one (like a transport belt) and confirm the
   tech completes on its own with no science.
10. exotic rounds magazine: it should hit clearly harder than uranium rounds,
    double size and double round damage.

Known and deferred, no need to test:
- The survey satellite item is decorative for now. Any rocket launch after the
  Planetary Survey tech spawns a planet.
- Oceanic water is a tiled island pattern, real water tuning is later.
