# NightMiner Performance Modes

Choose the right performance mode for your needs!

## 🎚️ Available Modes:

### 🟢 LIGHT Mode (1 Worker)
**File:** `run_light.vbs`
- **CPU Usage:** ~25% (1 core)
- **RAM:** ~1 GB
- **Hash Rate:** ~800 H/s
- **Best for:** Laptops, active work sessions, low-end machines
- **Impact:** Minimal - system stays very responsive

### 🟡 MEDIUM Mode (2 Workers)
**File:** `run_medium.vbs`
- **CPU Usage:** ~50% (2 cores)
- **RAM:** ~2 GB
- **Hash Rate:** ~1,600 H/s
- **Best for:** Dual-core systems, background mining during work
- **Impact:** Moderate - system remains usable

### 🟠 BALANCED Mode (3 Workers) - **DEFAULT**
**File:** `run_miner_hidden.vbs`
- **CPU Usage:** ~75% (3 cores)
- **RAM:** ~3 GB
- **Hash Rate:** ~2,400 H/s
- **Best for:** Quad-core systems, general purpose mining
- **Impact:** Noticeable - some tasks may be slower

### 🔴 MAXIMUM Mode (4 Workers)
**File:** `run_maximum.vbs`
- **CPU Usage:** ~100% (4 cores)
- **RAM:** ~4 GB
- **Hash Rate:** ~3,200 H/s
- **Best for:** Dedicated mining, idle machines
- **Impact:** High - system may lag during use

---

## 🔄 How to Switch Modes:

1. **Stop current mining:**
   ```powershell
   .\stop_miner.ps1
   ```

2. **Start desired mode:**
   - Double-click the VBS file for your desired mode
   - Or use PowerShell:
     ```powershell
     python miner.py --workers 1  # Light
     python miner.py --workers 2  # Medium
     python miner.py --workers 3  # Balanced
     python miner.py --workers 4  # Maximum
     ```

3. **Check status:**
   ```powershell
   .\check_miner_status.ps1
   ```

---

## 🎯 Quick Mode Selection Guide:

| Situation | Recommended Mode | File to Use |
|-----------|------------------|-------------|
| Working actively on PC | LIGHT (1) | `run_light.vbs` |
| Browsing/light tasks | MEDIUM (2) | `run_medium.vbs` |
| Computer mostly idle | BALANCED (3) | `run_miner_hidden.vbs` |
| Computer dedicated to mining | MAXIMUM (4) | `run_maximum.vbs` |
| Laptop on battery | LIGHT (1) or stop mining | `run_light.vbs` |
| Overnight/weekend | MAXIMUM (4) | `run_maximum.vbs` |

---

## 💡 Pro Tips:

### Dynamic Adjustment Throughout Day:
- **9 AM - 5 PM:** LIGHT mode (working hours)
- **5 PM - 11 PM:** MEDIUM mode (evening browsing)
- **11 PM - 9 AM:** MAXIMUM mode (overnight)

### Task Scheduler Setup:
You can use Windows Task Scheduler to automatically switch modes:
```powershell
# Morning: Switch to LIGHT
schtasks /create /tn "Miner_Light" /tr "C:\apps\NightMiner\run_light.vbs" /sc daily /st 09:00

# Evening: Switch to MEDIUM  
schtasks /create /tn "Miner_Medium" /tr "C:\apps\NightMiner\run_medium.vbs" /sc daily /st 17:00

# Night: Switch to MAXIMUM
schtasks /create /tn "Miner_Maximum" /tr "C:\apps\NightMiner\run_maximum.vbs" /sc daily /st 23:00
```

### Monitor Impact:
- Open Task Manager (Ctrl+Shift+Esc)
- Watch CPU % and temperature
- If system lags, switch to lighter mode

---

## 🌡️ Temperature Monitoring:

If your machine gets hot:
1. Stop mining: `.\stop_miner.ps1`
2. Let it cool down
3. Ensure good ventilation
4. Restart with lighter mode
5. Consider cleaning dust from fans/vents

**Safe temperature range:** Under 80-85°C for CPU

---

## 🔧 Custom Worker Count:

For machines with different specs:

```powershell
# Direct command (any number of workers)
python miner.py --workers 6   # For 8-core CPU
python miner.py --workers 8   # For 12-core CPU
python miner.py --workers 12  # For 16+ core CPU
```

**Rule of thumb:** Use 75% of your core count for best balance.

---

**Choose your mode and start mining! 🌙**
