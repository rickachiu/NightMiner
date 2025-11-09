# NightMiner

Automated mining bot for the Midnight Network's scavenger hunt. Earn NIGHT tokens by solving cryptographic challenges.

**Works on Windows, Linux, and MacOS.**

---

## ⚡ One-Line Install

### Windows
1. **Open PowerShell** (Right-click Start menu → Windows PowerShell)
2. **Copy and paste this command:**
```powershell
iex (irm https://raw.githubusercontent.com/rickachiu/NightMiner/main/SETUP.ps1)
```
3. Press Enter and follow the prompts

> **Important:** Use `iex (irm ...)` not `irm ... | iex` - the parentheses are required!

### Linux
1. **Open Terminal** (Ctrl+Alt+T)
2. **Copy and paste this command:**
```bash
curl -sSL https://raw.githubusercontent.com/rickachiu/NightMiner/main/setup.sh | bash
```
3. Press Enter and follow the prompts

### MacOS
1. **Open Terminal** (Cmd+Space, type "Terminal")
2. **Copy and paste this command:**
```bash
curl -sSL https://raw.githubusercontent.com/rickachiu/NightMiner/main/setup.sh | bash
```
3. Press Enter and follow the prompts

**That's it!** The installer will:
- ✅ Install all dependencies (Git, UV, Python, packages)
- ✅ Configure optimal worker count for your CPU
- ✅ Set up auto-start on boot (defaults to YES)
- ✅ Start mining immediately in the background

> **💡 Note:** Windows users need [Git](https://git-scm.com/downloads) installed first. The installer will guide you if it's missing.

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

The installer automatically recommends workers based on your CPU (75% of cores). You can use any number you want:

```bash
# Start with custom worker count
python miner.py --workers 6

# Disable developer donations (optional 5%)
python miner.py --no-donation

# Resubmit failed solutions (if network issues occurred)
python resubmit_solutions.py
```

**Worker Count Guidelines:**
- **Light (50%)**: Half your CPU cores - leaves plenty for other tasks
- **Balanced (75%)**: Three-quarters of cores - recommended for most users
- **Heavy (100%)**: All CPU cores - maximum mining, system may be slower
- **Custom**: Any number you prefer based on your needs

**Examples:**
- 4-core CPU: 2 (light), 3 (balanced), 4 (heavy)
- 8-core CPU: 4 (light), 6 (balanced), 8 (heavy)
- 16-core CPU: 8 (light), 12 (balanced), 16 (heavy)
- 32-core CPU: 16 (light), 24 (balanced), 32 (heavy)

**Note:** Each worker uses ~1 CPU core and ~1GB RAM. Choose based on your system's capabilities and what else you're running.

---

## 📚 Additional Guides

- **[UNIFIED_INSTALLER_README.md](UNIFIED_INSTALLER_README.md)** - Detailed installer features
- **[BACKGROUND_MINING.md](BACKGROUND_MINING.md)** - Advanced background mining
- **[EasyGuide.md](EasyGuide.md)** - Beginner-friendly walkthrough

---

## ⚠️ Disclaimer

This is an unofficial tool. Use at your own risk. The software is provided as-is without warranty.

