# Check if MidnightMiner is running and show stats
$pythonProcesses = Get-Process python -ErrorAction SilentlyContinue
$minerProcesses = @()

if ($pythonProcesses) {
    foreach ($proc in $pythonProcesses) {
        $cmdLine = (Get-WmiObject Win32_Process -Filter "ProcessId=$($proc.Id)" -ErrorAction SilentlyContinue).CommandLine
        if ($cmdLine -like "*miner.py*") {
            $minerProcesses += $proc
        }
    }
}

Write-Host "`n=== MidnightMiner Status ===" -ForegroundColor Cyan

if ($minerProcesses.Count -gt 0) {
    Write-Host "Status: RUNNING" -ForegroundColor Green
    Write-Host "Active Processes: $($minerProcesses.Count)" -ForegroundColor White
    
    $totalCPU = ($minerProcesses | Measure-Object -Property CPU -Sum).Sum
    $totalMemMB = ($minerProcesses | Measure-Object -Property WorkingSet64 -Sum).Sum / 1MB
    
    Write-Host "Total CPU Time: $([math]::Round($totalCPU, 2))s" -ForegroundColor White
    Write-Host "Total Memory: $([math]::Round($totalMemMB, 2)) MB" -ForegroundColor White
    
    if ($minerProcesses[0].StartTime) {
        Write-Host "Started: $($minerProcesses[0].StartTime)" -ForegroundColor White
    }
}
else {
    Write-Host "Status: NOT RUNNING" -ForegroundColor Red
}

# Mining Statistics
Write-Host "`n=== Mining Statistics ===" -ForegroundColor Cyan

# Check solutions
if (Test-Path "solutions.csv") {
    $solutions = Import-Csv "solutions.csv"
    $solutionCount = $solutions.Count
    Write-Host "Total Solutions Submitted: $solutionCount" -ForegroundColor Green
    
    if ($solutionCount -gt 0) {
        # Count accepted vs rejected
        $accepted = ($solutions | Where-Object { $_.status -eq "accepted" }).Count
        $rejected = ($solutions | Where-Object { $_.status -eq "rejected" }).Count
        $pending = $solutionCount - $accepted - $rejected
        
        Write-Host "  Accepted: $accepted" -ForegroundColor Green
        if ($rejected -gt 0) {
            Write-Host "  Rejected: $rejected" -ForegroundColor Red
        }
        if ($pending -gt 0) {
            Write-Host "  Pending: $pending" -ForegroundColor Yellow
        }
        
        $lastSolution = $solutions[-1]
        Write-Host "`nLast Solution: $($lastSolution.timestamp)" -ForegroundColor White
        Write-Host "Last Challenge: $($lastSolution.challenge)" -ForegroundColor White
        Write-Host "Last Status: $($lastSolution.status)" -ForegroundColor $(if ($lastSolution.status -eq "accepted") { "Green" } elseif ($lastSolution.status -eq "rejected") { "Red" } else { "Yellow" })
    }
    
    # Estimate NIGHT tokens (based on accepted solutions only)
    # Typical rewards range from 0.1 to 1 NIGHT per solution
    if ($accepted -gt 0) {
        $estimatedMin = [math]::Round($accepted * 0.1, 2)
        $estimatedMax = [math]::Round($accepted * 1.0, 2)
        Write-Host "`nEstimated NIGHT*: $estimatedMin - $estimatedMax" -ForegroundColor Yellow
    } else {
        Write-Host "`nEstimated NIGHT*: 0.00 (no accepted solutions yet)" -ForegroundColor Yellow
    }
    Write-Host "*Actual rewards vary by challenge difficulty and network conditions" -ForegroundColor DarkGray
    Write-Host "*Balances update every 24h on Midnight Network" -ForegroundColor DarkGray
    
    # Per-wallet breakdown
    Write-Host "`n=== Per-Wallet Statistics ===" -ForegroundColor Cyan
    $walletStats = $solutions | Group-Object -Property wallet | Sort-Object Count -Descending
    
    foreach ($wallet in $walletStats) {
        $walletAddr = $wallet.Name
        $walletSolutions = $wallet.Group
        $walletAccepted = ($walletSolutions | Where-Object { $_.status -eq "accepted" }).Count
        $walletRejected = ($walletSolutions | Where-Object { $_.status -eq "rejected" }).Count
        $walletPending = $walletSolutions.Count - $walletAccepted - $walletRejected
        
        # Truncate address for display
        $shortAddr = $walletAddr.Substring(0, [Math]::Min(25, $walletAddr.Length)) + "..."
        
        Write-Host "`n$shortAddr" -ForegroundColor White
        Write-Host "  Total: $($walletSolutions.Count) | Accepted: $walletAccepted | Rejected: $walletRejected" -ForegroundColor $(if ($walletAccepted -gt 0) { "Green" } else { "Yellow" })
        
        # Estimate NIGHT for this wallet
        $walletEstMin = [math]::Round($walletAccepted * 0.1, 2)
        $walletEstMax = [math]::Round($walletAccepted * 1.0, 2)
        Write-Host "  Est. NIGHT: $walletEstMin - $walletEstMax" -ForegroundColor Yellow
    }
}
else {
    Write-Host "No solutions found yet" -ForegroundColor Yellow
}

