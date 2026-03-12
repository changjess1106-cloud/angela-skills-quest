Set-Location "C:\workspace\angela-skills-quest"
powershell -NoLogo -NoProfile -ExecutionPolicy Bypass -File "C:\workspace\angela-skills-quest\governor\fortress-web-lock.ps1"
if ($LASTEXITCODE -ne 0) {
 Write-Host "Guard failed. Commit blocked."
 exit 1
}
git add .
$status = git status --porcelain
if ([string]::IsNullOrWhiteSpace($status)) {
 Write-Host "Nothing to commit."
 exit 0
}
git commit -m "guarded commit"
if ($LASTEXITCODE -ne 0) {
 exit 1
}
git push origin main
