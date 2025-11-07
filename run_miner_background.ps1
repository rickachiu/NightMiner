# Run MidnightMiner in background without visible window
$pythonPath = (Get-Command python).Source
$minerScript = Join-Path $PSScriptRoot "miner.py"

Start-Process -FilePath $pythonPath -ArgumentList "$minerScript --workers 16" -WorkingDirectory $PSScriptRoot -WindowStyle Hidden -PassThru

Write-Host "MidnightMiner started in background successfully!" -ForegroundColor Green
Write-Host "Check Task Manager > Details > python.exe to verify it's running" -ForegroundColor Cyan
Write-Host "To stop: Open Task Manager and end the python.exe process" -ForegroundColor Yellow
