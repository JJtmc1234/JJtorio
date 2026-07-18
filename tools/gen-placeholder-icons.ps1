# Generates placeholder icon PNGs (and the mod thumbnail) for JJtorio.
#
# These are SCRIPT-DRIVEN STAND-INS, not final art. Each placeholder gets its
# own base color, a big letter, and a simple glyph so items are easy to tell
# apart in-game and in the inventory. A real artist still needs to replace all
# of these; see the note at the bottom of this file and what-im-doing.txt.
#
# Re-run after adding entries to $icons below:
#   powershell -File tools\gen-placeholder-icons.ps1
param(
  [string]$OutDir    = (Join-Path $PSScriptRoot '..\mod\graphics\icons'),
  [string]$ThumbPath = (Join-Path $PSScriptRoot '..\mod\thumbnail.png')
)

Add-Type -AssemblyName System.Drawing

# name  = output file jjt-<name>.png ; label = big glyph letters ;
# r/g/b = base color ; glyph = extra shape drawn behind the label so items are
# distinct even at a glance / for the colorblind ("dish","droplet","bars","none").
$icons = @(
  @{ name = 'survey-satellite';    label = 'SAT'; r = 60;  g = 120; b = 170; glyph = 'dish'    },
  @{ name = 'placeholder-machine'; label = 'M';   r = 70;  g = 90;  b = 140; glyph = 'bars'    },
  @{ name = 'placeholder-plate';   label = 'P';   r = 150; g = 105; b = 55;  glyph = 'none'    },
  @{ name = 'placeholder-fluid';   label = 'F';   r = 55;  g = 135; b = 130; glyph = 'droplet' }
)

New-Item -ItemType Directory -Force -Path $OutDir | Out-Null

function New-Placeholder {
  param([int]$Size, [int]$R, [int]$G, [int]$B, [string]$Label, [string]$Glyph)

  $bmp = New-Object System.Drawing.Bitmap $Size, $Size
  # NOTE: use $gfx, not $g -- $g would collide with the [int]$G parameter
  # (PowerShell variable names are case-insensitive) and get constrained to int.
  $gfx = [System.Drawing.Graphics]::FromImage($bmp)
  $gfx.SmoothingMode     = 'AntiAlias'
  $gfx.TextRenderingHint = 'AntiAliasGridFit'

  # Vertical gradient (lighter top -> darker bottom) gives it some depth
  # instead of reading as a flat swatch.
  $top = [System.Drawing.Color]::FromArgb(255, [Math]::Min($R + 35, 255), [Math]::Min($G + 35, 255), [Math]::Min($B + 35, 255))
  $bot = [System.Drawing.Color]::FromArgb(255, [Math]::Max($R - 40, 0),   [Math]::Max($G - 40, 0),   [Math]::Max($B - 40, 0))
  $rect = New-Object System.Drawing.Rectangle 0, 0, $Size, $Size
  $grad = New-Object System.Drawing.Drawing2D.LinearGradientBrush $rect, $top, $bot, 90.0
  $gfx.FillRectangle($grad, $rect)

  # Soft top-left highlight so the icon reads as a lit surface, not a flat swatch.
  $hlPath = New-Object System.Drawing.Drawing2D.GraphicsPath
  $hlPath.AddEllipse(($Size * -0.15), ($Size * -0.15), ($Size * 0.9), ($Size * 0.9))
  $hl = New-Object System.Drawing.Drawing2D.PathGradientBrush $hlPath
  $hl.CenterColor = [System.Drawing.Color]::FromArgb(90, 255, 255, 255)
  $hl.SurroundColors = @([System.Drawing.Color]::FromArgb(0, 255, 255, 255))
  $gfx.FillRectangle($hl, $rect)
  $hl.Dispose(); $hlPath.Dispose()

  # Distinguishing glyph, drawn faintly behind the letter.
  $glyphColor = [System.Drawing.Color]::FromArgb(70, 255, 255, 255)
  $gbrush = New-Object System.Drawing.SolidBrush $glyphColor
  $gpen   = New-Object System.Drawing.Pen $glyphColor, ([single]($Size / 20))
  $c = $Size / 2.0
  switch ($Glyph) {
    'dish' {
      # satellite: body + two solar panels + a dish arc
      $gfx.FillEllipse($gbrush, ($c - $Size*0.10), ($c - $Size*0.10), $Size*0.20, $Size*0.20)
      $gfx.FillRectangle($gbrush, ($c - $Size*0.38), ($c - $Size*0.05), $Size*0.20, $Size*0.10)
      $gfx.FillRectangle($gbrush, ($c + $Size*0.18), ($c - $Size*0.05), $Size*0.20, $Size*0.10)
      $gfx.DrawArc($gpen, ($c - $Size*0.22), ($c - $Size*0.30), $Size*0.44, $Size*0.30, 200, 140)
    }
    'droplet' {
      $pts = @(
        (New-Object System.Drawing.PointF ([single]$c), ([single]($c - $Size*0.28))),
        (New-Object System.Drawing.PointF ([single]($c + $Size*0.22)), ([single]($c + $Size*0.18))),
        (New-Object System.Drawing.PointF ([single]($c - $Size*0.22)), ([single]($c + $Size*0.18)))
      )
      $gfx.FillPolygon($gbrush, $pts)
      $gfx.FillEllipse($gbrush, ($c - $Size*0.22), ($c - $Size*0.04), $Size*0.44, $Size*0.40)
    }
    'bars' {
      for ($i = 0; $i -lt 3; $i++) {
        $x = $c - $Size*0.30 + ($i * $Size*0.22)
        $h = $Size * (0.18 + 0.12 * $i)
        $gfx.FillRectangle($gbrush, $x, ($c + $Size*0.22 - $h), $Size*0.14, $h)
      }
    }
    default { }
  }

  # Border.
  $inset = [Math]::Max([int]($Size / 21), 2)
  $pen = New-Object System.Drawing.Pen ([System.Drawing.Color]::FromArgb(255, 235, 235, 235)), ([single]$inset)
  $gfx.DrawRectangle($pen, $inset, $inset, ($Size - 2 * $inset - 1), ($Size - 2 * $inset - 1))

  # Label: size the font to the number of characters so 3-letter labels fit.
  $fontSize = if ($Label.Length -ge 3) { [int]($Size * 0.30) }
              elseif ($Label.Length -eq 2) { [int]($Size * 0.42) }
              else { [int]($Size * 0.50) }
  $font  = New-Object System.Drawing.Font 'Arial', $fontSize, ([System.Drawing.FontStyle]::Bold)
  $sf    = New-Object System.Drawing.StringFormat
  $sf.Alignment     = [System.Drawing.StringAlignment]::Center
  $sf.LineAlignment = [System.Drawing.StringAlignment]::Center
  $box = New-Object System.Drawing.RectangleF 0, 0, $Size, $Size
  # Drop shadow then white text for legibility on any base color.
  $shadow = New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::FromArgb(160, 0, 0, 0))
  $shbox  = New-Object System.Drawing.RectangleF ([single]($Size*0.03)), ([single]($Size*0.03)), $Size, $Size
  $gfx.DrawString($Label, $font, $shadow, $shbox, $sf)
  $white = New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::White)
  $gfx.DrawString($Label, $font, $white, $box, $sf)

  $gfx.Dispose()
  return $bmp
}

