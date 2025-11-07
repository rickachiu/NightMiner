@echo off
:MENU
cls
echo ========================================
echo    NightMiner - Installation Menu
echo ========================================
echo.
echo Choose an option:
echo.
echo   1. Clone from GitHub (git clone)
echo   2. Fresh Install (Setup + Start)
echo   3. Update Existing Installation
echo   4. Just Install Dependencies
echo   5. Start Mining (3 workers)
echo   6. Check Mining Status
echo   7. Stop Mining
echo   0. Exit
echo.
echo ========================================
set /p choice="Enter your choice (0-7): "

if "%choice%"=="0" goto END
if "%choice%"=="1" goto CLONE_REPO
if "%choice%"=="2" goto FRESH_INSTALL
if "%choice%"=="3" goto UPDATE
if "%choice%"=="4" goto INSTALL_DEPS
if "%choice%"=="5" goto START_MINING
if "%choice%"=="6" goto CHECK_STATUS
if "%choice%"=="7" goto STOP_MINING
echo Invalid choice! Please try again.
timeout /t 2 >nul
goto MENU

:CLONE_REPO
cls
echo ========================================
echo    Clone from GitHub
echo ========================================
echo.
echo Checking for Git...
where git >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    echo ERROR: Git is not installed!
    echo Please install Git from: https://git-scm.com/download/win
    pause
    goto MENU
)
echo Git found!

echo.
if exist NightMiner (
    echo WARNING: NightMiner folder already exists!
    echo Please delete it first or use option 3 to update.
    pause
    goto MENU
)

echo Cloning NightMiner repository from GitHub...
git clone https://github.com/rickachiu/NightMiner.git
echo.
if exist NightMiner (
    echo Clone successful!
    echo.
    echo Next steps:
    echo   - Run option 2 (Fresh Install) to setup and start
    echo   - Or run option 4 (Just Install Dependencies)
) else (
    echo Clone failed! Please check your internet connection.
)
echo.
pause
goto MENU

:FRESH_INSTALL
cls
echo ========================================
echo    Fresh Installation (Setup + Start)
echo ========================================
echo.
if not exist NightMiner (
    echo ERROR: NightMiner folder not found!
    echo Please run option 1 (Clone from GitHub) first.
    pause
    goto MENU
)
cd NightMiner

echo [1/5] Unblocking PowerShell scripts...
powershell -ExecutionPolicy Bypass -Command "Set-ExecutionPolicy RemoteSigned -Scope CurrentUser -Force; Get-ChildItem *.ps1 -ErrorAction SilentlyContinue | Unblock-File"
echo     Scripts unblocked!

echo.
echo [2/5] Checking for UV...
where uv >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    echo     UV not found, installing...
    powershell -ExecutionPolicy Bypass -Command "irm https://astral.sh/uv/install.ps1 | iex"
    echo     Please close and reopen this window to refresh PATH, then run option 3.
    pause
    goto MENU
) else (
    echo     UV already installed!
)

echo.
echo [3/5] Installing Python and dependencies...
powershell -ExecutionPolicy Bypass -Command "$env:Path = [System.Environment]::GetEnvironmentVariable('Path','Machine') + ';' + [System.Environment]::GetEnvironmentVariable('Path','User'); uv python install 3.13; uv pip install --system -r requirements.txt"

echo.
echo [4/5] Starting miner in background...
powershell -ExecutionPolicy Bypass -File run_miner_background.ps1

echo.
echo ========================================
echo    Installation Complete!
echo ========================================
echo.
pause
goto MENU

:UPDATE
cls
echo ========================================
echo    Updating Installation
echo ========================================
echo.
if not exist NightMiner (
    echo ERROR: NightMiner folder not found!
    echo Please run Fresh Install first (option 1).
    pause
    goto MENU
)
cd NightMiner
echo Pulling latest updates from GitHub...
git pull
echo.
echo Update complete!
pause
goto MENU

:INSTALL_DEPS
cls
echo ========================================
echo    Installing Dependencies
echo ========================================
echo.
if not exist NightMiner (
    echo ERROR: NightMiner folder not found!
    echo Please run Fresh Install first (option 1).
    pause
    goto MENU
)
cd NightMiner

echo Checking for UV...
where uv >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    echo UV not found, installing...
    powershell -ExecutionPolicy Bypass -Command "irm https://astral.sh/uv/install.ps1 | iex"
    echo.
    echo UV installed! Please close and reopen this window, then try again.
    pause
    goto MENU
)

echo Installing Python and dependencies...
powershell -ExecutionPolicy Bypass -Command "$env:Path = [System.Environment]::GetEnvironmentVariable('Path','Machine') + ';' + [System.Environment]::GetEnvironmentVariable('Path','User'); uv python install 3.13; uv pip install --system -r requirements.txt"
echo.
echo Dependencies installed!
pause
goto MENU

:START_MINING
cls
echo ========================================
echo    Starting Mining
echo ========================================
echo.
if exist NightMiner (
    cd NightMiner
    echo Starting miner with 3 workers (balanced mode)...
    powershell -ExecutionPolicy Bypass -File run_miner_background.ps1
    cd ..
) else if exist run_miner_background.ps1 (
    echo Starting miner with 3 workers (balanced mode)...
    powershell -ExecutionPolicy Bypass -File run_miner_background.ps1
) else (
    echo ERROR: Cannot find run_miner_background.ps1
    echo Please ensure you're in the correct directory.
)
echo.
echo Miner started!
pause
goto MENU

:CHECK_STATUS
cls
echo ========================================
echo    Mining Status
echo ========================================
echo.
if exist NightMiner (
    cd NightMiner
    powershell -ExecutionPolicy Bypass -File check_miner_status.ps1
    cd ..
) else if exist check_miner_status.ps1 (
    powershell -ExecutionPolicy Bypass -File check_miner_status.ps1
) else (
    echo ERROR: Cannot find check_miner_status.ps1
    echo Please ensure you're in the correct directory.
)
echo.
pause
goto MENU

:STOP_MINING
cls
echo ========================================
echo    Stopping Mining
echo ========================================
echo.
if exist NightMiner (
    cd NightMiner
    powershell -ExecutionPolicy Bypass -File stop_miner.ps1
    cd ..
) else if exist stop_miner.ps1 (
    powershell -ExecutionPolicy Bypass -File stop_miner.ps1
) else (
    echo ERROR: Cannot find stop_miner.ps1
    echo Please ensure you're in the correct directory.
)
echo.
echo Mining stopped!
pause
goto MENU

:END
echo.
echo Goodbye!
timeout /t 1 >nul
exit
