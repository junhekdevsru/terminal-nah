local wezterm = require("wezterm")
local act = wezterm.action

local config = {}

-- 🎨 Цветовая тема
config.color_scheme = "Catppuccin Mocha" -- можно "Tokyo Night", "Nightfox", "OneDark (base16)", "Dracula"

-- ⛓️ Шрифт (как в Neovim GUI)
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

-- 🌌 Неон-фон (опционально — если хочешь поверх изображения)
-- config.background = {
--   {
--     source = { File = "/path/to/background.png" },
--     hsb = { brightness = 0.1 },
--   },
-- }

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
  
  -- 🪟 Управление панелями (split panes)
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

-- 📊 Мониторинг системы в статусной строке
wezterm.on('update-right-status', function(window, pane)
  -- Простой скрипт для macOS
  local success, stdout = wezterm.run_child_process({
    'sh', '-c', 'top -l 1 | head -10 | grep "CPU usage" | awk "{print $3}" | tr -d "%"'
  })
  
  local success2, stdout2 = wezterm.run_child_process({
    'sh', '-c', 'top -l 1 | head -10 | grep PhysMem | awk "{print $2}" | tr -d "GM"'
  })
  
  local cpu_usage = "--"
  local ram_used = "--"
  
  if success and stdout then
    cpu_usage = string.format("%.1f", tonumber(stdout:match("%S+")) or 0)
  end
  
  if success2 and stdout2 then
    local ram_val = tonumber(stdout2:match("%S+")) or 0
    ram_used = string.format("%.1f", ram_val)
  end
  
  -- Форматируем статусную строку
  local cpu_icon = "🔥"
  local ram_icon = "🧠"
  local separator = " • "
  
  -- Цветовая схема для CPU
  local cpu_color = "#50fa7b"  -- Зелёный
  local cpu_val = tonumber(cpu_usage) or 0
  if cpu_val > 80 then
    cpu_color = "#ff5555"  -- Красный
    cpu_icon = "⚡"
  elseif cpu_val > 50 then
    cpu_color = "#ffb86c"  -- Оранжевый
    cpu_icon = "🌡️"
  end
  
  -- Цветовая схема для RAM
  local ram_color = "#50fa7b"  -- Зелёный
  local ram_val = tonumber(ram_used) or 0
  if ram_val > 12 then
    ram_color = "#ff5555"  -- Красный
    ram_icon = "💾"
  elseif ram_val > 8 then
    ram_color = "#ffb86c"  -- Оранжевый
    ram_icon = "🗄️"
  end
  
  -- Форматируем вывод
  local status_text = wezterm.format({
    { Foreground = { Color = cpu_color } },
    { Text = cpu_icon .. " " .. cpu_usage .. "%" },
    { Foreground = { Color = "#f8f8f2" } },  -- Белый
    { Text = separator },
    { Foreground = { Color = ram_color } },
    { Text = ram_icon .. " " .. ram_used .. "G" },
    { Text = " " },
  })
  
  window:set_right_status(status_text)
end)

-- 🎯 Настройки статусной строки
config.status_update_interval = 1000  -- Обновление каждую секунду

return config


