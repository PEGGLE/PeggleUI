local local_player = game:GetService("Players").LocalPlayer
local mouse = local_player:GetMouse()

_G.ui = {}
ui = _G.ui
ui._windows = {}
ui._drag = nil
ui._content_scroll_drag = nil
ui._section_scroll_drag = nil
ui._slider_drag = nil
ui._prev_m1 = false
ui._open_dropdown = nil
ui._keybind_listening = nil
ui._keybind_ready = false
ui._keybind_cooldown = nil

ui.Side = {
    Left = "left",
    Right = "right",
}

local all_themes = {
    dark = {
        bg = Color3.fromRGB(13, 13, 15),
        titlebar = Color3.fromRGB(19, 19, 23),
        sidebar = Color3.fromRGB(19, 19, 23),
        tab_active = Color3.fromRGB(28, 28, 34),
        section_bg = Color3.fromRGB(17, 17, 20),
        border = Color3.fromRGB(42, 42, 50),
        accent = Color3.fromRGB(188, 72, 112),
        text = Color3.fromRGB(220, 220, 226),
        text_dim = Color3.fromRGB(128, 128, 138),
        divider = Color3.fromRGB(36, 36, 44),
        scroll_track = Color3.fromRGB(24, 24, 29),
    },
    ocean = {
        bg = Color3.fromRGB(8, 18, 28),
        titlebar = Color3.fromRGB(12, 25, 38),
        sidebar = Color3.fromRGB(12, 25, 38),
        tab_active = Color3.fromRGB(18, 35, 52),
        section_bg = Color3.fromRGB(10, 22, 33),
        border = Color3.fromRGB(30, 60, 90),
        accent = Color3.fromRGB(64, 160, 220),
        text = Color3.fromRGB(200, 225, 245),
        text_dim = Color3.fromRGB(100, 140, 170),
        divider = Color3.fromRGB(20, 45, 65),
        scroll_track = Color3.fromRGB(15, 30, 45),
    },
    rose = {
        bg = Color3.fromRGB(20, 12, 16),
        titlebar = Color3.fromRGB(28, 16, 22),
        sidebar = Color3.fromRGB(28, 16, 22),
        tab_active = Color3.fromRGB(38, 22, 30),
        section_bg = Color3.fromRGB(24, 14, 19),
        border = Color3.fromRGB(80, 40, 55),
        accent = Color3.fromRGB(240, 100, 140),
        text = Color3.fromRGB(245, 220, 228),
        text_dim = Color3.fromRGB(160, 110, 128),
        divider = Color3.fromRGB(50, 28, 38),
        scroll_track = Color3.fromRGB(30, 18, 24),
    },
    slate = {
        bg = Color3.fromRGB(22, 24, 30),
        titlebar = Color3.fromRGB(30, 32, 40),
        sidebar = Color3.fromRGB(30, 32, 40),
        tab_active = Color3.fromRGB(40, 42, 52),
        section_bg = Color3.fromRGB(26, 28, 35),
        border = Color3.fromRGB(60, 64, 80),
        accent = Color3.fromRGB(130, 160, 240),
        text = Color3.fromRGB(210, 215, 230),
        text_dim = Color3.fromRGB(120, 125, 145),
        divider = Color3.fromRGB(45, 48, 60),
        scroll_track = Color3.fromRGB(32, 34, 44),
    },
    forest = {
        bg = Color3.fromRGB(10, 16, 12),
        titlebar = Color3.fromRGB(14, 22, 16),
        sidebar = Color3.fromRGB(14, 22, 16),
        tab_active = Color3.fromRGB(20, 32, 22),
        section_bg = Color3.fromRGB(12, 19, 14),
        border = Color3.fromRGB(40, 70, 45),
        accent = Color3.fromRGB(80, 200, 110),
        text = Color3.fromRGB(200, 230, 205),
        text_dim = Color3.fromRGB(100, 150, 110),
        divider = Color3.fromRGB(25, 45, 28),
        scroll_track = Color3.fromRGB(16, 26, 18),
    },
}

local theme = all_themes.dark

local title_h = 38
local sidebar_w = 190
local tab_h = 52
local section_header_h = 28
local section_inner_pad = 8
local content_pad = 10
local section_gap = 10
local col_gap = 10
local scroll_w = 3
local scroll_thumb_h = 20

local widget_pad = 8
local widget_line_h = 14
local widget_char_w = 8
local widget_font_size = 12
local widget_header_font_size = 14
local widget_h_header = 24
local widget_h_divider = 11
local widget_h_spacer = 8
local widget_h_toggle = 20
local widget_toggle_box = 10
local widget_h_slider = 28
local widget_slider_h = 4
local widget_slider_thumb_w = 6
local widget_slider_thumb_h = 10
local widget_h_keybind = 20
local widget_keybind_box_w = 50
local widget_keybind_box_h = 16
local widget_h_button = 22
local widget_h_dropdown = 36
local widget_dropdown_box_h = 16
local widget_dropdown_item_h = 18

local z_border = 10
local z_bg = 11
local z_chrome = 12
local z_sep = 13
local z_tab_bg = 14
local z_section_border = 14
local z_section_bg = 15
local z_tab_el = 15
local z_section_header = 16
local z_widget = 16
local z_section_scroll = 17
local z_content_scroll = 18
local z_mask = 20
local z_title_el = 22
local z_dropdown = 50

local key_names = {
    [0x01] = "M1",
    [0x02] = "M2",
    [0x03] = "Break",
    [0x04] = "M3",
    [0x05] = "M4",
    [0x06] = "M5",
    [0x08] = "Back",
    [0x09] = "Tab",
    [0x0C] = "Clear",
    [0x0D] = "Enter",
    [0x10] = "Shift",
    [0x11] = "Ctrl",
    [0x12] = "Alt",
    [0x13] = "Pause",
    [0x14] = "Caps",
    [0x1B] = "Esc",
    [0x20] = "Space",
    [0x21] = "PgUp",
    [0x22] = "PgDn",
    [0x23] = "End",
    [0x24] = "Home",
    [0x25] = "Left",
    [0x26] = "Up",
    [0x27] = "Right",
    [0x28] = "Down",
    [0x2C] = "Print",
    [0x2D] = "Insert",
    [0x2E] = "Delete",
    [0x30] = "0",
    [0x31] = "1",
    [0x32] = "2",
    [0x33] = "3",
    [0x34] = "4",
    [0x35] = "5",
    [0x36] = "6",
    [0x37] = "7",
    [0x38] = "8",
    [0x39] = "9",
    [0x41] = "A",
    [0x42] = "B",
    [0x43] = "C",
    [0x44] = "D",
    [0x45] = "E",
    [0x46] = "F",
    [0x47] = "G",
    [0x48] = "H",
    [0x49] = "I",
    [0x4A] = "J",
    [0x4B] = "K",
    [0x4C] = "L",
    [0x4D] = "M",
    [0x4E] = "N",
    [0x4F] = "O",
    [0x50] = "P",
    [0x51] = "Q",
    [0x52] = "R",
    [0x53] = "S",
    [0x54] = "T",
    [0x55] = "U",
    [0x56] = "V",
    [0x57] = "W",
    [0x58] = "X",
    [0x59] = "Y",
    [0x5A] = "Z",
    [0x70] = "F1",
    [0x71] = "F2",
    [0x72] = "F3",
    [0x73] = "F4",
    [0x74] = "F5",
    [0x75] = "F6",
    [0x76] = "F7",
    [0x77] = "F8",
    [0x78] = "F9",
    [0x79] = "F10",
    [0x7A] = "F11",
    [0x7B] = "F12",
    [0x90] = "NumLk",
    [0x91] = "ScrLk",
    [0xA0] = "LShift",
    [0xA1] = "RShift",
    [0xA2] = "LCtrl",
    [0xA3] = "RCtrl",
    [0xBA] = ";",
    [0xBB] = "=",
    [0xBC] = ",",
    [0xBD] = "-",
    [0xBE] = ".",
    [0xBF] = "/",
    [0xC0] = "`",
    [0xDB] = "[",
    [0xDC] = "\\",
    [0xDD] = "]",
    [0xDE] = "'",
    [0xE2] = "<",
}

