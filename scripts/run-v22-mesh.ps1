$root="C:\workspace\angela-skills-quest"
$data="$root\docs\data"
$node="$data\mesh-node.json"
$peers="$data\mesh-peers.json"
$events="$data\mesh-events.json"
$time=(Get-Date).ToString("s")

$nodeInfo=@{
 node_id="angela-node-001";
 platform="Angela Skills Quest";
 status="online";
 capabilities=@("skills","battle","testing");
 last_seen=$time
}

$nodeInfo|ConvertTo-Json -Depth 5|Out-File $node -Encoding utf8

$p=Get-Content $peers -Raw|ConvertFrom-Json
if(!$p){$p=@()}

$event=@{
 time=$time;
 type="mesh_cycle";
 peers=$p.Count
}

$e=Get-Content $events -Raw|ConvertFrom-Json
if(!$e){$e=@()}
$e+=$event
$e|ConvertTo-Json -Depth 5|Out-File $events -Encoding utf8

git -C $root add docs\data
$s=git -C $root status --porcelain docs\data
if($s){
 git -C $root commit -m "v22 mesh network cycle"|Out-Null
 git -C $root push origin main|Out-Null
}

Write-Host "Mesh Cycle Complete"
