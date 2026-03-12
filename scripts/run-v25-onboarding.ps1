$root="C:\workspace\angela-skills-quest"
$data="$root\docs\data"
$intake="$data\skill-intake.json"
$pending="$data\pending-skills.json"
$events="$data\onboarding-events.json"
$time=(Get-Date).ToString("s")

$i=Get-Content $intake -Raw|ConvertFrom-Json
if(!$i){$i=@()}

$p=Get-Content $pending -Raw|ConvertFrom-Json
if(!$p){$p=@()}

foreach($skill in $i){
 $p += $skill
}

$p|ConvertTo-Json -Depth 5|Out-File $pending -Encoding utf8
"[]"|Out-File $intake -Encoding utf8

$event=@{
 time=$time;
 event="onboarding-cycle";
 pending=$p.Count
}

$e=Get-Content $events -Raw|ConvertFrom-Json
if(!$e){$e=@()}
$e+=$event
$e|ConvertTo-Json -Depth 5|Out-File $events -Encoding utf8

git -C $root add docs
$s=git -C $root status --porcelain docs
if($s){
 git -C $root commit -m "v25 onboarding cycle"|Out-Null
 git -C $root push origin main|Out-Null
}

Write-Host "Onboarding Cycle Complete"
