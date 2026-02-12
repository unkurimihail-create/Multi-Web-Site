@echo off
setlocal

set SCRIPT_DIR=%~dp0
powershell -NoLogo -ExecutionPolicy Bypass -File "%SCRIPT_DIR%windows-terminal.ps1"

endlocal
