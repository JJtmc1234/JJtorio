# jjtest

Quick checks for 0.1.36, about 30 seconds each. Mark done, or error: <what>, or
skip. Tip: use /editor to jump straight to items and surfaces, no need to play up
to them.

1. load: enable JJtorio on a base 2.0 save with Space Age disabled, no red error.
2. main menu: the background rotates through the JJtorio scenes (assembly hall,
   smelting, belt highway, defense, rocket launch). Machines run and belts flow.
3. /new-planet then /goto <name>: you land on natural looking varied ground, not
   one flat square, with class trees scattered (dense on fertile, none on barren).
4. walk a few hundred tiles out on that planet: the terrain keeps painting, it does
   NOT revert to Nauvis grass past a square.
5. /new-planet until you get an oceanic one, /goto it: organic sea with sand beach
   islands, not a checkerboard.
6. /orbit: a round dark platform with a hazard rim floating in black, reads as
   space, not a bare square.
7. /planets: the list shows class, name, and ore richness, no dead day or gravity
   facts.
8. in /editor search techs for jjt-trigger: the 24 trigger techs sit under their
   related base tech, not all piled at the tree root.
9. Exotic Munitions tech: it should require uranium ammo, so it cannot appear
   before uranium rounds exist.
10. in /editor grab the exo flamethrower and fire it: very long range (100).
11. exotic rounds magazine still hits harder than uranium rounds.

Known and deferred, no need to test:
- The survey satellite item is decorative. Any rocket launch after the Planetary
  Survey tech discovers a planet, and the surface is now created only when you
  /goto it, so discovering many planets no longer bloats the save.
- A true twinkling starfield in orbit needs custom art, later.
