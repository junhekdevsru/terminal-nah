#!/bin/bash

# 🚀 Terminal Configuration Manager - macOS
# Интерактивное меню для управления конфигурацией терминала

set -e

# Цвета для красивого вывода
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
GRAY='\033[0;90m'
NC='\033[0m' # No Color

# Папка для бэкапов
BACKUP_DIR="$HOME/.terminal-config-backups"

# Функции для вывода
print_header() {
    clear
    echo -e "${CYAN}╭───────────────────────────────────────────────────────╮${NC}"
    echo -e "${CYAN}│${WHITE}                 🍎 Terminal Configuration Manager                ${CYAN}│${NC}"
    echo -e "${CYAN}│${GRAY}                   Менеджер конфигурации терминала                   ${CYAN}│${NC}"
    echo -e "${CYAN}╰───────────────────────────────────────────────────────╯${NC}"
    echo ""
}

print_success() {
    echo -e "${GREEN}✓ $1${NC}"
}

print_error() {
    echo -e "${RED}✗ $1${NC}"
}

print_info() {
    echo -e "${BLUE}ℹ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠ $1${NC}"
}

# Проверка операционной системы
check_macos() {
    if [[ "$OSTYPE" != "darwin"* ]]; then
        print_error "This script is for macOS only!"
        exit 1
    fi
}

# Создание бэкапа текущей конфигурации
create_backup() {
    print_header
    echo -e "${YELLOW}💾 Создание бэкапа текущей конфигурации...${NC}"
    echo ""
    
    local backup_timestamp=$(date +"%Y%m%d_%H%M%S")
    local backup_path="$BACKUP_DIR/backup_$backup_timestamp"
    
    # Создание папки для бэкапов
    mkdir -p "$backup_path"
    
    # Бэкап .zshrc
    if [ -f "$HOME/.zshrc" ]; then
        cp "$HOME/.zshrc" "$backup_path/.zshrc"
        print_success "Zsh конфигурация сохранена"
    fi
    
    # Бэкап WezTerm конфига
    if [ -f "$HOME/.config/wezterm/wezterm.lua" ]; then
        mkdir -p "$backup_path/.config/wezterm"
        cp "$HOME/.config/wezterm/wezterm.lua" "$backup_path/.config/wezterm/wezterm.lua"
        print_success "WezTerm конфигурация сохранена"
    fi
    
    # Бэкап кастомных тем
    if [ -d "$HOME/.oh-my-zsh/custom/themes" ]; then
        mkdir -p "$backup_path/.oh-my-zsh/custom"
        cp -r "$HOME/.oh-my-zsh/custom/themes" "$backup_path/.oh-my-zsh/custom/"
        print_success "Кастомные темы сохранены"
    fi
    
    # Бэкап плагинов
    if [ -d "$HOME/.oh-my-zsh/custom/plugins" ]; then
        mkdir -p "$backup_path/.oh-my-zsh/custom"
        cp -r "$HOME/.oh-my-zsh/custom/plugins" "$backup_path/.oh-my-zsh/custom/"
        print_success "Кастомные плагины сохранены"
    fi
    
    echo ""
    print_success "Бэкап создан: $backup_path"
    echo ""
    
    # Сохраняем путь к последнему бэкапу
    echo "$backup_path" > "$BACKUP_DIR/.last_backup"
    
    read -p "Нажмите Enter для продолжения..."
}

# Установка новой конфигурации
install_new_config() {
    print_header
    echo -e "${GREEN}🚀 Установка новой конфигурации терминала...${NC}"
    echo ""
    
    # Временная директория
    local temp_dir=$(mktemp -d)
    cd "$temp_dir"
    
    print_info "Загрузка конфигурации с GitHub..."
    
    # Клонирование репозитория
    if git clone https://github.com/junhekdevsru/terminal-nah.git > /dev/null 2>&1; then
        print_success "Конфигурация загружена"
    else
        print_error "Ошибка при загрузке конфигурации"
        return 1
    fi
    
    cd terminal-nah
    
    print_info "Запуск скрипта установки..."
    echo ""
    
    # Запуск основного скрипта установки
    bash install.sh
    
    # Очистка
    cd "$HOME"
    rm -rf "$temp_dir"
    
    echo ""
    print_success "Конфигурация успешно установлена!"
    echo ""
    echo -e "${YELLOW}⭐ Новые возможности S-MON:${NC}"
    echo -e "${GREEN}• s-mon          - Мониторинг системы с графиками${NC}"
    echo -e "${GREEN}• s-mon web      - Веб-интерфейс с интерактивными графиками${NC}"
    echo -e "${GREEN}• s-mon compact  - Компактный режим для мониторинга в углу${NC}"
    echo ""
    
    read -p "Нажмите Enter для продолжения..."
}

