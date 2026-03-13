$task1="AngelaSkillsQuest-skill-sync"
$task2="AngelaSkillsQuest-challenge-score"
$cmd1='powershell.exe -NoLogo -NoProfile -ExecutionPolicy Bypass -File "C:\workspace\angela-skills-quest\scripts\run-v27-skill-sync.ps1"'
$cmd2='powershell.exe -NoLogo -NoProfile -ExecutionPolicy Bypass -File "C:\workspace\angela-skills-quest\scripts\run-v27-challenge-score.ps1"'
schtasks /Create /TN $task1 /SC MINUTE /MO 30 /TR $cmd1 /F | Out-Null
schtasks /Create /TN $task2 /SC MINUTE /MO 20 /TR $cmd2 /F | Out-Null
schtasks /Query /TN $task1 /FO LIST
schtasks /Query /TN $task2 /FO LIST
