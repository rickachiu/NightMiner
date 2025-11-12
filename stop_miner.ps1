# Stop all running MidnightMiner processes
$minerProcesses = @()
Get-Process python -ErrorAction SilentlyContinue | ForEach-Object {
    $cmdLine = (Get-WmiObject Win32_Process -Filter "ProcessId=$($_.Id)").CommandLine
    if ($cmdLine -like "*miner.py*") {
        $minerProcesses += $_
    }
}

if ($minerProcesses.Count -gt 0) {
    $minerProcesses | Stop-Process -Force
    Write-Host "Stopped $($minerProcesses.Count) miner process(es)" -ForegroundColor Green
    
    # Also stop any child worker processes
    Start-Sleep -Seconds 1
    $remainingWorkers = Get-Process python -ErrorAction SilentlyContinue | Where-Object {
        $cmd = (Get-WmiObject Win32_Process -Filter "ProcessId=$($_.Id)").CommandLine
        $cmd -like "*multiprocessing*"
    }
    if ($remainingWorkers) {
        $remainingWorkers | Stop-Process -Force
        Write-Host "Stopped $($remainingWorkers.Count) worker process(es)" -ForegroundColor Green
    }
} else {
    Write-Host "No miner processes found running" -ForegroundColor Yellow
}