# Восстановление старой конфигурации
restore_backup() {
    print_header
    echo -e "${PURPLE}🔄 Восстановление ранее сохранённой конфигурации...${NC}"
    echo ""
    
    # Проверяем наличие бэкапов
    if [ ! -d "$BACKUP_DIR" ] || [ -z "$(ls -A "$BACKUP_DIR" 2>/dev/null | grep -v '.last_backup')" ]; then
        print_warning "Не найдено ни одного бэкапа"
        echo ""
        read -p "Нажмите Enter для возврата в меню..."
        return
    fi
    
    echo -e "${YELLOW}Доступные бэкапы:${NC}"
    echo ""
    
    local backup_count=0
    local backup_list=()
    
    # Создаём список бэкапов
    for backup_dir in "$BACKUP_DIR"/backup_*; do
        if [ -d "$backup_dir" ]; then
            backup_count=$((backup_count + 1))
            backup_list+=("$backup_dir")
            local backup_name=$(basename "$backup_dir")
            local backup_date=$(echo "$backup_name" | sed 's/backup_//' | sed 's/_/ /')
            echo -e "${WHITE}$backup_count.${NC} Бэкап от $backup_date"
        fi
    done
    
    if [ $backup_count -eq 0 ]; then
        print_warning "Не найдено ни одного бэкапа"
        echo ""
        read -p "Нажмите Enter для возврата в меню..."
        return
    fi
    
    echo ""
    echo -e "${WHITE}0.${NC} Отмена"
    echo ""
    
    while true; do
        read -p "Выберите бэкап для восстановления (1-$backup_count, 0 - отмена): " choice
        
        if [ "$choice" = "0" ]; then
            return
        elif [ "$choice" -ge 1 ] && [ "$choice" -le $backup_count ]; then
            local selected_backup="${backup_list[$((choice-1))]}"
            break
        else
            print_error "Некорректный выбор"
        fi
    done
    
    echo ""
    print_info "Восстановление из $selected_backup..."
    
    # Восстановление .zshrc
    if [ -f "$selected_backup/.zshrc" ]; then
        cp "$selected_backup/.zshrc" "$HOME/.zshrc"
        print_success "Zsh конфигурация восстановлена"
    fi
    
    # Восстановление WezTerm конфига
    if [ -f "$selected_backup/.config/wezterm/wezterm.lua" ]; then
        mkdir -p "$HOME/.config/wezterm"
        cp "$selected_backup/.config/wezterm/wezterm.lua" "$HOME/.config/wezterm/wezterm.lua"
        print_success "WezTerm конфигурация восстановлена"
    fi
    
    # Восстановление кастомных тем
    if [ -d "$selected_backup/.oh-my-zsh/custom/themes" ]; then
        mkdir -p "$HOME/.oh-my-zsh/custom"
        rm -rf "$HOME/.oh-my-zsh/custom/themes"
        cp -r "$selected_backup/.oh-my-zsh/custom/themes" "$HOME/.oh-my-zsh/custom/"
        print_success "Кастомные темы восстановлены"
    fi
    
    # Восстановление плагинов
    if [ -d "$selected_backup/.oh-my-zsh/custom/plugins" ]; then
        mkdir -p "$HOME/.oh-my-zsh/custom"
        rm -rf "$HOME/.oh-my-zsh/custom/plugins"
        cp -r "$selected_backup/.oh-my-zsh/custom/plugins" "$HOME/.oh-my-zsh/custom/"
        print_success "Кастомные плагины восстановлены"
    fi
    
    echo ""
    print_success "Конфигурация успешно восстановлена!"
    echo ""
    
    read -p "Нажмите Enter для продолжения..."
}

