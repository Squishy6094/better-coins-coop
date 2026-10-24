local m = gMarioStates[0] ---@type MarioState

local TEX_JP_RED_COIN_BAG_CLOSED = get_texture_info("red_coin_jp_bag_closed")
local TEX_JP_RED_COIN_BAG_OPEN = get_texture_info("red_coin_jp_bag_open")
local TEX_JP_RED_COIN_BAG_COIN = get_texture_info("red_coin_jp_bag_coin")


local currShopPage = 0
local shopItems = {
    --[[
    {
        name = "Test Item",
        texture = gTextures.star,
        description = "Tests the Item System\nFreaking Awesome",
        coins = 100,
        stock = -1,
    },
    ]]
    {
        name = "Pink Companion",
        key = "pinkCoin",
        stockDefault = 1,
        coins = mod_storage_load_bool("redeem"..redeemPinkCoin, false) and 999 or 999999,
        texture = gTextures.coin,
        color = function(item)
            if item.stock ~= 0 then
                return {
                    r = 255,
                    g = 255,
                    b = 255,
                    a = 255
                }
            elseif gPlayerSyncTable[0].pinkCoinActive then
                return {
                    r = 100,
                    g = 255,
                    b = 100,
                    a = 255
                }
            else
                return {
                    r = 255,
                    g = 100,
                    b = 100,
                    a = 255
                }
            end
        end,
        description = function(item)
            desc = "A fun little coin shaped friend.\nIt finds joy in showing you things\nwe cannot comprehend, almost\nletting you See the Unseen.\n\n"
            if item.stock == 0 then
                desc = desc..item.name.." "..(gPlayerSyncTable[0].pinkCoinActive and "Enabled" or "Disabled")
            else
                desc = desc.."Purchase to Enable"
            end
            if item.coins == 999 then
                desc = desc .. "\n\nThank you for being a supporter!\nEvery coin helps, and it means the\nworld that you enjoyed my work\nenough to support me!\n- With love, Squishy\n\n"
            end
            return desc
        end,
        before_interact = function(item)
            if item.stock == 0 then
                gPlayerSyncTable[0].pinkCoinActive = not gPlayerSyncTable[0].pinkCoinActive
                mod_storage_save_bool("pinkCoinToggle", gPlayerSyncTable[0].pinkCoinActive)
                play_sound_with_freq_scale(SOUND_MENU_CLICK_FILE_SELECT, gGlobalSoundSource, 0.9 + (gPlayerSyncTable[0].pinkCoinActive and 0.2 or 0))
                return
            end
            return true
        end,
    },
    {
        name = "JP Red Coin Sound",
        key = "jpRedCoinSounds",
        stockDefault = 1,
        coins = 2500,
        texture = function(item, x, y, scale)
            local texBag = configJPReds == 0 and TEX_JP_RED_COIN_BAG_CLOSED or TEX_JP_RED_COIN_BAG_OPEN 
            djui_hud_render_texture(texBag, x, y, scale, scale)
            if configJPReds > 0 then
                if configJPReds == 2 then
                    y = y + math.round(-0.5 + 1.5*math.sin(get_global_timer()/10))
                end
                djui_hud_render_texture(TEX_JP_RED_COIN_BAG_COIN, x, y, 1, 1)
            end
        end,
        description = function(item)
            desc = "Even though it's a seemingly normal\nRed Coin, there's something off\nabout it. It washed up on the shore\nand keeps making funky noises,\nalmost like it wasn't meant to\nfloat across the ocean.\n\nEven though it sounds different, it\nseems to take a liking to the way\nall of the Red Coins around here\ncount up!\n\n"
            if item.stock == 0 then
                desc = desc..item.name.." set to "
                if configJPReds == 2 then
                    desc = desc.."Pitched"
                elseif configJPReds == 1 then
                    desc = desc.."Original"
                else
                    desc = desc.."Off"
                end
            else
                desc = desc.."Purchase to Enable"
            end
            return desc
        end,
        before_interact = function(item)
            if item.stock == 0 then
                configJPReds = (configJPReds + 1)%3
                mod_storage_save_integer("configJPReds", configJPReds)
                play_sound_with_freq_scale(SOUND_MENU_CLICK_FILE_SELECT, gGlobalSoundSource, 0.9 + configJPReds*0.1)
                if configJPReds == 0 then
                    play_sound(SOUND_GENERAL_RED_COIN, gGlobalSoundSource)
                else
                    audio_stream_play(jpRedCoinSounds[configJPReds == 1 and 1 or 3], true, 2)
                end
                return
            end
            return true
        end,
    },
    {
        name = "Special Triple Jump",
        key = "specialTripleJump",
        stockDefault = 1,
        coins = 100 * (gBetterCoinValues.numCoinsToLife or 50),
        texture = function(item, x, y)
            return sSecretTextures[math.round(get_global_timer()*0.5)%(#sSecretTextures) + 1]
        end,
        color = function(item)
            if item.stock ~= 0 then
                return {
                    r = 255,
                    g = 255,
                    b = 255,
                    a = 255
                }
            elseif gMarioStates[0].specialTripleJump ~= 0 then
                return {
                    r = 100,
                    g = 255,
                    b = 100,
                    a = 255
                }
            else
                return {
                    r = 255,
                    g = 100,
                    b = 100,
                    a = 255
                }
            end
        end,
        description = function(item)
            desc = "A trinket from a green dinosaur\nfella that grants the wearer an\nenhanced Triple Jump that's immune\nto fall damage and packed with a\npretty sparkle!\n\n"
            if item.stock == 0 then
                desc = desc..item.name.." "..(gMarioStates[0].specialTripleJump ~= 0 and "Enabled" or "Disabled")
            else
                desc = desc.."Purchase to Enable"
            end
            return desc
        end,
        before_interact = function(item)
            if item.stock == 0 then
                gMarioStates[0].specialTripleJump = gMarioStates[0].specialTripleJump == 1 and 0 or 1
                play_sound(gMarioStates[0].specialTripleJump and SOUND_MENU_CAMERA_ZOOM_IN or SOUND_MENU_CAMERA_ZOOM_OUT, gGlobalSoundSource)
                play_sound_with_freq_scale(SOUND_MENU_CLICK_FILE_SELECT, gGlobalSoundSource, 0.9 + gMarioStates[0].specialTripleJump*0.2)
                
                return
            end
            return true
        end,
    },
    {
        name = "Cosmetic Hot Footed",
        key = "cosmeticHotFoot",
        stockDefault = 1,
        coins = 1000,
        texture = gTextures.star,
        color = function(item)
            if item.stock ~= 0 then
                return {
                    r = 255,
                    g = 255,
                    b = 255,
                    a = 255
                }
            elseif gPlayerSyncTable[0].particleActiveFoot ~= 0 then
                return {
                    r = 100,
                    g = 255,
                    b = 100,
                    a = 255
                }
            else
                return {
                    r = 255,
                    g = 100,
                    b = 100,
                    a = 255
                }
            end
        end,
        description = function(item)
            desc = "Ouch Hot!!!!\n\n"
            if item.stock == 0 then
                desc = desc..item.name.." "..(gPlayerSyncTable[0].particleActiveFoot ~= 0 and "Enabled" or "Disabled")
            else
                desc = desc.."Purchase to Enable"
            end
            return desc
        end,
        before_interact = function(item)
            if item.stock == 0 then
                gPlayerSyncTable[0].particleActiveFoot = gPlayerSyncTable[0].particleActiveFoot == 1 and 0 or 1
                play_sound(gPlayerSyncTable[0].particleActiveFoot and SOUND_MENU_CAMERA_ZOOM_IN or SOUND_MENU_CAMERA_ZOOM_OUT, gGlobalSoundSource)
                play_sound_with_freq_scale(SOUND_MENU_CLICK_FILE_SELECT, gGlobalSoundSource, 0.9 + gPlayerSyncTable[0].particleActiveFoot*0.2)
                
                return
            end
            return true
        end,
    },
}

local function setup_item(item)
    item.stockDefault = item.stockDefault or -1
    item.stock = item.stockDefault ~= -1 and mod_storage_load_integer("shop"..item.key.."Stock", item.stockDefault) or -1
    item.color = item.color or function()
        local color = (item.stock ~= 0 or item.before_interact) and 255 or 150
        return {
            r = color,
            g = color,
            b = color,
            a = 255
        }
    end
end

function add_shop_item(item)
    setup_item(item)
    table.insert(shopItems, item)
end

function get_shop_item_from_name(name)
    for _, item in pairs(shopItems) do
        if item.name == name then
            return item
        end
    end
end

local function init_shop_items()
    for _, item in pairs(shopItems) do
        setup_item(item)
    end

    -- Load toggle if unlocked
    pinkCoinItem = get_shop_item_from_name("Pink Companion")
    gPlayerSyncTable[0].pinkCoinActive = pinkCoinItem.stock == 0 and mod_storage_load_bool("pinkCoinToggle", false) or false

    jpRedCoinItem = get_shop_item_from_name("Pink Companion")
    configJPReds = jpRedCoinItem.stock == 0 and mod_storage_load_integer("configJPReds", 0) or 0
end

hook_event(HOOK_ON_MODS_LOADED, init_shop_items)

local TEX_HAND_CLOSED = get_texture_info("gd_texture_hand_closed")
local TEX_HAND_OPEN = get_texture_info("gd_texture_hand_open")


-- override dialog color funcs for shop screen
og_set_dialog_override_color = set_dialog_override_color
og_reset_dialog_override_color = reset_dialog_override_color

local dialogBgR = 0
local dialogBgG = 0
local dialogBgB = 0
local dialogBgA = 150
local dialogTextR = 255
local dialogTextG = 255
local dialogTextB = 255
local dialogTextA = 255
_G.set_dialog_override_color = function(bgR, bgG, bgB, bgA, textR, textG, textB, textA)
    dialogBgR = bgR
    dialogBgG = bgG
    dialogBgB = bgB
    dialogBgA = bgA
    dialogTextR = textR
    dialogTextG = textG
    dialogTextB = textB
    dialogTextA = textA
    return og_set_dialog_override_color(bgR, bgG, bgB, bgA, textR, textG, textB, textA)
end
_G.reset_dialog_override_color = function()
    dialogBgR = 0
    dialogBgG = 0
    dialogBgB = 0
    dialogBgA = 150
    dialogTextR = 255
    dialogTextG = 255
    dialogTextB = 255
    dialogTextA = 255
    return og_reset_dialog_override_color()
end

local cursorX = 0
local cursorY = 0
local itemSpacing = 20
local coinCountLerp = savedCoinCount
local prevCoinAmount = 1000
local arrowSize = 10
local perColumn = 8
local shakeTimer = 0

-- Vanilla anim vars
gShopBoxState = 3
gShopBoxScale = 0.1
gShopBoxOpenTimer = 90

local function hud_render()
    if gShopBoxState == 3 then
        coinCountLerp = savedCoinCount
        return
    end
    local c = m.controller
    djui_hud_set_resolution(RESOLUTION_N64)
    local sW = djui_hud_get_screen_width()
    local sH = djui_hud_get_screen_height()


    -- anim logic
    if (gShopBoxState == 0 or gShopBoxState == 2) then
        sShopScalePrev = gShopBoxScale;
        if (gShopBoxState == 0) then
            gShopBoxScale = gShopBoxScale*1.5;
            if gShopBoxScale >= 1 then
                gShopBoxScale = 1
                gShopBoxState = 1
            end
        else
            gShopBoxScale = gShopBoxScale/1.5;
            if gShopBoxScale <= 0.05 then
                gShopBoxScale = 0.05
                gShopBoxState = 3
                set_mario_action(gMarioStates[0], ACT_IDLE, 0)
            end
        end
    end
    
    local s = gShopBoxScale
    local shopX = sW*0.5 - sW*0.4*s
    local shopY = sH*0.5 - sH*0.4*s
    local shopW = sW*0.8*s
    local shopH = sH*0.8*s

    local perRow = math.round((shopW*0.6 - shopH*0.2)/s/itemSpacing)
    local perPage = perColumn*perRow
    local pageCount = math.floor(#shopItems/perPage)
    local perRowSize = perRow*itemSpacing*s
    if gShopBoxState == 1 then
        cursorMag = math.sqrt(c.stickX^2 + c.stickY^2)
        cursorX = math.clamp(cursorX + c.stickX/8, shopX + shopW*0.3 - perRowSize*0.5 - 10, shopX + shopW*0.3 + perRowSize*0.5 + 10)
        cursorY = math.clamp(cursorY - c.stickY/8, shopY + shopH*0.1, shopY + shopH*0.9)
    end

    djui_hud_set_color(dialogBgR, dialogBgG, dialogBgB, dialogBgA)
    djui_hud_render_rect(shopX, shopY, shopW, shopH)

    djui_hud_set_color(255, 255, 255, 255)
    djui_hud_render_rect(shopX + shopW*0.6, shopY + shopH*0.1, s, shopH*0.8)

    local pageString = "Page "..tostring(currShopPage+1).."/"..tostring(pageCount+1)
    local tW, tH = djui_hud_measure_text(pageString)
    djui_hud_print_text(pageString, shopX + shopW*0.3 - tW*0.15*s, shopY + shopH - 14, 0.3*s, 0.3*s)

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
    currShopPage = math.clamp(currShopPage, 0, pageCount)
    djui_hud_reset_scissor()
    djui_hud_set_rotation(0, 0, 0)

    for id, item in pairs(shopItems) do
        if id > perPage*currShopPage and id <= perPage*(currShopPage + 1) then
            local x = shopX + shopW*0.3 - perRowSize*0.5 + itemSpacing*((id-1-perPage*currShopPage)%perRow)*s
            local y = shopY + shopH*0.1 + itemSpacing*math.floor((id-1-perPage*currShopPage)/perRow)*s
            local color = run_func_or_get_var(item.color, item)
            djui_hud_set_color(color.r, color.g, color.b, color.a)
            local tex = run_func_or_get_var(item.texture, item, x, y, s)
            if tex then
                djui_hud_render_texture(tex, x, y, 16/tex.width*s, 16/tex.height*s)
            end
            djui_hud_set_color(dialogTextR, dialogTextG, dialogTextB, dialogTextA)
            if gShopBoxState == 1 and cursorX > x and cursorX < x + 16 and cursorY > y and cursorY < y + 16 then
                if cursorMag < 0.1 then
                    cursorX = math.lerp(cursorX, x + 8, 0.1)
                    cursorY = math.lerp(cursorY, y + 8, 0.1)
                end
                local x = shopX + shopW*0.6 + 7
                local y = shopY + shopH*0.1

                -- Name
                djui_hud_set_font(FONT_NORMAL)
                local tW, tH = djui_hud_measure_text(item.name)
                local tS = math.min((shopW*0.6 + 7)/tW, 1)*0.5*s
                djui_hud_print_text(item.name, x, y, tS, tS)
                y = y + tH*tS

                -- Cost
                y = y + 2
                djui_hud_set_font(FONT_HUD)
                local stockColor = (item.stock ~= 0) and 255 or 150
                djui_hud_set_color(stockColor, stockColor, stockColor, 255)
                local coinText = tostring(item.coins):gsub("-", "M")
                djui_hud_render_texture(gTextures.coin, x, y, 0.5, 0.5)
                djui_hud_print_text(coinText, x + 8, y, 0.5*s, 0.5*s)
                tW, tH = djui_hud_measure_text(coinText)
                if item.stock == 0 then
                    djui_hud_set_color(255, 255, 255, 255)
                    djui_hud_render_texture(gTextures.no_camera, x, y, 0.5, 0.5)
                end
                y = y + tH*0.5
                djui_hud_set_color(dialogTextR, dialogTextG, dialogTextB, dialogTextA)

                -- Stock
                if item.stock ~= -1 then
                    y = y + 2
                    djui_hud_set_font(FONT_NORMAL)
                    local stockText = item.stock > 0 and "Stock: "..item.stock or "Out of Stock!"
                    djui_hud_print_text(stockText, x, y, 0.25*s, 0.25*s)
                    tW, tH = djui_hud_measure_text(stockText)
                    y = y + tH*0.25
                end

                -- Line
                djui_hud_set_color(dialogTextR, dialogTextG, dialogTextB, dialogTextA)
                y = y + 3
                djui_hud_render_rect(x - 2, y, shopW*0.4 - 9, 1)
                y = y + 4

                -- Description
                djui_hud_set_font(FONT_NORMAL)
                local descText = run_func_or_get_var(item.description, item)
                djui_hud_print_text(descText, x, y, 0.25*s, 0.25*s)
                tW, tH = djui_hud_measure_text(descText)
                y = y + tH*0.25

                if c.buttonPressed & A_BUTTON ~= 0 then
                    local beforeInteract = true
                    if item.before_interact then
                        beforeInteract = item.before_interact(item)
                    end
                    if beforeInteract ~= nil then
                        if savedCoinCount >= item.coins and item.stock ~= 0 and beforeInteract then
                            prevCoinAmount = item.coins
                            savedCoinCount = savedCoinCount - item.coins
                            save_coin_count()
                            if item.stock ~= -1 then
                                item.stock = item.stock - 1
                                mod_storage_save_integer("shop"..item.key.."Stock", item.stock)
                            end
                            if item.interact then
                                item.interact(item) 
                            end
                        elseif item.stock ~= 0 then
                            shakeTimer = 15
                            play_sound(SOUND_MENU_CAMERA_BUZZ, gGlobalSoundSource)
                        end
                    end
                end
            end
        end
    end

    if gShopBoxState == 1 then
        djui_hud_render_texture(c.buttonDown & A_BUTTON ~= 0 and TEX_HAND_CLOSED or TEX_HAND_OPEN, cursorX - 4, cursorY - 10, 1, 1)
    end
    --djui_hud_render_rect(cursorX, cursorY, 1, 1)
    djui_hud_set_font(FONT_HUD)
    local shake = shakeTimer*math.sin(shakeTimer)*0.1
    local coinString = tostring(coinCountLerp):gsub("-", "M")
    local tW, tH = djui_hud_measure_text(coinString)
    tW = tW * s
    djui_hud_render_texture(gTextures.coin, sW*0.5 - tW*0.5 - 16*s - shake, shopY + shopH + 3, 1*s, 1*s)
    djui_hud_print_text("@", sW*0.5 - tW*0.5 - shake, shopY + shopH + 3, 1*s, 1*s)
    djui_hud_print_text(coinString, sW*0.5 - tW*0.5 + 16*s - shake, shopY + shopH + 3, 1*s, 1*s)
    shakeTimer = math.max(shakeTimer - 1, 0)

    if c.buttonDown & B_BUTTON ~= 0 then
        gShopBoxState = 2
        play_sound(SOUND_MENU_MESSAGE_DISAPPEAR, gGlobalSoundSource)
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

hook_event(HOOK_ON_HUD_RENDER, hud_render)