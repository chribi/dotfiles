local wezterm = require('wezterm')
local mux = wezterm.mux
local act = wezterm.action

local config = wezterm.config_builder()

config.default_prog = { "C:\\Program Files\\Git\\bin\\bash", "-l", "-i" }
config.scrollback_lines = 9000
config.skip_close_confirmation_for_processes_named = {
  'bash',
  'sh',
  'zsh',
  'fish',
  'tmux',
  'nu',
  'bash.exe',
  'cmd.exe',
  'pwsh.exe',
  'powershell.exe',
}

-- Appearance {{{
config.color_scheme = 'Solarized Light (Gogh)'
config.hide_tab_bar_if_only_one_tab = false
config.window_decorations = "RESIZE | INTEGRATED_BUTTONS"
config.font = wezterm.font "CaskaydiaCove Nerd Font"
config.font_size = 9.6
config.enable_scroll_bar = true

config.inactive_pane_hsb = {
    saturation = 0.9,
    brightness = 0.9,
}

config.window_frame = {
    font = wezterm.font { family = 'Roboto', italic = true },
    font_size = 9,
    active_titlebar_bg = '#e8e8e8',
    inactive_titlebar_bg = '#e8e8e8',
}

config.colors = {
    tab_bar = {
        inactive_tab_edge = '#808080',

        active_tab = {
            bg_color = '#fdf6e3',
            fg_color = '#073642',
        },

        inactive_tab = {
            bg_color = '#eee8d5',
            fg_color = '#808080',
        },

        inactive_tab_hover = {
            bg_color = '#fdf6e3',
            fg_color = '#909090',
        },

        new_tab = {
            bg_color = '#e8e8e8',
            fg_color = '#808080',
        },

        new_tab_hover = {
            bg_color = '#fdf6e3',
            fg_color = '#909090',
        },
    },
}

-- }}}

wezterm.on("gui-startup", function()
    local tab, pane, window = mux.spawn_window{}
    window:gui_window():maximize()
end)

