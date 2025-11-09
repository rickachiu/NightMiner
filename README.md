# NightMiner

Automated mining bot for the Midnight Network's scavenger hunt. Earn NIGHT tokens by solving cryptographic challenges.

**Works on Windows, Linux, and MacOS.**

---

## ⚡ One-Line Install

### Windows
```powershell
irm https://raw.githubusercontent.com/rickachiu/NightMiner/main/SETUP.ps1 | iex
```

### Linux
```bash
curl -sSL https://raw.githubusercontent.com/rickachiu/NightMiner/main/setup.sh | bash
```

### MacOS
```bash
curl -sSL https://raw.githubusercontent.com/rickachiu/NightMiner/main/setup.sh | bash
```

**That's it!** The installer will:
- ✅ Install all dependencies (Git, UV, Python, packages)
- ✅ Configure optimal worker count for your CPU
- ✅ Set up auto-start on boot (optional)
- ✅ Start mining immediately in the background

> **💡 First time?** You'll need [Git](https://git-scm.com/downloads) installed first. The installer will guide you if it's missing.

---

## 📋 After Installation

The installer starts mining automatically in the background. 

### 🎯 PRIMARY: Interactive Dashboard (Recommended)

Use this to monitor your mining with live stats:

**Windows:**
```powershell
cd NightMiner
.\Night-Miner.ps1
# or
python miner.py --workers 3
```

**Linux/Mac:**
```bash
cd NightMiner
.venv/bin/python miner.py --workers 3
```

**Shows:**
- ✅ Live hash rates per worker
- ✅ Challenges being solved
- ✅ Total NIGHT earned (always visible, even if 0.00)
- ✅ Active workers count
- ✅ Solutions saved
- ✅ Real-time updates every 5 seconds
- Press `Ctrl+C` to stop

### 📊 SECONDARY: Quick Status Check

Use this only for a quick peek when miner runs in background:

**Windows:**
```powershell
.\check_miner_status.ps1
```

**Linux/Mac:**
```bash
tail -f miner.log
# or
ps aux | grep miner.py
```

### Stop Mining
**Windows:**
```powershell
.\stop_miner.ps1
```

**Linux/Mac:**
```bash
pkill -f miner.py
```

### Backup Your Wallet
**CRITICAL:** Your private keys are in `wallets.json` - backup regularly!

```bash
# Linux/Mac
cp wallets.json wallets_backup_$(date +%Y%m%d).json

# Windows
Copy-Item wallets.json wallets_backup_$(Get-Date -Format 'yyyyMMdd').json
```

### Update
```bash
git pull
```
Run this daily for the latest optimizations.

---

## 💰 Claiming Your NIGHT Tokens

When you're ready to claim your rewards:

```bash
python export_skeys.py
```

This creates `.skey` files in the `skeys/` directory. Import them into a Cardano wallet like [Eternl](https://eternl.io/):
1. Open Eternl → **Add Wallet** → **More** → **CLI Signing Keys**
2. Import the `.skey` files from the `skeys/` directory

---

## ⚙️ Customizing Worker Count

The installer automatically recommends workers based on your CPU (75% of cores). To change:

```bash
# Start with custom worker count
python miner.py --workers 6

# Disable developer donations (optional 5%)
python miner.py --no-donation

# Resubmit failed solutions (if network issues occurred)
python resubmit_solutions.py
```

**Recommended Worker Counts:**
- **2-core CPU**: 1-2 workers
- **4-core CPU**: 3 workers
- **8-core CPU**: 6 workers
- **16-core CPU**: 12 workers

Rule of thumb: Use 75% of your CPU cores (each worker = 1 core + 1GB RAM).

---

## 📚 Additional Guides

- **[UNIFIED_INSTALLER_README.md](UNIFIED_INSTALLER_README.md)** - Detailed installer features
- **[BACKGROUND_MINING.md](BACKGROUND_MINING.md)** - Advanced background mining
- **[EasyGuide.md](EasyGuide.md)** - Beginner-friendly walkthrough

---

## ⚠️ Disclaimer

This is an unofficial tool. Use at your own risk. The software is provided as-is without warranty.

