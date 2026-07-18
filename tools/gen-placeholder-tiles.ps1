# Generates placeholder tile textures for JJtorio custom tiles.
#
# Output is a 4-variant strip per tile (128x32 = four 32x32 tiles side by side)
# so it matches a Factorio tile main variant with count 4, size 1. These are
# SCRIPT-DRIVEN STAND-INS, not final art. Each tile gets a base color plus
# scattered flecks so it reads as a material.
#
# Re-run after adding entries to $tiles:
#   powershell -File tools\gen-placeholder-tiles.ps1
param(
  [string]$OutDir = (Join-Path $PSScriptRoot '..\mod\graphics\tiles')
)

Add-Type -AssemblyName System.Drawing

$tiles = @(
  @{ name = 'jjt-snow';   base = @(220, 230, 242); fleck = @(195, 210, 232); seed = 11 },
  @{ name = 'jjt-ash';    base = @(36, 31, 31);    fleck = @(150, 60, 18);   seed = 22 },
  @{ name = 'jjt-sand';   base = @(200, 180, 130); fleck = @(170, 150, 100); seed = 33 },
  @{ name = 'jjt-basalt'; base = @(85, 85, 92);    fleck = @(60, 60, 68);    seed = 44 }
)

New-Item -ItemType Directory -Force -Path $OutDir | Out-Null
$tile = 32
$count = 4
$w = $tile * $count
$h = $tile

function Clamp([int]$v) { [Math]::Min([Math]::Max($v, 0), 255) }

foreach ($t in $tiles) {
  $bmp = New-Object System.Drawing.Bitmap $w, $h
  $g = [System.Drawing.Graphics]::FromImage($bmp)
  $g.Clear([System.Drawing.Color]::FromArgb(255, $t.base[0], $t.base[1], $t.base[2]))
  $g.SmoothingMode = 'AntiAlias'
  $rand = New-Object System.Random $t.seed
  for ($v = 0; $v -lt $count; $v++) {
    $ox = $v * $tile
    # Coarse mottle: a few soft translucent blotches break up the uniform base
    # so the material varies at a larger scale than the flecks.
    for ($i = 0; $i -lt 5; $i++) {
      $d = $rand.Next(8, 18)
      $x = $ox + $rand.Next(-4, $tile - $d + 4)
      $y = $rand.Next(-4, $tile - $d + 4)
      $j = $rand.Next(-18, 12)
      $col = [System.Drawing.Color]::FromArgb(55, (Clamp ($t.base[0] + $j)), (Clamp ($t.base[1] + $j)), (Clamp ($t.base[2] + $j)))
      $brush = New-Object System.Drawing.SolidBrush $col
      $g.FillEllipse($brush, $x, $y, $d, $d)
      $brush.Dispose()
    }
    for ($i = 0; $i -lt 60; $i++) {
      $x = $ox + $rand.Next(0, $tile)
      $y = $rand.Next(0, $tile)
      $s = $rand.Next(1, 3)
      $j = $rand.Next(-14, 15)
      $col = [System.Drawing.Color]::FromArgb(255, (Clamp ($t.fleck[0] + $j)), (Clamp ($t.fleck[1] + $j)), (Clamp ($t.fleck[2] + $j)))
      $brush = New-Object System.Drawing.SolidBrush $col
      $g.FillRectangle($brush, $x, $y, $s, $s)
      $brush.Dispose()
    }
    # Fine grain pass: single-pixel specks near the base color add texture
    # without changing the tile's overall read.
    for ($i = 0; $i -lt 90; $i++) {
      $x = $ox + $rand.Next(0, $tile)
      $y = $rand.Next(0, $tile)
      $j = $rand.Next(-10, 11)
      $col = [System.Drawing.Color]::FromArgb(255, (Clamp ($t.base[0] + $j)), (Clamp ($t.base[1] + $j)), (Clamp ($t.base[2] + $j)))
      $brush = New-Object System.Drawing.SolidBrush $col
      $g.FillRectangle($brush, $x, $y, 1, 1)
      $brush.Dispose()
    }
  }
  $g.Dispose()
  $path = Join-Path $OutDir ($t.name + ".png")
  $bmp.Save($path, [System.Drawing.Imaging.ImageFormat]::Png)
  $bmp.Dispose()
  "Wrote $path"
}
