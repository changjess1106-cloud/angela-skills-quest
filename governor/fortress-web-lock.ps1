$files = git diff --name-only
foreach($f in $files){
 if($f -like "docs/index.html"){
 Write-Host "BLOCKED: Attempt to modify docs/index.html"
 exit 1
 }
 if($f -like "docs/arena/*"){
 Write-Host "BLOCKED: Attempt to modify docs/arena/*"
 exit 1
 }
 if($f -like "docs/battle/*"){
 Write-Host "BLOCKED: Attempt to modify docs/battle/*"
 exit 1
 }
 if($f -like "docs/submit/*"){
 Write-Host "BLOCKED: Attempt to modify docs/submit/*"
 exit 1
 }
}
Write-Host "SAFE: UI unchanged"
exit 0
