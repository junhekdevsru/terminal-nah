local wezterm = require("wezterm")
local act = wezterm.action

local config = {}

-- 🎨 Цветовая тема
config.color_scheme = "Catppuccin Mocha"

-- ⛓️ Шрифт
config.font = wezterm.font_with_fallback({
  "JetBrainsMono Nerd Font",
  "FiraCode Nerd Font",
})
config.font_size = 14.0

-- 🪟 Настройки окна и вкладок
config.window_decorations = "NONE"
config.enable_tab_bar = true
config.hide_tab_bar_if_only_one_tab = false
config.use_fancy_tab_bar = false
config.tab_bar_at_bottom = false
config.show_tab_index_in_tab_bar = true
config.window_padding = {
  left = 4,
  right = 4,
  top = 2,
  bottom = 2,
}

-- 🫥 Полупрозрачность фона
config.window_background_opacity = 0.92

-- 🚀 Быстрый старт
config.check_for_updates = false

-- ⚡ Горячие клавиши
config.keys = {
  -- 📑 Управление вкладками
  { key = "t", mods = "CMD", action = act.SpawnTab("CurrentPaneDomain") },
  { key = "w", mods = "CMD", action = act.CloseCurrentTab({ confirm = true }) },
  { key = "1", mods = "CMD", action = act.ActivateTab(0) },
  { key = "2", mods = "CMD", action = act.ActivateTab(1) },
  { key = "3", mods = "CMD", action = act.ActivateTab(2) },
  { key = "4", mods = "CMD", action = act.ActivateTab(3) },
  { key = "5", mods = "CMD", action = act.ActivateTab(4) },
  { key = "6", mods = "CMD", action = act.ActivateTab(5) },
  { key = "7", mods = "CMD", action = act.ActivateTab(6) },
  { key = "8", mods = "CMD", action = act.ActivateTab(7) },
  { key = "9", mods = "CMD", action = act.ActivateTab(8) },
  { key = "[", mods = "CMD", action = act.ActivateTabRelative(-1) },
  { key = "]", mods = "CMD", action = act.ActivateTabRelative(1) },
  
  -- 🪟 Управление панелями
  { key = "d", mods = "CMD", action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
  { key = "d", mods = "CMD|SHIFT", action = act.SplitVertical({ domain = "CurrentPaneDomain" }) },
  { key = "w", mods = "CMD|SHIFT", action = act.CloseCurrentPane({ confirm = true }) },
  
  -- 🔄 Переключение между панелями
  { key = "h", mods = "CMD|SHIFT", action = act.ActivatePaneDirection("Left") },
  { key = "j", mods = "CMD|SHIFT", action = act.ActivatePaneDirection("Down") },
  { key = "k", mods = "CMD|SHIFT", action = act.ActivatePaneDirection("Up") },
  { key = "l", mods = "CMD|SHIFT", action = act.ActivatePaneDirection("Right") },
  
  -- 📐 Изменение размера панелей
  { key = "LeftArrow", mods = "CMD|SHIFT", action = act.AdjustPaneSize({ "Left", 5 }) },
  { key = "RightArrow", mods = "CMD|SHIFT", action = act.AdjustPaneSize({ "Right", 5 }) },
  { key = "UpArrow", mods = "CMD|SHIFT", action = act.AdjustPaneSize({ "Up", 5 }) },
  { key = "DownArrow", mods = "CMD|SHIFT", action = act.AdjustPaneSize({ "Down", 5 }) },
  
  -- 🔍 Поиск
  { key = "f", mods = "CMD", action = act.Search({ CaseInSensitiveString = "" }) },
  
  -- 📋 Копирование/вставка
  { key = "c", mods = "CMD", action = act.CopyTo("Clipboard") },
  { key = "v", mods = "CMD", action = act.PasteFrom("Clipboard") },
  
  -- 🎨 Полноэкранный режим
  { key = "Enter", mods = "CMD", action = act.ToggleFullScreen },
  
  -- 🔧 Настройки
  { key = ",", mods = "CMD", action = act.SpawnCommandInNewTab({
    cwd = wezterm.home_dir,
    args = { "nvim", wezterm.config_file },
  }) },
  
  -- 🔄 Перезагрузка конфигурации
  { key = "r", mods = "CMD|SHIFT", action = act.ReloadConfiguration },
}

-- 📊 Простой мониторинг системы
wezterm.on('update-right-status', function(window, pane)
  -- Получаем CPU и RAM одной командой
  local success, stdout = wezterm.run_child_process({
    'bash', '-c', 'echo "$(top -l 1 | grep "CPU usage" | awk "{print $3}" | tr -d "%") $(top -l 1 | grep PhysMem | awk "{print $2}" | tr -d "G") $(df -h / | tail -1 | awk "{print $3}" | tr -d "G") $(uptime | awk -F"averages: " "{print $2}" | awk "{print $1}")"'
  })
  
  if success then
    local cpu, ram, disk, load = stdout:match("([%d%.]+) ([%d%.]+) ([%d%.]+) ([%d%.]+)")
    
    if cpu and ram and disk and load then
      window:set_right_status(wezterm.format({
        { Foreground = { Color = "#50fa7b" } },
        { Text = "🔥 " .. cpu .. "% " },
        { Foreground = { Color = "#f8f8f2" } },
        { Text = "• " },
        { Foreground = { Color = "#ff79c6" } },
        { Text = "🧠 " .. ram .. "G " },
        { Foreground = { Color = "#f8f8f2" } },
        { Text = "• " },
        { Foreground = { Color = "#8be9fd" } },
        { Text = "💾 " .. disk .. "G " },
        { Foreground = { Color = "#f8f8f2" } },
        { Text = "• " },
        { Foreground = { Color = "#bd93f9" } },
        { Text = "⚖️ " .. load .. " " },
      }))
    else
      window:set_right_status("📊 Loading...")
    end
  else
    window:set_right_status("📊 Error")
  end
end)

-- 🎯 Настройки статусной строки
config.status_update_interval = 2000  -- Обновление каждые 2 секунды

return config
