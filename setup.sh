#!/bin/bash
# NightMiner - One-Line Setup Script for Linux/MacOS
# Usage: curl -sSL https://raw.githubusercontent.com/rickachiu/NightMiner/main/setup.sh | bash

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

echo -e "${CYAN}"
echo "╔══════════════════════════════════════════════════════════╗"
echo "║           NIGHT MINER - One-Line Installer               ║"
echo "╚══════════════════════════════════════════════════════════╝"
echo -e "${NC}"

# Check if Git is installed
echo -e "${CYAN}[1/6] Checking for Git...${NC}"
if ! command -v git &> /dev/null; then
    echo -e "${RED}  ✗ Git is not installed.${NC}"
    echo ""
    echo -e "${YELLOW}  Please install Git first:${NC}"
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        echo -e "${NC}    Ubuntu/Debian: sudo apt-get install git${NC}"
        echo -e "${NC}    Fedora/RHEL:   sudo dnf install git${NC}"
        echo -e "${NC}    Arch:          sudo pacman -S git${NC}"
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        echo -e "${NC}    Install Xcode Command Line Tools: xcode-select --install${NC}"
        echo -e "${NC}    Or install Homebrew and run: brew install git${NC}"
    fi
    echo ""
    exit 1
fi
echo -e "${GREEN}  ✓ Git is installed${NC}"

# Clone or update repository
echo -e "${CYAN}\n[2/6] Getting NightMiner...${NC}"
if [ -d "NightMiner" ]; then
    echo -e "${YELLOW}  Updating existing installation...${NC}"
    cd NightMiner
    git pull
else
    git clone https://github.com/rickachiu/NightMiner.git
    cd NightMiner
fi
echo -e "${GREEN}  ✓ NightMiner downloaded${NC}"

# Detect MacOS and handle library
if [[ "$OSTYPE" == "darwin"* ]]; then
    echo -e "${CYAN}\n[MacOS] Configuring mining library...${NC}"
    if [ -f "ashmaize_py_mac.so" ]; then
        rm -f ashmaize_py.so
        mv ashmaize_py_mac.so ashmaize_py.so
        echo -e "${GREEN}  ✓ MacOS library configured${NC}"
    fi
fi

# Install UV
echo -e "${CYAN}\n[3/6] Installing UV (fast package manager)...${NC}"
if ! command -v uv &> /dev/null; then
    curl -LsSf https://astral.sh/uv/install.sh | sh
    export PATH="$HOME/.cargo/bin:$PATH"
    echo -e "${GREEN}  ✓ UV installed${NC}"
else
    echo -e "${GREEN}  ✓ UV already installed${NC}"
fi

# Setup Python environment
echo -e "${CYAN}\n[4/6] Setting up Python environment...${NC}"
if [ ! -d ".venv" ]; then
    uv venv
    echo -e "${GREEN}  ✓ Virtual environment created${NC}"
else
    echo -e "${GREEN}  ✓ Virtual environment exists${NC}"
fi

# Install dependencies
echo -e "${CYAN}\n[5/6] Installing dependencies...${NC}"
uv pip install -r requirements.txt
echo -e "${GREEN}  ✓ Dependencies installed${NC}"

# Configure workers
echo -e "${CYAN}\n[6/6] Configuring workers...${NC}"
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    CORES=$(nproc)
elif [[ "$OSTYPE" == "darwin"* ]]; then
    CORES=$(sysctl -n hw.logicalcpu)
else
    CORES=4
fi

RECOMMENDED=$((CORES * 3 / 4))
if [ $RECOMMENDED -lt 1 ]; then
    RECOMMENDED=1
fi

echo -e "\n${NC}  Detected $CORES CPU cores${NC}"
echo -e "${NC}  Recommended workers: $RECOMMENDED (75% of CPU)${NC}"
echo -e "\n${YELLOW}  Worker count options:${NC}"
echo -e "${NC}    • Light (50%):   $((CORES / 2)) workers${NC}"
echo -e "${GREEN}    • Balanced (75%): $RECOMMENDED workers (recommended)${NC}"
echo -e "${NC}    • Maximum (100%): $CORES workers${NC}"

echo -e "\n${CYAN}  How many workers? [default: $RECOMMENDED]: ${NC}"
read -r WORKERS
if [ -z "$WORKERS" ]; then
    WORKERS=$RECOMMENDED
