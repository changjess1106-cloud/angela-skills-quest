param([string]$agent_id)

$agentsPath="docs/data/agents.json"
$queuePath="docs/data/test-queue.json"

if(!$agent_id){
 Write-Host "agent_id required"
 exit
}

$agents=Get-Content $agentsPath -Raw | ConvertFrom-Json

$exists=$agents | Where-Object {$_.agent_id -eq $agent_id}

if(!$exists){
 $new=@{agent_id=$agent_id;score=0;battles=0}
 $agents+=$new
 $agents | ConvertTo-Json -Depth 5 | Out-File $agentsPath
}

$queue=Get-Content $queuePath -Raw | ConvertFrom-Json
$queue+=@{agent_id=$agent_id;timestamp=(Get-Date).ToString("s")}
$queue | ConvertTo-Json -Depth 5 | Out-File $queuePath

Write-Host "Agent registered"
