$log="C:\workspace\angela-skills-quest\governor\logs\guardian.log"
$nodes=Get-Process node -ErrorAction SilentlyContinue

if($null -eq $nodes){
  Add-Content -Path $log -Value ((Get-Date).ToString("s") + " node missing -> alert only; no automatic restart")
  exit 1
}

$stale = $false
foreach($n in $nodes){
  if($n.StartTime -lt (Get-Date).AddMinutes(-20)){ $stale = $true }
}

if($stale){
  Add-Content -Path $log -Value ((Get-Date).ToString("s") + " long-lived node detected -> observed only; no kill/restart")
}
else {
  Add-Content -Path $log -Value ((Get-Date).ToString("s") + " guardian ok")
}