fi

echo -e "${GREEN}  ✓ Configured for $WORKERS workers${NC}"

# Create systemd service for Linux
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    echo -e "\n${CYAN}  Enable auto-start on boot? (Y/n) [default: Y]: ${NC}"
    read -r AUTO_START
    if [ -z "$AUTO_START" ]; then
        AUTO_START="Y"
    fi
    if [ "$AUTO_START" != "n" ] && [ "$AUTO_START" != "N" ]; then
        SERVICE_FILE="$HOME/.config/systemd/user/nightminer.service"
        mkdir -p "$HOME/.config/systemd/user"
        
        cat > "$SERVICE_FILE" << EOF
[Unit]
Description=NightMiner - Midnight Network Token Miner
After=network.target

[Service]
Type=simple
WorkingDirectory=$(pwd)
ExecStart=$(pwd)/.venv/bin/python $(pwd)/miner.py --workers $WORKERS
Restart=always
RestartSec=10

[Install]
WantedBy=default.target
EOF
        
        systemctl --user daemon-reload
        systemctl --user enable nightminer.service
        echo -e "${GREEN}  ✓ Auto-start enabled (systemd service)${NC}"
    fi
fi

# Create launch agent for MacOS
if [[ "$OSTYPE" == "darwin"* ]]; then
    echo -e "\n${CYAN}  Enable auto-start on boot? (Y/n) [default: Y]: ${NC}"
    read -r AUTO_START
    if [ -z "$AUTO_START" ]; then
        AUTO_START="Y"
    fi
    if [ "$AUTO_START" != "n" ] && [ "$AUTO_START" != "N" ]; then
        PLIST_FILE="$HOME/Library/LaunchAgents/com.nightminer.plist"
        mkdir -p "$HOME/Library/LaunchAgents"
        
        cat > "$PLIST_FILE" << EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>com.nightminer</string>
    <key>ProgramArguments</key>
    <array>
        <string>$(pwd)/.venv/bin/python</string>
        <string>$(pwd)/miner.py</string>
        <string>--workers</string>
        <string>$WORKERS</string>
    </array>
    <key>WorkingDirectory</key>
    <string>$(pwd)</string>
    <key>RunAtLoad</key>
    <true/>
    <key>KeepAlive</key>
    <true/>
    <key>StandardOutPath</key>
    <string>$(pwd)/miner.log</string>
    <key>StandardErrorPath</key>
    <string>$(pwd)/miner.log</string>
</dict>
</plist>
EOF
        
        launchctl load "$PLIST_FILE"
        echo -e "${GREEN}  ✓ Auto-start enabled (launchd service)${NC}"
    fi
fi

# Installation complete
echo -e "\n${GREEN}"
echo "╔══════════════════════════════════════════════════════════╗"
echo "║              ✓ Installation Complete!                   ║"
echo "╚══════════════════════════════════════════════════════════╝"
echo -e "${NC}"

echo -e "${NC}  📊 Your NightMiner is configured with:${NC}"
echo -e "${CYAN}    • $WORKERS workers${NC}"
if [ "$AUTO_START" != "n" ] && [ "$AUTO_START" != "N" ]; then
    echo -e "${CYAN}    • Auto-start: Enabled${NC}"
else
    echo -e "${CYAN}    • Auto-start: Disabled${NC}"
fi

echo -e "\n${YELLOW}  🚀 Starting miner now...${NC}"
.venv/bin/python miner.py --workers $WORKERS > /dev/null 2>&1 &
sleep 2

echo -e "\n${GREEN}  ✓ Miner is running in background!${NC}"
echo -e "${YELLOW}     (Mining ends Nov 21, 2025 - airdrop cutoff)${NC}"
echo -e "\n${NC}  📋 Useful commands:${NC}"
echo -e "${CYAN}    • Check status:  ps aux | grep miner.py${NC}"
echo -e "${CYAN}    • Stop miner:    pkill -f miner.py${NC}"
echo -e "${CYAN}    • View logs:     tail -f miner.log${NC}"
echo -e "${CYAN}    • Backup wallet: cp wallets.json backup.json${NC}"
echo -e "${CYAN}    • Update:        git pull${NC}"

echo -e "\n${YELLOW}  🌙 Happy mining!${NC}\n"
