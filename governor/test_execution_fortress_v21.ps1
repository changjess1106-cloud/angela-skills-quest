$smokeTestPath = "C:\workspace\angela-skills-quest\governor\v21-smoke-test.txt"

# Verify file existence
$fileExists = Test-Path $smokeTestPath

# Verify file content
if ($fileExists) {
    $fileContent = Get-Content $smokeTestPath -Raw
    $expectedContent = "alpha one`nbeta two`ngamma three"
    $contentMatch = ($fileContent -eq $expectedContent)
} else {
    $contentMatch = $false
}

# Final judgment
if ($fileExists -and $contentMatch) {
    Write-Output "PASS"
} elseif ($fileExists -or $contentMatch) {
    Write-Output "PARTIAL"
} else {
    Write-Output "FAIL"
}