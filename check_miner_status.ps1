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
    Write-Host "Total Solutions: $solutionCount" -ForegroundColor Green
    
    if ($solutionCount -gt 0) {
        $lastSolution = $solutions[-1]
        Write-Host "Last Solution: $($lastSolution.timestamp)" -ForegroundColor White
        Write-Host "Last Challenge: $($lastSolution.challenge)" -ForegroundColor White
    }
    
    # Estimate NIGHT tokens (approximate - actual may vary)
    # Typical rewards range from 0.1 to 1 NIGHT per solution
    $estimatedMin = [math]::Round($solutionCount * 0.1, 2)
    $estimatedMax = [math]::Round($solutionCount * 1.0, 2)
    Write-Host "Estimated NIGHT*: $estimatedMin - $estimatedMax" -ForegroundColor Yellow
    Write-Host "*Actual rewards vary by challenge difficulty and network conditions" -ForegroundColor DarkGray
    Write-Host "*Balances update every 24h on Midnight Network" -ForegroundColor DarkGray
}
else {
    Write-Host "No solutions found yet" -ForegroundColor Yellow
}

# Check wallets
if (Test-Path "wallets.json") {
    $wallets = Get-Content "wallets.json" | ConvertFrom-Json
    Write-Host "`nTotal Wallets: $($wallets.Count)" -ForegroundColor Cyan
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
