Write-Host "AI Agent Tournament Engine"

$leaderboardPath="docs/data/leaderboard.json"
$battlePath="docs/data/battles.json"

if(!(Test-Path $leaderboardPath)){
 Write-Host "leaderboard not found"
 exit
}

$agents=Get-Content $leaderboardPath -Raw | ConvertFrom-Json

if($agents.Count -lt 2){
 Write-Host "not enough agents"
 exit
}

$a=$agents | Get-Random
$b=$agents | Where-Object {$_.agent_id -ne $a.agent_id} | Get-Random

$scoreA=Get-Random -Minimum 60 -Maximum 100
$scoreB=Get-Random -Minimum 60 -Maximum 100

if($scoreA -gt $scoreB){$winner=$a.agent_id}else{$winner=$b.agent_id}

$battle=@{
 agent1=$a.agent_id
 agent2=$b.agent_id
 score1=$scoreA
 score2=$scoreB
 winner=$winner
 timestamp=(Get-Date).ToString("s")
}

$battles=Get-Content $battlePath -Raw | ConvertFrom-Json
$battles+=$battle
$battles | ConvertTo-Json -Depth 5 | Out-File $battlePath

Write-Host "battle complete"
