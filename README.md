# 🍎 macOS Terminal Configuration

Красивая и функциональная конфигурация терминала для macOS с **WezTerm** и **Zsh**.

## 🎯 Особенности

### 🚀 **WezTerm**
- 📊 **Мониторинг системы в реальном времени** (CPU & RAM)
- 🪟 **Мультиплексинг** (вкладки и панели)
- ⚡ **Горячие клавиши** в стиле macOS
- 🎨 **Цветовая тема** Catppuccin Mocha
- 🫥 **Полупрозрачный фон** для стильного вида

### 🌈 **Zsh с Oh My Zsh**
- 🚀 **Кастомная тема** с эмоджи вместо обычного `$`
- 📁 **Умные иконки** для разных типов папок
- 🌱 **Git интеграция** с цветовой индикацией статуса
- 🐍 **Поддержка виртуальных сред** Python
- 🕐 **Время в правом углу**
- 🔧 **Полезные алиасы** для повседневной работы

## 📸 Скриншоты

> *Добавьте скриншоты в папку `screenshots/`*

## 🛠 Установка

### 🚀 Автоматическая установка (Рекомендуется)

**Установка одной командой:**

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/junhekdevsru/terminal-nah/main/quick-install.sh)
```

**Или клонируйте репозиторий и запустите скрипт:**

```bash
git clone https://github.com/junhekdevsru/terminal-nah.git
cd terminal-nah
./install.sh
```

### 🔧 Что делает скрипт установки:

- ✅ Проверяет совместимость с macOS
- ✅ Устанавливает Homebrew (если не установлен)
- ✅ Устанавливает WezTerm
- ✅ Устанавливает Oh My Zsh
- ✅ Устанавливает необходимые плагины
- ✅ Создает резервные копии существующих конфигураций
- ✅ Применяет новые конфигурации
- ✅ Устанавливает дополнительные инструменты (Neovim, Git)

---

### 📝 Ручная установка

<details>
<summary>Нажмите для просмотра инструкций по ручной установке</summary>

#### 1. Установка WezTerm

```bash
brew install --cask wezterm
```

#### 2. Установка Oh My Zsh

```bash
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```

#### 3. Установка плагинов

```bash
# Автодополнение
git clone https://github.com/zsh-users/zsh-autosuggestions ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions

# Подсветка синтаксиса
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting
```

#### 4. Применение конфигурации

```bash
# Клонируем репозиторий
git clone https://github.com/junhekdevsru/terminal-nah.git ~/terminal-config

# Создаем папку для WezTerm
mkdir -p ~/.config/wezterm

# Копируем конфигурационные файлы
cp ~/terminal-config/wezterm/wezterm.lua ~/.config/wezterm/
cp ~/terminal-config/zsh/.zshrc ~/.zshrc
cp ~/terminal-config/themes/macos-style.zsh-theme ~/.oh-my-zsh/custom/themes/

