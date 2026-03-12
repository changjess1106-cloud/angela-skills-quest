$root="C:\workspace\angela-skills-quest"
$data="$root\docs\data"
$events="$data\system-events.json"
$state="$data\civilization-state.json"

$timestamp=(Get-Date).ToString("s")

function ReadJson($p){
 if(!(Test-Path $p)){ return $null }
 $r=Get-Content $p -Raw
 if([string]::IsNullOrWhiteSpace($r)){ return $null }
 return $r|ConvertFrom-Json
}

$leader=(ReadJson "$data\leaderboard.json")
$battles=(ReadJson "$data\battles.json")
$tests=(ReadJson "$data\test-results.json")

$leaderCount=0
if($leader){$leaderCount=$leader.Count}

$battleCount=0
if($battles){$battleCount=$battles.Count}

$testCount=0
if($tests){$testCount=$tests.Count}

$civilization=@{
 timestamp=$timestamp;
 agents=$leaderCount;
 battles=$battleCount;
 tests=$testCount;
 status="alive"
}

$civilization|ConvertTo-Json -Depth 5|Out-File $state -Encoding utf8

$log=@{
 time=$timestamp;
 type="kernel_cycle";
 agents=$leaderCount;
 battles=$battleCount;
 tests=$testCount
}

$e=ReadJson $events
if(!$e){$e=@()}
$e+=$log
$e|ConvertTo-Json -Depth 5|Out-File $events -Encoding utf8

git -C $root add docs\data
$s=git -C $root status --porcelain docs\data
if($s){
 git -C $root commit -m "v21 civilization kernel cycle"|Out-Null
 git -C $root push origin main|Out-Null
}

Write-Host "Civilization Kernel Cycle Complete"
