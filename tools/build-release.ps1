# Builds dist/<name>_<version>.zip from mod/, reading name+version from
# mod/info.json so the filename always matches the manifest.
#
# Uses System.IO.Compression directly (not Compress-Archive): Windows
# PowerShell's Compress-Archive writes backslash path separators inside the
# zip, which the Factorio mod portal rejects. Entry names here use forward
# slashes so the zip works on Linux/macOS too.
param(
  [string]$Root = (Resolve-Path (Join-Path $PSScriptRoot '..'))
)

Add-Type -AssemblyName System.IO.Compression
Add-Type -AssemblyName System.IO.Compression.FileSystem

$modDir = (Resolve-Path (Join-Path $Root 'mod')).Path
$info = Get-Content (Join-Path $modDir 'info.json') -Raw | ConvertFrom-Json
$name = $info.name
$version = $info.version

$dist = Join-Path $Root 'dist'
New-Item -ItemType Directory -Force -Path $dist | Out-Null
$zip = Join-Path $dist ("{0}_{1}.zip" -f $name, $version)
if (Test-Path $zip) { Remove-Item $zip -Force }

$fs = [System.IO.File]::Open($zip, [System.IO.FileMode]::CreateNew)
$archive = New-Object System.IO.Compression.ZipArchive($fs, [System.IO.Compression.ZipArchiveMode]::Create)
try {
  # Ship only git-tracked files, never whatever happens to be on disk, so an
  # uncommitted or half-written change cannot leak into a release. Paths come out
  # of git as "mod/<rel>" with forward slashes already.
  $tracked = git -C $Root ls-files mod
  if (-not $tracked) { throw "git ls-files found no tracked files under mod/. Commit the mod before building." }
  foreach ($rel in $tracked) {
    $full = Join-Path $Root $rel
    if (-not (Test-Path $full)) { continue }  # tracked but deleted on disk
    $entry = "$name/$($rel.Substring(4))"     # strip the leading "mod/"
    [System.IO.Compression.ZipFileExtensions]::CreateEntryFromFile($archive, $full, $entry) | Out-Null
  }
}
finally {
  $archive.Dispose()
  $fs.Dispose()
}

"Built $zip ($([math]::Round((Get-Item $zip).Length / 1kb, 1)) KB)"
