$task = "AngelaSkillsQuest-auto-repair"
$cmd = 'powershell.exe -NoLogo -NoProfile -ExecutionPolicy Bypass -File "C:\workspace\angela-skills-quest\scripts\run-v20-auto-repair.ps1"'
schtasks /Create /TN $task /SC HOURLY /MO 1 /TR $cmd /F | Out-Null
schtasks /Query /TN $task /FO LIST