-- Key bindings {{{
config.keys = {
    -- Tabs
    { key = 'T', mods = 'SHIFT|CTRL', action = act.SpawnTab 'CurrentPaneDomain' },
    { key = 'W', mods = 'SHIFT|CTRL', action = act.CloseCurrentTab{ confirm = true } },
    { key = 'Tab', mods = 'CTRL', action = act.ActivateTabRelative(1) },
    { key = 'Tab', mods = 'SHIFT|CTRL', action = act.ActivateTabRelative(-1) },
    { key = 'h', mods = 'CTRL|ALT', action = act.MoveTabRelative(-1) },
    { key = 'l', mods = 'CTRL|ALT', action = act.MoveTabRelative(1) },
    { key = '1', mods = 'CTRL|ALT', action = act.ActivateTab(0) },
    { key = '2', mods = 'CTRL|ALT', action = act.ActivateTab(1) },
    { key = '3', mods = 'CTRL|ALT', action = act.ActivateTab(2) },
    { key = '4', mods = 'CTRL|ALT', action = act.ActivateTab(3) },
    { key = '5', mods = 'CTRL|ALT', action = act.ActivateTab(4) },
    { key = '6', mods = 'CTRL|ALT', action = act.ActivateTab(5) },
    { key = '7', mods = 'CTRL|ALT', action = act.ActivateTab(6) },
    { key = '8', mods = 'CTRL|ALT', action = act.ActivateTab(7) },
    { key = '9', mods = 'CTRL|ALT', action = act.ActivateTab(-1) },

    -- Splits
    { key = '_', mods = 'SHIFT|ALT', action = act.SplitHorizontal{ domain =  'CurrentPaneDomain' } },
    { key = '+', mods = 'SHIFT|ALT', action = act.SplitVertical{ domain =  'CurrentPaneDomain' } },
    { key = 'D', mods = 'SHIFT|ALT', action = wezterm.action_callback(
        -- dynamic split: vertical / horizontal depending on dimensions
        function(_, pane)
            local dims = pane:get_dimensions()
            if (dims.cols > dims.viewport_rows * 2) then
                pane:split( { direction = 'Right' })
            else
                pane:split( { direction = 'Bottom' })
            end
        end) },
    { key = 'W', mods = 'SHIFT|ALT', action = act.CloseCurrentPane{ confirm = true } },
    { key = 'LeftArrow', mods = 'ALT', action = act.ActivatePaneDirection 'Left' },
    { key = 'RightArrow', mods = 'ALT', action = act.ActivatePaneDirection 'Right' },
    { key = 'UpArrow', mods = 'ALT', action = act.ActivatePaneDirection 'Up' },
    { key = 'DownArrow', mods = 'ALT', action = act.ActivatePaneDirection 'Down' },
    { key = 'LeftArrow', mods = 'SHIFT|ALT', action = act.AdjustPaneSize{ 'Left', 1 } },
    { key = 'RightArrow', mods = 'SHIFT|ALT', action = act.AdjustPaneSize{ 'Right', 1 } },
    { key = 'UpArrow', mods = 'SHIFT|ALT', action = act.AdjustPaneSize{ 'Up', 1 } },
    { key = 'DownArrow', mods = 'SHIFT|ALT', action = act.AdjustPaneSize{ 'Down', 1 } },
    { key = 'r', mods = 'SHIFT|ALT', action = act.RotatePanes 'Clockwise' },
    { key = 'z', mods = 'SHIFT|CTRL', action = act.TogglePaneZoomState },

    -- Font size
    { key = '0', mods = 'CTRL', action = act.ResetFontSize },
    { key = '-', mods = 'CTRL', action = act.DecreaseFontSize },
    { key = '=', mods = 'CTRL', action = act.IncreaseFontSize },

    -- Scroll
    { key = 'PageUp', mods = 'CTRL|SHIFT', action = act.ScrollByPage(-1) },
    { key = 'PageDown', mods = 'CTRL|SHIFT', action = act.ScrollByPage(1) },
    { key = 'UpArrow', mods = 'CTRL|SHIFT', action = act.ScrollByLine(-1) },
    { key = 'DownArrow', mods = 'CTRL|SHIFT', action = act.ScrollByLine(1) },
    { key = 'K', mods = 'SHIFT|CTRL', action = act.ClearScrollback 'ScrollbackOnly' },
    { key = 'F', mods = 'SHIFT|CTRL', action = act.Search 'CurrentSelectionOrEmptyString' },

    -- Copy/Paste/Select
    { key = 'phys:Space', mods = 'SHIFT|CTRL', action = act.QuickSelect },
    { key = 'X', mods = 'SHIFT|CTRL', action = act.ActivateCopyMode },
    { key = 'C', mods = 'SHIFT|CTRL', action = act.CopyTo 'Clipboard' },
    { key = 'V', mods = 'SHIFT|CTRL', action = act.PasteFrom 'Clipboard' },
    { key = 'Insert', mods = 'SHIFT', action = act.PasteFrom 'PrimarySelection' },
    { key = 'Insert', mods = 'CTRL', action = act.CopyTo 'PrimarySelection' },
    { key = 'Copy', mods = 'NONE', action = act.CopyTo 'Clipboard' },
    { key = 'Paste', mods = 'NONE', action = act.PasteFrom 'Clipboard' },

    -- other
    { key = 'Enter', mods = 'ALT', action = act.ToggleFullScreen },
    { key = 'p', mods = 'SHIFT|CTRL', action = act.ActivateCommandPalette },
    { key = 'l', mods = 'SHIFT|CTRL', action = act.ShowDebugOverlay },
    { key = 'r', mods = 'SHIFT|CTRL', action = act.ReloadConfiguration },
    { key = 'n', mods = 'SHIFT|CTRL', action = act.SpawnWindow },
    { key = 'U', mods = 'SHIFT|CTRL', action = act.CharSelect{ copy_on_select = true, copy_to =  'ClipboardAndPrimarySelection' } },
}

config.key_tables = {
    copy_mode = {
        { key = 'Tab', mods = 'NONE', action = act.CopyMode 'MoveForwardWord' },
        { key = 'Tab', mods = 'SHIFT', action = act.CopyMode 'MoveBackwardWord' },
        { key = 'Enter', mods = 'NONE', action = act.Multiple{ { CopyTo =  'ClipboardAndPrimarySelection' }, { CopyMode =  'Close' } } },
        { key = 'Escape', mods = 'NONE', action = act.CopyMode 'Close' },
        { key = 'Space', mods = 'NONE', action = act.CopyMode{ SetSelectionMode =  'Cell' } },
        { key = '$', mods = 'NONE', action = act.CopyMode 'MoveToEndOfLineContent' },
        { key = '$', mods = 'SHIFT', action = act.CopyMode 'MoveToEndOfLineContent' },
        { key = ',', mods = 'NONE', action = act.CopyMode 'JumpReverse' },
        { key = '0', mods = 'NONE', action = act.CopyMode 'MoveToStartOfLine' },
        { key = ';', mods = 'NONE', action = act.CopyMode 'JumpAgain' },
        { key = 'F', mods = 'NONE', action = act.CopyMode{ JumpBackward = { prev_char = false } } },
        { key = 'F', mods = 'SHIFT', action = act.CopyMode{ JumpBackward = { prev_char = false } } },
        { key = 'G', mods = 'NONE', action = act.CopyMode 'MoveToScrollbackBottom' },
        { key = 'G', mods = 'SHIFT', action = act.CopyMode 'MoveToScrollbackBottom' },
        { key = 'H', mods = 'NONE', action = act.CopyMode 'MoveToViewportTop' },
        { key = 'H', mods = 'SHIFT', action = act.CopyMode 'MoveToViewportTop' },
        { key = 'L', mods = 'NONE', action = act.CopyMode 'MoveToViewportBottom' },
        { key = 'L', mods = 'SHIFT', action = act.CopyMode 'MoveToViewportBottom' },
        { key = 'M', mods = 'NONE', action = act.CopyMode 'MoveToViewportMiddle' },
        { key = 'M', mods = 'SHIFT', action = act.CopyMode 'MoveToViewportMiddle' },
        { key = 'O', mods = 'NONE', action = act.CopyMode 'MoveToSelectionOtherEndHoriz' },
        { key = 'O', mods = 'SHIFT', action = act.CopyMode 'MoveToSelectionOtherEndHoriz' },
        { key = 'T', mods = 'NONE', action = act.CopyMode{ JumpBackward = { prev_char = true } } },
        { key = 'T', mods = 'SHIFT', action = act.CopyMode{ JumpBackward = { prev_char = true } } },
        { key = 'V', mods = 'NONE', action = act.CopyMode{ SetSelectionMode =  'Line' } },
        { key = 'V', mods = 'SHIFT', action = act.CopyMode{ SetSelectionMode =  'Line' } },
        { key = '^', mods = 'NONE', action = act.CopyMode 'MoveToStartOfLineContent' },
        { key = '^', mods = 'SHIFT', action = act.CopyMode 'MoveToStartOfLineContent' },
        { key = 'b', mods = 'NONE', action = act.CopyMode 'MoveBackwardWord' },
        { key = 'b', mods = 'ALT', action = act.CopyMode 'MoveBackwardWord' },
        { key = 'b', mods = 'CTRL', action = act.CopyMode 'PageUp' },
        { key = 'c', mods = 'CTRL', action = act.CopyMode 'Close' },
        { key = 'd', mods = 'CTRL', action = act.CopyMode{ MoveByPage = (0.5) } },
        { key = 'e', mods = 'NONE', action = act.CopyMode 'MoveForwardWordEnd' },
        { key = 'f', mods = 'NONE', action = act.CopyMode{ JumpForward = { prev_char = false } } },
        { key = 'f', mods = 'ALT', action = act.CopyMode 'MoveForwardWord' },
        { key = 'f', mods = 'CTRL', action = act.CopyMode 'PageDown' },
        { key = 'g', mods = 'NONE', action = act.CopyMode 'MoveToScrollbackTop' },
        { key = 'g', mods = 'CTRL', action = act.CopyMode 'Close' },
        { key = 'h', mods = 'NONE', action = act.CopyMode 'MoveLeft' },
        { key = 'j', mods = 'NONE', action = act.CopyMode 'MoveDown' },
        { key = 'k', mods = 'NONE', action = act.CopyMode 'MoveUp' },
        { key = 'l', mods = 'NONE', action = act.CopyMode 'MoveRight' },
        { key = 'm', mods = 'ALT', action = act.CopyMode 'MoveToStartOfLineContent' },
        { key = 'o', mods = 'NONE', action = act.CopyMode 'MoveToSelectionOtherEnd' },
        { key = 'q', mods = 'NONE', action = act.CopyMode 'Close' },
        { key = 't', mods = 'NONE', action = act.CopyMode{ JumpForward = { prev_char = true } } },
        { key = 'u', mods = 'CTRL', action = act.CopyMode{ MoveByPage = (-0.5) } },
        { key = 'v', mods = 'NONE', action = act.CopyMode{ SetSelectionMode =  'Cell' } },
        { key = 'v', mods = 'CTRL', action = act.CopyMode{ SetSelectionMode =  'Block' } },
        { key = 'w', mods = 'NONE', action = act.CopyMode 'MoveForwardWord' },
        { key = 'y', mods = 'NONE', action = act.Multiple{ { CopyTo =  'ClipboardAndPrimarySelection' }, { CopyMode =  'Close' } } },
        { key = 'PageUp', mods = 'NONE', action = act.CopyMode 'PageUp' },
        { key = 'PageDown', mods = 'NONE', action = act.CopyMode 'PageDown' },
        { key = 'End', mods = 'NONE', action = act.CopyMode 'MoveToEndOfLineContent' },
        { key = 'Home', mods = 'NONE', action = act.CopyMode 'MoveToStartOfLine' },
        { key = 'LeftArrow', mods = 'NONE', action = act.CopyMode 'MoveLeft' },
        { key = 'LeftArrow', mods = 'ALT', action = act.CopyMode 'MoveBackwardWord' },
        { key = 'RightArrow', mods = 'NONE', action = act.CopyMode 'MoveRight' },
        { key = 'RightArrow', mods = 'ALT', action = act.CopyMode 'MoveForwardWord' },
        { key = 'UpArrow', mods = 'NONE', action = act.CopyMode 'MoveUp' },
        { key = 'DownArrow', mods = 'NONE', action = act.CopyMode 'MoveDown' },
    },

    search_mode = {
        { key = 'Enter', mods = 'NONE', action = act.CopyMode 'PriorMatch' },
        { key = 'Escape', mods = 'NONE', action = act.CopyMode 'Close' },
        { key = 'n', mods = 'CTRL', action = act.CopyMode 'NextMatch' },
        { key = 'p', mods = 'CTRL', action = act.CopyMode 'PriorMatch' },
        { key = 'r', mods = 'CTRL', action = act.CopyMode 'CycleMatchType' },
        { key = 'u', mods = 'CTRL', action = act.CopyMode 'ClearPattern' },
        { key = 'PageUp', mods = 'NONE', action = act.CopyMode 'PriorMatchPage' },
        { key = 'PageDown', mods = 'NONE', action = act.CopyMode 'NextMatchPage' },
        { key = 'UpArrow', mods = 'NONE', action = act.CopyMode 'PriorMatch' },
        { key = 'DownArrow', mods = 'NONE', action = act.CopyMode 'NextMatch' },
    },
}
-- }}}

return config

-- vim: fdm=marker
