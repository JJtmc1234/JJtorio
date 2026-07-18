# Generates placeholder tile textures for JJtorio planet biomes.
#
# These are SCRIPT-DRIVEN STAND-INS, not final art. Each tile gets a base color
# plus scattered flecks so it reads as a material rather than a flat swatch. A
# real artist still needs to replace them. Wiring these into Factorio tile
# prototypes (variants.main, material_background, transitions, map_color) is a
# separate step and is NOT done here.
#
# Re-run after adding entries to $tiles below:
#   powershell -File tools\gen-placeholder-tiles.ps1
param(
  [string]$OutDir = (Join-Path $PSScriptRoot '..\mod\graphics\tiles')
)

Add-Type -AssemblyName System.Drawing

# name = output file jjt-<name>.png ; base = fill color ; fleck = speckle color ;
# seed = fixed so the texture is reproducible.
$tiles = @(
  @{ name = 'snow';   base = @(225, 235, 245); fleck = @(200, 215, 235); seed = 11 },  # frozen
  @{ name = 'ash';    base = @(35, 30, 30);    fleck = @(185, 75, 20);   seed = 22 },  # volcanic
  @{ name = 'sand';   base = @(200, 180, 130); fleck = @(170, 150, 100); seed = 33 },  # barren
  @{ name = 'basalt'; base = @(85, 85, 92);    fleck = @(60, 60, 68);    seed = 44 }   # rocky
)

New-Item -ItemType Directory -Force -Path $OutDir | Out-Null
$size = 256

function Clamp([int]$v) { [Math]::Min([Math]::Max($v, 0), 255) }

foreach ($t in $tiles) {
  $bmp = New-Object System.Drawing.Bitmap $size, $size
  $g = [System.Drawing.Graphics]::FromImage($bmp)
  $g.Clear([System.Drawing.Color]::FromArgb(255, $t.base[0], $t.base[1], $t.base[2]))
  $rand = New-Object System.Random $t.seed
  for ($i = 0; $i -lt 1600; $i++) {
    $x = $rand.Next(0, $size)
    $y = $rand.Next(0, $size)
    $s = $rand.Next(1, 4)
    $j = $rand.Next(-15, 16)
    $col = [System.Drawing.Color]::FromArgb(255, (Clamp ($t.fleck[0] + $j)), (Clamp ($t.fleck[1] + $j)), (Clamp ($t.fleck[2] + $j)))
    $brush = New-Object System.Drawing.SolidBrush $col
    $g.FillRectangle($brush, $x, $y, $s, $s)
    $brush.Dispose()
  }
  $g.Dispose()
  $path = Join-Path $OutDir ("jjt-" + $t.name + ".png")
  $bmp.Save($path, [System.Drawing.Imaging.ImageFormat]::Png)
  $bmp.Dispose()
  "Wrote $path"
}
