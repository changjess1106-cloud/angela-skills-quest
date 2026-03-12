param([string]$ScriptPath)
Set-Location "C:\workspace\angela-skills-quest"
if([string]::IsNullOrWhiteSpace($ScriptPath)){ Write-Host "ScriptPath required"; exit 1 }
if(!(Test-Path $ScriptPath)){ Write-Host "Missing script: $ScriptPath"; exit 1 }
Write-Host "Running: $ScriptPath"
powershell -NoLogo -NoProfile -ExecutionPolicy Bypass -File $ScriptPath
if($LASTEXITCODE -ne 0){ Write-Host "Wrapped script failed"; exit 1 }
powershell -NoLogo -NoProfile -ExecutionPolicy Bypass -File "C:\workspace\angela-skills-quest\scripts\safe-data-commit.ps1"
