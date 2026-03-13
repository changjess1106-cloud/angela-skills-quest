Set-Location "C:\workspace\angela-skills-quest"
$path = ".github\workflows\pages.yml"
if(!(Test-Path $path)){ Write-Host "MISSING: pages.yml"; exit 1 }
$raw = Get-Content $path -Raw
$ok = $true
if($raw -notmatch "name:"){ Write-Host "MISSING: name"; $ok = $false }
if($raw -notmatch "on:"){ Write-Host "MISSING: on"; $ok = $false }
if($raw -notmatch "jobs:"){ Write-Host "MISSING: jobs"; $ok = $false }
if($raw -notmatch "deploy:"){ Write-Host "MISSING: deploy"; $ok = $false }
if($ok){ Write-Host "WORKFLOW OK"; exit 0 }
exit 1
