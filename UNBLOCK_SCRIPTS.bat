@echo off
echo ========================================
echo    Unblocking PowerShell Scripts
echo ========================================
echo.
echo This will allow PowerShell scripts to run on this machine.
echo.
pause

echo Setting execution policy...
powershell -Command "Set-ExecutionPolicy RemoteSigned -Scope CurrentUser -Force"

echo.
echo Unblocking all .ps1 files in this folder...
powershell -Command "Get-ChildItem *.ps1 | Unblock-File"

echo.
echo ========================================
echo    Scripts Unblocked!
echo ========================================
echo.
echo You can now run PowerShell scripts normally.
echo.
pause
