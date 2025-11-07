# Install NightMiner to run at Windows startup (hidden) - Virtual Environment Version
param(
    [switch]$Remove
)

$vbsPath = Join-Path $PSScriptRoot "run_miner_venv.vbs"
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
    $Shortcut.Description = "NightMiner Background Service (Virtual Environment)"
    $Shortcut.Save()
    
    Write-Host "NightMiner added to startup successfully!" -ForegroundColor Green
    Write-Host "Location: $shortcutPath" -ForegroundColor Cyan
    Write-Host "It will start automatically when Windows boots" -ForegroundColor Cyan
    Write-Host "Using virtual environment python" -ForegroundColor Cyan
}
