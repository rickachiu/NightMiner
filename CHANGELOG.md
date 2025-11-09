# NightMiner Changelog

## Version 2.0 - Simplified Edition (2025-01-15)

### 🎉 Major Overhaul - One-Line Installer Edition

This release represents a complete simplification and modernization of NightMiner, making it incredibly easy for anyone to start mining NIGHT tokens.

---

## ⚡ One-Line Installation

### New Installation Methods

**Windows:**
```powershell
iex (irm https://raw.githubusercontent.com/rickachiu/NightMiner/main/SETUP.ps1)
```

**Linux/MacOS:**
```bash
curl -sSL https://raw.githubusercontent.com/rickachiu/NightMiner/main/setup.sh | bash
```

**Features:**
- ✅ Fully automated installation
- ✅ Auto-installs Git via winget/chocolatey
- ✅ Auto-installs UV, Python, all dependencies
- ✅ Configures optimal worker count (75% of CPU)
- ✅ Auto-start defaults to YES
- ✅ Starts mining immediately in background
- ✅ Complete setup in 3 steps: Open PowerShell → Paste command → Press Enter

---

## 🗑️ Repository Cleanup

### Removed Redundant Files (13 total)
- `run_light.vbs`
- `run_medium.vbs`
- `run_maximum.vbs`
- `run_miner_hidden.vbs`
- `run_miner_venv.vbs`
- `run_miner_venv_6workers.vbs`
- `run_miner_venv_light.vbs`
- `run_miner_venv_medium.vbs`
- `run_miner_venv_maximum.vbs`
- `install_startup_venv.ps1`
- `install_startup_venv_6workers.ps1`
- `UNBLOCK_SCRIPTS.bat`
- `PERFORMANCE_MODES.md`

**Result:** Clean, professional repository structure with only essential files.

---

## 📊 Enhanced Dashboard

### New Real-Time Statistics
- **Active Workers Count**: Shows X/Y (e.g., 3/4 = 3 actively mining)
- **NIGHT Balance Always Visible**: Displays even when 0.00
- **Solutions Saved**: Shows pending solutions awaiting resubmission
- **Total Wallets**: Displays wallet count
- **Comma-Formatted Numbers**: Better readability (e.g., 6,103 H/s)
- **Clearer Update Info**: "NIGHT balance updates every 24h after 2am UTC"

### Dashboard Preview
```
==============================================================================
                        MIDNIGHT MINER - v0.3
==============================================================================
Active Workers: 4 | Last Update: 2025-01-15 14:32:18
==============================================================================

ID   Address                                      Challenge          Attempts      H/s
------------------------------------------------------------------------------
0    addr1vxask5vpp8p4xddsc3qd63luy4ecf...        **D05C02           470,000       2,040
1    developer (thank you!)                       **D05C19           471,000       2,035
2    addr1v9hcpxeevkks7g4mvyls029yuvvsm0d...      Building ROM       0             0
3    addr1vx64c8703ketwnjtxkjcqzsktwkcvh...      **D05C20           154,000       2,028
------------------------------------------------------------------------------

Total Hash Rate:     6,103 H/s
Active Workers:      3/4
Total Completed:     127 (+15)
Total NIGHT:         45.32
Solutions Saved:     2 (pending resubmission)
Total Wallets:       8
==============================================================================
NIGHT balance updates every 24h after 2am UTC

Press Ctrl+C to stop all miners
```

---

## 📋 Documentation Improvements

### Streamlined README.md
- **One-line installers** featured prominently at the top
- **Step-by-step instructions** for opening PowerShell/Terminal
- **Clear PRIMARY vs SECONDARY** monitoring guidance
- **Dashboard-first approach** emphasized
- **Removed verbose sections** (How It Works, Prerequisites)
- **Better organization** with emoji sections

### Updated User Workflow
**PRIMARY (Recommended):**
- `.\Night-Miner.ps1` or `python miner.py` - Interactive dashboard with live stats

**SECONDARY (Quick Check):**
- `.\check_miner_status.ps1` - Quick peek when running in background

---

## 🔧 New Features

### 1. Auto-Start Defaults to YES
- Installer now defaults to enabling auto-start on boot
- Users just press Enter to accept (no typing needed)
- Clear feedback: "✓ Auto-start enabled" or "○ Auto-start disabled"

### 2. Mining Cutoff Date (Nov 22, 2025)
- Miner automatically stops after Nov 21, 2025 (airdrop end date)
- Displays helpful message about claiming tokens
- Prevents wasted resources after airdrop ends
- Shows cutoff warning when starting miner

