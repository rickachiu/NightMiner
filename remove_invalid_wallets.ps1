# Remove Invalid Wallets - Automatically removes wallets that failed validation
# Run this AFTER running check_wallet_validity.ps1

$ErrorActionPreference = "Stop"

Write-Host "`n╔══════════════════════════════════════════════════════════╗" -ForegroundColor Yellow
Write-Host "║           REMOVE INVALID WALLETS                         ║" -ForegroundColor Yellow
Write-Host "╚══════════════════════════════════════════════════════════╝`n" -ForegroundColor Yellow

# Check if invalid_wallets.json exists
if (-not (Test-Path "invalid_wallets.json")) {
    Write-Host "ERROR: invalid_wallets.json not found!" -ForegroundColor Red
    Write-Host "Please run check_wallet_validity.ps1 first" -ForegroundColor Yellow
    exit 1
}

# Load invalid wallets list
$invalidWallets = Get-Content "invalid_wallets.json" | ConvertFrom-Json

if ($invalidWallets.Count -eq 0) {
    Write-Host "No invalid wallets to remove!" -ForegroundColor Green
    exit 0
}

Write-Host "Found $($invalidWallets.Count) invalid wallet(s) to remove:" -ForegroundColor Yellow
$invalidWallets | ForEach-Object {
    Write-Host "  - Wallet #$($_.Index): $($_.Address.Substring(0,30))..." -ForegroundColor Red
}

# Ask for confirmation
Write-Host "`nWARNING: This will modify wallets.json" -ForegroundColor Yellow
$confirm = Read-Host "Continue? (Y/n)"
if ($confirm -eq 'n' -or $confirm -eq 'N') {
    Write-Host "Cancelled" -ForegroundColor Yellow
    exit 0
}

# Create backup
$backupName = "wallets_backup_$(Get-Date -Format 'yyyyMMdd_HHmmss').json"
Copy-Item wallets.json $backupName
Write-Host "`nBackup created: $backupName" -ForegroundColor Green

# Load wallets
$wallets = Get-Content wallets.json | ConvertFrom-Json
$walletList = [System.Collections.ArrayList]@($wallets)

Write-Host "Before: $($walletList.Count) wallets" -ForegroundColor Cyan

# Remove invalid wallets (in reverse order to maintain indices)
$invalidAddresses = $invalidWallets | Select-Object -ExpandProperty Address
$removed = 0

for ($i = $walletList.Count - 1; $i -ge 0; $i--) {
    if ($invalidAddresses -contains $walletList[$i].address) {
        Write-Host "Removing wallet: $($walletList[$i].address.Substring(0,30))..." -ForegroundColor Yellow
        $walletList.RemoveAt($i)
        $removed++
    }
}

Write-Host "After: $($walletList.Count) wallets" -ForegroundColor Cyan
Write-Host "Removed: $removed wallet(s)" -ForegroundColor Green

# Save updated wallets.json
$walletList | ConvertTo-Json -Depth 10 | Set-Content wallets.json

Write-Host "`n✓ Invalid wallets removed successfully!" -ForegroundColor Green
Write-Host "Backup saved as: $backupName" -ForegroundColor Gray

# Clean up
Remove-Item "invalid_wallets.json" -ErrorAction SilentlyContinue

Write-Host "`nYou should now restart your miner for changes to take effect." -ForegroundColor Cyan
Write-Host ""
