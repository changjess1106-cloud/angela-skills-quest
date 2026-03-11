$skills = Get-Content docs/data/skills.json | ConvertFrom-Json
foreach($s in $skills){
  if($s.status -eq "pending"){
    $s.status="tested"
  }
}
$skills | ConvertTo-Json | Out-File docs/data/skills.json