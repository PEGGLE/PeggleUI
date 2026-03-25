# PeggleUI (Primordial-ish Based)

![Lua](https://img.shields.io/badge/Lua-blue?style=flat-square) ![Roblox](https://img.shields.io/badge/Roblox-executor-green?style=flat-square) ![Matcha](https://img.shields.io/badge/Matcha-Drawing%20API-red?style=flat-square)

A fully featured Drawing-based UI library for Roblox executors. Built with the Matcha Drawing API in mind — no GUI instances, no ScreenGui, just raw `Drawing` objects rendered directly to screen.

---

## Features

- **Windowed layout** — draggable window with a sidebar tab list and two-column content area
- **Scrolling** — independent scroll per section and per tab content area
- **Themes** — 5 built-in themes with live switching and a full theming API
- **Widgets** — header text, info text, divider, spacer, toggle, slider, button, dropdown, multiselect, keybind
- **Keybind system** — click to bind, Esc to cancel, cooldown guard to prevent re-fire on bind key
- **Library pattern** — `return ui` at the end, require or loadstring into your own script

---

## Themes

| Name | Accent |
|---|---|
| `dark` | Rose pink — default |
| `ocean` | Sky blue |
| `rose` | Hot pink |
| `slate` | Periwinkle |
| `forest` | Mint green |

---

## API reference

### Window

#### `ui.create_window(id, title, x, y, w, h)` → win
Creates a new window. `id` is a unique string key. Returns the window object.

#### `ui.set_window_visible(win, visible)`
Shows or hides the entire window and all its contents.

---

### Tabs

#### `ui.add_tab(win, id, label, sublabel)` → tab
Adds a tab to the sidebar. `sublabel` is the smaller line of text shown below the label. Returns the tab object.

---

### Sections

#### `ui.add_section(win, tab, title, side)` → sec
Adds a section to a tab. `side` is `ui.Side.Left` or `ui.Side.Right`. Sections grow automatically as widgets are added. Returns the section object.

---

### Widgets

#### `ui.add_header_text(win, tab, sec, text)` → widget
Renders a bold label with an accent underline. Used to group widgets visually.

#### `ui.add_info_text(win, tab, sec, text)` → widget
Renders dimmed body text with automatic word wrapping.

#### `ui.add_divider(win, tab, sec)` → widget
Renders a thin horizontal rule.

#### `ui.add_spacer(win, tab, sec, height?)` → widget
Inserts blank vertical space. `height` defaults to 8.

#### `ui.add_toggle(win, tab, sec, label, default, callback?)` → widget
Checkbox toggle. `callback(state: boolean)` fires on click.

#### `ui.add_slider(win, tab, sec, label, min, max, default, callback?)` → widget
Draggable slider. `callback(value: number)` fires while dragging.

#### `ui.add_button(win, tab, sec, label, callback?)` → widget
Full-width clickable button. `callback()` fires on click.

#### `ui.add_dropdown(win, tab, sec, label, options, default, callback?)` → widget
Single-select dropdown. `options` is a table of strings. `default` is the starting index. `callback(option: string, index: number)` fires on selection.

#### `ui.add_multiselect(win, tab, sec, label, options, defaults, callback?)` → widget
Multi-select dropdown. `defaults` is a table of booleans matching `options`. `callback(selected: table, mask: table)` fires on each toggle, where `selected` is the list of chosen option strings and `mask` is the raw boolean table.

#### `ui.add_keybind(win, tab, sec, label, default_key, callback?)` → widget
Keybind row. Click the box to enter listen mode, then press any key. Esc cancels. `callback(key: number)` fires each time the bound key is pressed (not on rebind). Pass a virtual key code as `default_key`.

---

### Theming

#### `ui.set_theme(name, win?)`
Sets the active theme by name. Falls back to `"dark"` if the name is not found. Passing `win` immediately redraws all drawing objects in that window.

#### `ui.apply_theme(win)`
Redraws all drawing objects in `win` using the current theme. Call this after manually editing `ui.themes`.

#### `ui.themes`
The full theme table. Keys are theme name strings, values are color tables. You can add your own:
```lua
ui.themes.my_theme = {
    bg = Color3.fromRGB(10, 10, 10),
    titlebar = Color3.fromRGB(15, 15, 15),
    sidebar = Color3.fromRGB(15, 15, 15),
    tab_active = Color3.fromRGB(22, 22, 22),
    section_bg = Color3.fromRGB(12, 12, 12),
    border = Color3.fromRGB(50, 50, 50),
    accent = Color3.fromRGB(255, 200, 0),
    text = Color3.fromRGB(230, 230, 230),
    text_dim = Color3.fromRGB(130, 130, 130),
    divider = Color3.fromRGB(40, 40, 40),
    scroll_track = Color3.fromRGB(20, 20, 20),
}
ui.set_theme("my_theme", win)
```

#### `ui.theme_names`
Ordered list of built-in theme name strings. Useful for building a theme dropdown.

#### `ui.current_theme`
String name of the currently active theme. Updated by `ui.set_theme`.

---

## Usage

```lua
local ui = loadstring(game:HttpGet("https://raw.githubusercontent.com/.../ui.lua"))()

local win = ui.create_window("main", "my cheat", 200, 150, 820, 510)
```

### Adding tabs and sections

```lua
local tab_aim = ui.add_tab(win, "aimbot", "Aim Bot", "Automatically aim & shoot")
local tab_misc = ui.add_tab(win, "misc", "Misc", "Miscellaneous features")

local sec_general = ui.add_section(win, tab_aim, "General", ui.Side.Left)
local sec_targeting = ui.add_section(win, tab_aim, "Targeting", ui.Side.Right)
```

### Header text

```lua
ui.add_header_text(win, tab_aim, sec_general, "Aimbot")
```

### Info text

```lua
ui.add_info_text(win, tab_aim, sec_general, "Aims at the nearest visible target within your FOV.")
```

### Divider

```lua
ui.add_divider(win, tab_aim, sec_general)
```

### Spacer

```lua
ui.add_spacer(win, tab_aim, sec_general)        -- default height
ui.add_spacer(win, tab_aim, sec_general, 16)    -- custom height
```

### Toggle

```lua
local aimbot_enabled = false

ui.add_toggle(win, tab_aim, sec_general, "Enabled", false, function(state)
    aimbot_enabled = state
end)
```

### Slider

```lua
local fov = 90

ui.add_slider(win, tab_aim, sec_general, "FOV", 1, 360, 90, function(value)
    fov = value
end)
```

### Button

```lua
ui.add_button(win, tab_misc, sec_misc, "Reset Config", function()
    print("config reset")
end)
```

### Dropdown

```lua
local aim_method = "FOV"

ui.add_dropdown(win, tab_aim, sec_targeting, "Method", {"FOV", "Distance", "Health"}, 1, function(option, idx)
    aim_method = option
end)
```

### Multiselect

```lua
local bones = {}

ui.add_multiselect(win, tab_aim, sec_targeting, "Bones",
    {"Head", "Neck", "Chest", "Stomach"},
    {true, false, true, false},
    function(selected, mask)
        bones = selected
    end
)
```

### Keybind

```lua
ui.add_keybind(win, tab_settings, sec_keybinds, "Menu Toggle", 0x2D, function(key)
    ui.set_window_visible(win, not win.visible)
end)
```

### Theme dropdown

```lua
local sec_appearance = ui.add_section(win, tab_settings, "Appearance", ui.Side.Right)

ui.add_dropdown(win, tab_settings, sec_appearance, "Theme", ui.theme_names, 1, function(name, idx)
    ui.set_theme(name, win)
end)
```

---

## Notes

- Requires the Matcha Drawing API — `Drawing.new`, `ismouse1pressed`, `iskeypressed` must be available in the executor environment.
- All rendering is done via `Drawing` objects. No `Instance`, `ScreenGui`, or `LayerCollector` is created.
- The update loop is started automatically inside the library via `task.spawn`. You do not need to call `ui.update()` yourself.
- Virtual key codes follow the standard Windows VK table. Common values: `0x2D` Insert, `0x70`–`0x7B` F1–F12, `0x41`–`0x5A` A–Z.
- The keybind widget fires `callback` on key-down each frame the key is held, with a cooldown guard that prevents the newly bound key from immediately firing after binding.
- `ui.set_theme` silently falls back to `"dark"` if an unknown name is passed, so it is safe to call with user input.

---

*For educational and research purposes only.*
