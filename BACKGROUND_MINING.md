# Running MidnightMiner in Background on Windows 11

## Quick Start - 3 Easy Methods

### Method 1: VBScript (Easiest - Just Double-Click)
**File:** `run_miner_hidden.vbs`
- Double-click the file
- Miner runs completely hidden
- No terminal window appears

### Method 2: PowerShell Script
**File:** `run_miner_background.ps1`
```powershell
.\run_miner_background.ps1
```
- Shows confirmation message
- Runs hidden in background

### Method 3: PowerShell One-Liner
```powershell
Start-Process python -ArgumentList "miner.py" -WindowStyle Hidden
```

## Management Commands

### Check if Miner is Running
```powershell
.\check_miner_status.ps1
```

### Stop the Miner
```powershell
.\stop_miner.ps1
```
Or: Task Manager > Details > python.exe > End Task

### Auto-Start at Windows Boot
```powershell
.\install_startup.ps1
```

### Remove from Startup
```powershell
.\install_startup.ps1 -Remove
```

## Monitoring

### View Live Logs
```powershell
Get-Content miner.log -Wait -Tail 20
```

### Check Solutions
```powershell
Import-Csv solutions.csv | Format-Table
```

## Laptop Warning
- Monitor temperatures (keep under 85°C)
- Keep plugged in (drains battery fast)
- Ensure good ventilation
- May impact performance

## Files Created
- `run_miner_hidden.vbs` - Silent starter
- `run_miner_background.ps1` - PowerShell starter
- `stop_miner.ps1` - Stop all miners
- `check_miner_status.ps1` - Check status
- `install_startup.ps1` - Startup installer
