$task="AngelaSkillsQuest-civilization-kernel"
$cmd='powershell.exe -NoLogo -NoProfile -ExecutionPolicy Bypass -File "C:\workspace\angela-skills-quest\scripts\run-v21-kernel.ps1"'
schtasks /Create /TN $task /SC MINUTE /MO 15 /TR $cmd /F|Out-Null
schtasks /Query /TN $task /FO LIST
