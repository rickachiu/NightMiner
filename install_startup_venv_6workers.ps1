# Install NightMiner to run at Windows startup with 6 workers - Virtual Environment Version
param(
    [switch]$Remove
)

$vbsPath = Join-Path $PSScriptRoot "run_miner_venv_6workers.vbs"
$startupFolder = [Environment]::GetFolderPath('Startup')
$shortcutPath = Join-Path $startupFolder "NightMiner.lnk"

if ($Remove) {
    # Remove from startup
    if (Test-Path $shortcutPath) {
        Remove-Item $shortcutPath -Force
        Write-Host "NightMiner removed from startup" -ForegroundColor Green
    } else {
        Write-Host "NightMiner not found in startup" -ForegroundColor Yellow
    }
} else {
    # Add to startup
    $WshShell = New-Object -ComObject WScript.Shell
    $Shortcut = $WshShell.CreateShortcut($shortcutPath)
    $Shortcut.TargetPath = $vbsPath
    $Shortcut.WorkingDirectory = $PSScriptRoot
    $Shortcut.Description = "NightMiner Background Service (6 Workers - Virtual Environment)"
    $Shortcut.Save()
    
    Write-Host "NightMiner added to startup successfully!" -ForegroundColor Green
    Write-Host "Location: $shortcutPath" -ForegroundColor Cyan
    Write-Host "Workers: 6 (optimized for 8-core systems)" -ForegroundColor Cyan
    Write-Host "It will start automatically when Windows boots" -ForegroundColor Cyan
}
