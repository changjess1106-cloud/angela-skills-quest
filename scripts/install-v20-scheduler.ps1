$task1 = "AngelaSkillsQuest-v20-auto-test"
$task2 = "AngelaSkillsQuest-v20-improvement-plan"
$task3 = "AngelaSkillsQuest-v20-evolution"
$task4 = "AngelaSkillsQuest-v20-battle"
$testCmd = 'powershell.exe -NoLogo -NoProfile -ExecutionPolicy Bypass -File "C:\\\\workspace\\\\angela-skills-quest\\\\scripts\\\\run-v10-cycle.ps1"'
$planCmd = 'powershell.exe -NoLogo -NoProfile -ExecutionPolicy Bypass -File "C:\\\\workspace\\\\angela-skills-quest\\\\scripts\\\\generate-improvement-plan.ps1"'
$evoCmd = 'powershell.exe -NoLogo -NoProfile -ExecutionPolicy Bypass -File "C:\\\\workspace\\\\angela-skills-quest\\\\scripts\\\\run-v20-evolution-cycle.ps1"'
$battleCmd = 'powershell.exe -NoLogo -NoProfile -ExecutionPolicy Bypass -File "C:\\\\workspace\\\\angela-skills-quest\\\\scripts\\\\run-battles.ps1"'
schtasks /Create /TN $task1 /SC MINUTE /MO 15 /TR $testCmd /F | Out-Null
schtasks /Create /TN $task2 /SC MINUTE /MO 30 /TR $planCmd /F | Out-Null
schtasks /Create /TN $task3 /SC MINUTE /MO 30 /TR $evoCmd /F | Out-Null
schtasks /Create /TN $task4 /SC HOURLY /MO 1 /TR $battleCmd /F | Out-Null
