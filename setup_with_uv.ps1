# NightMiner - Fast Setup with UV
# This script automatically installs everything needed using UV (blazingly fast!)

Write-Host "`n=== NightMiner Fast Setup with UV ===" -ForegroundColor Cyan
Write-Host "This will install UV, Python, and all dependencies`n" -ForegroundColor Yellow

# Check if uv is already installed
$uvInstalled = Get-Command uv -ErrorAction SilentlyContinue

if (-not $uvInstalled) {
    Write-Host "[1/4] Installing UV (Rust-powered package installer)..." -ForegroundColor Green
    try {
        irm https://astral.sh/uv/install.ps1 | iex
        
        # Refresh environment variables
        $env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")
        
        Write-Host "✓ UV installed successfully!`n" -ForegroundColor Green
    } catch {
        Write-Host "✗ Failed to install UV. Please install manually from: https://docs.astral.sh/uv/" -ForegroundColor Red
        exit 1
    }
} else {
    Write-Host "[1/4] UV already installed ✓`n" -ForegroundColor Green
}

# Install Python using uv
Write-Host "[2/4] Installing Python 3.13 via UV..." -ForegroundColor Green
try {
    uv python install 3.13
    Write-Host "✓ Python 3.13 installed!`n" -ForegroundColor Green
} catch {
    Write-Host "! Python may already be installed, continuing...`n" -ForegroundColor Yellow
}

# Install dependencies using uv
Write-Host "[3/4] Installing dependencies (FAST with UV)..." -ForegroundColor Green
try {
    uv pip install -r requirements.txt
    Write-Host "✓ All dependencies installed!`n" -ForegroundColor Green
} catch {
    Write-Host "✗ Failed to install dependencies" -ForegroundColor Red
    exit 1
}

# Verify installation
Write-Host "[4/4] Verifying installation..." -ForegroundColor Green
$pythonVersion = python --version 2>&1
Write-Host "Python: $pythonVersion" -ForegroundColor Cyan

# Check if required packages are installed
$packages = @("pycardano", "wasmtime", "requests", "cbor2", "portalocker")
$allInstalled = $true
foreach ($pkg in $packages) {
    $check = uv pip list | Select-String -Pattern $pkg
    if ($check) {
        Write-Host "✓ $pkg installed" -ForegroundColor Green
    } else {
        Write-Host "✗ $pkg NOT installed" -ForegroundColor Red
        $allInstalled = $false
    }
}

Write-Host "`n=== Setup Complete! ===" -ForegroundColor Cyan

if ($allInstalled) {
    Write-Host "`n✓ NightMiner is ready to run!" -ForegroundColor Green
    Write-Host "`nTo start mining with 16 workers (hidden):" -ForegroundColor Yellow
    Write-Host "  • Double-click: run_miner_hidden.vbs" -ForegroundColor White
    Write-Host "  • Or run: .\run_miner_background.ps1" -ForegroundColor White
    Write-Host "`nTo check status: .\check_miner_status.ps1" -ForegroundColor White
    Write-Host "To stop mining: .\stop_miner.ps1" -ForegroundColor White
} else {
    Write-Host "`n✗ Some packages failed to install. Please check errors above." -ForegroundColor Red
}

Write-Host "`n==============================================`n" -ForegroundColor Cyan
