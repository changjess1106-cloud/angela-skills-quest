@echo off
:: Proof task state with fallback logic
powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\prove_state.ps1
if %ERRORLEVEL% NEQ 0 (
    echo "Falling back to Python..."
    python prove_state.py
)
