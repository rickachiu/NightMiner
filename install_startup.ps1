# Install MidnightMiner to run at Windows startup (hidden)
param(
    [switch]$Remove
)

$vbsPath = Join-Path $PSScriptRoot "run_miner_hidden.vbs"
$startupFolder = [Environment]::GetFolderPath('Startup')
$shortcutPath = Join-Path $startupFolder "MidnightMiner.lnk"

if ($Remove) {
    # Remove from startup
    if (Test-Path $shortcutPath) {
        Remove-Item $shortcutPath -Force
        Write-Host "MidnightMiner removed from startup" -ForegroundColor Green
    } else {
        Write-Host "MidnightMiner not found in startup" -ForegroundColor Yellow
    }
} else {
    # Add to startup
    $WshShell = New-Object -ComObject WScript.Shell
    $Shortcut = $WshShell.CreateShortcut($shortcutPath)
    $Shortcut.TargetPath = $vbsPath
    $Shortcut.WorkingDirectory = $PSScriptRoot
    $Shortcut.Description = "MidnightMiner Background Service"
    $Shortcut.Save()
    
    Write-Host "MidnightMiner added to startup successfully!" -ForegroundColor Green
    Write-Host "Location: $shortcutPath" -ForegroundColor Cyan
    Write-Host "It will start automatically when Windows boots" -ForegroundColor Cyan
}
