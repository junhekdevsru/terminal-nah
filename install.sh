#!/bin/bash

# 🍎 macOS Terminal Configuration - Automatic Installation Script
# Автоматическая установка красивой конфигурации терминала

set -e  # Остановить выполнение при любой ошибке

# Цвета для красивого вывода
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
NC='\033[0m' # No Color

# Эмоджи для красивого вывода
ROCKET="🚀"
STAR="⭐"
CHECKMARK="✅"
CROSS="❌"
GEAR="⚙️"
PACKAGE="📦"
FOLDER="📁"
FIRE="🔥"

print_header() {
    echo ""
    echo -e "${CYAN}=================================${NC}"
    echo -e "${WHITE}🍎 macOS Terminal Configuration${NC}"
    echo -e "${CYAN}=================================${NC}"
    echo ""
}

print_step() {
    echo -e "${BLUE}${GEAR} $1${NC}"
}

print_success() {
    echo -e "${GREEN}${CHECKMARK} $1${NC}"
}

print_error() {
    echo -e "${RED}${CROSS} $1${NC}"
}

print_info() {
    echo -e "${YELLOW}${STAR} $1${NC}"
}

# Проверка операционной системы
check_os() {
    print_step "Checking operating system..."
    if [[ "$OSTYPE" != "darwin"* ]]; then
        print_error "This script is designed for macOS only!"
        exit 1
    fi
    print_success "macOS detected"
}

# Проверка и установка Homebrew
install_homebrew() {
    print_step "Checking Homebrew..."
    if ! command -v brew &> /dev/null; then
        print_info "Installing Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        print_success "Homebrew installed"
    else
        print_success "Homebrew already installed"
    fi
}

# Установка WezTerm
install_wezterm() {
    print_step "Installing WezTerm..."
    if ! command -v wezterm &> /dev/null; then
        brew install --cask wezterm
        print_success "WezTerm installed"
    else
        print_success "WezTerm already installed"
    fi
}

# Установка Oh My Zsh
install_ohmyzsh() {
    print_step "Installing Oh My Zsh..."
    if [ ! -d "$HOME/.oh-my-zsh" ]; then
        print_info "Downloading and installing Oh My Zsh..."
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
        print_success "Oh My Zsh installed"
    else
        print_success "Oh My Zsh already installed"
    fi
}

# Установка плагинов Zsh
install_zsh_plugins() {
    print_step "Installing Zsh plugins..."
    
    # zsh-autosuggestions
    if [ ! -d "$HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions" ]; then
        print_info "Installing zsh-autosuggestions..."
        git clone https://github.com/zsh-users/zsh-autosuggestions ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions
        print_success "zsh-autosuggestions installed"
    else
        print_success "zsh-autosuggestions already installed"
    fi
    
    # zsh-syntax-highlighting
    if [ ! -d "$HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting" ]; then
        print_info "Installing zsh-syntax-highlighting..."
        git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting
        print_success "zsh-syntax-highlighting installed"
    else
        print_success "zsh-syntax-highlighting already installed"
    fi
}

# Создание резервных копий
create_backups() {
    print_step "Creating backups of existing configurations..."
    
    # Резервная копия .zshrc
    if [ -f "$HOME/.zshrc" ]; then
        cp "$HOME/.zshrc" "$HOME/.zshrc.backup.$(date +%Y%m%d_%H%M%S)"
        print_success "Backup created: ~/.zshrc.backup.$(date +%Y%m%d_%H%M%S)"
    fi
    
    # Резервная копия WezTerm конфига
    if [ -f "$HOME/.config/wezterm/wezterm.lua" ]; then
        mkdir -p "$HOME/.config/wezterm.backup"
        cp "$HOME/.config/wezterm/wezterm.lua" "$HOME/.config/wezterm.backup/wezterm.lua.backup.$(date +%Y%m%d_%H%M%S)"
        print_success "Backup created: ~/.config/wezterm.backup/"
    fi
}

# Применение конфигурации
apply_configs() {
    print_step "Applying terminal configurations..."
    
    # Создание директорий
    mkdir -p "$HOME/.config/wezterm"
    mkdir -p "$HOME/.oh-my-zsh/custom/themes"
    
    # Копирование файлов конфигурации
    print_info "Copying WezTerm configuration..."
    cp "wezterm/wezterm.lua" "$HOME/.config/wezterm/"
    print_success "WezTerm configuration applied"
    
    print_info "Copying Zsh configuration..."
    cp "zsh/.zshrc" "$HOME/.zshrc"
    print_success "Zsh configuration applied"
    
    print_info "Copying custom theme..."
    cp "themes/macos-style.zsh-theme" "$HOME/.oh-my-zsh/custom/themes/"
    print_success "Custom theme applied"
}

# Установка дополнительных инструментов
install_optional_tools() {
    print_step "Installing optional tools..."
    
    # Neovim (если не установлен)
    if ! command -v nvim &> /dev/null; then
        print_info "Installing Neovim..."
        brew install neovim
        print_success "Neovim installed"
    else
        print_success "Neovim already installed"
    fi
    
    # Git (обычно уже установлен на macOS)
    if ! command -v git &> /dev/null; then
        print_info "Installing Git..."
        brew install git
        print_success "Git installed"
    else
        print_success "Git already installed"
    fi
}

# Настройка Git (если нужно)
setup_git() {
    print_step "Checking Git configuration..."
    
    if ! git config --global user.name &> /dev/null; then
        print_info "Git user name not configured. You can set it later with:"
        echo "git config --global user.name 'Your Name'"
    fi
    
    if ! git config --global user.email &> /dev/null; then
        print_info "Git user email not configured. You can set it later with:"
        echo "git config --global user.email 'your.email@example.com'"
    fi
}

# Финальные шаги
finalize_installation() {
    print_step "Finalizing installation..."
    
    # Перезагрузка конфигурации Zsh
    print_info "Reloading Zsh configuration..."
    # Не можем напрямую перезагрузить в скрипте, но можем подготовить
    
    print_success "Installation completed successfully!"
    
    echo ""
    echo -e "${PURPLE}${STAR} Next steps:${NC}"
    echo -e "${WHITE}1. Close this terminal and open WezTerm${NC}"
    echo -e "${WHITE}2. Your new beautiful terminal is ready!${NC}"
    echo ""
    echo -e "${CYAN}${FIRE} Features enabled:${NC}"
    echo -e "${WHITE}• 🚀 Custom prompt with emojis${NC}"
    echo -e "${WHITE}• 📊 Real-time system monitoring${NC}"
    echo -e "${WHITE}• 🪟 Terminal multiplexing${NC}"
    echo -e "${WHITE}• 📁 Smart folder icons${NC}"
    echo -e "${WHITE}• 🔧 Useful aliases and shortcuts${NC}"
    echo ""
    echo -e "${GREEN}${CHECKMARK} Enjoy your new terminal experience!${NC}"
}

# Главная функция
main() {
    print_header
    
    print_info "This script will install and configure:"
    echo "• Homebrew (if not installed)"
    echo "• WezTerm terminal emulator"
    echo "• Oh My Zsh framework"
    echo "• Custom theme with emojis"
    echo "• Useful plugins and aliases"
    echo "• System monitoring"
    echo ""
    
    read -p "Do you want to continue? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        print_info "Installation cancelled by user"
        exit 0
    fi
    
    echo ""
    print_info "Starting installation..."
    
    check_os
    install_homebrew
    install_wezterm
    install_ohmyzsh
    install_zsh_plugins
    create_backups
    apply_configs
    install_optional_tools
    setup_git
    finalize_installation
}

# Запуск скрипта
main "$@"
