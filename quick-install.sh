#!/bin/bash

# 🚀 Quick Install Script - macOS Terminal Configuration
# Быстрая установка одной командой из GitHub

set -e

# Цвета
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${BLUE}🚀 Quick installing macOS Terminal Configuration...${NC}"

# Проверка macOS
if [[ "$OSTYPE" != "darwin"* ]]; then
    echo -e "${RED}❌ This script is for macOS only!${NC}"
    exit 1
fi

# Временная директория
TEMP_DIR=$(mktemp -d)
cd "$TEMP_DIR"

echo -e "${YELLOW}📥 Downloading configuration...${NC}"

# Клонирование репозитория
git clone https://github.com/junhekdevsru/terminal-nah.git
cd terminal-nah

echo -e "${YELLOW}🔧 Running installation...${NC}"

# Запуск основного скрипта установки
bash install.sh

# Очистка
cd "$HOME"
rm -rf "$TEMP_DIR"

echo -e "${GREEN}✅ Installation completed!${NC}"
echo -e "${BLUE}🎉 Open WezTerm and enjoy your new terminal!${NC}"
echo ""
echo -e "${YELLOW}⭐ New S-MON features available:${NC}"
echo -e "${GREEN}• s-mon          - System monitoring with graphs${NC}"
echo -e "${GREEN}• s-mon web      - Web interface with interactive charts${NC}"
echo -e "${GREEN}• s-mon compact  - Compact mode for corner monitoring${NC}"
echo ""
