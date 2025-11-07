@echo off
:MENU
cls
echo ========================================
echo    NightMiner - Installation Menu
echo ========================================
echo.
echo Choose an option:
echo.
echo   1. Fresh Install (Clone + Setup + Start)
echo   2. Update Existing Installation
echo   3. Just Install Dependencies (if already cloned)
echo   4. Start Mining (3 workers)
echo   5. Check Mining Status
echo   6. Stop Mining
echo   0. Exit
echo.
echo ========================================
set /p choice="Enter your choice (0-6): "

if "%choice%"=="0" goto END
if "%choice%"=="1" goto FRESH_INSTALL
if "%choice%"=="2" goto UPDATE
if "%choice%"=="3" goto INSTALL_DEPS
if "%choice%"=="4" goto START_MINING
if "%choice%"=="5" goto CHECK_STATUS
if "%choice%"=="6" goto STOP_MINING
echo Invalid choice! Please try again.
timeout /t 2 >nul
goto MENU

:FRESH_INSTALL
cls
echo ========================================
echo    Fresh Installation
echo ========================================
echo.
echo [1/5] Checking for Git...
where git >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    echo ERROR: Git is not installed!
    echo Please install Git from: https://git-scm.com/download/win
    pause
    goto MENU
)
echo     Git found!

echo.
echo [2/5] Cloning NightMiner repository...
if exist NightMiner (
    echo     Repository already exists! Use option 2 to update instead.
    pause
    goto MENU
)
git clone https://github.com/rickachiu/NightMiner.git
cd NightMiner

echo.
echo [3/5] Checking for UV...
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
if not exist NightMiner (
    echo ERROR: NightMiner folder not found!
    pause
    goto MENU
)
cd NightMiner
echo Starting miner with 3 workers (balanced mode)...
powershell -ExecutionPolicy Bypass -File run_miner_background.ps1
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
if not exist NightMiner (
    echo ERROR: NightMiner folder not found!
    pause
    goto MENU
)
cd NightMiner
powershell -ExecutionPolicy Bypass -File check_miner_status.ps1
echo.
pause
goto MENU

:STOP_MINING
cls
echo ========================================
echo    Stopping Mining
echo ========================================
echo.
if not exist NightMiner (
    echo ERROR: NightMiner folder not found!
    pause
    goto MENU
)
cd NightMiner
powershell -ExecutionPolicy Bypass -File stop_miner.ps1
echo.
echo Mining stopped!
pause
goto MENU

:END
echo.
echo Goodbye!
timeout /t 1 >nul
exit