local function new_square(filled, x, y, w, h, color, z)
    local obj = Drawing.new("Square")
    obj.Filled = filled
    obj.Position = Vector2.new(x, y)
    obj.Size = Vector2.new(w, h)
    obj.Color = color
    obj.Transparency = 1
    obj.ZIndex = z
    obj.Visible = true
    return obj
end

local function new_line(x1, y1, x2, y2, color, thickness, z)
    local obj = Drawing.new("Line")
    obj.From = Vector2.new(x1, y1)
    obj.To = Vector2.new(x2, y2)
    obj.Color = color
    obj.Thickness = thickness
    obj.Transparency = 1
    obj.ZIndex = z
    obj.Visible = true
    return obj
end

local function new_text(str, x, y, size, color, z)
    local obj = Drawing.new("Text")
    obj.Text = str
    obj.Position = Vector2.new(x, y)
    obj.Size = size
    obj.Color = color
    obj.Outline = false
    obj.Center = false
    obj.Transparency = 1
    obj.ZIndex = z
    obj.Visible = true
    return obj
end

local function content_origin(win)
    return win.x + sidebar_w + 1, win.y + title_h
end

local function get_content_h(win)
    return win.h - title_h
end

local function get_col_w(win)
    local content_w = win.w - sidebar_w - 1 - scroll_w - 4
    return math.floor((content_w - content_pad * 2 - col_gap) / 2)
end

local function get_col_ox(win, side)
    if side == ui.Side.Left then
        return content_pad
    end
    return content_pad + get_col_w(win) + col_gap
end

local function get_active_tab(win)
    for _, tab in ipairs(win.tabs) do
        if tab.id == win.active_tab then
            return tab
        end
    end
    return nil
end

local function get_max_content_scroll(win)
    local tab = get_active_tab(win)
    if not tab then return 0 end
    local total_h = math.max(tab.left_cursor, tab.right_cursor) + content_pad
    return math.max(0, total_h - get_content_h(win))
end

local function get_max_section_scroll(sec)
    local visible_body = sec.h - section_header_h - section_inner_pad
    return math.max(0, sec.body_h - visible_body)
end

local function word_wrap(str, avail_w)
    local max_chars = math.floor(avail_w / widget_char_w)
    local lines = {}
    local words = {}
    for word in str:gmatch("%S+") do
        table.insert(words, word)
    end
    local current = ""
    for _, word in ipairs(words) do
        local candidate = current == "" and word or current .. " " .. word
        if #candidate > max_chars then
            if current ~= "" then
                table.insert(lines, current)
            end
            current = word
        else
            current = candidate
        end
    end
    if current ~= "" then
        table.insert(lines, current)
    end
    return lines
end

local function truncate(str, avail_w)
    local max_chars = math.floor(avail_w / widget_char_w)
    if #str <= max_chars then
        return str
    end
    return str:sub(1, math.max(1, max_chars - 3)) .. "..."
end

local function hide_widget(widget)
    if widget.type == "header_text" then
        widget.draws.label.Visible = false
        widget.draws.line.Visible = false
    elseif widget.type == "info_text" then
        for _, obj in ipairs(widget.draws.lines) do
            obj.Visible = false
        end
    elseif widget.type == "divider" then
        widget.draws.line.Visible = false
    elseif widget.type == "toggle" then
        widget.draws.box.Visible = false
        widget.draws.fill.Visible = false
        widget.draws.label.Visible = false
    elseif widget.type == "slider" then
        widget.draws.label.Visible = false
        widget.draws.value.Visible = false
        widget.draws.track.Visible = false
        widget.draws.fill.Visible = false
        widget.draws.thumb.Visible = false
    elseif widget.type == "keybind" then
        widget.draws.label.Visible = false
        widget.draws.box.Visible = false
        widget.draws.key_text.Visible = false
    elseif widget.type == "button" then
        widget.draws.bg.Visible = false
        widget.draws.border.Visible = false
        widget.draws.label.Visible = false
    elseif widget.type == "dropdown" then
        widget.draws.label.Visible = false
        widget.draws.box.Visible = false
        widget.draws.selected_text.Visible = false
        widget.draws.arrow.Visible = false
        if ui._open_dropdown == widget then
            ui._open_dropdown = nil
            for _, item in ipairs(widget.draws.items) do
                item.bg.Visible = false
                item.text.Visible = false
            end
            widget.draws.list_bg.Visible = false
            widget.draws.list_border.Visible = false
        end
    elseif widget.type == "multiselect" then
        widget.draws.label.Visible = false
        widget.draws.box.Visible = false
        widget.draws.selected_text.Visible = false
        widget.draws.arrow.Visible = false
        if ui._open_dropdown == widget then
            ui._open_dropdown = nil
            for _, item in ipairs(widget.draws.items) do
                item.bg.Visible = false
                item.check.Visible = false
                item.text.Visible = false
            end
            widget.draws.list_bg.Visible = false
            widget.draws.list_border.Visible = false
        end
    end
end

