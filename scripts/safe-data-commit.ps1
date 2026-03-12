Set-Location "C:\workspace\angela-skills-quest"
$changed = git diff --name-only
foreach($f in $changed){
 if($f -like "docs/index.html"){ Write-Host "BLOCKED: docs/index.html"; exit 1 }
 if($f -like "docs/arena/*"){ Write-Host "BLOCKED: docs/arena"; exit 1 }
 if($f -like "docs/battle/*"){ Write-Host "BLOCKED: docs/battle"; exit 1 }
 if($f -like "docs/submit/*"){ Write-Host "BLOCKED: docs/submit"; exit 1 }
}
git add docs\data scripts governor
$status = git status --porcelain
if([string]::IsNullOrWhiteSpace($status)){ Write-Host "Nothing to commit."; exit 0 }
git commit -m "safe data commit"
if($LASTEXITCODE -ne 0){ exit 1 }
git push origin main
