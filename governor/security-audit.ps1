Set-Location "C:\workspace\angela-skills-quest"
Write-Host "=== OpenClaw Security Audit ==="
Write-Host "Protected UI files:"
Test-Path "docs\index.html"
Test-Path "docs\arena\index.html"
Test-Path "docs\battle\index.html"
Test-Path "docs\submit\index.html"
Write-Host "Data files:"
Get-ChildItem "docs\data" -File | Select-Object Name,Length,LastWriteTime
Write-Host "Scheduler scripts:"
Get-ChildItem "scripts" -Filter "*.ps1" | Select-Object Name,Length,LastWriteTime
Write-Host "Recent git status:"
git status --short
