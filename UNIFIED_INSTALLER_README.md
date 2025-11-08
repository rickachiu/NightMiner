# Night-Miner - Unified Installer & Manager

## 🚀 The Simplest Way to Mine NIGHT Tokens

**One script does everything:**
- ✅ Installs all dependencies (Git, UV, Python, packages)
- ✅ Configures optimal worker count
- ✅ Sets up auto-start on boot
- ✅ Runs completely silent in background
- ✅ Beautiful status dashboard
- ✅ Easy start/stop controls

---

## 📋 Prerequisites

**Only ONE thing needed:**
- **Windows 10/11** with PowerShell

**That's it!** The script installs everything else automatically.

---

## 🎯 Quick Start (3 Steps)

### Step 1: Install Git (One-time)
Download and install: https://git-scm.com/download/win
- Run installer with default settings
- **Restart your computer**

### Step 2: Clone Repository
```powershell
git clone https://github.com/rickachiu/NightMiner.git
cd NightMiner
```

### Step 3: Run Night-Miner
```powershell
.\Night-Miner.ps1
```

**That's it!** The script will:
1. Install UV and Python automatically
2. Ask how many workers you want
3. Set up auto-start on boot
4. Start mining immediately
5. Show you the dashboard

---

## 📊 What You'll See

### First Run (Installation):
```
╔══════════════════════════════════════════════════════════╗
║        NIGHT MINER - Installation Wizard                ║
╚══════════════════════════════════════════════════════════╝

[1/5] Checking for Git...
  ✓ Git is installed

[2/5] Installing UV (fast package manager)...
  ✓ UV installed successfully

[3/5] Setting up Python environment...
  ✓ Virtual environment created
  ✓ Dependencies installed

[4/5] Configuring workers...
  How many CPU cores does this system have? 8

  Recommendations based on 8 cores:
    • Balanced (75% CPU): 6 workers
    • Light (50% CPU): 4 workers
    • Maximum (100% CPU): 8 workers

  How many workers do you want? 6
  ✓ Configured for 6 workers

[5/5] Configuring auto-start on boot...
  ✓ Auto-start enabled (6 workers)

╔══════════════════════════════════════════════════════════╗
║           ✓ Installation Complete!                      ║
╚══════════════════════════════════════════════════════════╝

  Your Night Miner is ready with:
    • 6 workers configured
    • Auto-start on boot enabled
    • Running in silent background mode
```

### After Installation (Dashboard):
```
╔══════════════════════════════════════════════════════════╗
║              NIGHT MINER - Status Dashboard              ║
╚══════════════════════════════════════════════════════════╝

✓ Miner Status: RUNNING
  Active Processes: 7
  Total Memory: 6000.00 MB
  CPU Time: 1234.56s

📊 Mining Statistics:
  Total Solutions: 25
    ✓ Accepted: 22
    ✗ Rejected: 2

  💰 Estimated NIGHT: 2.2 - 22.0
     (Actual rewards vary by difficulty)

👛 Wallet Performance:
  addr1v8fvjf3hsnk6z...
    Solutions: 8 | ✓ 7 ✗ 1 | NIGHT: 0.7-7.0
  addr1vxwqp48ew0y4z...
    Solutions: 9 | ✓ 8 ✗ 1 | NIGHT: 0.8-8.0
  addr1vy9rcugrg0q4s...
    Solutions: 8 | ✓ 7 ✗ 0 | NIGHT: 0.7-7.0

  Total Wallets Created: 5

╔══════════════════════════════════════════════════════════╗
║                   CONTROL PANEL                          ║
╚══════════════════════════════════════════════════════════╝

  [1] Stop Miner
  [2] Refresh Status
  [3] Change Worker Count (Current: 6)
  [4] Backup Wallets
  [0] Exit
```

---

## 🎮 Menu Options

### [1] Start/Stop Miner
- Toggles the miner on/off
- Automatically detects current state
- Safe shutdown of all workers

### [2] Refresh Status
- Updates the dashboard
- Shows latest mining stats
- Real-time process information

### [3] Change Worker Count
- Adjust CPU usage on the fly
- Recommendations provided
- Updates auto-start configuration

### [4] Backup Wallets
- Creates timestamped backup of wallets.json
- Protects your NIGHT tokens
- Essential before major changes

### [0] Exit
- Exits the dashboard
- **Miner keeps running in background**
- Auto-starts on reboot

---

## 🔄 After Reboot

When you restart your computer:
1. ✅ Miner **automatically starts** (hidden)
2. Run `.\Night-Miner.ps1` anytime to see dashboard
3. All your settings are preserved

---

## 💡 Recommended Worker Counts

| CPU Cores | RAM  | Light | Balanced | Maximum |
|-----------|------|-------|----------|---------|
| 2 cores   | 8GB  | 1     | 1        | 2       |
| 4 cores   | 16GB | 2     | 3        | 4       |
| 8 cores   | 16GB | 3     | 6        | 8       |
| 8 cores   | 32GB | 4     | 6        | 8       |
| 16 cores  | 32GB | 8     | 12       | 16      |

**Rule of thumb:** Use 75% of CPU cores for balanced performance.

---

## 📁 Important Files

- **`wallets.json`** - Your private keys (BACKUP THIS!)
- **`solutions.csv`** - Mining history
- **`night-miner-config.json`** - Your settings
- **`run_miner_auto.vbs`** - Auto-start launcher
- **`miner.log`** - Detailed logs

---

## 🔒 Security

- ✅ Private keys generated locally
- ✅ Never transmitted anywhere
- ✅ You have full control
- ✅ Wallets automatically excluded from git
- ⚠️ **Always backup wallets.json!**

---

## 🆘 Troubleshooting

### "Git is not installed"
- Install Git from: https://git-scm.com/download/win
- **Restart computer** after installation
- Run Night-Miner.ps1 again

### "UV not found after install"
- Close PowerShell completely
- Reopen PowerShell
- Run Night-Miner.ps1 again

### Miner not starting
- Check the log: `Get-Content miner.log -Tail 20`
- Try running with fewer workers
- Ensure you have enough RAM

### Script execution policy error
Run this first:
```powershell
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
Get-ChildItem *.ps1 | Unblock-File
```

---

## 📈 Performance Tips

1. **Start Conservative**: Begin with recommended worker count
2. **Monitor Resources**: Check Task Manager during first run
3. **Adjust as Needed**: Use option [3] to change workers
4. **Backup Regularly**: Use option [4] frequently
5. **Check Dashboard**: Run Night-Miner.ps1 daily to see progress

---

## 🎯 For Multiple Machines

**On each machine:**
```powershell
# 1. Install Git (if needed)
# 2. Clone repository
git clone https://github.com/rickachiu/NightMiner.git
cd NightMiner

# 3. Run unified installer
.\Night-Miner.ps1
```

Each machine will:
- Configure independently
- Create its own wallets
- Auto-start on boot
- Mine with optimal settings

---

## 🌟 Key Features

✅ **Zero Configuration** - Just answer how many workers  
✅ **Auto-Everything** - Install, configure, start, auto-start  
✅ **Beautiful Dashboard** - See all stats at a glance  
✅ **Persistent** - Survives reboots automatically  
✅ **Safe** - Easy backup, clear status  
✅ **Smart** - Provides recommendations based on your system  

---

## 💰 Claiming Your NIGHT Tokens

When ready to claim:
```powershell
# Export wallet keys
python export_skeys.py

# Import .skey files into Cardano wallet
# Tokens appear after 24h network sync
```

---

**Happy Mining! 🌙**

Questions? Issues? Check the main README.md or create a GitHub issue.
