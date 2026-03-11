param([string]$TargetFile,[string[]]$Content)
$root="C:\workspace\angela-skills-quest"
$temp="$root\governor\temp\temp.html"
$backup="$root\governor\backup\index-backup.html"
try{
 $Content | Out-File $temp -Encoding utf8
 if(!(Test-Path $temp)){throw "temp fail"}
 if(Test-Path $TargetFile){Copy-Item $TargetFile $backup -Force}
 Copy-Item $temp $TargetFile -Force
 git add docs
 git commit -m "safe deploy"
 git push origin main
 Write-Host "DEPLOY SUCCESS"
}
catch{
 Write-Host "DEPLOY FAILED ROLLBACK"
 if(Test-Path $backup){Copy-Item $backup $TargetFile -Force}
 git reset --hard HEAD
}
