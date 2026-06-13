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
  foreach ($f in Get-ChildItem $modDir -Recurse -File) {
    $rel = $f.FullName.Substring($modDir.Length + 1) -replace '\\', '/'
    $entry = "$name/$rel"
    [System.IO.Compression.ZipFileExtensions]::CreateEntryFromFile($archive, $f.FullName, $entry) | Out-Null
  }
}
finally {
  $archive.Dispose()
  $fs.Dispose()
}

"Built $zip ($([math]::Round((Get-Item $zip).Length / 1kb, 1)) KB)"
