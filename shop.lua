local testToggle = false

local currShopPage = 0
local shopItems = {}

for i = 1, 100 do
    table.insert(shopItems, 
    {
        name = "Test Entry "..i,
        texture = gTextures.star,
        description = "Magical powers or something\nI love you",
        coins = 100,
        stock = -1,
        interact = function(purchased)
            testToggle = not testToggle
        end,
    })
end

local inShop = false

local function update()
    if gMarioStates[0].controller.buttonPressed & D_JPAD ~= 0 then
        djui_chat_message_create("set")
        if inShop then
            set_mario_action(gMarioStates[0], ACT_IDLE, 0)
            inShop = false
        else
            set_mario_action(gMarioStates[0], ACT_WAITING_FOR_DIALOG, 0)
            inShop = true
        end
    end
end

local TEX_HAND_CLOSED = get_texture_info("gd_texture_hand_closed")
local TEX_HAND_OPEN = get_texture_info("gd_texture_hand_open")

local cursorX = 0
local cursorY = 0
local itemSpacing = 20
local coinCountLerp = savedCoinCount
local prevCoinAmount = 1000
local arrowSize = 10
local perColumn = 8

local function hud_render()
    if not inShop then
        coinCountLerp = savedCoinCount
        return
    end
    local c = gMarioStates[0].controller
    djui_hud_set_resolution(RESOLUTION_N64)
    local sW = djui_hud_get_screen_width()
    local sH = djui_hud_get_screen_height()

    local shopX = sW*0.1
    local shopY = sH*0.1
    local shopW = sW*0.8
    local shopH = sH*0.8

    local perRow = math.round((shopW*0.6 - shopH*0.2)/itemSpacing)
    local perPage = perColumn*perRow
    local pageCount = math.floor(#shopItems/perPage)
    local perRowSize = perRow*itemSpacing
    cursorX = math.clamp(cursorX + c.stickX/8, shopX + shopW*0.3 - perRowSize*0.5 - 10, shopX + shopW*0.3 + perRowSize*0.5 + 10)
    cursorY = math.clamp(cursorY - c.stickY/8, shopY + shopH*0.1, shopY + shopH*0.9)

    djui_hud_set_color(0, 0, 0, 150)
    djui_hud_render_rect(shopX, shopY, shopW, shopH)

    djui_hud_set_color(255, 255, 255, 255)
    djui_hud_render_rect(shopX + shopW*0.6, shopY + shopH*0.1, 1, shopH*0.8)

    local pageString = "Page "..tostring(currShopPage+1).."/"..tostring(pageCount+1)
    local tW, tH = djui_hud_measure_text(pageString)
    djui_hud_print_text(pageString, shopX + shopW*0.3 - tW*0.15, shopY + shopH - 14, 0.3, 0.3)

    if currShopPage > 0 then
        if cursorX < shopX + shopW*0.3 - perRowSize*0.5 then
            djui_hud_set_rotation(0, 0, 0)
            djui_hud_set_color(255, 255, 255, 100)
            djui_hud_render_rect(shopX + shopW*0.3 - perRowSize*0.5 - 14, shopY + shopH*0.1, 12, shopH*0.8)
            if c.buttonPressed & A_BUTTON ~= 0 then
                play_sound(SOUND_MENU_CLICK_FILE_SELECT, gGlobalSoundSource)
                currShopPage = currShopPage - 1
            end
        end
        djui_hud_set_rotation(0x2000, 0.5, 0.5)
        djui_hud_set_color(255, 255, 255, 255)
        djui_hud_set_scissor((shopX + shopW*0.3 - perRowSize*0.5 - 15)*(320/sW), 0, (shopX + shopW*0.3 - perRowSize*0.5 - 5)*(320/sW), sH)
        djui_hud_render_rect(shopX + shopW*0.3 - perRowSize*0.5 - 5 - arrowSize*0.5, shopY + shopH*0.5 - arrowSize*0.5, arrowSize, arrowSize)
    end
    if pageCount > currShopPage then
        if cursorX > shopX + shopW*0.3 + perRowSize*0.5 then
            djui_hud_set_rotation(0, 0, 0)
            djui_hud_set_color(255, 255, 255, 100)
            djui_hud_render_rect(shopX + shopW*0.3 + perRowSize*0.5 + 2, shopY + shopH*0.1, 12, shopH*0.8)
            if c.buttonPressed & A_BUTTON ~= 0 then
                play_sound(SOUND_MENU_CLICK_FILE_SELECT, gGlobalSoundSource)
                currShopPage = currShopPage + 1
            end
        end
        djui_hud_set_rotation(0x2000, 0.5, 0.5)
        djui_hud_set_color(255, 255, 255, 255)
        djui_hud_set_scissor((shopX + shopW*0.3 + perRowSize*0.5 + 5)*(320/sW), 0, (shopX + shopW*0.3 + perRowSize*0.5 + 15)*(320/sW), sH)
        djui_hud_render_rect(shopX + shopW*0.3 + perRowSize*0.5 + 5 - arrowSize*0.5, shopY + shopH*0.5 - arrowSize*0.5, arrowSize, arrowSize)
    end
    djui_hud_reset_scissor()
    djui_hud_set_rotation(0, 0, 0)

    for id, item in pairs(shopItems) do
        if id > perPage*currShopPage and id <= perPage*(currShopPage + 1) then
            local x = shopX + shopW*0.3 - perRowSize*0.5 + itemSpacing*((id-1-perPage*currShopPage)%perRow)
            local y = shopY + shopH*0.1 + itemSpacing*math.floor((id-1-perPage*currShopPage)/perRow)
            djui_hud_render_texture(item.texture, x, y, 16/item.texture.width, 16/item.texture.height)
            if cursorX > x and cursorX < x + 16 and cursorY > y and cursorY < y + 16 then
                local x = shopX + shopW*0.6 + 10
                local y = shopY + shopH*0.1
                djui_hud_set_font(FONT_NORMAL)
                djui_hud_print_text(item.name, x, y, 0.5, 0.5)
                local tW, tH = djui_hud_measure_text(item.name)
                y = y + tH*0.5
                djui_hud_print_text(item.description, x, y, 0.25, 0.25)
                tW, tH = djui_hud_measure_text(item.description)
                y = y + tH*0.25 + 3
                djui_hud_set_font(FONT_HUD)
                djui_hud_render_texture(gTextures.coin, x, y, 1, 1)
                djui_hud_print_text(tostring(item.coins):gsub("-", "M"), x + 16, y, 1, 1)
                tW, tH = djui_hud_measure_text(item.description)
                y = y + tH

                if c.buttonPressed & A_BUTTON ~= 0 then
                    prevCoinAmount = item.coins
                    savedCoinCount = savedCoinCount - item.coins
                    save_coin_count()
                end
            end
        end
    end

    djui_hud_render_texture(c.buttonDown & A_BUTTON ~= 0 and TEX_HAND_CLOSED or TEX_HAND_OPEN, cursorX - 4, cursorY - 10, 1, 1)
    --djui_hud_render_rect(cursorX, cursorY, 1, 1)
    djui_hud_set_font(FONT_HUD)
    local coinString = tostring(coinCountLerp):gsub("-", "M")
    local tW, tH = djui_hud_measure_text(coinString)
    djui_hud_render_texture(gTextures.coin, sW*0.5 - tW*0.5 - 16, shopY + shopH + 3, 1, 1)
    djui_hud_print_text("@", sW*0.5 - tW*0.5, shopY + shopH + 3, 1, 1)
    djui_hud_print_text(coinString, sW*0.5 - tW*0.5 + 16, shopY + shopH + 3, 1, 1)

    if c.buttonDown & B_BUTTON ~= 0 then
        set_mario_action(gMarioStates[0], ACT_IDLE, 0)
        inShop = false
    end

    coinCountLerp = math.lerp(coinCountLerp, savedCoinCount, 0.1)
    local coinPitch = 1
    if coinCountLerp > savedCoinCount then
        coinCountLerp = math.floor(coinCountLerp)
        coinPitch = math.lerp(0.70, 1.25, math.clamp((coinCountLerp - savedCoinCount)/prevCoinAmount, 0, 1))
    else
        coinCountLerp = math.ceil(coinCountLerp)
        coinPitch = math.lerp(1.5, 0.95, math.clamp((coinCountLerp - savedCoinCount)/prevCoinAmount, 0, 1))
    end
    if coinCountLerp ~= savedCoinCount then
        customCoinSound = true
        play_sound_with_freq_scale(SOUND_GENERAL_COIN, gGlobalSoundSource, coinPitch)
    end
end

hook_event(HOOK_UPDATE, update)
hook_event(HOOK_ON_HUD_RENDER, hud_render)