# Показ списка бэкапов
list_backups() {
    print_header
    echo -e "${CYAN}📁 Список сохранённых бэкапов${NC}"
    echo ""
    
    if [ ! -d "$BACKUP_DIR" ] || [ -z "$(ls -A "$BACKUP_DIR" 2>/dev/null | grep -v '.last_backup')" ]; then
        print_warning "Не найдено ни одного бэкапа"
        echo ""
        read -p "Нажмите Enter для возврата в меню..."
        return
    fi
    
    echo -e "${WHITE}Папка бэкапов: ${CYAN}$BACKUP_DIR${NC}"
    echo ""
    
    for backup_dir in "$BACKUP_DIR"/backup_*; do
        if [ -d "$backup_dir" ]; then
            local backup_name=$(basename "$backup_dir")
            local backup_date=$(echo "$backup_name" | sed 's/backup_//' | sed 's/_/ /')
            local backup_size=$(du -sh "$backup_dir" | cut -f1)
            echo -e "${GREEN}•${NC} ${WHITE}Бэкап от $backup_date${NC} ${GRAY}($backup_size)${NC}"
            
            # Показываем содержимое бэкапа
            if [ -f "$backup_dir/.zshrc" ]; then
                echo -e "  ${GRAY}✓ Zsh конфигурация${NC}"
            fi
            if [ -f "$backup_dir/.config/wezterm/wezterm.lua" ]; then
                echo -e "  ${GRAY}✓ WezTerm конфигурация${NC}"
            fi
            if [ -d "$backup_dir/.oh-my-zsh/custom/themes" ]; then
                echo -e "  ${GRAY}✓ Кастомные темы${NC}"
            fi
            if [ -d "$backup_dir/.oh-my-zsh/custom/plugins" ]; then
                echo -e "  ${GRAY}✓ Кастомные плагины${NC}"
            fi
            echo ""
        fi
    done
    
    read -p "Нажмите Enter для возврата в меню..."
}

# Очистка старых бэкапов
clean_backups() {
    print_header
    echo -e "${RED}🗑️  Очистка старых бэкапов${NC}"
    echo ""
    
    if [ ! -d "$BACKUP_DIR" ] || [ -z "$(ls -A "$BACKUP_DIR" 2>/dev/null | grep -v '.last_backup')" ]; then
        print_warning "Не найдено ни одного бэкапа для удаления"
        echo ""
        read -p "Нажмите Enter для возврата в меню..."
        return
    fi
    
    local backup_count=$(ls -1 "$BACKUP_DIR"/backup_* 2>/dev/null | wc -l)
    local total_size=$(du -sh "$BACKUP_DIR" 2>/dev/null | cut -f1)
    
    echo -e "${WHITE}Найдено бэкапов: ${YELLOW}$backup_count${NC}"
    echo -e "${WHITE}Общий размер: ${YELLOW}$total_size${NC}"
    echo ""
    
    print_warning "Это действие удалит ВСЕ сохранённые бэкапы!"
    echo ""
    
    read -p "Вы уверены? (введите 'yes' для подтверждения): " confirm
    
    if [ "$confirm" = "yes" ]; then
        rm -rf "$BACKUP_DIR"
        print_success "Все бэкапы успешно удалены"
    else
        print_info "Очистка отменена"
    fi
    
    echo ""
    read -p "Нажмите Enter для возврата в меню..."
}

# Основное меню
show_main_menu() {
    while true; do
        print_header
        echo -e "${WHITE}Выберите действие:${NC}"
        echo ""
        echo -e "${GREEN}1.${NC} 💾 Создать бэкап текущей конфигурации"
        echo -e "${GREEN}2.${NC} 🚀 Установить новую конфигурацию (с GitHub)"
        echo -e "${GREEN}3.${NC} 🔄 Восстановить старую конфигурацию из бэкапа"
        echo -e "${GREEN}4.${NC} 📁 Посмотреть список бэкапов"
        echo -e "${GREEN}5.${NC} 🗑️  Очистить все бэкапы"
        echo -e "${GREEN}0.${NC} ❌ Выход"
        echo ""
        
        read -p "Ваш выбор (0-5): " choice
        
        case $choice in
            1)
                create_backup
                ;;
            2)
                install_new_config
                ;;
            3)
                restore_backup
                ;;
            4)
                list_backups
                ;;
            5)
                clean_backups
                ;;
            0)
                print_header
                echo -e "${GREEN}✓ Спасибо за использование Terminal Configuration Manager!${NC}"
                echo -e "${BLUE}🍎 Откройте WezTerm и наслаждайтесь новым терминалом!${NC}"
                echo ""
                exit 0
                ;;
            *)
                print_error "Некорректный выбор"
                sleep 1
                ;;
        esac
    done
}

# Основная функция
main() {
    check_macos
    show_main_menu
}

# Запуск скрипта
main "$@"
