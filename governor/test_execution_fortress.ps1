# Test Execution Fortress Script

# Verify required files
$files = @(
    "C:\workspace\angela-skills-quest\governor\Execution-Fortress-v2.md",
    "C:\workspace\angela-skills-quest\governor\execution-response-template.md",
    "C:\workspace\angela-skills-quest\governor\test_execution_fortress.ps1",
    "C:\workspace\angela-skills-quest\governor\APPLY-MANUALLY.md"
)

$missingFiles = @()
foreach ($file in $files) {
    if (-Not (Test-Path -Path $file)) {
        $missingFiles += $file
    }
}

if ($missingFiles.Count -gt 0) {
    Write-Output "PARTIAL: Missing files: $($missingFiles -join ', ')"
} else {
    Write-Output "PASS: All required files exist."
}