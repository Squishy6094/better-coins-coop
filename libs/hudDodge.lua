-- Library for Making sure HUD elements don't overlap each other

log_to_console("loaded")

local HUD_HITBOXES_RENDER = true
local hitboxMarginWidth = 2
local hitboxMarginHeight = 2
local screenMarginWidth = 22
local screenMarginHeight = 15

local hitboxList = {}

local function reset_hitbox_list()
    local sW = djui_hud_get_screen_width()
    local sH = djui_hud_get_screen_height()
    hitboxList = {
        {x = 0, y = 0, w = screenMarginWidth, h = screenMarginHeight},
        {x = sW - screenMarginWidth, y = 0, w = screenMarginWidth, h = screenMarginHeight},
        {x = 0, y = sH - screenMarginHeight, w = screenMarginWidth, h = screenMarginHeight},
        {x = sW - screenMarginWidth, y = sH - screenMarginHeight, w = screenMarginWidth, h = screenMarginHeight},
    }
end

local og_djui_hud_render_rect = djui_hud_render_rect
local og_djui_hud_print_text = djui_hud_print_text
local og_djui_hud_render_texture = djui_hud_render_texture

_G.djui_hud_render_rect = function (x, y, w, h)
    local sW = djui_hud_get_screen_width()
    local sH = djui_hud_get_screen_height()
    if (w/sW) < 0.9 and (h/sH) < 0.9 then
        table.insert(hitboxList, {x = x, y = y, w = w, h = h})
    end
    og_djui_hud_render_rect(x, y, w, h)
end

_G.djui_hud_print_text = function (message, x, y, scaleX, scaleY)
    scaleY = scaleY or scaleX
    local msgW, msgH = djui_hud_measure_text(message)
    table.insert(hitboxList, {x = x, y = y, w = msgW*scaleX, h = msgH*scaleY})
    og_djui_hud_print_text(message, x, y, scaleX, scaleY)
end

_G.djui_hud_render_texture = function (tex, x, y, w, h)
    table.insert(hitboxList, {x = x, y = y, w = w*tex.width, h = h*tex.width})
    og_djui_hud_render_texture(tex, x, y, w, h)
end

local function hud_render()
    djui_hud_set_resolution(RESOLUTION_N64)
    for seed, hitbox in pairs(hitboxList) do
        if HUD_HITBOXES_RENDER then
            math.randomseed(seed)
            djui_hud_set_color(math.random(0, 2)/2*255, math.random(0, 2)/2*255, math.random(0, 2)/2*255, 100)
            og_djui_hud_render_rect(hitbox.x, hitbox.y, hitbox.w, hitbox.h)
        end
    end
    reset_hitbox_list()
end

hook_event(HOOK_ON_HUD_RENDER, hud_render)

local function set_hitbox_margin(x, y)
    hitboxMarginWidth = x
    hitboxMarginHeight = y
end

local function set_screen_margin(x, y)
    screenMarginWidth = x
    screenMarginHeight = y
end

local function rects_overlap(x1, y1, w1, h1, x2, y2, w2, h2)
    return x1 <= x2 + w2 and
           x1 + w1 >= x2 and
           y1 <= y2 + h2 and
           y1 + h1 >= y2
end

local function find_open_hud_space(x, y, w, h)
    local sW = djui_hud_get_screen_width()
    local sH = djui_hud_get_screen_height()
    repeat
        local overlapFound = false
        for _, hitbox in ipairs(hitboxList) do
            if rects_overlap(x, y, w, h, hitbox.x, hitbox.y, hitbox.w, hitbox.h) then
                x = hitbox.x + hitbox.w + hitboxMarginWidth
                djui_chat_message_create(tostring(x))
                overlapFound = true
                break
            end
        end
    until not overlapFound
    return x, y
end

return {
    set_hitbox_margin = set_hitbox_margin,
    set_screen_margin = set_screen_margin,
    find_open_hud_space = find_open_hud_space,
}