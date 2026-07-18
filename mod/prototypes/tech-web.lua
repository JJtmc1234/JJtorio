-- tech-web.lua: a large DRAFT tech web (over 1000 techs) of placeholder feature
-- families hung off each science tier, so the tree is dense like SE. Runs after
-- science-tree.lua and reuses each tier gateway's science cost, so every tech
-- satisfies Factorio's prerequisite science pack rule. Effects are empty on
-- purpose. These are structure only, there as data, not working features yet.

local ICON = "__JJtorio__/graphics/icons/jjt-placeholder-machine.png"

-- Feature families grouped by the science tier gateway they hang off.
local DOMAINS = {
  { gate = "jjt-rocket-science",    names = { "Launch Systems", "Cargo Handling", "Guidance", "Fuel Refining", "Heat Shielding", "Telemetry" } },
  { gate = "jjt-orbital-science",   names = { "Orbital Assembly", "Station Keeping", "Docking", "Radiation Shielding", "Microgravity Fabrication", "Solar Arrays" } },
  { gate = "jjt-vacuum-science",    names = { "Radiators", "Coolant Loops", "Vacuum Sealing", "Sublimation" } },
  { gate = "jjt-cryo-science",      names = { "Heaters", "Antifreeze", "Insulation", "Cryo Storage" } },
  { gate = "jjt-magma-science",     names = { "Corrosion Plating", "Lava Tapping", "Refractories", "Ash Processing" } },
  { gate = "jjt-tide-science",      names = { "Floating Platforms", "Desalination", "Wave Power", "Deep Diving" } },
  { gate = "jjt-gravity-science",   names = { "Gravitic Belts", "Fluid Dynamics", "Structural Bracing", "Mass Drivers" } },
  { gate = "jjt-verdant-science",   names = { "Cultivation", "Biofuels", "Composting", "Greenhouses" } },
  { gate = "jjt-resonance-science", names = { "Freight Networks", "Colony Autonomy", "Signal Relays", "Route Planning", "Bulk Transit" } },
  { gate = "jjt-core-science",      names = { "Core Tapping", "Fragment Refining", "Mantle Siphons", "Seismic Control", "Deep Boring" } },
  { gate = "jjt-exotic-science",    names = { "Exotic Alloys", "Metamaterials", "Phase Matter", "Catalysts", "Isotopes" } },
  { gate = "jjt-gravitic-science",  names = { "Grav Plating", "Inertial Dampers", "Tractor Fields", "Warp Coils" } },
  { gate = "jjt-thermal-science",   names = { "Heat Exchange", "Thermal Batteries", "Plasma Containment", "Superconductors" } },
  { gate = "jjt-flux-science",      names = { "Storm Harvest", "Capacitor Banks", "Field Stabilizers", "Flux Cores" } },
  { gate = "jjt-stellar-science",   names = { "Stellar Collectors", "Starlifting", "Fusion Cascades", "Lattice Nodes", "Ascendant Works", "Convergence Prep" } },
}

local LEVELS = 16 -- techs per family; families times LEVELS is the web size

local function copy_units(src)
  local out = {}
  for _, e in ipairs(src) do out[#out + 1] = { e[1] or e.name, e[2] or e.amount } end
  return out
end

local function slug(s) return (s:lower():gsub("[^%w]+", "-")) end

local protos, total = {}, 0

for _, d in ipairs(DOMAINS) do
  local gateway = data.raw.technology[d.gate]
  if gateway and gateway.unit then
    local base = copy_units(gateway.unit.ingredients)
    local short = d.gate:match("^jjt%-(.+)%-science$") or d.gate
    for _, fname in ipairs(d.names) do
      local fslug = slug(fname)
      local prev = d.gate
      for i = 1, LEVELS do
        local name = "jjt-" .. short .. "-" .. fslug .. "-" .. i
        protos[#protos + 1] = {
          type = "technology",
          name = name,
          localised_name = { "", fname .. " " .. i },
          icon = ICON,
          icon_size = 64,
          prerequisites = { prev },
          effects = {},
          unit = { count = 400 + 100 * i, time = 30, ingredients = copy_units(base) },
        }
        prev = name
        total = total + 1
      end
    end
  end
end

data:extend(protos)
log("[JJtorio] tech-web generated " .. total .. " draft technologies")
