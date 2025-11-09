# NightMiner - One-Line Setup Script
# Usage: iex (irm https://raw.githubusercontent.com/rickachiu/NightMiner/main/SETUP.ps1)

$ErrorActionPreference = "Continue"

# This script is designed to be run with: iex (irm URL)
# Not: irm URL | iex (which doesn't support Read-Host properly)

Write-Host "`n╔══════════════════════════════════════════════════════════╗" -ForegroundColor Cyan
Write-Host "║           NIGHT MINER - One-Line Installer               ║" -ForegroundColor Cyan
Write-Host "╚══════════════════════════════════════════════════════════╝`n" -ForegroundColor Cyan

# Check if Git is installed
Write-Host "[1/6] Checking for Git..." -ForegroundColor Cyan
$gitInstalled = Get-Command git -ErrorAction SilentlyContinue
if (-not $gitInstalled) {
    Write-Host "  ✗ Git is not installed." -ForegroundColor Red
    Write-Host "`n  Please install Git first:" -ForegroundColor Yellow
    Write-Host "    1. Download: https://git-scm.com/download/win" -ForegroundColor White
    Write-Host "    2. Install with default settings" -ForegroundColor White
    Write-Host "    3. Restart PowerShell (close and reopen)" -ForegroundColor White
    Write-Host "    4. Run this command again:`n" -ForegroundColor White
    Write-Host "       iex (irm https://raw.githubusercontent.com/rickachiu/NightMiner/main/SETUP.ps1)`n" -ForegroundColor Cyan
    Read-Host "Press Enter to open Git download page"
    Start-Process "https://git-scm.com/download/win"
    return
}
Write-Host "  ✓ Git is installed" -ForegroundColor Green

# Clone or update repository
Write-Host "`n[2/6] Getting NightMiner..." -ForegroundColor Cyan
if (Test-Path "NightMiner") {
    Write-Host "  Updating existing installation..." -ForegroundColor Yellow
    Set-Location NightMiner
    & git pull
} else {
    & git clone https://github.com/rickachiu/NightMiner.git
    Set-Location NightMiner
}
Write-Host "  ✓ NightMiner downloaded" -ForegroundColor Green

# Install UV
Write-Host "`n[3/6] Installing UV (fast package manager)..." -ForegroundColor Cyan
$uvInstalled = Get-Command uv -ErrorAction SilentlyContinue
if (-not $uvInstalled) {
    irm https://astral.sh/uv/install.ps1 | iex
    $env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")
    Write-Host "  ✓ UV installed" -ForegroundColor Green
} else {
    Write-Host "  ✓ UV already installed" -ForegroundColor Green
}

# Setup Python environment
Write-Host "`n[4/6] Setting up Python environment..." -ForegroundColor Cyan
if (-not (Test-Path ".venv")) {
    & uv venv
    Write-Host "  ✓ Virtual environment created" -ForegroundColor Green
} else {
    Write-Host "  ✓ Virtual environment exists" -ForegroundColor Green
}

# Install dependencies
Write-Host "`n[5/6] Installing dependencies..." -ForegroundColor Cyan
& uv pip install -r requirements.txt
Write-Host "  ✓ Dependencies installed" -ForegroundColor Green

# Configure workers
Write-Host "`n[6/6] Configuring workers..." -ForegroundColor Cyan
$coreCount = (Get-WmiObject Win32_ComputerSystem).NumberOfLogicalProcessors
$recommended = [math]::Max(1, [math]::Floor($coreCount * 0.75))

Write-Host "`n  Detected $coreCount CPU cores" -ForegroundColor White
Write-Host "  Recommended workers: $recommended (75% of CPU)" -ForegroundColor White
Write-Host "`n  Worker count options:" -ForegroundColor Yellow
Write-Host "    • Light (50%):   $([math]::Max(1, [math]::Floor($coreCount * 0.5))) workers" -ForegroundColor White
Write-Host "    • Balanced (75%): $recommended workers (recommended)" -ForegroundColor Green
Write-Host "    • Maximum (100%): $coreCount workers" -ForegroundColor White

$workers = Read-Host "`n  How many workers? [default: $recommended]"
if ([string]::IsNullOrWhiteSpace($workers)) {
    $workers = $recommended
}
$workers = [int]$workers

