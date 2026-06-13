# Builds dist/<name>_<version>.zip from mod/, reading name+version from
# mod/info.json so the filename always matches the manifest.
param(
  [string]$Root = (Resolve-Path (Join-Path $PSScriptRoot '..'))
)

$info = Get-Content (Join-Path $Root 'mod\info.json') -Raw | ConvertFrom-Json
$name = $info.name
$version = $info.version

$stage = Join-Path $env:TEMP 'jjt_pkg'
if (Test-Path $stage) { Remove-Item $stage -Recurse -Force }
Copy-Item (Join-Path $Root 'mod') (Join-Path $stage $name) -Recurse

$dist = Join-Path $Root 'dist'
New-Item -ItemType Directory -Force -Path $dist | Out-Null
$zip = Join-Path $dist ("{0}_{1}.zip" -f $name, $version)
if (Test-Path $zip) { Remove-Item $zip -Force }
Compress-Archive -Path (Join-Path $stage $name) -DestinationPath $zip

"Built $zip ($([math]::Round((Get-Item $zip).Length / 1kb, 1)) KB)"
