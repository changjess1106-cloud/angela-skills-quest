$root = "C:\\workspace\\angela-skills-quest"
$dataDir = Join-Path $root "docs\\data"
$logDir = Join-Path $root "governor\\logs"
$improvementQueue = Join-Path $dataDir "improvement-queue.json"
$evolutionLog = Join-Path $dataDir "evolution-log.json"
$testQueue = Join-Path $dataDir "test-queue.json"
$testResults = Join-Path $dataDir "test-results.json"
$battles = Join-Path $dataDir "battles.json"
$leaderboard = Join-Path $dataDir "leaderboard.json"
$runLog = Join-Path $logDir "v20_1_evolution_cycle.log"

function Read-JsonArray([string]$path){
 if(!(Test-Path $path)){ return @() }
 $raw = Get-Content $path -Raw
 if([string]::IsNullOrWhiteSpace($raw)){ return @() }
 $obj = $raw | ConvertFrom-Json
 if($null -eq $obj){ return @() }
 if($obj -is [System.Collections.IEnumerable] -and $obj -isnot [string]){ return @($obj) }
 return @($obj)
}

function Write-Json([object]$obj,[string]$path){
 $obj | ConvertTo-Json -Depth 20 | Out-File $path -Encoding utf8
}

$results = Read-JsonArray $testResults
$battleData = Read-JsonArray $battles
$queue = Read-JsonArray $improvementQueue
$evo = Read-JsonArray $evolutionLog
$tests = Read-JsonArray $testQueue
$board = Read-JsonArray $leaderboard

$recentResults = @($results) | Sort-Object -Property time -Descending | Select-Object -First 10
foreach($r in $recentResults){
 if($null -eq $r){ continue }
 $score = 0
 if($null -ne $r.score){ $score = [int]$r.score }
 if($score -lt 75){
 $exists = @($queue) | Where-Object { $_.agent_id -eq $r.agent_id -and $_.skill_name -eq $r.skill_name -and $_.status -eq "pending" } | Select-Object -First 1
 if(-not $exists){
 $queue += @{ agent_id = $r.agent_id; skill_name = $r.skill_name; reason = "low test score"; target = "improve benchmark performance"; created_at = (Get-Date).ToString("s"); status = "pending" }
 }
 }
}

$recentBattles = @($battleData) | Sort-Object -Property time -Descending | Select-Object -First 5
foreach($b in $recentBattles){
 if($null -eq $b){ continue }
 if($null -eq $b.agent1 -or $null -eq $b.agent2 -or $null -eq $b.winner){ continue }
 $loser = $b.agent1
 if($b.winner -eq $b.agent1){ $loser = $b.agent2 }
 $exists = @($queue) | Where-Object { $_.agent_id -eq $loser -and $_.skill_name -eq "battle-adjustment" -and $_.status -eq "pending" } | Select-Object -First 1
 if(-not $exists){
 $queue += @{ agent_id = $loser; skill_name = "battle-adjustment"; reason = "lost recent battle"; target = "improve tournament score"; created_at = (Get-Date).ToString("s"); status = "pending" }
 }
}

$pending = @($queue) | Where-Object { $_.status -eq "pending" } | Sort-Object -Property created_at | Select-Object -First 3
foreach($item in $pending){
 if($null -eq $item){ continue }
 $tests += @{ agent_id = $item.agent_id; skill_name = $item.skill_name; timestamp = (Get-Date).ToString("s") }
 $evo += @{ agent_id = $item.agent_id; skill_name = $item.skill_name; action = "queued for retest"; reason = $item.reason; target = $item.target; time = (Get-Date).ToString("s") }
 $item.status = "processed"
}

$queue = @($queue) | Sort-Object -Property created_at -Descending | Select-Object -First 200
$evo = @($evo) | Sort-Object -Property time -Descending | Select-Object -First 300
$tests = @($tests) | Sort-Object -Property timestamp -Descending | Select-Object -First 200
$board = @($board) | Sort-Object -Property score -Descending | Select-Object -First 100

Write-Json $queue $improvementQueue
Write-Json $evo $evolutionLog
Write-Json $tests $testQueue
Write-Json $board $leaderboard

git -C $root add docs\\data
$status = git -C $root status --porcelain docs\\data
if(-not [string]::IsNullOrWhiteSpace($status)){
 git -C $root commit -m "Angela Skills Quest v20.1 auto evolution cycle" | Out-Null
 git -C $root push origin main | Out-Null
}

$line = (Get-Date).ToString("s") + " pending_processed=" + @($pending).Count
Add-Content -Path $runLog -Value $line
Write-Host "V20.1 EVOLUTION COMPLETE"
