@echo off
echo ========================================
echo    NightMiner - One-Click Installer
echo ========================================
echo.
echo This will automatically:
echo   1. Install UV (fast package manager)
echo   2. Install Python 3.13
echo   3. Install all dependencies
echo   4. Start mining with 3 workers
echo.
pause

echo.
echo [1/5] Checking for Git...
where git >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    echo ERROR: Git is not installed!
    echo Please install Git from: https://git-scm.com/download/win
    pause
    exit /b 1
)
echo     Git found!

echo.
echo [2/5] Cloning NightMiner repository...
if exist NightMiner (
    echo     Repository already exists, updating...
    cd NightMiner
    git pull
) else (
    git clone https://github.com/rickachiu/NightMiner.git
    cd NightMiner
)

echo.
echo [3/5] Installing UV...
powershell -ExecutionPolicy Bypass -Command "irm https://astral.sh/uv/install.ps1 | iex"

echo.
echo [4/5] Installing Python and dependencies...
powershell -ExecutionPolicy Bypass -Command "$env:Path = [System.Environment]::GetEnvironmentVariable('Path','Machine') + ';' + [System.Environment]::GetEnvironmentVariable('Path','User'); uv python install 3.13; uv pip install --system -r requirements.txt"

echo.
echo [5/5] Starting miner in background...
powershell -ExecutionPolicy Bypass -File run_miner_background.ps1

echo.
echo ========================================
echo    Installation Complete!
echo ========================================
echo.
echo Miner is now running with 3 workers in the background.
echo.
echo To check status: run check_miner_status.ps1
echo To stop mining: run stop_miner.ps1
echo.
pause