# --- Icons (64x64, Factorio's standard icon size) ---
$size = 64
foreach ($ic in $icons) {
  $bmp  = New-Placeholder -Size $size -R $ic.r -G $ic.g -B $ic.b -Label $ic.label -Glyph $ic.glyph
  $path = Join-Path $OutDir ("jjt-" + $ic.name + ".png")
  $bmp.Save($path, [System.Drawing.Imaging.ImageFormat]::Png)
  $bmp.Dispose()
  "Wrote $path"
}

# --- Thumbnail (144x144, mod-portal size) ---
$tsize = 144
$tb = New-Object System.Drawing.Bitmap $tsize, $tsize
$tg = [System.Drawing.Graphics]::FromImage($tb)
$tg.SmoothingMode     = 'AntiAlias'
$tg.TextRenderingHint = 'AntiAliasGridFit'
$rect = New-Object System.Drawing.Rectangle 0, 0, $tsize, $tsize
$grad = New-Object System.Drawing.Drawing2D.LinearGradientBrush $rect,
  ([System.Drawing.Color]::FromArgb(255, 25, 35, 65)),
  ([System.Drawing.Color]::FromArgb(255, 8, 12, 24)), 90.0
$tg.FillRectangle($grad, $rect)
# A few stars + a planet to read as "space overhaul" at a glance.
$star = New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::FromArgb(200, 255, 255, 255))
$rand = New-Object System.Random 98  # fixed seed -> reproducible thumbnail
for ($i = 0; $i -lt 40; $i++) {
  $x = $rand.Next(0, $tsize); $y = $rand.Next(0, $tsize); $s = $rand.Next(1, 3)
  $tg.FillEllipse($star, $x, $y, $s, $s)
}
$planet = New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::FromArgb(255, 90, 150, 200))
$tg.FillEllipse($planet, ($tsize - 58), ($tsize - 58), 44, 44)
$tfont = New-Object System.Drawing.Font 'Arial', 25, ([System.Drawing.FontStyle]::Bold)
$tsf = New-Object System.Drawing.StringFormat
$tsf.Alignment = [System.Drawing.StringAlignment]::Center
$tbrush = New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::FromArgb(255, 150, 200, 255))
$tg.DrawString('JJtorio', $tfont, $tbrush, (New-Object System.Drawing.RectangleF 0, 18, $tsize, 40), $tsf)
$subfont = New-Object System.Drawing.Font 'Arial', 10, ([System.Drawing.FontStyle]::Regular)
$subbrush = New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::FromArgb(200, 180, 200, 230))
$tg.DrawString('space overhaul', $subfont, $subbrush, (New-Object System.Drawing.RectangleF 0, 58, $tsize, 20), $tsf)
$tg.Dispose()
$tb.Save($ThumbPath, [System.Drawing.Imaging.ImageFormat]::Png)
$tb.Dispose()
"Wrote $ThumbPath"

# NOTE FOR A REAL ARTIST: everything this script emits is a stopgap.
# Still needed as real art:
#   - jjt-survey-satellite: a proper satellite icon (currently letters + a glyph).
#   - the machine/plate/fluid placeholders, once those items are designed.
#   - thumbnail.png: real key art for the mod portal.
