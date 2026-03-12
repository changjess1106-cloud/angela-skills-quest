$task1 = "AngelaSkillsQuest-runtime-guard"
$task2 = "AngelaSkillsQuest-security-audit"
$guardCmd = 'powershell.exe -NoLogo -NoProfile -ExecutionPolicy Bypass -File "C:\workspace\angela-skills-quest\governor\runtime-guard.ps1"'
$auditCmd = 'powershell.exe -NoLogo -NoProfile -ExecutionPolicy Bypass -File "C:\workspace\angela-skills-quest\governor\security-audit.ps1" > "C:\workspace\angela-skills-quest\governor\logs\security-audit-last.txt"'
schtasks /Create /TN $task1 /SC MINUTE /MO 30 /TR $guardCmd /F | Out-Null
schtasks /Create /TN $task2 /SC DAILY /ST 09:00 /TR $auditCmd /F | Out-Null
schtasks /Query /TN $task1 /FO LIST
schtasks /Query /TN $task2 /FO LIST
