$log="C:\workspace\angela-skills-quest\governor\logs\guardian.log"
$openclawCmd="openclaw"
$nodes=Get-Process node -ErrorAction SilentlyContinue
if($null -eq $nodes){
  Add-Content -Path $log -Value ((Get-Date).ToString("s") + " node missing -> restarting openclaw")
  Start-Process powershell -ArgumentList "-NoLogo -NoProfile -Command openclaw" -WindowStyle Minimized
  exit 0
}
$stale = $false
foreach($n in $nodes){
  if($n.StartTime -lt (Get-Date).AddMinutes(-20)){ $stale = $true }
}
if($stale){
  Add-Content -Path $log -Value ((Get-Date).ToString("s") + " stale node detected -> restarting")
  taskkill /IM node.exe /F | Out-Null
  Start-Sleep -Seconds 2
  Start-Process powershell -ArgumentList "-NoLogo -NoProfile -Command openclaw" -WindowStyle Minimized
}
else {
  Add-Content -Path $log -Value ((Get-Date).ToString("s") + " guardian ok")
}