local function position_widget(widget, ax, clip_top, clip_bot, body_ay, sec_w)
    local wy = body_ay + widget.body_oy
    local inner_w = sec_w - widget_pad * 2

    if widget.type == "header_text" then
        local label_y = wy + 2
        widget.draws.label.Position = Vector2.new(ax + widget_pad, label_y)
        widget.draws.label.Visible = label_y >= clip_top and label_y + widget_header_font_size <= clip_bot

        local line_y = wy + widget_h_header - 4
        widget.draws.line.From = Vector2.new(ax + widget_pad, line_y)
        widget.draws.line.To = Vector2.new(ax + widget_pad + inner_w, line_y)
        widget.draws.line.Visible = line_y >= clip_top and line_y <= clip_bot

    elseif widget.type == "info_text" then
        for i, obj in ipairs(widget.draws.lines) do
            local line_y = wy + (i - 1) * widget_line_h
            obj.Position = Vector2.new(ax + widget_pad, line_y)
            obj.Visible = line_y >= clip_top and line_y + widget_font_size <= clip_bot
        end

    elseif widget.type == "divider" then
        local line_y = wy + 5
        widget.draws.line.From = Vector2.new(ax + widget_pad, line_y)
        widget.draws.line.To = Vector2.new(ax + widget_pad + inner_w, line_y)
        widget.draws.line.Visible = line_y >= clip_top and line_y <= clip_bot

    elseif widget.type == "toggle" then
        local box_y = wy + math.floor((widget_h_toggle - widget_toggle_box) / 2)
        local in_clip = box_y >= clip_top and box_y + widget_toggle_box <= clip_bot

        widget.draws.box.Position = Vector2.new(ax + widget_pad, box_y)
        widget.draws.box.Visible = in_clip

        widget.draws.fill.Position = Vector2.new(ax + widget_pad + 1, box_y + 1)
        widget.draws.fill.Visible = in_clip and widget.state

        local label_y = wy + math.floor((widget_h_toggle - widget_font_size) / 2)
        widget.draws.label.Position = Vector2.new(ax + widget_pad + widget_toggle_box + 7, label_y)
        widget.draws.label.Visible = label_y >= clip_top and label_y + widget_font_size <= clip_bot

    elseif widget.type == "slider" then
        local track_w = inner_w
        local label_y = wy + 2
        local track_y = wy + widget_h_slider - widget_slider_h - 4
        local t = (widget.value - widget.min) / (widget.max - widget.min)
        local fill_w = math.floor(t * track_w)
        local thumb_x = ax + widget_pad + fill_w - math.floor(widget_slider_thumb_w / 2)
        local thumb_y = track_y - math.floor((widget_slider_thumb_h - widget_slider_h) / 2)
        local in_clip = track_y >= clip_top and track_y + widget_slider_h <= clip_bot

        widget.draws.label.Position = Vector2.new(ax + widget_pad, label_y)
        widget.draws.label.Visible = label_y >= clip_top and label_y + widget_font_size <= clip_bot

        local val_str = tostring(math.floor(widget.value))
        widget.draws.value.Text = val_str
        local val_x = ax + widget_pad + track_w - #val_str * widget_char_w
        widget.draws.value.Position = Vector2.new(val_x, label_y)
        widget.draws.value.Visible = widget.draws.label.Visible

        widget.draws.track.Position = Vector2.new(ax + widget_pad, track_y)
        widget.draws.track.Size = Vector2.new(track_w, widget_slider_h)
        widget.draws.track.Visible = in_clip

        widget.draws.fill.Position = Vector2.new(ax + widget_pad, track_y)
        widget.draws.fill.Size = Vector2.new(math.max(0, fill_w), widget_slider_h)
        widget.draws.fill.Visible = in_clip

        widget.draws.thumb.Position = Vector2.new(thumb_x, thumb_y)
        widget.draws.thumb.Visible = in_clip

        widget._track_ax = ax + widget_pad
        widget._track_w = track_w
        widget._track_y = track_y

    elseif widget.type == "keybind" then
        local row_y = wy + math.floor((widget_h_keybind - widget_font_size) / 2)
        local box_x = ax + sec_w - widget_pad - widget_keybind_box_w
        local box_y = wy + math.floor((widget_h_keybind - widget_keybind_box_h) / 2)
        local in_clip = row_y >= clip_top and row_y + widget_font_size <= clip_bot
        local listening = ui._keybind_listening == widget

        widget.draws.label.Position = Vector2.new(ax + widget_pad, row_y)
        widget.draws.label.Visible = in_clip

        widget.draws.box.Position = Vector2.new(box_x, box_y)
        widget.draws.box.Size = Vector2.new(widget_keybind_box_w, widget_keybind_box_h)
        widget.draws.box.Color = listening and theme.accent or theme.border
        widget.draws.box.Visible = in_clip

        local key_label = listening and "..." or (key_names[widget.key] or "?")
        widget.draws.key_text.Text = key_label
        widget.draws.key_text.Position = Vector2.new(
            box_x + math.floor((widget_keybind_box_w - #key_label * widget_char_w) / 2),
            box_y + math.floor((widget_keybind_box_h - widget_font_size) / 2)
        )
        widget.draws.key_text.Visible = in_clip

        widget._box_x = box_x
        widget._box_y = box_y

    elseif widget.type == "button" then
        local btn_y = wy + 2
        local btn_h = widget_h_button - 4
        local btn_w = inner_w
        local in_clip = btn_y >= clip_top and btn_y + btn_h <= clip_bot

        widget.draws.border.Position = Vector2.new(ax + widget_pad - 1, btn_y - 1)
        widget.draws.border.Size = Vector2.new(btn_w + 2, btn_h + 2)
        widget.draws.border.Visible = in_clip

        widget.draws.bg.Position = Vector2.new(ax + widget_pad, btn_y)
        widget.draws.bg.Size = Vector2.new(btn_w, btn_h)
        widget.draws.bg.Visible = in_clip

        local label_y = btn_y + math.floor((btn_h - widget_font_size) / 2)
        local label_x = ax + widget_pad + math.floor((btn_w - #widget.label * widget_char_w) / 2)
        widget.draws.label.Position = Vector2.new(label_x, label_y)
        widget.draws.label.Visible = in_clip

        widget._btn_x = ax + widget_pad
        widget._btn_y = btn_y
        widget._btn_w = btn_w
        widget._btn_h = btn_h

    elseif widget.type == "dropdown" or widget.type == "multiselect" then
        local label_y = wy + 2
        local row_y = wy + widget_font_size + 6
        local box_w = inner_w
        local in_clip_label = label_y >= clip_top and label_y + widget_font_size <= clip_bot
        local in_clip_box = row_y >= clip_top and row_y + widget_dropdown_box_h <= clip_bot

        widget.draws.label.Position = Vector2.new(ax + widget_pad, label_y)
        widget.draws.label.Visible = in_clip_label

        widget.draws.box.Position = Vector2.new(ax + widget_pad, row_y)
        widget.draws.box.Size = Vector2.new(box_w, widget_dropdown_box_h)
        widget.draws.box.Visible = in_clip_box

        local summary
        if widget.type == "multiselect" then
            local parts = {}
            for i, sel in ipairs(widget.selected) do
                if sel then table.insert(parts, widget.options[i]) end
            end
            summary = #parts == 0 and "None" or table.concat(parts, ", ")
        else
            summary = widget.options[widget.selected] or "?"
        end
        widget.draws.selected_text.Text = truncate(summary, box_w - 5 - 22)
        widget.draws.selected_text.Position = Vector2.new(ax + widget_pad + 5, row_y + math.floor((widget_dropdown_box_h - widget_font_size) / 2))
        widget.draws.selected_text.Visible = in_clip_box

        widget.draws.arrow.Text = "v"
        widget.draws.arrow.Position = Vector2.new(ax + widget_pad + box_w - 12, row_y + math.floor((widget_dropdown_box_h - widget_font_size) / 2))
        widget.draws.arrow.Visible = in_clip_box

        widget._box_x = ax + widget_pad
        widget._box_y = row_y
        widget._box_w = box_w
    end
end

local function set_section_hidden(sec)
    local sd = sec.draws
    sd.border.Visible = false
    sd.bg.Visible = false
    sd.header_title.Visible = false
    sd.header_sep.Visible = false
    sd.scroll_track.Visible = false
    sd.scroll_thumb.Visible = false
    for _, widget in ipairs(sec.widgets) do
        hide_widget(widget)
    end
end

local function position_section(win, sec, content_scroll)
    local cx, cy = content_origin(win)
    local cy_end = cy + get_content_h(win)
    local ax = cx + sec.ox
    local ay = cy + sec.oy - content_scroll
    local w = sec.w
    local h = sec.h
    local sd = sec.draws

    local sec_top = ay
    local sec_bot = ay + h
    local any_overlap = sec_bot > cy and sec_top < cy_end

    local draw_top = math.max(ay, cy)
    local draw_bot = math.min(ay + h, cy_end)
    local draw_h = draw_bot - draw_top
    local has_area = draw_h > 0

    sd.border.Position = Vector2.new(ax - 1, draw_top - 1)
    sd.border.Size = Vector2.new(w + 2, draw_h + 2)
    sd.border.Visible = has_area

    sd.bg.Position = Vector2.new(ax, draw_top)
    sd.bg.Size = Vector2.new(w, draw_h)
    sd.bg.Visible = has_area

    local title_y = ay + math.floor(section_header_h / 2) - 6
    sd.header_title.Position = Vector2.new(ax + 10, title_y)
    sd.header_title.Visible = any_overlap and title_y >= cy and title_y + widget_header_font_size <= cy_end

    local sep_y = ay + section_header_h
    sd.header_sep.From = Vector2.new(ax, sep_y)
    sd.header_sep.To = Vector2.new(ax + w, sep_y)
    sd.header_sep.Visible = any_overlap and sep_y > cy and sep_y < cy_end

    local body_ay = ay + section_header_h + 5 - sec.scroll
    local body_clip_top = math.max(cy, ay + section_header_h)
    local body_clip_bot = math.min(cy_end, ay + h)

    for _, widget in ipairs(sec.widgets) do
        if not any_overlap then
            hide_widget(widget)
        else
            position_widget(widget, ax, body_clip_top, body_clip_bot, body_ay, w)
        end
    end

    local max_sec_scroll = get_max_section_scroll(sec)
    local body_top = ay + section_header_h
    local body_h = h - section_header_h
    local body_bot = ay + h

    if max_sec_scroll > 0 then
        local thumb_range = body_h - scroll_thumb_h
        local thumb_off = thumb_range > 0 and math.floor((sec.scroll / max_sec_scroll) * thumb_range) or 0
        local track_x = ax + w - scroll_w - 2
        local track_visible = any_overlap and body_top >= cy and body_bot <= cy_end

        sd.scroll_track.Position = Vector2.new(track_x, body_top)
        sd.scroll_track.Size = Vector2.new(scroll_w, body_h)
        sd.scroll_track.Visible = track_visible

        sd.scroll_thumb.Position = Vector2.new(track_x, body_top + thumb_off)
        sd.scroll_thumb.Visible = track_visible
    else
        sd.scroll_track.Visible = false
        sd.scroll_thumb.Visible = false
    end
end

local function rebuild_tab_layout(win, tab)
    local left_cur = content_pad
    local right_cur = content_pad
    for _, sec in ipairs(tab.sections) do
        sec.ox = get_col_ox(win, sec.side)
        sec.w = get_col_w(win)
        if sec.side == ui.Side.Left then
            sec.oy = left_cur
            left_cur = left_cur + sec.h + section_gap
        else
            sec.oy = right_cur
            right_cur = right_cur + sec.h + section_gap
        end
    end
    tab.left_cursor = left_cur
    tab.right_cursor = right_cur
end

local function grow_section(win, tab, sec, amount)
    sec.body_h = sec.body_h + amount
    sec.h = section_header_h + sec.body_h + section_inner_pad
    rebuild_tab_layout(win, tab)
end

local function refresh_sections(win)
    local active_tab = get_active_tab(win)
    local cy = win.y + title_h
    local content_h = get_content_h(win)
    local d = win.draws

    for _, tab in ipairs(win.tabs) do
        local is_active = tab.id == win.active_tab
        for _, sec in ipairs(tab.sections) do
            if not is_active then
                set_section_hidden(sec)
            else
                position_section(win, sec, tab.content_scroll)
            end
        end
    end

    local max_scroll = active_tab and get_max_content_scroll(win) or 0
    local track_x = win.x + win.w - scroll_w - 2

    if max_scroll > 0 and active_tab then
        local thumb_range = content_h - scroll_thumb_h
        local thumb_off = thumb_range > 0 and math.floor((active_tab.content_scroll / max_scroll) * thumb_range) or 0

        d.content_track.Position = Vector2.new(track_x, cy)
        d.content_track.Size = Vector2.new(scroll_w, content_h)
        d.content_track.Visible = true

        d.content_thumb.Position = Vector2.new(track_x, cy + thumb_off)
        d.content_thumb.Visible = true
    else
        d.content_track.Visible = false
        d.content_thumb.Visible = false
    end
end

local function refresh_tabs(win)
    if not win.visible then
        local d = win.draws
        d.border.Visible = false
        d.bg.Visible = false
        d.titlebar.Visible = false
        d.sidebar_bg.Visible = false
        d.sidebar_sep.Visible = false
        d.mask_top.Visible = false
        d.title_sep.Visible = false
        d.title_text.Visible = false
        d.content_track.Visible = false
        d.content_thumb.Visible = false
        for _, tab in ipairs(win.tabs) do
            local td = tab.draws
            td.bg.Visible = false
            td.accent.Visible = false
            td.label.Visible = false
            if td.sublabel then td.sublabel.Visible = false end
            for _, sec in ipairs(tab.sections) do
                set_section_hidden(sec)
            end
        end
        return
    end

    local x, y = win.x, win.y
    local sidebar_y = y + title_h
    local sidebar_bottom = y + win.h
    local d = win.draws

    d.border.Visible = true
    d.bg.Visible = true
    d.titlebar.Visible = true
    d.sidebar_bg.Visible = true
    d.sidebar_sep.Visible = true
    d.mask_top.Visible = true
    d.title_sep.Visible = true
    d.title_text.Visible = true

    for i, tab in ipairs(win.tabs) do
        local tab_y = sidebar_y + (i - 1) * tab_h
        local fits = tab_y + tab_h <= sidebar_bottom
        local is_active = tab.id == win.active_tab
        local td = tab.draws

        td.bg.Position = Vector2.new(x, tab_y)
        td.bg.Color = is_active and theme.tab_active or theme.sidebar
        td.bg.Visible = fits

        td.accent.From = Vector2.new(x, tab_y)
        td.accent.To = Vector2.new(x, tab_y + tab_h)
        td.accent.Visible = fits and is_active

        td.label.Position = Vector2.new(x + 14, tab_y + 14)
        td.label.Visible = fits

        if td.sublabel then
            td.sublabel.Position = Vector2.new(x + 14, tab_y + 30)
            td.sublabel.Visible = fits
        end
    end

    refresh_sections(win)
end

local function apply_window_pos(win)
    local x, y, w, h = win.x, win.y, win.w, win.h
    local d = win.draws
    local cx = x + sidebar_w + 1
    local content_w = w - sidebar_w - 1

    d.border.Position = Vector2.new(x - 1, y - 1)
    d.bg.Position = Vector2.new(x, y)
    d.titlebar.Position = Vector2.new(x, y)
    d.sidebar_bg.Position = Vector2.new(x, y + title_h)
    d.sidebar_sep.From = Vector2.new(x + sidebar_w, y + title_h)
    d.sidebar_sep.To = Vector2.new(x + sidebar_w, y + h)
    d.title_text.Position = Vector2.new(x + 12, y + math.floor(title_h / 2) - 6)
    d.title_sep.From = Vector2.new(x, y + title_h)
    d.title_sep.To = Vector2.new(x + w, y + title_h)
    d.mask_top.Position = Vector2.new(cx, y)
    d.mask_top.Size = Vector2.new(content_w, title_h)

    refresh_tabs(win)
end

local function build_window_draws(win)
    local x, y, w, h = win.x, win.y, win.w, win.h
    local cx = x + sidebar_w + 1
    local content_w = w - sidebar_w - 1
    local d = {}

    d.border = new_square(true, x - 1, y - 1, w + 2, h + 2, theme.border, z_border)
    d.bg = new_square(true, x, y, w, h, theme.bg, z_bg)
    d.titlebar = new_square(true, x, y, w, title_h, theme.titlebar, z_chrome)
    d.sidebar_bg = new_square(true, x, y + title_h, sidebar_w, h - title_h, theme.sidebar, z_chrome)
    d.sidebar_sep = new_line(x + sidebar_w, y + title_h, x + sidebar_w, y + h, theme.border, 1, z_sep)
    d.mask_top = new_square(true, cx, y, content_w, title_h, theme.titlebar, z_mask)
    d.title_sep = new_line(x, y + title_h, x + w, y + title_h, theme.accent, 1, z_title_el)
    d.title_text = new_text(win.title, x + 12, y + math.floor(title_h / 2) - 6, 14, theme.text, z_title_el)
    d.content_track = new_square(true, x + w - scroll_w - 2, y + title_h, scroll_w, h - title_h, theme.scroll_track, z_content_scroll)
    d.content_track.Visible = false
    d.content_thumb = new_square(true, x + w - scroll_w - 2, y + title_h, scroll_w, scroll_thumb_h, theme.accent, z_content_scroll + 1)
    d.content_thumb.Visible = false

    return d
end

local function build_tab_draws(win, tab)
    local x = win.x
    local tab_y = win.y + title_h + (#win.tabs * tab_h)
    local td = {}

    td.bg = new_square(true, x, tab_y, sidebar_w, tab_h, theme.sidebar, z_tab_bg)
    td.bg.Visible = false
    td.accent = new_line(x, tab_y, x, tab_y + tab_h, theme.accent, 2, z_tab_el)
    td.accent.Visible = false
    td.label = new_text(tab.label, x + 14, tab_y + 14, 14, theme.text, z_tab_el)
    td.label.Visible = false

    if tab.sublabel then
        td.sublabel = new_text(tab.sublabel, x + 14, tab_y + 30, 12, theme.text_dim, z_tab_el)
        td.sublabel.Visible = false
    end

    tab.draws = td
end

local function build_section_draws(win, sec)
    local cx, cy = content_origin(win)
    local ax = cx + sec.ox
    local ay = cy + sec.oy
    local w = sec.w
    local h = sec.h
    local sd = {}

    sd.border = new_square(true, ax - 1, ay - 1, w + 2, h + 2, theme.border, z_section_border)
    sd.border.Visible = false
    sd.bg = new_square(true, ax, ay, w, h, theme.section_bg, z_section_bg)
    sd.bg.Visible = false
    sd.header_title = new_text(sec.title, ax + 10, ay + math.floor(section_header_h / 2) - 6, widget_header_font_size, theme.text, z_section_header)
    sd.header_title.Visible = false
    sd.header_sep = new_line(ax, ay + section_header_h, ax + w, ay + section_header_h, theme.accent, 1, z_section_header)
    sd.header_sep.Visible = false
    sd.scroll_track = new_square(true, ax + w - scroll_w - 2, ay + section_header_h, scroll_w, h - section_header_h, theme.scroll_track, z_section_scroll)
    sd.scroll_track.Visible = false
    sd.scroll_thumb = new_square(true, ax + w - scroll_w - 2, ay + section_header_h, scroll_w, scroll_thumb_h, theme.accent, z_section_scroll + 1)
    sd.scroll_thumb.Visible = false

    sec.draws = sd
end

function ui.create_window(id, title, x, y, w, h)
    if ui._windows[id] then
        return ui._windows[id]
    end

    local win = {
        id = id,
        title = title,
        x = x, y = y,
        w = w, h = h,
        tabs = {},
        active_tab = nil,
        visible = true,
    }

    win.draws = build_window_draws(win)
    ui._windows[id] = win
    return win
end

function ui.set_window_visible(win, visible)
    win.visible = visible
    refresh_tabs(win)
end

function ui.add_tab(win, id, label, sublabel)
    local tab = {
        id = id,
        label = label,
        sublabel = sublabel,
        sections = {},
        left_cursor = content_pad,
        right_cursor = content_pad,
        content_scroll = 0,
    }

    build_tab_draws(win, tab)
    table.insert(win.tabs, tab)

    if not win.active_tab then
        win.active_tab = id
    end

    refresh_tabs(win)
    return tab
end

function ui.add_section(win, tab, title, side)
    local oy = side == ui.Side.Left and tab.left_cursor or tab.right_cursor

    local sec = {
        title = title,
        side = side,
        ox = get_col_ox(win, side),
        oy = oy,
        w = get_col_w(win),
        body_h = 0,
        scroll = 0,
        widgets = {},
        widget_cursor = 0,
    }

    sec.h = section_header_h + sec.body_h + section_inner_pad

    build_section_draws(win, sec)
    table.insert(tab.sections, sec)

    local advanced = sec.h + section_gap
    if side == ui.Side.Left then
        tab.left_cursor = tab.left_cursor + advanced
    else
        tab.right_cursor = tab.right_cursor + advanced
    end

    if tab.id == win.active_tab then
        position_section(win, sec, tab.content_scroll)
    end

    return sec
end

function ui.add_header_text(win, tab, sec, text)
    local widget = {
        type = "header_text",
        body_oy = sec.widget_cursor,
        h = widget_h_header,
        draws = {},
    }

    widget.draws.label = new_text(text, 0, 0, widget_header_font_size, theme.text, z_widget)
    widget.draws.label.Visible = false
    widget.draws.line = new_line(0, 0, 10, 0, theme.accent, 1, z_widget)
    widget.draws.line.Visible = false

    table.insert(sec.widgets, widget)
    sec.widget_cursor = sec.widget_cursor + widget.h
    grow_section(win, tab, sec, widget.h)

    if tab.id == win.active_tab then
        refresh_sections(win)
    end

    return widget
end

function ui.add_info_text(win, tab, sec, text)
    local avail_w = sec.w - widget_pad * 2
    local wrapped = word_wrap(text, avail_w)
    local total_h = #wrapped * widget_line_h + 4

    local widget = {
        type = "info_text",
        body_oy = sec.widget_cursor,
        h = total_h,
        draws = { lines = {} },
    }

    for _, line_str in ipairs(wrapped) do
        local obj = new_text(line_str, 0, 0, widget_font_size, theme.text_dim, z_widget)
        obj.Visible = false
        table.insert(widget.draws.lines, obj)
    end

    table.insert(sec.widgets, widget)
    sec.widget_cursor = sec.widget_cursor + widget.h
    grow_section(win, tab, sec, widget.h)

    if tab.id == win.active_tab then
        refresh_sections(win)
    end

    return widget
end

function ui.add_divider(win, tab, sec)
    local widget = {
        type = "divider",
        body_oy = sec.widget_cursor,
        h = widget_h_divider,
        draws = {},
    }

    widget.draws.line = new_line(0, 0, 10, 0, theme.divider, 1, z_widget)
    widget.draws.line.Visible = false

    table.insert(sec.widgets, widget)
    sec.widget_cursor = sec.widget_cursor + widget.h
    grow_section(win, tab, sec, widget.h)

    if tab.id == win.active_tab then
        refresh_sections(win)
    end

    return widget
end

function ui.add_spacer(win, tab, sec, height)
    local h = height or widget_h_spacer
    local widget = {
        type = "spacer",
        body_oy = sec.widget_cursor,
        h = h,
        draws = {},
    }

    table.insert(sec.widgets, widget)
    sec.widget_cursor = sec.widget_cursor + h
    grow_section(win, tab, sec, h)

    if tab.id == win.active_tab then
        refresh_sections(win)
    end

    return widget
end

local function refresh_toggle_draw(widget)
    widget.draws.fill.Color = widget.state and theme.accent or theme.border
    widget.draws.box.Color = widget.state and theme.accent or theme.border
end

function ui.add_toggle(win, tab, sec, label, default, callback)
    local widget = {
        type = "toggle",
        body_oy = sec.widget_cursor,
        h = widget_h_toggle,
        state = default or false,
        callback = callback,
        draws = {},
    }

    widget.draws.box = new_square(false, 0, 0, widget_toggle_box, widget_toggle_box, theme.border, z_widget)
    widget.draws.box.Visible = false
    widget.draws.fill = new_square(true, 0, 0, widget_toggle_box - 2, widget_toggle_box - 2, theme.accent, z_widget)
    widget.draws.fill.Visible = false
    widget.draws.label = new_text(label, 0, 0, widget_font_size, theme.text, z_widget)
    widget.draws.label.Visible = false

    refresh_toggle_draw(widget)

    table.insert(sec.widgets, widget)
    sec.widget_cursor = sec.widget_cursor + widget.h
    grow_section(win, tab, sec, widget.h)

    if tab.id == win.active_tab then
        refresh_sections(win)
    end

    return widget
end

function ui.add_slider(win, tab, sec, label, min, max, default, callback)
    local widget = {
        type = "slider",
        body_oy = sec.widget_cursor,
        h = widget_h_slider,
        min = min,
        max = max,
        value = math.clamp(default or min, min, max),
        callback = callback,
        draws = {},
        _track_ax = 0,
        _track_w = 0,
        _track_y = 0,
    }

    widget.draws.label = new_text(label, 0, 0, widget_font_size, theme.text, z_widget)
    widget.draws.label.Visible = false
    widget.draws.value = new_text(tostring(math.floor(widget.value)), 0, 0, widget_font_size, theme.text_dim, z_widget)
    widget.draws.value.Visible = false
    widget.draws.track = new_square(true, 0, 0, 10, widget_slider_h, theme.border, z_widget)
    widget.draws.track.Visible = false
    widget.draws.fill = new_square(true, 0, 0, 0, widget_slider_h, theme.accent, z_widget + 1)
    widget.draws.fill.Visible = false
    widget.draws.thumb = new_square(true, 0, 0, widget_slider_thumb_w, widget_slider_thumb_h, theme.accent, z_widget + 2)
    widget.draws.thumb.Visible = false

    table.insert(sec.widgets, widget)
    sec.widget_cursor = sec.widget_cursor + widget.h
    grow_section(win, tab, sec, widget.h)

    if tab.id == win.active_tab then
        refresh_sections(win)
    end

    return widget
end

function ui.add_keybind(win, tab, sec, label, default_key, callback)
    local widget = {
        type = "keybind",
        body_oy = sec.widget_cursor,
        h = widget_h_keybind,
        label = label,
        key = default_key,
        callback = callback,
        draws = {},
        _box_x = 0,
        _box_y = 0,
        _prev_pressed = false,
    }

    widget.draws.label = new_text(label, 0, 0, widget_font_size, theme.text, z_widget)
    widget.draws.label.Visible = false
    widget.draws.box = new_square(false, 0, 0, widget_keybind_box_w, widget_keybind_box_h, theme.border, z_widget)
    widget.draws.box.Visible = false
    local key_label = key_names[default_key] or "?"
    widget.draws.key_text = new_text(key_label, 0, 0, widget_font_size, theme.text_dim, z_widget + 1)
    widget.draws.key_text.Visible = false

    table.insert(sec.widgets, widget)
    sec.widget_cursor = sec.widget_cursor + widget.h
    grow_section(win, tab, sec, widget.h)

    if tab.id == win.active_tab then
        refresh_sections(win)
    end

    return widget
end

function ui.add_button(win, tab, sec, label, callback)
    local widget = {
        type = "button",
        body_oy = sec.widget_cursor,
        h = widget_h_button,
        label = label,
        callback = callback,
        draws = {},
        _btn_x = 0,
        _btn_y = 0,
        _btn_w = 0,
        _btn_h = 0,
    }

    widget.draws.border = new_square(false, 0, 0, 10, widget_h_button - 4, theme.border, z_widget)
    widget.draws.border.Visible = false
    widget.draws.bg = new_square(true, 0, 0, 10, widget_h_button - 4, theme.tab_active, z_widget)
    widget.draws.bg.Visible = false
    widget.draws.label = new_text(label, 0, 0, widget_font_size, theme.text, z_widget + 1)
    widget.draws.label.Visible = false

    table.insert(sec.widgets, widget)
    sec.widget_cursor = sec.widget_cursor + widget.h
    grow_section(win, tab, sec, widget.h)

    if tab.id == win.active_tab then
        refresh_sections(win)
    end

    return widget
end

local function close_dropdown()
    local widget = ui._open_dropdown
    if not widget then return end
    for _, item in ipairs(widget.draws.items) do
        item.bg.Visible = false
        if item.check then item.check.Visible = false end
        item.text.Visible = false
    end
    widget.draws.list_bg.Visible = false
    widget.draws.list_border.Visible = false
    ui._open_dropdown = nil
end

local function open_dropdown(widget)
    close_dropdown()
    local list_w = widget._box_w
    local list_h = #widget.options * widget_dropdown_item_h
    local lx = widget._box_x
    local ly = widget._box_y + widget_dropdown_box_h
    local is_multi = widget.type == "multiselect"

    widget.draws.list_border.Position = Vector2.new(lx - 1, ly - 1)
    widget.draws.list_border.Size = Vector2.new(list_w + 2, list_h + 2)
    widget.draws.list_border.Visible = true

    widget.draws.list_bg.Position = Vector2.new(lx, ly)
    widget.draws.list_bg.Size = Vector2.new(list_w, list_h)
    widget.draws.list_bg.Visible = true

    for i, item in ipairs(widget.draws.items) do
        local iy = ly + (i - 1) * widget_dropdown_item_h
        local is_sel = is_multi and widget.selected[i] or (i == widget.selected)
        item.bg.Position = Vector2.new(lx, iy)
        item.bg.Size = Vector2.new(list_w, widget_dropdown_item_h)
        item.bg.Color = is_sel and theme.tab_active or theme.section_bg
        item.bg.Visible = true
        if is_multi then
            local check_y = iy + math.floor((widget_dropdown_item_h - 8) / 2)
            item.check.Position = Vector2.new(lx + 5, check_y)
            item.check.Size = Vector2.new(8, 8)
            item.check.Color = is_sel and theme.accent or theme.border
            item.check.Visible = true
            item.text.Text = truncate(widget.options[i], list_w - 22)
            item.text.Position = Vector2.new(lx + 18, iy + math.floor((widget_dropdown_item_h - widget_font_size) / 2))
        else
            item.text.Text = truncate(widget.options[i], list_w - 10)
            item.text.Position = Vector2.new(lx + 5, iy + math.floor((widget_dropdown_item_h - widget_font_size) / 2))
        end
        item.text.Visible = true
    end

    ui._open_dropdown = widget
end

local function build_dropdown_draws(widget, options)
    widget.draws.label = new_text(widget.label, 0, 0, widget_font_size, theme.text, z_widget)
    widget.draws.label.Visible = false
    widget.draws.box = new_square(false, 0, 0, 10, widget_dropdown_box_h, theme.border, z_widget)
    widget.draws.box.Visible = false
    widget.draws.selected_text = new_text("", 0, 0, widget_font_size, theme.text_dim, z_widget + 1)
    widget.draws.selected_text.Visible = false
    widget.draws.arrow = new_text("v", 0, 0, widget_font_size, theme.text_dim, z_widget + 1)
    widget.draws.arrow.Visible = false
    widget.draws.list_border = new_square(false, 0, 0, 10, 10, theme.border, z_dropdown)
    widget.draws.list_border.Visible = false
    widget.draws.list_bg = new_square(true, 0, 0, 10, 10, theme.section_bg, z_dropdown)
    widget.draws.list_bg.Visible = false
    widget.draws.items = {}
    local is_multi = widget.type == "multiselect"
    for _, opt in ipairs(options) do
        local item = {}
        item.bg = new_square(true, 0, 0, 10, widget_dropdown_item_h, theme.section_bg, z_dropdown + 1)
        item.bg.Visible = false
        if is_multi then
            item.check = new_square(true, 0, 0, 8, 8, theme.border, z_dropdown + 2)
            item.check.Visible = false
        end
        item.text = new_text(opt, 0, 0, widget_font_size, theme.text, z_dropdown + 2)
        item.text.Visible = false
        table.insert(widget.draws.items, item)
    end
end

function ui.add_dropdown(win, tab, sec, label, options, default, callback)
    local widget = {
        type = "dropdown",
        body_oy = sec.widget_cursor,
        h = widget_h_dropdown,
        label = label,
        options = options,
        selected = math.clamp(default or 1, 1, #options),
        callback = callback,
        draws = {},
        _box_x = 0,
        _box_y = 0,
        _box_w = 0,
    }

    build_dropdown_draws(widget, options)
    table.insert(sec.widgets, widget)
    sec.widget_cursor = sec.widget_cursor + widget.h
    grow_section(win, tab, sec, widget.h)

    if tab.id == win.active_tab then
        refresh_sections(win)
    end

    return widget
end

function ui.add_multiselect(win, tab, sec, label, options, defaults, callback)
    local selected = {}
    for i = 1, #options do
        selected[i] = defaults and defaults[i] or false
    end

    local widget = {
        type = "multiselect",
        body_oy = sec.widget_cursor,
        h = widget_h_dropdown,
        label = label,
        options = options,
        selected = selected,
        callback = callback,
        draws = {},
        _box_x = 0,
        _box_y = 0,
        _box_w = 0,
    }

    build_dropdown_draws(widget, options)
    table.insert(sec.widgets, widget)
    sec.widget_cursor = sec.widget_cursor + widget.h
    grow_section(win, tab, sec, widget.h)

    if tab.id == win.active_tab then
        refresh_sections(win)
    end

    return widget
end

local function apply_theme_to_all_draws(win)
    local d = win.draws
    d.border.Color = theme.border
    d.bg.Color = theme.bg
    d.titlebar.Color = theme.titlebar
    d.sidebar_bg.Color = theme.sidebar
    d.sidebar_sep.Color = theme.border
    d.mask_top.Color = theme.titlebar
    d.title_sep.Color = theme.accent
    d.title_text.Color = theme.text
    d.content_track.Color = theme.scroll_track
    d.content_thumb.Color = theme.accent

    for _, tab in ipairs(win.tabs) do
        local td = tab.draws
        local is_active = tab.id == win.active_tab
        td.bg.Color = is_active and theme.tab_active or theme.sidebar
        td.accent.Color = theme.accent
        td.label.Color = theme.text
        if td.sublabel then td.sublabel.Color = theme.text_dim end

        for _, sec in ipairs(tab.sections) do
            local sd = sec.draws
            sd.border.Color = theme.border
            sd.bg.Color = theme.section_bg
            sd.header_title.Color = theme.text
            sd.header_sep.Color = theme.accent
            sd.scroll_track.Color = theme.scroll_track
            sd.scroll_thumb.Color = theme.accent

            for _, widget in ipairs(sec.widgets) do
                if widget.type == "header_text" then
                    widget.draws.label.Color = theme.text
                    widget.draws.line.Color = theme.accent
                elseif widget.type == "info_text" then
                    for _, obj in ipairs(widget.draws.lines) do
                        obj.Color = theme.text_dim
                    end
                elseif widget.type == "divider" then
                    widget.draws.line.Color = theme.divider
                elseif widget.type == "toggle" then
                    widget.draws.label.Color = theme.text
                    refresh_toggle_draw(widget)
                elseif widget.type == "slider" then
                    widget.draws.label.Color = theme.text
                    widget.draws.value.Color = theme.text_dim
                    widget.draws.track.Color = theme.border
                    widget.draws.fill.Color = theme.accent
                    widget.draws.thumb.Color = theme.accent
                elseif widget.type == "keybind" then
                    widget.draws.label.Color = theme.text
                    widget.draws.key_text.Color = theme.text_dim
                    if ui._keybind_listening == widget then
                        widget.draws.box.Color = theme.accent
                    else
                        widget.draws.box.Color = theme.border
                    end
                elseif widget.type == "button" then
                    widget.draws.border.Color = theme.border
                    widget.draws.bg.Color = theme.tab_active
                    widget.draws.label.Color = theme.text
                elseif widget.type == "dropdown" or widget.type == "multiselect" then
                    widget.draws.label.Color = theme.text
                    widget.draws.box.Color = theme.border
                    widget.draws.selected_text.Color = theme.text_dim
                    widget.draws.arrow.Color = theme.text_dim
                    widget.draws.list_border.Color = theme.border
                    widget.draws.list_bg.Color = theme.section_bg
                    for _, item in ipairs(widget.draws.items) do
                        item.text.Color = theme.text
                    end
                end
            end
        end
    end

    refresh_tabs(win)
end

function ui.update()
    local mx = mouse.X
    local my = mouse.Y
    local m1 = ismouse1pressed()
    local clicked = m1 and not ui._prev_m1

    if m1 then
        if ui._drag then
            local win = ui._drag.win
            if win.visible then
                win.x = mx - ui._drag.ox
                win.y = my - ui._drag.oy
                apply_window_pos(win)
            end
        elseif ui._content_scroll_drag then
            local csd = ui._content_scroll_drag
            local win = csd.win
            local tab = get_active_tab(win)
            if tab then
                local thumb_range = get_content_h(win) - scroll_thumb_h
                local delta = thumb_range > 0 and ((my - csd.start_my) / thumb_range) * csd.max_scroll or 0
                tab.content_scroll = math.clamp(csd.start_scroll + delta, 0, csd.max_scroll)
                refresh_sections(win)
            end
        elseif ui._section_scroll_drag then
            local ssd = ui._section_scroll_drag
            local sec = ssd.sec
            local body_h = sec.h - section_header_h
            local thumb_range = body_h - scroll_thumb_h
            local delta = thumb_range > 0 and ((my - ssd.start_my) / thumb_range) * ssd.max_scroll or 0
            sec.scroll = math.clamp(ssd.start_scroll + delta, 0, ssd.max_scroll)
            local tab = get_active_tab(ssd.win)
            if tab then
                position_section(ssd.win, sec, tab.content_scroll)
            end
        elseif ui._slider_drag then
            local sd = ui._slider_drag
            local widget = sd.widget
            local t = math.clamp((mx - widget._track_ax) / widget._track_w, 0, 1)
            widget.value = sd.min + t * (sd.max - sd.min)
            local tab = get_active_tab(sd.win)
            if tab then
                position_section(sd.win, sd.sec, tab.content_scroll)
            end
            if widget.callback then
                widget.callback(widget.value)
            end
        elseif clicked then
            if ui._open_dropdown then
                local wd = ui._open_dropdown
                local list_h = #wd.options * widget_dropdown_item_h
                local lx = wd._box_x
                local ly = wd._box_y + widget_dropdown_box_h
                local hit_item = false
                if mx >= lx and mx <= lx + wd._box_w and my >= ly and my <= ly + list_h then
                    local idx = math.floor((my - ly) / widget_dropdown_item_h) + 1
                    if idx >= 1 and idx <= #wd.options then
                        if wd.type == "multiselect" then
                            wd.selected[idx] = not wd.selected[idx]
                            if wd.callback then
                                local result = {}
                                for i, sel in ipairs(wd.selected) do
                                    if sel then table.insert(result, wd.options[i]) end
                                end
                                wd.callback(result, wd.selected)
                            end
                            open_dropdown(wd)
                            for _, win in pairs(ui._windows) do
                                local tab = get_active_tab(win)
                                if tab then
                                    for _, sec in ipairs(tab.sections) do
                                        for _, w in ipairs(sec.widgets) do
                                            if w == wd then
                                                position_section(win, sec, tab.content_scroll)
                                            end
                                        end
                                    end
                                end
                            end
                        else
                            wd.selected = idx
                            if wd.callback then
                                wd.callback(wd.options[idx], idx)
                            end
                            close_dropdown()
                            for _, win in pairs(ui._windows) do
                                local tab = get_active_tab(win)
                                if tab then
                                    for _, sec in ipairs(tab.sections) do
                                        for _, w in ipairs(sec.widgets) do
                                            if w == wd then
                                                position_section(win, sec, tab.content_scroll)
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    else
                        close_dropdown()
                    end
                    hit_item = true
                end
                if not hit_item then
                    close_dropdown()
                end
                if hit_item then
                    ui._prev_m1 = m1
                    return
                end
            end

            for _, win in pairs(ui._windows) do
                if not win.visible then continue end
                local sidebar_y = win.y + title_h
                local sidebar_bottom = win.y + win.h
                local cx, cy = content_origin(win)

                local max_content = get_max_content_scroll(win)
                if max_content > 0 then
                    local active_tab = get_active_tab(win)
                    if active_tab then
                        local thumb_range = get_content_h(win) - scroll_thumb_h
                        local thumb_off = thumb_range > 0 and math.floor((active_tab.content_scroll / max_content) * thumb_range) or 0
                        local track_x = win.x + win.w - scroll_w - 2
                        local thumb_y = cy + thumb_off

                        if mx >= track_x and mx <= track_x + scroll_w and my >= thumb_y and my <= thumb_y + scroll_thumb_h then
                            ui._content_scroll_drag = {
                                win = win,
                                start_my = my,
                                start_scroll = active_tab.content_scroll,
                                max_scroll = max_content,
                            }
                            break
                        end
                    end
                end

                local active_tab = get_active_tab(win)
                if active_tab then
                    local hit_widget = false
                    for _, sec in ipairs(active_tab.sections) do
                        local ax = cx + sec.ox
                        local ay = cy + sec.oy - active_tab.content_scroll
                        local body_ay = ay + section_header_h + 5 - sec.scroll
                        for _, widget in ipairs(sec.widgets) do
                            if widget.type == "toggle" and widget.draws.box.Visible then
                                local wy = body_ay + widget.body_oy
                                local box_y = wy + math.floor((widget_h_toggle - widget_toggle_box) / 2)
                                local box_x = ax + widget_pad
                                if mx >= box_x and mx <= box_x + widget_toggle_box and my >= box_y and my <= box_y + widget_toggle_box then
                                    widget.state = not widget.state
                                    refresh_toggle_draw(widget)
                                    position_section(win, sec, active_tab.content_scroll)
                                    if widget.callback then widget.callback(widget.state) end
                                    hit_widget = true
                                    break
                                end
                            elseif widget.type == "slider" and widget.draws.track.Visible then
                                local wy = body_ay + widget.body_oy
                                local track_y = wy + widget_h_slider - widget_slider_h - 4
                                local hit_y = track_y - math.floor((widget_slider_thumb_h - widget_slider_h) / 2)
                                if mx >= widget._track_ax and mx <= widget._track_ax + widget._track_w and my >= hit_y and my <= hit_y + widget_slider_thumb_h then
                                    ui._slider_drag = {
                                        win = win,
                                        sec = sec,
                                        widget = widget,
                                        min = widget.min,
                                        max = widget.max,
                                    }
                                    hit_widget = true
                                    break
                                end
                            elseif (widget.type == "dropdown" or widget.type == "multiselect") and widget.draws.box.Visible then
                                if mx >= widget._box_x and mx <= widget._box_x + widget._box_w and my >= widget._box_y and my <= widget._box_y + widget_dropdown_box_h then
                                    if ui._open_dropdown == widget then
                                        close_dropdown()
                                    else
                                        open_dropdown(widget)
                                    end
                                    hit_widget = true
                                    break
                                end
                            elseif widget.type == "button" and widget.draws.bg.Visible then
                                if mx >= widget._btn_x and mx <= widget._btn_x + widget._btn_w and my >= widget._btn_y and my <= widget._btn_y + widget._btn_h then
                                    if widget.callback then widget.callback() end
                                    hit_widget = true
                                    break
                                end
                            elseif widget.type == "keybind" and widget.draws.box.Visible then
                                if mx >= widget._box_x and mx <= widget._box_x + widget_keybind_box_w and my >= widget._box_y and my <= widget._box_y + widget_keybind_box_h then
                                    if ui._keybind_listening == widget then
                                        widget.key = 0x01
                                        ui._keybind_listening = nil
                                        ui._keybind_ready = false
                                        if widget.callback then widget.callback(widget.key) end
                                    else
                                        ui._keybind_listening = widget
                                        ui._keybind_ready = false
                                    end
                                    position_section(win, sec, active_tab.content_scroll)
                                    hit_widget = true
                                    break
                                end
                            end
                        end
                        if hit_widget then break end
                    end
                    if hit_widget then break end
                end

                active_tab = get_active_tab(win)
                if active_tab then
                    local hit_sec_scroll = false
                    for _, sec in ipairs(active_tab.sections) do
                        local max_sec = get_max_section_scroll(sec)
                        if max_sec > 0 then
                            local ax = cx + sec.ox
                            local ay = cy + sec.oy - active_tab.content_scroll
                            local body_top = ay + section_header_h
                            local body_h = sec.h - section_header_h
                            local thumb_range = body_h - scroll_thumb_h
                            local thumb_off = thumb_range > 0 and math.floor((sec.scroll / max_sec) * thumb_range) or 0
                            local track_x = ax + sec.w - scroll_w - 2
                            local thumb_y = body_top + thumb_off

                            if mx >= track_x and mx <= track_x + scroll_w and my >= thumb_y and my <= thumb_y + scroll_thumb_h then
                                ui._section_scroll_drag = {
                                    win = win,
                                    sec = sec,
                                    start_my = my,
                                    start_scroll = sec.scroll,
                                    max_scroll = max_sec,
                                }
                                hit_sec_scroll = true
                                break
                            end
                        end
                    end
                    if hit_sec_scroll then break end
                end

                if mx >= win.x and mx <= win.x + win.w and my >= win.y and my <= win.y + title_h then
                    ui._drag = { win = win, ox = mx - win.x, oy = my - win.y }
                    break
                end

                if mx >= win.x and mx <= win.x + sidebar_w and my >= sidebar_y and my <= sidebar_bottom then
                    for i, tab in ipairs(win.tabs) do
                        local tab_y = sidebar_y + (i - 1) * tab_h
                        if tab_y + tab_h <= sidebar_bottom and my >= tab_y and my <= tab_y + tab_h then
                            win.active_tab = tab.id
                            refresh_tabs(win)
                            break
                        end
                    end
                    break
                end
            end
        end
    else
        ui._drag = nil
        ui._content_scroll_drag = nil
        ui._section_scroll_drag = nil
        ui._slider_drag = nil
    end

    if ui._keybind_listening then
        if not m1 then
            ui._keybind_ready = true
        end

        if ui._keybind_ready then
            local widget = ui._keybind_listening
            for vk, _ in pairs(key_names) do
                if iskeypressed(vk) then
                    if vk == 0x1B then
                        ui._keybind_listening = nil
                        ui._keybind_ready = false
                    else
                        widget.key = vk
                        ui._keybind_listening = nil
                        ui._keybind_ready = false
                        ui._keybind_cooldown = widget
                    end
                    for _, win in pairs(ui._windows) do
                        local tab = get_active_tab(win)
                        if tab then
                            for _, sec in ipairs(tab.sections) do
                                for _, w in ipairs(sec.widgets) do
                                    if w == widget then
                                        position_section(win, sec, tab.content_scroll)
                                    end
                                end
                            end
                        end
                    end
                    break
                end
            end
        end
    end

    if ui._keybind_cooldown then
        if not iskeypressed(ui._keybind_cooldown.key) then
            ui._keybind_cooldown = nil
        end
    end

    if not ui._keybind_listening and not ui._keybind_cooldown then
        for _, win in pairs(ui._windows) do
            for _, tab in ipairs(win.tabs) do
                for _, sec in ipairs(tab.sections) do
                    for _, widget in ipairs(sec.widgets) do
                        if widget.type == "keybind" and widget.key and widget.callback then
                            local pressed = iskeypressed(widget.key)
                            if pressed and not widget._prev_pressed then
                                widget.callback(widget.key)
                            end
                            widget._prev_pressed = pressed
                        end
                    end
                end
            end
        end
    end

    ui._prev_m1 = m1
end


task.spawn(function()
    while true do
        ui.update()
        task.wait()
    end
end)

ui.themes = all_themes
ui.current_theme = "dark"
ui.theme_names = {"dark", "ocean", "rose", "slate", "forest"}

function ui.set_theme(name, win)
    local t = all_themes[name]
    if not t then
        t = all_themes["dark"]
        name = "dark"
    end
    theme = t
    ui.current_theme = name
    if win then
        apply_theme_to_all_draws(win)
    end
end

ui.apply_theme = apply_theme_to_all_draws
