# Check Wallet Validity - Test all wallets against Midnight Network API
# Run this on each machine to find invalid wallets

$ErrorActionPreference = "Continue"

Write-Host "`n╔══════════════════════════════════════════════════════════╗" -ForegroundColor Cyan
Write-Host "║            WALLET VALIDITY CHECKER                       ║" -ForegroundColor Cyan
Write-Host "╚══════════════════════════════════════════════════════════╝`n" -ForegroundColor Cyan

# Check if wallets.json exists
if (-not (Test-Path "wallets.json")) {
    Write-Host "ERROR: wallets.json not found!" -ForegroundColor Red
    Write-Host "Make sure you run this script in the NightMiner directory" -ForegroundColor Yellow
    exit 1
}

# Load wallets
$wallets = Get-Content wallets.json | ConvertFrom-Json
Write-Host "Found $($wallets.Count) wallets to test`n" -ForegroundColor Cyan

# Test each wallet
$results = @()
$validCount = 0
$invalidCount = 0
$totalNight = 0.0

for ($i = 0; $i -lt $wallets.Count; $i++) {
    $wallet = $wallets[$i]
    $shortAddr = $wallet.address.Substring(0, 20) + "..."
    
    Write-Host "[$($i+1)/$($wallets.Count)] Testing $shortAddr..." -NoNewline
    
    try {
        $response = Invoke-RestMethod -Uri "https://scavenger.prod.gd.midnighttge.io/statistics/$($wallet.address)" -Method Get -TimeoutSec 5 -ErrorAction Stop
        $night = $response.local.night_allocation / 1000000.0
        $totalNight += $night
        $validCount++
        
        Write-Host " OK" -ForegroundColor Green
        
        $results += [PSCustomObject]@{
            Index = $i + 1
            Address = $wallet.address
            ShortAddr = $shortAddr
            Status = "VALID"
            NIGHT = $night
            Error = ""
        }
    } catch {
        $invalidCount++
        $errorMsg = $_.Exception.Message
        
        Write-Host " INVALID" -ForegroundColor Red
        
        $results += [PSCustomObject]@{
            Index = $i + 1
            Address = $wallet.address
            ShortAddr = $shortAddr
            Status = "INVALID"
            NIGHT = 0
            Error = $errorMsg
        }
    }
    
    Start-Sleep -Milliseconds 200  # Be nice to the API
}

# Display summary
Write-Host "`n╔══════════════════════════════════════════════════════════╗" -ForegroundColor Cyan
Write-Host "║                    SUMMARY                               ║" -ForegroundColor Cyan
Write-Host "╚══════════════════════════════════════════════════════════╝`n" -ForegroundColor Cyan

Write-Host "Total Wallets:   $($wallets.Count)" -ForegroundColor White
Write-Host "Valid Wallets:   $validCount" -ForegroundColor Green
Write-Host "Invalid Wallets: $invalidCount" -ForegroundColor $(if ($invalidCount -eq 0) {'Green'} else {'Red'})
Write-Host "Total NIGHT:     $([math]::Round($totalNight, 2))" -ForegroundColor Cyan

# Show invalid wallets if any
if ($invalidCount -gt 0) {
    Write-Host "`n╔══════════════════════════════════════════════════════════╗" -ForegroundColor Red
    Write-Host "║              INVALID WALLETS FOUND!                      ║" -ForegroundColor Red
    Write-Host "╚══════════════════════════════════════════════════════════╝`n" -ForegroundColor Red
    
    $invalidWallets = $results | Where-Object { $_.Status -eq "INVALID" }
    
    Write-Host "Invalid wallet details:" -ForegroundColor Yellow
    $invalidWallets | Format-Table Index, ShortAddr, Error -AutoSize
    
    Write-Host "`nTo remove invalid wallets automatically, run:" -ForegroundColor Cyan
    Write-Host "  .\remove_invalid_wallets.ps1" -ForegroundColor White
    
    # Save invalid wallet list for removal script
    $invalidWallets | Select-Object Index, Address | ConvertTo-Json | Set-Content "invalid_wallets.json"
    Write-Host "`nInvalid wallet list saved to: invalid_wallets.json" -ForegroundColor Gray
} else {
    Write-Host "`n✓ All wallets are valid and working!" -ForegroundColor Green
}

Write-Host ""
