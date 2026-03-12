Set-Location "C:\workspace\angela-skills-quest"
$log = "C:\workspace\angela-skills-quest\governor\logs\runtime-guard.log"
$alerts = @()
if(Test-Path "docs\index.html"){
 $len = (Get-Item "docs\index.html").Length
 if($len -lt 200){ $alerts += "ALERT: docs/index.html suspiciously small" }
} else {
 $alerts += "ALERT: docs/index.html missing"
}
if(Test-Path "docs\data\leaderboard.json"){
 $len = (Get-Item "docs\data\leaderboard.json").Length
 if($len -gt 2000000){ $alerts += "ALERT: leaderboard.json too large" }
}
if(Test-Path "docs\data\evolution-log.json"){
 $len = (Get-Item "docs\data\evolution-log.json").Length
 if($len -gt 3000000){ $alerts += "ALERT: evolution-log.json too large" }
}
if($alerts.Count -eq 0){
 $line = (Get-Date).ToString("s") + " OK"
 Add-Content -Path $log -Value $line
 Write-Host "Runtime guard OK"
 exit 0
}
foreach($a in $alerts){
 Add-Content -Path $log -Value ((Get-Date).ToString("s") + " " + $a)
 Write-Host $a
}
exit 1