# Перезагружаем конфигурацию
source ~/.zshrc
```

</details>

## 🎮 Горячие клавиши WezTerm

### 📑 Управление вкладками
- `Cmd+T` - Создать новую вкладку
- `Cmd+W` - Закрыть вкладку
- `Cmd+1-9` - Переключиться на вкладку по номеру
- `Cmd+[` / `Cmd+]` - Предыдущая/следующая вкладка

### 🪟 Управление панелями
- `Cmd+D` - Горизонтальный split (панель справа)
- `Cmd+Shift+D` - Вертикальный split (панель снизу)
- `Cmd+Shift+W` - Закрыть панель
- `Cmd+Shift+H/J/K/L` - Навигация между панелями (vim-style)
- `Cmd+Shift+Стрелки` - Изменение размера панелей

### 🔧 Утилиты
- `Cmd+F` - Поиск
- `Cmd+C/V` - Копирование/вставка
- `Cmd+Enter` - Полноэкранный режим
- `Cmd+,` - Открыть конфиг в nvim
- `Cmd+Shift+R` - Перезагрузить конфигурацию

## 🎨 Иконки папок

Тема автоматически определяет тип папки и показывает соответствующую иконку:

- 🖥️ Desktop
- 📄 Documents
- 📥 Downloads
- 🎵 Music
- 🖼️ Pictures
- 📹 Videos
- ⚙️ .config
- 🔐 .ssh
- 📦 Node.js проекты (package.json)
- 🐍 Python проекты (requirements.txt, pyproject.toml)
- 🦀 Rust проекты (Cargo.toml)
- 🐹 Go проекты (go.mod)
- 🐳 Docker проекты (Dockerfile)
- 🌱 Git репозитории

## 📋 Полезные алиасы

### 🚀 Git
```bash
gs     # git status
ga     # git add
gc     # git commit
gp     # git push
gl     # git log --oneline --graph --decorate
gd     # git diff
gb     # git branch
gco    # git checkout
```

### 📁 Навигация
```bash
desktop    # cd ~/Desktop
downloads  # cd ~/Downloads
documents  # cd ~/Documents
home       # cd ~
..         # cd ..
...        # cd ../..
....       # cd ../../..
```

### 🧹 Система
```bash
cls        # clear
ll         # ls -alF
la         # ls -A
reload     # source ~/.zshrc
```

### 📦 Пакеты
```bash
brewup     # brew update && brew upgrade
brewclean  # brew cleanup
```

### 🎨 Развлечения
```bash
weather    # curl wttr.in
joke       # случайная шутка
myip       # показать внешний IP
```

## 📊 Мониторинг системы

В правом верхнем углу WezTerm отображается:

- 🔥 **CPU**: Загрузка процессора с цветовой индикацией
  - 🔥 Зелёный (< 50%) - нормальная загрузка
  - 🌡️ Оранжевый (50-80%) - умеренная загрузка
  - ⚡ Красный (> 80%) - высокая загрузка

- 🧠 **RAM**: Использование памяти в GB
  - 🧠 Зелёный (< 8GB) - нормальное использование
  - 🗄️ Оранжевый (8-12GB) - умеренное использование
  - 💾 Красный (> 12GB) - высокое использование

## 🔧 Настройка

### Изменение цветовой темы WezTerm

В файле `wezterm/wezterm.lua` найдите строку:
```lua
config.color_scheme = "Catppuccin Mocha"
```

Замените на одну из доступных тем:
- `"Tokyo Night"`
- `"Nightfox"`
- `"OneDark (base16)"`
- `"Dracula"`

### Изменение интервала обновления мониторинга

```lua
config.status_update_interval = 1000  -- миллисекунды
```

### Изменение прозрачности фона

```lua
config.window_background_opacity = 0.92  -- от 0.0 до 1.0
```

## 🐛 Устранение неполадок

### WezTerm не запускается
- Проверьте синтаксис `wezterm.lua`
- Убедитесь, что все пути указаны правильно

### Тема не загружается
- Проверьте, что файл темы находится в `~/.oh-my-zsh/custom/themes/`
- Убедитесь, что в `.zshrc` указано правильное имя темы

### Плагины не работают
- Убедитесь, что плагины установлены в правильные папки
- Перезапустите терминал после установки

## 🤝 Вклад в проект

Если у вас есть идеи по улучшению конфигурации:

1. Форкните репозиторий
2. Создайте ветку для ваших изменений
3. Сделайте коммит с изменениями
4. Создайте Pull Request

## 📄 Лицензия

MIT License - используйте как хотите! 🎉

## 🙏 Благодарности

- [WezTerm](https://wezfurlong.org/wezterm/) - отличный терминал
- [Oh My Zsh](https://ohmyz.sh/) - мощный фреймворк для Zsh
- [Catppuccin](https://github.com/catppuccin) - красивая цветовая тема

---

**Сделано с ❤️ для красивого терминала на macOS**
