# NightMiner - Quick Start for Multiple Machines

## 🚀 Super Easy Installation (For 5+ Machines)

### Prerequisites (One-time per machine):
1. **Install Git** (if not already installed)
   - Download: https://git-scm.com/download/win
   - Run installer with default settings
   - Restart computer (or at least restart any open terminals)

### Method 1: One-Click Installer (Easiest!)

1. **Download the installer:**
   - Go to: https://github.com/rickachiu/NightMiner
   - Click the green "Code" button → "Download ZIP"
   - Extract the ZIP file
   - Double-click `EASY_INSTALL.bat`

2. **That's it!** The script will:
   - ✅ Install UV (fast package manager)
   - ✅ Install Python 3.13
   - ✅ Install all dependencies
   - ✅ Start mining with 3 workers automatically

---

### Method 2: Manual (If bat file doesn't work)

Open PowerShell and run:

```powershell
# Clone the repository
git clone https://github.com/rickachiu/NightMiner.git
cd NightMiner

# Install UV
irm https://astral.sh/uv/install.ps1 | iex

# Restart PowerShell (to refresh PATH), then:
cd NightMiner
uv python install 3.13
uv pip install --system -r requirements.txt

# Start mining
.\run_miner_background.ps1
```

---

### Method 3: Copy from Existing Machine (Fastest!)

If you already have it working on one machine:

1. **On working machine:**
   ```powershell
   # Backup your wallets first!
   Copy-Item wallets.json wallets_backup.json
   
   # Zip everything (excluding sensitive data)
   Compress-Archive -Path * -DestinationPath NightMiner_portable.zip -Force
   ```

2. **On new machine:**
   - Copy `NightMiner_portable.zip` via USB/network
   - Extract to `C:\apps\NightMiner`
   - Delete the `wallets.json` file (so it creates new wallets)
   - Double-click `run_miner_hidden.vbs`

⚠️ **Important:** Each machine should have its own `wallets.json` - don't share wallet files between machines!

---

## 📊 After Installation

### Check Status:
```powershell
cd NightMiner
.\check_miner_status.ps1
```

### View Live Dashboard:
```powershell
python miner.py --workers 3
```
(Press Ctrl+C to exit, miner continues in background)

### Stop Mining:
```powershell
.\stop_miner.ps1
```

### Backup Wallets (Do this regularly!):
```powershell
Copy-Item wallets.json wallets_backup_$(Get-Date -Format 'yyyyMMdd').json
```

---

## ⚙️ Adjusting Worker Count

Default is 3 workers (good for 4-core CPUs).

**To change:**

Edit `run_miner_hidden.vbs` or `run_miner_background.ps1`:
- **1 worker** for laptops (low impact)
- **2 workers** for dual-core
- **3 workers** for quad-core (recommended, leaves headroom)
- **4 workers** for quad-core (maximum, system may lag)
- **6-8 workers** for 8-core CPUs
- **12-16 workers** for high-end workstations

---

## 🔒 Security Notes

- ✅ Each machine creates its own wallets
- ✅ Private keys stored in `wallets.json` - **BACKUP THIS FILE!**
- ✅ Never share `wallets.json` publicly
- ✅ `.gitignore` prevents accidental uploads to GitHub

---

## 🆘 Troubleshooting

### "Git not found"
- Install Git from: https://git-scm.com/download/win
- Restart computer after installation

### "UV not found after install"
- Close and reopen PowerShell/Command Prompt
- Try running: `$env:Path = [System.Environment]::GetEnvironmentVariable('Path','Machine') + ';' + [System.Environment]::GetEnvironmentVariable('Path','User')`

### "Python not found"
- UV should install it automatically
- If not, manually install from: https://www.python.org/downloads/

### Miner won't start
- Check logs: `Get-Content miner.log -Tail 20`
- Try running visible: `python miner.py --workers 3`

### Status shows "NOT RUNNING" but it is
- Update the repo: `git pull`
- The status checker was fixed in recent versions

---

## 📈 Expected Performance

| CPU Cores | Workers | Hash Rate | RAM Usage | CPU % |
|-----------|---------|-----------|-----------|-------|
| 2 cores   | 1       | ~800 H/s  | ~1 GB     | 50%   |
| 4 cores   | 3       | ~2,400 H/s| ~3 GB     | 75%   |
| 8 cores   | 6       | ~4,800 H/s| ~6 GB     | 75%   |
| 16 cores  | 12      | ~9,600 H/s| ~12 GB    | 75%   |

---

## 🎯 Quick Command Reference

| Task | Command |
|------|---------|
| Install | `EASY_INSTALL.bat` |
| Start mining | `run_miner_hidden.vbs` |
| Check status | `.\check_miner_status.ps1` |
| Stop mining | `.\stop_miner.ps1` |
| View dashboard | `python miner.py --workers 3` |
| Backup wallets | `Copy-Item wallets.json backup.json` |
| Update miner | `git pull` |

---

**Ready to mine NIGHT tokens on all your machines! 🌙**
