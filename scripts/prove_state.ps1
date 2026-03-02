# prove_state.ps1

param(
    [string]$TaskFile = "../runtime/task.current.json"
)

if (!(Test-Path $TaskFile)) {
    Write-Host "MISS: Task file not found at $TaskFile"
    exit 1
}

$Task = Get-Content $TaskFile | ConvertFrom-Json
$ReportPath = "../task_scratch/state_report_$(Get-Date -Format yyyyMMdd_HHmmss).txt"

$Report = @(
    "State Prove Report",
    "Task ID: $($Task.task_id)",
    "Goal: $($Task.goal)",
    "Last Updated: $($Task.last_update)",
    "Next Action: $($Task.next_action)",
    "Completed Steps:",
    ($Task.done -join "`n    "),
    "---- End of Report ----"
)

$Report -join "`n" | Out-File -FilePath $ReportPath -Encoding UTF8

Write-Host "OK: Report saved to $ReportPath"