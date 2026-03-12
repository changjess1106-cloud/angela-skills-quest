$root = "C:\workspace\angela-skills-quest"
$docs = Join-Path $root "docs"
$data = Join-Path $docs "data"
$logFile = Join-Path $root "governor\logs\v20_3_auto_repair.log"
$homeFile = Join-Path $docs "index.html"
$leaderFile = Join-Path $data "leaderboard.json"
$testQueueFile = Join-Path $data "test-queue.json"
$improvementQueueFile = Join-Path $data "improvement-queue.json"
$evolutionFile = Join-Path $data "evolution-log.json"

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

function Log-Line([string]$msg){
 Add-Content -Path $logFile -Value ((Get-Date).ToString("s") + " " + $msg)
}

$changed = $false

# 1. Repair homepage only if missing or suspiciously small
if(!(Test-Path $homeFile)){
 $home = @(
'<!DOCTYPE html>',
'<html>',
'<head>',
'<meta charset="UTF-8">',
'<meta name="viewport" content="width=device-width,initial-scale=1">',
'<title>Angela Skills Quest</title>',
'<style>',
'body{background:#0b0f1a;color:white;font-family:Arial;margin:0;padding:40px}',
'h1{font-size:48px}',
'a{color:#6ea8ff;text-decoration:none;font-size:20px}',
'.card{background:#141b2d;padding:20px;border-radius:12px;margin-top:20px}',
'</style>',
'</head>',
'<body>',
'<h1>Angela Skills Quest</h1>',
'<div class="card">',
'<p>AI Agent Olympics Platform</p>',
'<p><a href="arena/">Arena Dashboard</a></p>',
'<p><a href="battle/">Battle Arena</a></p>',
'<p><a href="submit/">Submit Skill</a></p>',
'</div>',
'</body>',
'</html>'
)
 $home | Out-File $homeFile -Encoding utf8
 Log-Line "Repaired missing homepage"
 $changed = $true
}
elseif((Get-Item $homeFile).Length -lt 200){
$home = @(
'<!DOCTYPE html>',
'<html>',
'<head>',
'<meta charset="UTF-8">',
'<meta name="viewport" content="width=device-width,initial-scale=1">',
'<title>Angela Skills Quest</title>',
'<style>',
'body{background:#0b0f1a;color:white;font-family:Arial;margin:0;padding:40px}',
'h1{font-size:48px}',
'a{color:#6ea8ff;text-decoration:none;font-size:20px}',
'.card{background:#141b2d;padding:20px;border-radius:12px;margin-top:20px}',
'</style>',
'</head>',
'<body>',
'<h1>Angela Skills Quest</h1>',
'<div class="card">',
'<p>AI Agent Olympics Platform</p>',
'<p><a href="arena/">Arena Dashboard</a></p>',
'<p><a href="battle/">Battle Arena</a></p>',
'<p><a href="submit/">Submit Skill</a></p>',
'</div>',
'</body>',
'</html>'
)
 $home | Out-File $homeFile -Encoding utf8
 Log-Line "Repaired suspiciously small homepage"
 $changed = $true
}

# 2. Deduplicate leaderboard by agent_id, keep max score
$leader = Read-JsonArray $leaderFile
if(@($leader).Count -gt 0){
 $dedup = @()
 $groups = $leader | Group-Object -Property agent_id
 foreach($g in $groups){
 $best = $g.Group | Sort-Object -Property score -Descending | Select-Object -First 1
 $dedup += $best
 }
 if(@($dedup).Count -ne @($leader).Count){
 $dedup = @($dedup) | Sort-Object -Property score -Descending | Select-Object -First 100
 Write-Json $dedup $leaderFile
 Log-Line "Deduplicated leaderboard entries"
 $changed = $true
 }
}

# 3. Trim queues
$testQueue = Read-JsonArray $testQueueFile
if(@($testQueue).Count -gt 200){
 $testQueue = @($testQueue) | Sort-Object -Property timestamp -Descending | Select-Object -First 200
 Write-Json $testQueue $testQueueFile
 Log-Line "Trimmed test queue to 200 items"
 $changed = $true
}

$improvementQueue = Read-JsonArray $improvementQueueFile
if(@($improvementQueue).Count -gt 200){
 $improvementQueue = @($improvementQueue) | Sort-Object -Property created_at -Descending | Select-Object -First 200
 Write-Json $improvementQueue $improvementQueueFile
 Log-Line "Trimmed improvement queue to 200 items"
 $changed = $true
}

# 4. Trim evolution log
$evo = Read-JsonArray $evolutionFile
if(@($evo).Count -gt 300){
 $evo = @($evo) | Sort-Object -Property time -Descending | Select-Object -First 300
 Write-Json $evo $evolutionFile
 Log-Line "Trimmed evolution log to 300 items"
 $changed = $true
}

if(-not $changed){
 Log-Line "No repair needed"
}

git -C $root add docs docs\data governor\logs
$status = git -C $root status --porcelain docs docs\data governor\logs
if(-not [string]::IsNullOrWhiteSpace($status)){
 git -C $root commit -m "Angela Skills Quest v20.3 auto repair" | Out-Null
 git -C $root push origin main | Out-Null
}

Write-Host "V20.3 AUTO REPAIR COMPLETE"
