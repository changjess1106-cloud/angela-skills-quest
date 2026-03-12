Write-Host "VERIFY OPENCLAW PATHS"
Test-Path "C:\Users\owner11\.openclaw\"
Test-Path "C:\workspace\angela-skills-quest\"
Test-Path "C:\Users\owner11\AppData\Roaming\npm\node_modules\openclaw\"
Test-Path "C:\Users\owner11\AppData\Roaming\npm\node_modules\openclaw\openclaw.mjs"
Test-Path "C:\Users\owner11\AppData\Roaming\npm\openclaw.cmd"
Get-Command node -ErrorAction SilentlyContinue
Get-Command powershell -ErrorAction SilentlyContinue
