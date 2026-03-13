$root="C:\workspace\angela-skills-quest"
$data="$root\docs\data"
$pending="$data\pending-skills.json"
$tests="$data\skill-tests.json"
$rank="$data\skill-rankings.json"
$events="$data\evolution-events.json"
$time=(Get-Date).ToString("s")

$p=Get-Content $pending -Raw|ConvertFrom-Json
if(!$p){$p=@()}

$t=@()
foreach($s in $p){
 $success=(Get-Random -Minimum 5 -Maximum 10)
 $tests=10
 $t+=@{skill=$s.skill;tests=$tests;success=$success}
}

$t|ConvertTo-Json -Depth 5|Out-File $tests -Encoding utf8

$r=@()
foreach($x in $t){
 $score=[math]::Round($x.success/$x.tests,2)
 $r+=@{skill=$x.skill;score=$score}
}

$r=$r|Sort-Object score -Descending
$i=1
foreach($x in $r){$x.rank=$i;$i++}

$r|ConvertTo-Json -Depth 5|Out-File $rank -Encoding utf8

$event=@{time=$time;event="evolution-cycle";skills=$r.Count}

$e=Get-Content $events -Raw|ConvertFrom-Json
if(!$e){$e=@()}
$e+=$event
$e|ConvertTo-Json -Depth 5|Out-File $events -Encoding utf8

git -C $root add docs
$s=git -C $root status --porcelain docs
if($s){
 git -C $root commit -m "v26 evolution engine"|Out-Null
 git -C $root push origin main|Out-Null
}

Write-Host "Evolution Cycle Complete"
