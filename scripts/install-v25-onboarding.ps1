$task="AngelaSkillsQuest-agent-onboarding"
$cmd='powershell.exe -NoLogo -NoProfile -ExecutionPolicy Bypass -File "C:\workspace\angela-skills-quest\scripts\run-v25-onboarding.ps1"'
schtasks /Create /TN $task /SC MINUTE /MO 30 /TR $cmd /F|Out-Null
schtasks /Query /TN $task /FO LIST
