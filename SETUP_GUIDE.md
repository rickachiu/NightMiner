# NightMiner - Quick Setup Guide

## 🚀 Fast Setup with UV (Recommended)

UV is a blazingly fast Python package installer written in Rust. It's **10-30x faster** than pip!

### Prerequisites
- **Git** - Download from: https://git-scm.com/download/win
- That's it! UV will handle Python and all dependencies.

### One-Command Setup

```powershell
# Clone the repository
git clone https://github.com/rickachiu/NightMiner.git
cd NightMiner

# Run the automated setup script (installs everything!)
.\setup_with_uv.ps1
```

That's it! The script will:
1. ✅ Install UV (if not already installed)
2. ✅ Install Python 3.13 via UV
3. ✅ Install all dependencies (super fast!)
4. ✅ Verify everything is working

---

## 🎮 Starting the Miner

### For Background Mining (Recommended)
```powershell
.\run_miner_background.ps1
```
Runs with 3 workers by default (hidden in background)

### For Laptop/Lower RAM (1 Worker)
```powershell
python miner.py
```

### Custom Worker Count
```powershell
Start-Process python -ArgumentList "miner.py --workers 6" -WindowStyle Hidden
```

---

## 📊 Managing the Miner

### Check Status
```powershell
.\check_miner_status.ps1
```
Shows: Running status, CPU/RAM usage, latest logs, solution count

### Stop Mining
```powershell
.\stop_miner.ps1
```
Or: Task Manager > Details > python.exe > End Task

### View Live Logs
```powershell
Get-Content miner.log -Wait -Tail 20
```
Press Ctrl+C to stop watching

---

## 🔧 Auto-Start at Windows Boot

### Enable Auto-Start
```powershell
.\install_startup.ps1
```
Miner will start automatically (hidden) when Windows boots

### Disable Auto-Start
```powershell
.\install_startup.ps1 -Remove
```

---

## 💾 Important Files

### Keep Safe (Contains Your Private Keys!)
- **`wallets.json`** - Your wallet private keys - BACKUP THIS FILE!

### Mining Data
- **`challenges.json`** - Tracks solved challenges
- **`solutions.csv`** - Your submitted solutions
- **`miner.log`** - Mining activity logs

### Export Wallet Keys
```powershell
python export_skeys.py
```
Creates `.skey` and `.vkey` files for each wallet (Cardano format)

---

## 📈 Expected Performance

### 32GB RAM, 16 Workers (Good CPU)
- **Hash Rate:** ~10,000-15,000 H/s
- **RAM Usage:** ~16GB
- **CPU Usage:** ~100% (16 cores)
- **Solutions:** Much faster completion

### Laptop, 1 Worker
- **Hash Rate:** ~500-1,000 H/s
- **RAM Usage:** ~1GB
- **CPU Usage:** ~1 core (6-12%)
- **Solutions:** Slower but still viable

---

## ⚠️ Laptop Warning

If running on a laptop:
- ✅ Use only 1 worker (default when running `python miner.py`)
- ✅ Monitor temperatures (keep under 85°C)
- ✅ Ensure good ventilation
- ✅ Keep plugged in (drains battery quickly)
- ⚠️ May impact performance of other applications

---

## 🔒 Security Notes

- ✅ Private keys are generated **locally** on your machine
- ✅ Private keys **never leave your computer** (unless you export them)
- ✅ Only public addresses are sent to the Midnight API
- ✅ YOU control your wallets and NIGHT tokens
- ⚠️ **BACKUP `wallets.json` REGULARLY!**

---

## 🆘 Troubleshooting

### UV Installation Fails
Manually install UV:
```powershell
irm https://astral.sh/uv/install.ps1 | iex
```

### Python Not Found After Setup
Restart PowerShell to refresh environment variables

### Dependencies Fail to Install
Try traditional pip:
```powershell
pip install -r requirements.txt
```

### Miner Won't Start Hidden
Try running normally first to see errors:
```powershell
python miner.py
```

---

## 📚 Additional Resources

- **Background Mining Guide:** See `BACKGROUND_MINING.md`
- **Original Guide:** See `EasyGuide.md`
- **Project Info:** See `README.md`

---

## 💰 Claiming NIGHT Tokens

When ready to claim your earned NIGHT tokens:
1. Export your wallet keys: `python export_skeys.py`
2. Import keys into a Cardano wallet
3. Wait for token distribution (updates every 24h)
4. Tokens will appear in your wallet!

---

## 🎯 Quick Reference

| Command | Description |
|---------|-------------|
| `.\setup_with_uv.ps1` | One-command setup (recommended) |
| `.\run_miner_background.ps1` | Start mining (hidden, 3 workers) |
| `.\check_miner_status.ps1` | Check mining status |
| `.\stop_miner.ps1` | Stop all miners |
| `python export_skeys.py` | Export wallet keys |
| `.\install_startup.ps1` | Add to Windows startup |

---

**Ready to mine NIGHT tokens! 🌙**
