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