# Check wallets and fetch actual NIGHT balance
if (Test-Path "wallets.json") {
    $wallets = Get-Content "wallets.json" | ConvertFrom-Json
    Write-Host "`nTotal Wallets: $($wallets.Count)" -ForegroundColor Cyan
    
    # Fetch actual NIGHT balance from API
    Write-Host "`n=== Actual NIGHT Balance ===" -ForegroundColor Cyan
    $totalNight = 0.0
    $totalChallenges = 0
    $successCount = 0
    $failedCount = 0
    $walletEarnings = @()
    
    foreach ($wallet in $wallets) {
        try {
            $response = Invoke-RestMethod -Uri "https://scavenger.prod.gd.midnighttge.io/statistics/$($wallet.address)" -Method Get -TimeoutSec 5 -ErrorAction Stop
            $nightAllocation = $response.local.night_allocation
            $challengesSolved = $response.global.challenges_solved
            
            if ($nightAllocation) {
                $night = $nightAllocation / 1000000.0
                $totalNight += $night
                $totalChallenges += $challengesSolved
                $successCount++
                
                $walletEarnings += [PSCustomObject]@{
                    Address = $wallet.address.Substring(0, [Math]::Min(42, $wallet.address.Length)) + "..."
                    Challenges = $challengesSolved
                    NIGHT = $night
                    Status = "OK"
                }
            }
        } catch {
            $failedCount++
            $walletEarnings += [PSCustomObject]@{
                Address = $wallet.address.Substring(0, [Math]::Min(42, $wallet.address.Length)) + "..."
                Challenges = 0
                NIGHT = 0.0
                Status = "Failed"
            }
        }
    }
    
    if ($successCount -gt 0) {
        Write-Host "Total NIGHT Earned: $([math]::Round($totalNight, 2))" -ForegroundColor Green
        Write-Host "Total Challenges: $totalChallenges" -ForegroundColor Green
        if ($failedCount -gt 0) {
            Write-Host "  (Failed to fetch $failedCount/$($wallets.Count) wallets)" -ForegroundColor Yellow
        }
    } else {
        Write-Host "Total NIGHT Earned: 0.00 (unable to fetch or no balance yet)" -ForegroundColor Yellow
    }
    Write-Host "  Balance updates every 24h after 2am UTC" -ForegroundColor DarkGray
    
    # Per-wallet earnings breakdown
    Write-Host "`n=== Per-Wallet Earnings ===" -ForegroundColor Cyan
    Write-Host ""
    $walletEarnings | Format-Table -Property @{Label="Wallet Address"; Expression={$_.Address}; Width=45}, 
                                             @{Label="Challenges"; Expression={$_.Challenges}; Width=12}, 
                                             @{Label="NIGHT Earned"; Expression={"{0:N2}" -f $_.NIGHT}; Width=15},
                                             @{Label="Status"; Expression={$_.Status}; Width=10} -AutoSize
    
    Write-Host "TOTAL: $totalChallenges challenges | $([math]::Round($totalNight, 2)) NIGHT" -ForegroundColor Green
}

# Check log file
if (Test-Path "miner.log") {
    Write-Host "`n=== Latest Log Entries ===" -ForegroundColor Cyan
    Get-Content "miner.log" -Tail 10
}

# Check solutions
if (Test-Path "solutions.csv") {
    $solutions = Import-Csv "solutions.csv"
    Write-Host "`n=== Solutions Found ===" -ForegroundColor Cyan
    Write-Host "Total Solutions: $($solutions.Count)" -ForegroundColor Green
}

Write-Host "`n========================" -ForegroundColor Cyan
