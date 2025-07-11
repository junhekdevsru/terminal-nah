# 🍎 macOS Style Theme for Oh My Zsh
# Красивый промпт с эмоджи в стиле macOS

# Цвета
local blue="%F{75}"
local green="%F{76}"
local orange="%F{214}"
local red="%F{196}"
local purple="%F{135}"
local pink="%F{211}"
local yellow="%F{226}"
local gray="%F{242}"
local white="%F{255}"
local reset="%f"

# Функция для статуса git
function git_prompt_info() {
  if git rev-parse --git-dir > /dev/null 2>&1; then
    local branch=$(git branch 2>/dev/null | grep '^*' | colrm 1 2)
    local status=""
    
    # Проверяем статус репозитория
    if [[ $(git status --porcelain 2>/dev/null) ]]; then
      status="${red}● ${reset}"  # Есть изменения
    else
      status="${green}● ${reset}"  # Чистый репозиторий
    fi
    
    echo " ${gray}on ${purple}🌱 ${branch}${reset} ${status}"
  fi
}

# Функция для виртуальной среды Python
function virtualenv_info() {
  if [[ -n "$VIRTUAL_ENV" ]]; then
    echo " ${blue}🐍 $(basename $VIRTUAL_ENV)${reset}"
  fi
}

# Функция для определения типа директории
function directory_icon() {
  local current_dir=$(basename "$PWD")
  
  case $current_dir in
    "Desktop")     echo "🖥️ " ;;
    "Documents")   echo "📄 " ;;
    "Downloads")   echo "📥 " ;;
    "Music")       echo "🎵 " ;;
    "Pictures")    echo "🖼️ " ;;
    "Videos")      echo "📹 " ;;
    "Applications") echo "📱 " ;;
    "Library")     echo "📚 " ;;
    ".config")     echo "⚙️ " ;;
    ".ssh")        echo "🔐 " ;;
    "node_modules") echo "📦 " ;;
    ".git")        echo "🌱 " ;;
    *)             
      if [[ -f "package.json" ]]; then
        echo "📦 "
      elif [[ -f "Cargo.toml" ]]; then
        echo "🦀 "
      elif [[ -f "go.mod" ]]; then
        echo "🐹 "
      elif [[ -f "requirements.txt" ]] || [[ -f "pyproject.toml" ]]; then
        echo "🐍 "
      elif [[ -f "Dockerfile" ]]; then
        echo "🐳 "
      elif [[ -d ".git" ]]; then
        echo "🌱 "
      else
        echo "📁 "
      fi
      ;;
  esac
}

# Функция для определения времени
function time_info() {
  echo "${gray}🕐 %D{%H:%M}${reset}"
}

# Основной промпт
PROMPT='
${blue}╭─${reset} ${green}%n${reset}${gray}@${reset}${blue}%m${reset} ${gray}in${reset} ${yellow}$(directory_icon)%~${reset}$(git_prompt_info)$(virtualenv_info)
${blue}╰─${reset} %(?:${green}:${red})🚀${reset} '

# Правый промпт с временем
RPROMPT='$(time_info)'

# Промпт для продолжения команды
PROMPT2='${blue}╰─${reset} ${purple}✨${reset} '

# Промпт для выбора
PROMPT3='${blue}╰─${reset} ${orange}🤔${reset} '

# Промпт для команды select
PROMPT4='${blue}╰─${reset} ${pink}➜${reset} '