### 3. Automated Git Installation
- Automatically installs Git using winget (Windows 10/11)
- Falls back to chocolatey if winget unavailable
- Only prompts for manual install if both fail
- Refreshes PATH after installation

### 4. PowerShell Command Syntax Fix
- Changed from `irm ... | iex` (doesn't support Read-Host)
- Changed to `iex (irm ...)` (proper syntax with interactive support)
- Parentheses are required for Read-Host prompts to work

---

## 🎯 User Experience Improvements

### Before → After

**Installation:**
- Before: Manual Git install, manual Python setup, multiple commands
- After: One command, everything automated

**Monitoring:**
- Before: Unclear which script to use
- After: Clear PRIMARY (dashboard) vs SECONDARY (status check) guidance

**Auto-Start:**
- Before: User had to type "Y" or "n"
- After: Just press Enter (defaults to YES)

**Repository:**
- Before: 36+ files, confusing VBS scripts
- After: 23 essential files, clean structure

**Documentation:**
- Before: Verbose, scattered information
- After: Concise, well-organized with clear hierarchy

---

## 📁 Final File Structure

### Core Application (4 files)
- `miner.py` - Main mining application
- `export_skeys.py` - Wallet key exporter
- `resubmit_solutions.py` - Retry failed solutions
- `requirements.txt` - Dependencies

### Documentation (6 files)
- `README.md` - Main guide with one-line installers
- `UNIFIED_INSTALLER_README.md` - Detailed installer features
- `BACKGROUND_MINING.md` - Windows background mining guide
- `EasyGuide.md` - Beginner-friendly walkthrough
- `QUICK_START.md` - Multi-machine setup
- `SETUP_GUIDE.md` - Detailed installation guide

### Installation Scripts (3 files)
- `SETUP.ps1` - Windows one-line installer
- `setup.sh` - Linux/Mac one-line installer
- `Night-Miner.ps1` - Interactive menu system
- `EASY_INSTALL.bat` - One-click Windows installer

### Support Scripts (6 files)
- `check_miner_status.ps1` - Quick status check
- `stop_miner.ps1` - Stop all miners
- `install_startup.ps1` - Auto-start manager
- `run_miner_background.ps1` - Background launcher
- `setup_with_uv.ps1` - UV-based setup

### Binary Libraries (4 files)
- `ashmaize_py.pyd` - Windows mining library
- `ashmaize_py.so` - Linux mining library
- `ashmaize_py_mac.so` - MacOS mining library
- `ashmaize_web_bg.wasm` - Web assembly module

**Total: 23 essential files** (down from 36+)

---

## 🚀 Installation Flow

1. **[1/7]** Check/Install Git (automated via winget/chocolatey)
2. **[2/7]** Clone/Update NightMiner repository
3. **[3/7]** Install UV package manager (10-30x faster than pip)
4. **[4/7]** Setup Python virtual environment
5. **[5/7]** Install all dependencies
6. **[6/7]** Configure workers (interactive, recommends 75% of CPU)
7. **[7/7]** Auto-start configuration (defaults to YES)

**Result:** Miner starts immediately in background, ready to earn NIGHT tokens!

---

## 💡 Key Highlights

✅ **3-Step Installation**: Open PowerShell → Paste command → Press Enter  
✅ **Fully Automated**: Git, UV, Python, dependencies all auto-installed  
✅ **Clean Repository**: 13 junk files removed, professional structure  
✅ **Enhanced Dashboard**: Real-time stats, always shows NIGHT balance  
✅ **Smart Defaults**: Auto-start YES, 75% CPU workers  
✅ **Mining Cutoff**: Automatically stops after Nov 21, 2025  
✅ **Clear Guidance**: PRIMARY (dashboard) vs SECONDARY (status check)  
✅ **Cross-Platform**: Windows, Linux, MacOS support  

---

## 📝 Migration Notes

### For Existing Users

If you're updating from an older version:

1. **Backup your wallets:**
   ```bash
   cp wallets.json wallets_backup.json
   ```

2. **Update to latest version:**
   ```bash
   git pull
   ```

3. **Old scripts still work** but the new one-line installer is recommended for fresh setups

4. **Dashboard improvements** are automatic - just run `python miner.py` as usual

---

## 🙏 Acknowledgments

Thank you to all miners who provided feedback and suggestions that made this release possible!

---

## 🔗 Links

- **Repository**: https://github.com/rickachiu/NightMiner
- **Issues**: https://github.com/rickachiu/NightMiner/issues
- **Midnight Network**: https://midnight.network/

---

*Last Updated: January 15, 2025*
