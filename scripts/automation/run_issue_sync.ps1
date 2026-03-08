Set-Location -Path "C:\workspace\angela-skills-quest"
python .\scripts\automation\sync_issue_queue.py | Out-Default
Write-Host "Sync completed successfully."