Write-Host "  ✓ Configured for $workers workers" -ForegroundColor Green

# Create auto-start script
$startScript = @"
@echo off
cd /d "%~dp0"
if exist .venv\Scripts\python.exe (
    .venv\Scripts\python.exe miner.py --workers $workers
) else (
    python miner.py --workers $workers
)
"@
$startScript | Set-Content "start_miner.bat"

# Ask about auto-start (default YES)
Write-Host "`n  Enable auto-start on Windows boot? (Y/n) [default: Y]: " -ForegroundColor Cyan -NoNewline
$autoStart = Read-Host
if ([string]::IsNullOrWhiteSpace($autoStart)) {
    $autoStart = 'Y'
}

if ($autoStart -ne 'n' -and $autoStart -ne 'N') {
    $startupFolder = [Environment]::GetFolderPath('Startup')
    $shortcutPath = Join-Path $startupFolder "NightMiner.lnk"
    
    $WshShell = New-Object -ComObject WScript.Shell
    $Shortcut = $WshShell.CreateShortcut($shortcutPath)
    $Shortcut.TargetPath = (Join-Path $PWD "start_miner.bat")
    $Shortcut.WorkingDirectory = $PWD
    $Shortcut.Description = "Night Miner - Auto Start ($workers workers)"
    $Shortcut.Save()
    
    Write-Host "  ✓ Auto-start enabled (starts on boot)" -ForegroundColor Green
} else {
    Write-Host "  ○ Auto-start disabled" -ForegroundColor Yellow
}

# Installation complete
Write-Host "`n╔══════════════════════════════════════════════════════════╗" -ForegroundColor Green
Write-Host "║              ✓ Installation Complete!                   ║" -ForegroundColor Green
Write-Host "╚══════════════════════════════════════════════════════════╝" -ForegroundColor Green

Write-Host "`n  📊 Your NightMiner is configured with:" -ForegroundColor White
Write-Host "    • $workers workers" -ForegroundColor Cyan
Write-Host "    • Auto-start: $(if ($autoStart -ne 'n' -and $autoStart -ne 'N') {'Enabled'} else {'Disabled'})" -ForegroundColor Cyan

Write-Host "`n  🚀 Starting miner now..." -ForegroundColor Yellow
Start-Process -FilePath (Join-Path $PWD "start_miner.bat") -WindowStyle Hidden
Start-Sleep -Seconds 2

Write-Host "`n  ✓ Miner is running in background!" -ForegroundColor Green
Write-Host "     (Mining ends Nov 21, 2025 - airdrop cutoff)" -ForegroundColor Yellow
Write-Host "`n  📊 How to Monitor Your Mining:" -ForegroundColor White
Write-Host "`n    PRIMARY - Interactive Dashboard (Recommended):" -ForegroundColor Green
Write-Host "      .\Night-Miner.ps1" -ForegroundColor Cyan
Write-Host "      or" -ForegroundColor White
Write-Host "      python miner.py --workers $workers" -ForegroundColor Cyan
Write-Host "      → Shows live stats, hash rates, NIGHT earned" -ForegroundColor White
Write-Host "      → Real-time updates every 5 seconds" -ForegroundColor White
Write-Host "      → Press Ctrl+C to stop" -ForegroundColor White

Write-Host "`n    SECONDARY - Quick Status Check:" -ForegroundColor Yellow
Write-Host "      .\check_miner_status.ps1" -ForegroundColor Cyan
Write-Host "      → Quick peek when running in background" -ForegroundColor White

Write-Host "`n  🔧 Other Useful Commands:" -ForegroundColor White
Write-Host "    • Stop miner:    .\stop_miner.ps1" -ForegroundColor Cyan
Write-Host "    • Backup wallet: Copy-Item wallets.json backup.json" -ForegroundColor Cyan
Write-Host "    • Update:        git pull" -ForegroundColor Cyan

Write-Host "`n  🌙 Happy mining!" -ForegroundColor Yellow
Write-Host "`nSetup complete! The miner is running in the background." -ForegroundColor Green
Write-Host "You are now in the NightMiner directory." -ForegroundColor White
Write-Host ""
