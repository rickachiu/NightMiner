# Night-Miner - Unified Installation and Management System
# One-stop solution for installing, configuring, and managing the NightMiner

param(
    [switch]$Silent
)

$ErrorActionPreference = "Stop"
$ScriptDir = $PSScriptRoot

# Configuration file to track installation state
$ConfigFile = Join-Path $ScriptDir "night-miner-config.json"

# Color functions
function Write-Success { param($Message) Write-Host $Message -ForegroundColor Green }
function Write-Info { param($Message) Write-Host $Message -ForegroundColor Cyan }
function Write-Warning { param($Message) Write-Host $Message -ForegroundColor Yellow }
function Write-Error { param($Message) Write-Host $Message -ForegroundColor Red }

# Load or create configuration
function Get-MinerConfig {
    if (Test-Path $ConfigFile) {
        return Get-Content $ConfigFile | ConvertFrom-Json
    }
    return @{
        Installed = $false
        Workers = 3
        VenvPath = ".venv"
        AutoStartEnabled = $false
    }
}

function Save-MinerConfig {
    param($Config)
    $Config | ConvertTo-Json | Set-Content $ConfigFile
}

# Check if miner is currently running
function Test-MinerRunning {
    $pythonProcesses = Get-Process python -ErrorAction SilentlyContinue
    if ($pythonProcesses) {
        foreach ($proc in $pythonProcesses) {
            $cmdLine = (Get-WmiObject Win32_Process -Filter "ProcessId=$($proc.Id)" -ErrorAction SilentlyContinue).CommandLine
            if ($cmdLine -like "*miner.py*") {
                return $true
            }
        }
    }
    return $false
}

# Display mining statistics
function Show-MiningStats {
    Write-Info "`n╔══════════════════════════════════════════════════════════╗"
    Write-Info "║              NIGHT MINER - Status Dashboard              ║"
    Write-Info "╚══════════════════════════════════════════════════════════╝"
    
    # Check if miner is running
    $isRunning = Test-MinerRunning
    
    if ($isRunning) {
        Write-Success "`nMiner Status: RUNNING"
        
        # Get process info
        $minerProcesses = @()
        $pythonProcesses = Get-Process python -ErrorAction SilentlyContinue
        foreach ($proc in $pythonProcesses) {
            $cmdLine = (Get-WmiObject Win32_Process -Filter "ProcessId=$($proc.Id)" -ErrorAction SilentlyContinue).CommandLine
            if ($cmdLine -like "*miner.py*") {
                $minerProcesses += $proc
            }
        }
        
        if ($minerProcesses.Count -gt 0) {
            $totalCPU = ($minerProcesses | Measure-Object -Property CPU -Sum).Sum
            $totalMemMB = ($minerProcesses | Measure-Object -Property WorkingSet64 -Sum).Sum / 1MB
            
            Write-Host "  Active Processes: $($minerProcesses.Count)" -ForegroundColor White
            Write-Host "  Total Memory: $([math]::Round($totalMemMB, 2)) MB" -ForegroundColor White
            Write-Host "  CPU Time: $([math]::Round($totalCPU, 2))s" -ForegroundColor White
        }
    } else {
        Write-Warning "`nMiner Status: NOT RUNNING"
    }
    
    # Mining Statistics
    if (Test-Path "solutions.csv") {
        $solutions = Import-Csv "solutions.csv"
        $solutionCount = $solutions.Count
        
        Write-Info "`n📊 Mining Statistics:"
        Write-Host "  Total Solutions: $solutionCount" -ForegroundColor White
        
        if ($solutionCount -gt 0) {
            $accepted = ($solutions | Where-Object { $_.status -eq "accepted" }).Count
            $rejected = ($solutions | Where-Object { $_.status -eq "rejected" }).Count
            
            Write-Success "    Accepted: $accepted"
            if ($rejected -gt 0) {
                Write-Error "    Rejected: $rejected"
            }
            
            # NIGHT estimates
            if ($accepted -gt 0) {
                $estimatedMin = [math]::Round($accepted * 0.1, 2)
                $estimatedMax = [math]::Round($accepted * 1.0, 2)
                Write-Host "`n  Estimated NIGHT: $estimatedMin - $estimatedMax" -ForegroundColor Yellow
                Write-Host "     (Actual rewards vary by difficulty)" -ForegroundColor DarkGray
            }
            
            # Per-wallet stats
            $walletStats = $solutions | Group-Object -Property wallet | Sort-Object Count -Descending
            
            if ($walletStats.Count -gt 0) {
                Write-Info "`nWallet Performance:"
                $count = 0
                foreach ($wallet in $walletStats) {
                    $count++
                    if ($count -le 5) {  # Show top 5 wallets
                        $walletSolutions = $wallet.Group
                        $walletAccepted = ($walletSolutions | Where-Object { $_.status -eq "accepted" }).Count
                        $walletRejected = ($walletSolutions | Where-Object { $_.status -eq "rejected" }).Count
                        
                        $shortAddr = $wallet.Name.Substring(0, [Math]::Min(20, $wallet.Name.Length)) + "..."
                        $walletEstMin = [math]::Round($walletAccepted * 0.1, 2)
                        $walletEstMax = [math]::Round($walletAccepted * 1.0, 2)
                        
                        Write-Host "  $shortAddr" -ForegroundColor White
                        Write-Host "    Solutions: $($walletSolutions.Count) | Accepted: $walletAccepted Rejected: $walletRejected | NIGHT: $walletEstMin-$walletEstMax" -ForegroundColor Gray
                    }
                }
            }
        }
    } else {
        Write-Info "`nMining Statistics: No solutions yet"
    }
    
    # Wallet count
    if (Test-Path "wallets.json") {
        $wallets = Get-Content "wallets.json" | ConvertFrom-Json
        Write-Host "`n  Total Wallets Created: $($wallets.Count)" -ForegroundColor Cyan
    }
}

