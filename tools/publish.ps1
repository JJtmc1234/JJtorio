# Publishes a new JJtorio release to the Factorio mod portal.
#
#   $env:FACTORIO_API_KEY = '<key from https://factorio.com/profile>'
#   powershell -File tools\publish.ps1                 # publish current version
#   powershell -File tools\publish.ps1 -NewVersion 0.1.1  # bump, then publish
#
# Uses the documented mod-portal upload API (init_upload -> upload). This
# only works for a mod that ALREADY EXISTS on the portal; do the very first
# publish through the website. The API key stays in the env var, never in
# this file or git.
param(
  [string]$Root = (Resolve-Path (Join-Path $PSScriptRoot '..')),
  [string]$NewVersion,
  [string]$ApiKey = $env:FACTORIO_API_KEY
)

$ErrorActionPreference = 'Stop'
[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.SecurityProtocolType]::Tls12

if (-not $ApiKey) {
  throw "Set FACTORIO_API_KEY first: `$env:FACTORIO_API_KEY = '<key from factorio.com/profile>'"
}

$modDir = (Resolve-Path (Join-Path $Root 'mod')).Path
$infoPath = Join-Path $modDir 'info.json'

# Optional version bump (targeted replace so the file's formatting survives).
if ($NewVersion) {
  $text = [System.IO.File]::ReadAllText($infoPath)
  $text = $text -replace '("version"\s*:\s*")[^"]*(")', ('${1}' + $NewVersion + '${2}')
  [System.IO.File]::WriteAllText($infoPath, $text, (New-Object System.Text.UTF8Encoding $false))
  "Bumped version to $NewVersion"
}

# Build the zip from the (possibly bumped) manifest.
& (Join-Path $PSScriptRoot 'build-release.ps1') -Root $Root | Write-Host

$info = Get-Content $infoPath -Raw | ConvertFrom-Json
$name = $info.name
$version = $info.version
$zip = Join-Path $Root ("dist\{0}_{1}.zip" -f $name, $version)
if (-not (Test-Path $zip)) { throw "Zip not found: $zip" }

Add-Type -AssemblyName System.Net.Http
$client = New-Object System.Net.Http.HttpClient
$client.DefaultRequestHeaders.Authorization =
  New-Object System.Net.Http.Headers.AuthenticationHeaderValue('Bearer', $ApiKey)

# Step 1: init_upload -> get a one-time upload URL.
$init = New-Object System.Net.Http.MultipartFormDataContent
$init.Add((New-Object System.Net.Http.StringContent($name)), 'mod')
$initResp = $client.PostAsync('https://mods.factorio.com/api/v2/mods/releases/init_upload', $init).Result
$initBody = $initResp.Content.ReadAsStringAsync().Result
if (-not $initResp.IsSuccessStatusCode) { throw "init_upload failed ($($initResp.StatusCode)): $initBody" }
$uploadUrl = ($initBody | ConvertFrom-Json).upload_url
if (-not $uploadUrl) { throw "No upload_url in response: $initBody" }

# Step 2: upload the zip to that URL.
$bytes = [System.IO.File]::ReadAllBytes($zip)
$fileContent = New-Object System.Net.Http.ByteArrayContent (, $bytes)
$fileContent.Headers.ContentType = New-Object System.Net.Http.Headers.MediaTypeHeaderValue('application/zip')
$upload = New-Object System.Net.Http.MultipartFormDataContent
$upload.Add($fileContent, 'file', [System.IO.Path]::GetFileName($zip))
$upResp = $client.PostAsync($uploadUrl, $upload).Result
$upBody = $upResp.Content.ReadAsStringAsync().Result
if (-not $upResp.IsSuccessStatusCode) { throw "upload failed ($($upResp.StatusCode)): $upBody" }

"Published $name $version to the mod portal."
