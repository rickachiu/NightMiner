# Windows Background Mining Guide

Run NightMiner silently in the background without visible terminal windows.

## 🚀 Quick Start

### Method 1: PowerShell Script (Easiest)
```powershell
.\run_miner_background.ps1
```
- Double-click or run from PowerShell
- Runs hidden in background
- Uses default 3 workers

### Method 2: PowerShell One-Liner
```powershell
Start-Process python -ArgumentList "miner.py --workers 3" -WindowStyle Hidden
```

---

## 🔧 Management Commands

### Check Mining Status
```powershell
.\check_miner_status.ps1
```
Shows: Running status, CPU/RAM usage, latest logs, solution count

### Stop Mining
```powershell
.\stop_miner.ps1
```
**Alternative:** Task Manager → Details → python.exe → End Task

### Auto-Start at Boot
Enable:
```powershell
.\install_startup.ps1
```

Disable:
```powershell
.\install_startup.ps1 -Remove
```

---

## 📊 Monitoring

### View Live Logs
```powershell
Get-Content miner.log -Wait -Tail 20
```
Press `Ctrl+C` to stop watching

### Check Solutions
```powershell
Import-Csv solutions.csv | Format-Table
```

---

## ⚙️ Customizing Worker Count

Edit `run_miner_background.ps1` and change the worker count, or run directly:
```powershell
Start-Process python -ArgumentList "miner.py --workers 6" -WindowStyle Hidden
```

Recommended:
- **2-core CPU**: 1-2 workers
- **4-core CPU**: 3-4 workers
- **8-core CPU**: 6-8 workers
- **16-core CPU**: 12-16 workers

---

## ⚠️ Laptop Warning

If running on a laptop:
- ✅ Monitor temperatures (keep under 85°C)
- ✅ Keep plugged in (drains battery fast)
- ✅ Ensure good ventilation
- ⚠️ May impact system performance

---

## 📁 Scripts Reference

| Script | Purpose |
|--------|---------|
| `run_miner_background.ps1` | Start mining silently in background |
| `check_miner_status.ps1` | Check if mining and view stats |
| `stop_miner.ps1` | Stop all mining processes |
| `install_startup.ps1` | Add/remove from Windows startup |
| `setup_with_uv.ps1` | Automated UV installation |