# Main menu
function Show-Menu {
    param($Config)
    
    Clear-Host
    Show-MiningStats
    
    Write-Info "`n╔══════════════════════════════════════════════════════════╗"
    Write-Info "║                   CONTROL PANEL                          ║"
    Write-Info "╚══════════════════════════════════════════════════════════╝"
    
    $isRunning = Test-MinerRunning
    
    if ($isRunning) {
        Write-Host "`n  [1] Stop Miner" -ForegroundColor Yellow
    } else {
        Write-Host "`n  [1] Start Miner" -ForegroundColor Green
    }
    
    Write-Host "  [2] Refresh Status" -ForegroundColor Cyan
    Write-Host "  [3] Change Worker Count (Current: $($Config.Workers))" -ForegroundColor Cyan
    Write-Host "  [4] Backup Wallets" -ForegroundColor Magenta
    Write-Host "  [0] Exit" -ForegroundColor White
    
    Write-Host ""
}

# Installation wizard
function Start-Installation {
    Write-Info "`n╔══════════════════════════════════════════════════════════╗"
    Write-Info "║        NIGHT MINER - Installation Wizard                ║"
    Write-Info "╚══════════════════════════════════════════════════════════╝"
    
    Write-Host "`nThis will install everything needed to mine NIGHT tokens.`n"
    
    # Step 1: Check Git
    Write-Info "[1/5] Checking for Git..."
    $gitInstalled = Get-Command git -ErrorAction SilentlyContinue
    if (-not $gitInstalled) {
        Write-Warning "  Git is not installed."
        Write-Host "`n  Git is required to download and update the miner."
        Write-Host "  Please install Git from: https://git-scm.com/download/win"
        Write-Host "`n  After installing Git:"
        Write-Host "    1. Restart this computer"
        Write-Host "    2. Run this script again"
        Read-Host "`nPress Enter to exit"
        exit 1
    }
    Write-Success "  Git is installed"
    
    # Step 2: Install UV
    Write-Info "`n[2/5] Installing UV (fast package manager)..."
    $uvInstalled = Get-Command uv -ErrorAction SilentlyContinue
    if (-not $uvInstalled) {
        try {
            irm https://astral.sh/uv/install.ps1 | iex
            $env:Path = [System.Environment]::GetEnvironmentVariable('Path','Machine') + ';' + [System.Environment]::GetEnvironmentVariable('Path','User')
            Write-Success '  UV installed successfully'
        } catch {
            Write-Error "  ✗ Failed to install UV"
            Write-Host "  Error: $_"
            Read-Host "`nPress Enter to exit"
            exit 1
        }
    } else {
        Write-Success "  UV is already installed"
    }
    
    # Step 3: Setup Python environment
    Write-Info "`n[3/5] Setting up Python environment..."
    try {
        if (-not (Test-Path ".venv")) {
            & uv venv
            Write-Success "  ✓ Virtual environment created"
        } else {
            Write-Success "  ✓ Virtual environment already exists"
        }
        
        # Install dependencies
        Write-Info "  Installing dependencies (this may take a minute)..."
        & uv pip install -r requirements.txt
        Write-Success "  ✓ Dependencies installed"
        
        # Unblock PowerShell scripts
        Get-ChildItem *.ps1 -ErrorAction SilentlyContinue | Unblock-File
        
    } catch {
        Write-Error "  ✗ Failed to setup environment"
        Write-Host "  Error: $_"
        Read-Host "`nPress Enter to exit"
        exit 1
    }
    
    # Step 4: Configure workers
    Write-Info "`n[4/5] Configuring workers..."
    Write-Host ""
    Write-Host '  How many CPU cores does this system have?'
    Write-Host '  (Check Task Manager - Performance - CPU)'
    Write-Host ""
    
    $coreCount = Read-Host '  Enter number of cores (e.g. 2, 4, 8, 16)'
    
    Write-Host ""
    Write-Host '  Resource requirements per worker:'
    Write-Host '    CPU: ~1 core'
    Write-Host '    RAM: ~1 GB'
    Write-Host '    Hash Rate: ~800 H/s per worker'
    Write-Host ""
    
    Write-Host "  Recommendations based on $coreCount cores:"
    $recommended = [math]::Max(1, [math]::Floor($coreCount * 0.75))
    Write-Success "    Balanced 75pct CPU: $recommended workers"
    Write-Host "    Light 50pct CPU: $([math]::Max(1, [math]::Floor($coreCount * 0.5))) workers"
    Write-Host "    Maximum 100pct CPU: $coreCount workers"
    Write-Host ""
    
    $workers = Read-Host "  How many workers do you want? (Recommended: $recommended)"
    if ([string]::IsNullOrWhiteSpace($workers)) {
        $workers = $recommended
    }
    $workers = [int]$workers
    
    Write-Success "`n  ✓ Configured for $workers workers"
    
    # Step 5: Setup auto-start
    Write-Info "`n[5/5] Configuring auto-start on boot..."
    
    # Create PowerShell startup script
    $startupScript = @"
# NightMiner Auto-Start Script
Set-Location '$ScriptDir'
if (Test-Path '.venv\Scripts\python.exe') {
    Start-Process -FilePath '.venv\Scripts\python.exe' -ArgumentList 'miner.py --workers $workers' -WindowStyle Hidden
} else {
    Start-Process python -ArgumentList 'miner.py --workers $workers' -WindowStyle Hidden
}
"@
    
    $startupScriptPath = Join-Path $ScriptDir "start_miner_auto.ps1"
    $startupScript | Set-Content $startupScriptPath
    
    # Add to startup folder
    $startupFolder = [Environment]::GetFolderPath('Startup')
    $shortcutPath = Join-Path $startupFolder "NightMiner.lnk"
    
    $WshShell = New-Object -ComObject WScript.Shell
    $Shortcut = $WshShell.CreateShortcut($shortcutPath)
    $Shortcut.TargetPath = "powershell.exe"
    $Shortcut.Arguments = "-WindowStyle Hidden -ExecutionPolicy Bypass -File `"$startupScriptPath`""
    $Shortcut.WorkingDirectory = $ScriptDir
    $Shortcut.Description = "Night Miner - Auto Start ($workers workers)"
    $Shortcut.Save()
    
    Write-Success "  Auto-start enabled ($workers workers)"
    Write-Host "    Miner will start automatically on boot (hidden)`n"
    
    # Save configuration
    $config = @{
        Installed = $true
        Workers = $workers
        VenvPath = ".venv"
        AutoStartEnabled = $true
    }
    Save-MinerConfig $config
    
    # Installation complete
    Write-Info "`n╔══════════════════════════════════════════════════════════╗"
    Write-Success "║           ✓ Installation Complete!                      ║"
    Write-Info "╚══════════════════════════════════════════════════════════╝"
    
    Write-Host "`n  Your Night Miner is ready with:" -ForegroundColor White
    Write-Host "    • $workers workers configured" -ForegroundColor Cyan
    Write-Host "    • Auto-start on boot enabled" -ForegroundColor Cyan
    Write-Host "    • Running in silent background mode" -ForegroundColor Cyan
    
    Write-Host "`n  Starting miner now...`n"
    Start-Sleep -Seconds 2
    
    # Start the miner
    Start-Process -FilePath $vbsPath -WindowStyle Hidden
    Start-Sleep -Seconds 3
    
    return $config
}

