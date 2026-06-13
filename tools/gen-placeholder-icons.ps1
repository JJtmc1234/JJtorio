# Generates flat-colored placeholder icon PNGs for JJtorio prototypes.
# These are throwaway stand-ins meant to be replaced with real art later.
# Re-run after adding entries to $icons below.
param(
  [string]$OutDir = (Join-Path $PSScriptRoot '..\mod\graphics\icons')
)

Add-Type -AssemblyName System.Drawing

$icons = @(
  @{ name = 'placeholder-machine'; label = 'M'; r = 70;  g = 90;  b = 140 },
  @{ name = 'placeholder-plate';   label = 'P'; r = 140; g = 110; b = 60  },
  @{ name = 'placeholder-fluid';   label = 'F'; r = 60;  g = 130; b = 120 }
)

New-Item -ItemType Directory -Force -Path $OutDir | Out-Null
$size = 64

foreach ($ic in $icons) {
  $bmp = New-Object System.Drawing.Bitmap $size, $size
  $g = [System.Drawing.Graphics]::FromImage($bmp)
  $g.SmoothingMode = 'AntiAlias'
  $g.Clear([System.Drawing.Color]::FromArgb(255, $ic.r, $ic.g, $ic.b))
  $pen = New-Object System.Drawing.Pen ([System.Drawing.Color]::FromArgb(255, 230, 230, 230)), 3
  $g.DrawRectangle($pen, 2, 2, ($size - 5), ($size - 5))
  $font = New-Object System.Drawing.Font 'Arial', 28, ([System.Drawing.FontStyle]::Bold)
  $brush = New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::White)
  $sf = New-Object System.Drawing.StringFormat
  $sf.Alignment = [System.Drawing.StringAlignment]::Center
  $sf.LineAlignment = [System.Drawing.StringAlignment]::Center
  $g.DrawString($ic.label, $font, $brush, (New-Object System.Drawing.RectangleF 0, 0, $size, $size), $sf)
  $g.Dispose()
  $path = Join-Path $OutDir ("jjt-" + $ic.name + ".png")
  $bmp.Save($path, [System.Drawing.Imaging.ImageFormat]::Png)
  $bmp.Dispose()
  "Wrote $path"
}
