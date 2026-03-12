Write-Host "AI Agent Mesh Sync"
$peers=Get-Content mesh/peers.json -Raw | ConvertFrom-Json

foreach($p in $peers){
 try{
 $agents=Invoke-RestMethod "$p/agents"
 $local=Get-Content "docs/data/agents.json" -Raw | ConvertFrom-Json
 $local+=$agents
 $local | ConvertTo-Json -Depth 5 | Out-File "docs/data/agents.json"
 }
 catch{}
}
Write-Host "mesh sync complete"