# Start miner
function Start-Miner {
    param($Workers)
    
    # Use PowerShell to start the miner in background
    $pythonExe = if (Test-Path ".venv\Scripts\python.exe") { ".venv\Scripts\python.exe" } else { "python" }
    Start-Process -FilePath $pythonExe -ArgumentList "miner.py --workers $Workers" -WindowStyle Hidden
    
    Write-Success "`nMiner started with $Workers workers (hidden)"
    Start-Sleep -Seconds 2
}

# Stop miner
function Stop-Miner {
    & (Join-Path $ScriptDir "stop_miner.ps1")
    Write-Success "`nMiner stopped"
    Start-Sleep -Seconds 2
}

# Main execution
Clear-Host

# Check if already installed
$config = Get-MinerConfig

if (-not $config.Installed) {
    # Run installation
    $config = Start-Installation
}

# Main menu loop
while ($true) {
    Show-Menu -Config $config
    
    $choice = Read-Host "`nEnter your choice"
    
    switch ($choice) {
        "1" {
            if (Test-MinerRunning) {
                Stop-Miner
            } else {
                Start-Miner -Workers $config.Workers
            }
        }
        "2" {
            # Refresh (loop will redraw)
            continue
        }
        "3" {
            Write-Host "`nCurrent: $($config.Workers) workers"
            $newWorkers = Read-Host "Enter new worker count"
            if ($newWorkers -match '^\d+$' -and [int]$newWorkers -gt 0) {
                $config.Workers = [int]$newWorkers
                Save-MinerConfig $config
                
                # Recreate startup script with new worker count
                $startupScript = @"
# NightMiner Auto-Start Script
Set-Location '$ScriptDir'
if (Test-Path '.venv\Scripts\python.exe') {
    Start-Process -FilePath '.venv\Scripts\python.exe' -ArgumentList 'miner.py --workers $($config.Workers)' -WindowStyle Hidden
} else {
    Start-Process python -ArgumentList 'miner.py --workers $($config.Workers)' -WindowStyle Hidden
}
"@
                $startupScriptPath = Join-Path $ScriptDir "start_miner_auto.ps1"
                $startupScript | Set-Content $startupScriptPath
                
                Write-Success "`nWorker count updated to $($config.Workers)"
                Write-Warning "Restart miner for changes to take effect"
                Start-Sleep -Seconds 2
            }
        }
        "4" {
            if (Test-Path "wallets.json") {
                $backupName = "wallets_backup_$(Get-Date -Format 'yyyyMMdd_HHmmss').json"
                Copy-Item "wallets.json" $backupName
                Write-Success "`nWallets backed up to: $backupName"
                Start-Sleep -Seconds 2
            } else {
                Write-Warning "`nNo wallets file found"
                Start-Sleep -Seconds 2
            }
        }
        "0" {
            Write-Host "`nGoodbye! Your miner will continue running in the background.`n" -ForegroundColor Cyan
            exit 0
        }
        default {
            Write-Warning "`nInvalid choice. Please try again."
            Start-Sleep -Seconds 1
        }
    }
}
