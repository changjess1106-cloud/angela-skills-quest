$root="C:\workspace\angela-skills-quest"
$rankFile="$root\docs\data\skill-rankings.json"
$boardFile="$root\docs\data\leaderboard.json"

if(!(Test-Path $rankFile)){
 Write-Host "ranking file missing"
 exit
}

$data=Get-Content $rankFile -Raw | ConvertFrom-Json
$top=$data | Sort-Object score -Descending | Select-Object -First 10
$top | ConvertTo-Json -Depth 10 | Out-File $boardFile -Encoding utf8

Write-Host "leaderboard generated"
