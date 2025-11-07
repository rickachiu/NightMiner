# Stop all running MidnightMiner processes
$processes = Get-Process python -ErrorAction SilentlyContinue | Where-Object {
    $_.CommandLine -like "*miner.py*"
}

if ($processes) {
    $processes | Stop-Process -Force
    Write-Host "Stopped $($processes.Count) miner process(es)" -ForegroundColor Green
} else {
    Write-Host "No miner processes found running" -ForegroundColor Yellow
}
