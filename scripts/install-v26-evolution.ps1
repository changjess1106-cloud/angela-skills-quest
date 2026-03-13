$task="AngelaSkillsQuest-skill-evolution"
$cmd='powershell.exe -NoLogo -NoProfile -ExecutionPolicy Bypass -File "C:\workspace\angela-skills-quest\scripts\run-v26-evolution.ps1"'
schtasks /Create /TN $task /SC MINUTE /MO 40 /TR $cmd /F|Out-Null
schtasks /Query /TN $task /FO LIST
