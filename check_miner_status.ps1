# Check if MidnightMiner is running and show stats
$processes = Get-Process python -ErrorAction SilentlyContinue | Where-Object {
    $_.CommandLine -like "*miner.py*"
}

Write-Host "`n=== MidnightMiner Status ===" -ForegroundColor Cyan

if ($processes) {
    Write-Host "Status: RUNNING" -ForegroundColor Green
    Write-Host "Process ID: $($processes.Id)" -ForegroundColor White
    Write-Host "CPU Usage: $($processes.CPU)" -ForegroundColor White
    Write-Host "Memory: $([math]::Round($processes.WorkingSet64/1MB, 2)) MB" -ForegroundColor White
    Write-Host "Started: $($processes.StartTime)" -ForegroundColor White
} else {
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
