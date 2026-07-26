-- name: Better Coins
-- description: Overhauls the coin collecting expirience to make 100 coin stars fun and satisfying to work towards\n\nMade by: Squishy6094

--[[
    - Todo:
        - Big Plants give blues
        - Chain Chomp gate should give coins
]]

gLevelValues.previewBlueCoins = 1
gLevelValues.respawnBlueCoinsSwitch = 1

gGlobalSyncTable.mouseGrab = false
gGlobalSyncTable.courtyardSecretSolved = false

-- Handle Level and Server Settings
gBetterCoinValues = {}
local function on_mods_loaded()
    -- Handle coin lives ourselves
    gBetterCoinValues.numCoinsToLife = gLevelValues.numCoinsToLife
    gLevelValues.numCoinsToLife = 0
end

hook_event(HOOK_ON_MODS_LOADED, on_mods_loaded)

gMousePosX = 0
gMousePosY = 0

gMarioCoinRange = {}
for i = 0, MAX_PLAYERS - 1 do
    gMarioCoinRange[i] = 0
end
local function mario_update_coin_range(m)
    gMarioCoinRange[m.playerIndex] = 400 + math.sqrt(m.vel.x^2 + m.vel.y^2 + m.vel.z^2)
    if m.flags & MARIO_METAL_CAP ~= 0 then
        gMarioCoinRange[m.playerIndex] = gMarioCoinRange[m.playerIndex] * 3
    end
    if m.action & (ACT_FLAG_FLYING | ACT_FLAG_SWIMMING | ACT_FLAG_RIDING_SHELL) ~= 0 then
        gMarioCoinRange[m.playerIndex] = gMarioCoinRange[m.playerIndex] * 1.25
    end
end

hook_event(HOOK_MARIO_UPDATE, mario_update_coin_range)

-- Updates / Hooks --

gLevelValues.maxCoins = 9999

local sRedCoinTextures = {
    [0] = get_texture_info("coin_seg3_texture_03005780"),
    get_texture_info("coin_seg3_texture_03005F80"),
    get_texture_info("coin_seg3_texture_03006780"),
    get_texture_info("coin_seg3_texture_03006F80"),
}

local sSecretTextures = {
    [0] = get_texture_info("sparkles_seg4_texture_04027490"),
    get_texture_info("sparkles_seg4_texture_04027C90"),
    get_texture_info("sparkles_seg4_texture_04028490"),
    get_texture_info("sparkles_seg4_texture_04028C90"),
    get_texture_info("sparkles_seg4_texture_04029490"),
    get_texture_info("sparkles_seg4_texture_04029C90"),
}

local sBooCoinTextures = {
    [0] = get_texture_info("Boo-Coins-Side"),
    get_texture_info("Boo-Coins-Joyous1"),
    get_texture_info("Boo-Coins-Joyous2"),
    get_texture_info("Boo-Coins-Joyous3"),
}

local customCoinHudValue = 0
local coinAnim = 0
local coinSpeed = 0
local prevNumCoinsToLifeCount = 0

---@param o Object Mario Object
---@param bhvId BehaviorId|integer
---@return integer?
local function obj_get_radar_dist_nearest_object_with_behavior_id(o, bhvId)
    local oTarget = obj_get_nearest_object_with_behavior_id(o, bhvId);
    if (oTarget) then
        local visableMario = collision_find_surface_on_ray(o.oPosX, (o.oPosY + o.hitboxHeight*0.5), o.oPosZ, oTarget.oPosX - o.oPosX, (oTarget.oPosY + oTarget.hitboxHeight*0.5) - (o.oPosY + o.hitboxHeight*0.5), oTarget.oPosZ - o.oPosZ, 1).surface == nil
        local dist = math.sqrt((oTarget.oPosX - o.oPosX)^2 + (oTarget.oPosY - o.oPosY)^2 + (oTarget.oPosZ - o.oPosZ)^2)*(visableMario and 1 or 2)
        return dist
    end
end

local prevTex = nil
local transOpacity = 1
local function coin_counter()
    local m = gMarioStates[0]
    local l = gLakituState
    djui_hud_set_resolution(RESOLUTION_N64)
    local screenWidth = djui_hud_get_screen_width()
    local screenHeight = djui_hud_get_screen_height()

    customCoinHudValue = math.min(math.ceil(math.lerp(customCoinHudValue, m.numCoins, 0.1)), m.numCoins)
    hud_set_value(HUD_DISPLAY_COINS, customCoinHudValue)
    gLevelValues.hudCapTimer = 1

    gLevelValues.hudRedCoinsRadar = 0
    gLevelValues.hudSecretsRadar = 0

    -- Hud 
    if gBetterCoinValues.numCoinsToLife > 0 then
        if hud_get_value(HUD_DISPLAY_COINS) > (prevNumCoinsToLifeCount + gBetterCoinValues.numCoinsToLife) then
            m.numLives = m.numLives + 1
            play_sound(SOUND_GENERAL_COLLECT_1UP, gGlobalSoundSource)
            prevNumCoinsToLifeCount = prevNumCoinsToLifeCount + gBetterCoinValues.numCoinsToLife
        end
        prevNumCoinsToLifeCount = math.min(prevNumCoinsToLifeCount, m.numCoins)
    end

    if (m.marioObj) then
        local currTex = nil
        local currDist = nil
        local dist = obj_get_radar_dist_nearest_object_with_behavior_id(m.marioObj, id_bhvRedCoin);
        if not currDist or (dist and currDist > dist) then
            currTex = sRedCoinTextures
            currDist = dist
        end

        local dist = obj_get_radar_dist_nearest_object_with_behavior_id(m.marioObj, id_bhvHiddenStarTrigger);
        if not currDist or (dist and currDist > dist) then
            currTex = sSecretTextures
            currDist = dist
        end

        local dist = obj_get_radar_dist_nearest_object_with_behavior_id(m.marioObj, id_bhvBlueCoinSwitch);
        if not currDist or (dist and currDist > dist) then
            currTex = sBooCoinTextures
            currDist = dist
        end

        if currDist and prevTex then
            local targetCoinSpeed = math.clamp((500*5 / currDist), 0, 1)
            coinSpeed = math.lerp(coinSpeed, targetCoinSpeed, 0.1)
            coinAnim = (coinAnim + coinSpeed*0.5) % (#prevTex + 1)
            local colorRed = (prevTex == sRedCoinTextures) and 0 or 255
            djui_hud_set_color(255, colorRed, colorRed, 255*coinSpeed*transOpacity)
            local dX, dY = hudDodge.find_open_hud_space(0, 0, 16, 16, 0, 1)
            djui_hud_render_texture(prevTex[math.floor(coinAnim)], dX, dY, 0.5, 0.5)
        else
            coinSpeed = math.lerp(coinSpeed, 0, 0.1)
        end

        if prevTex ~= currTex then
            transOpacity = math.clamp(transOpacity - 0.1, 0, 1)
            if transOpacity == 0 then
                prevTex = currTex
            end
        else
            transOpacity = math.clamp(transOpacity + 0.1, 0, 1)
        end

        --[[
        -- Red Coin Radar
        local redCoin = obj_get_nearest_object_with_behavior_id(m.marioObj, id_bhvRedCoin);
        if (redCoin) then
            local dist = math.sqrt((redCoin.oPosX - m.pos.x)^2 + (redCoin.oPosY - m.pos.y)^2 + (redCoin.oPosZ - m.pos.z)^2)
            local visableCam = collision_find_surface_on_ray(l.pos.x, l.pos.y, l.pos.z, redCoin.oPosX - l.pos.x, redCoin.oPosY - l.pos.y, redCoin.oPosZ - l.pos.z, 1).surface == nil
            local visableMario = collision_find_surface_on_ray(m.pos.x, m.pos.y, m.pos.z, redCoin.oPosX - m.pos.x, redCoin.oPosY - m.pos.y, redCoin.oPosZ - m.pos.z, 1).surface == nil
            local targetCoinSpeed = math.clamp((400*5 / dist), 0, 0.75) + ((visableCam and visableMario) and 0.25 or 0)
            coinSpeed = math.lerp(coinSpeed, targetCoinSpeed, 0.1)
        else
            coinSpeed = math.lerp(coinSpeed, 0, 0.1)
        end

        coinAnim = (coinAnim + coinSpeed*0.5) % #sRedCoinTextures
        djui_hud_set_color(255, 0, 0, 255*coinSpeed)
        djui_hud_render_texture(sRedCoinTextures[math.floor(coinAnim)], screenWidth*0.25 + 18, 15, 0.5, 0.5)

        -- Secret Radar
        local secret = obj_get_nearest_object_with_behavior_id(m.marioObj, id_bhvHiddenStarTrigger);
        if (secret) then
            local dist = math.sqrt((secret.oPosX - m.pos.x)^2 + (secret.oPosY - m.pos.y)^2 + (secret.oPosZ - m.pos.z)^2)
            local visableCam = collision_find_surface_on_ray(l.pos.x, l.pos.y, l.pos.z, secret.oPosX - l.pos.x, secret.oPosY - l.pos.y, secret.oPosZ - l.pos.z, 1).surface == nil
            local visableMario = collision_find_surface_on_ray(m.pos.x, m.pos.y, m.pos.z, secret.oPosX - m.pos.x, secret.oPosY - m.pos.y, secret.oPosZ - m.pos.z, 1).surface == nil
            local targetSecretSpeed = math.clamp((400*5 / dist), 0, 0.75) + ((visableCam and visableMario) and 0.25 or 0)
            secretSpeed = math.lerp(secretSpeed, math.clamp(targetSecretSpeed, 0, 0.75), 0.1)
        else
            secretSpeed = math.lerp(secretSpeed, 0, 0.1)
        end

        secretAnim = (secretAnim + secretSpeed*0.5) % #sSecretTextures
        djui_hud_set_color(255, 255, 255, 255*secretSpeed)
        djui_hud_render_texture(sSecretTextures[math.floor(secretAnim)], screenWidth*0.25, 15, 0.5, 0.5)
        ]]
    end

    -- Mouse
    if gGlobalSyncTable.mouseGrab == true then
        djui_hud_set_resolution(RESOLUTION_DJUI)
        local djuiWidth = djui_hud_get_screen_width()
        local djuiHeight = djui_hud_get_screen_height()
        djui_hud_set_resolution(RESOLUTION_N64)
        local newMouseX = djui_hud_get_mouse_x() * (djui_hud_get_screen_width()/djuiWidth)
        local newMouseY = djui_hud_get_mouse_y() * (djui_hud_get_screen_height()/djuiHeight)
        djui_hud_render_rect_interpolated(gMousePosX, gMousePosY, 16, 16, gMousePosX, gMousePosY, 16, 16)
        gMousePosX = newMouseX
        gMousePosY = newMouseY
    end
end

local saveFile = get_current_save_file_num()
local function obj_is_star_collected(o)
    local starId = o.oBehParams >> 24;
    local currentLevelStarFlags = save_file_get_star_flags(saveFile - 1, (gLevelValues.useGlobalStarIds ~= 0 and (starId / 7) - 1 or gNetworkPlayers[0].currCourseNum - 1))
    return (currentLevelStarFlags & (1 << (gLevelValues.useGlobalStarIds ~= 0 and starId % 7 or starId)) ~= 0)
end

local originalStayInLevel = gServerSettings.stayInLevelAfterStar
local function allow_interact(m, o, int)
    if o.oIntangibleTimer ~= 0 then return end
    if (int == INTERACT_STAR_OR_KEY) then
        -- Make Transparent Stars turn on nonstop
        if obj_is_star_collected(o) then
            originalStayInLevel = gServerSettings.stayInLevelAfterStar
            gServerSettings.stayInLevelAfterStar = 2
        end
    end
end

local coinSoundCount = 0
local coinSoundCombo = 0
local coinSoundComboEnd = 0
--[[
local coinsSounds = {
    [0] = audio_stream_load("coin1.ogg"),
    [1] = audio_stream_load("coin2.ogg"),
    [2] = audio_stream_load("coin3.ogg"),
    [3] = audio_stream_load("coin4.ogg"),
}
]]
customCoinSound = false
---@param m MarioState
local function interact(m, o, int)
    if m.playerIndex ~= 0 then return end
    if o.oIntangibleTimer ~= 0 then return end
    if int == INTERACT_COIN then
        -- Make Coin Sound
        --local currCoinSound = coinsSounds[coinSoundCount]
        if get_global_timer() > coinSoundComboEnd then
            coinSoundCombo = 0
        else
            coinSoundCombo = coinSoundCombo + 1
        end
        local freqScale = math.lerp(0.95, 1.5, math.clamp(coinSoundCombo/50, 0, 1))
        customCoinSound = true
        play_sound_with_freq_scale(SOUND_GENERAL_COIN, gGlobalSoundSource, freqScale)
        --audio_stream_set_frequency(currCoinSound, math.lerp(0.95, 1.5, math.clamp(coinSoundCombo/50, 0, 1)))
        --audio_stream_play(currCoinSound, true, 1.25)
        coinSoundCount = (coinSoundCount + 1)%4
        coinSoundComboEnd = get_global_timer() + 90

        if mario_master_cap_active(m) then
            master_cap_add_coin(nil, o.oDamageOrCoinValue)
        else
            m.capTimer = m.capTimer + 25*o.oDamageOrCoinValue
        end
        return
    end

    if (int == INTERACT_STAR_OR_KEY) then
        -- Spawn Coins and turn it back on
        if gServerSettings.stayInLevelAfterStar == 2 then
            spawn_coin_spawner(o, 10, true)
        end
        gServerSettings.stayInLevelAfterStar = originalStayInLevel
        return
    end
end

local function object_unload(o)
    -- Handle Celebration Stars poofing into coins
    if obj_has_behavior_id(o, id_bhvCelebrationStar) ~= 0 then
        spawn_mist_from_global()
        spawn_coin_spawner(o, 10, true)
        return
    end

    if obj_has_behavior_id(o, id_bhvGrandStar) ~= 0 then
        spawn_coin_spawner(o, 10, true)
        return
    end
end

areaCoinDensity = 0
local function count_possible_coins()
    local areaCoinDistance = 0
    local areaCoinCount = 0
    -- Replace all Object Models
    for i = 0, NUM_OBJ_LISTS - 1 do
        local o = obj_get_first(i)
        local prevO = o
        while o ~= nil do
            local coinValue = math.max(o.oNumLootCoins, o.oDamageOrCoinValue, o.oCustomCoins)
            if coinValue > 0 then
                areaCoinCount = areaCoinCount + coinValue
                prevO = o
                areaCoinDistance = (areaCoinDistance + math.sqrt((o.oPosX + prevO.oPosX)^2 + (o.oPosY + prevO.oPosY)^2 + (o.oPosZ + prevO.oPosZ)^2))*0.5
            end
            o = obj_get_next(o)
        end
    end
    areaCoinDensity = areaCoinDistance / areaCoinCount
    djui_chat_message_create("Seconds Per Coin: "..tostring(math.round(areaCoinDensity)/100))
end

local function on_coin_sound(sound, pos)
    if sound == SOUND_GENERAL_COIN and not customCoinSound then
        return NO_SOUND
    end
    customCoinSound = false
end

local function courtyard_secret()
    if CURR_ROMHACK ~= "sm64" then return end
    if gNetworkPlayers[0].currLevelNum == LEVEL_CASTLE_COURTYARD and not gGlobalSyncTable.courtyardSecretSolved and gMarioStates[0].numStars >= 12 then
        if obj_get_first_with_behavior_id(id_bhvCourtyardCondition) == nil then
            spawn_sync_object(id_bhvCourtyardCondition, E_MODEL_NONE, 0, 425, -1735, function (o) end)
        end
    end
end

---@param m MarioState
local function mario_update(m)
    -- Allow Infinate Metal Jumping
    if m.action & ACT_FLAG_METAL_WATER ~= 0 and m.flags & MARIO_WING_CAP ~= 0 and m.controller.buttonPressed & A_BUTTON ~= 0 then
        m.marioObj.header.gfx.animInfo.animID = -1
        set_mario_action(m, m.heldObj == nil and ACT_METAL_WATER_JUMP or ACT_HOLD_METAL_WATER_JUMP, 0)
    end
end

hook_event(HOOK_ON_HUD_RENDER_BEHIND, coin_counter)
hook_event(HOOK_ALLOW_INTERACT, allow_interact)
hook_event(HOOK_ON_OBJECT_UNLOAD, object_unload)
hook_event(HOOK_ON_INTERACT, interact)
hook_event(HOOK_ON_PLAY_SOUND, on_coin_sound)
hook_event(HOOK_ON_SYNC_VALID, courtyard_secret)
hook_event(HOOK_MARIO_UPDATE, mario_update)
hook_event(HOOK_ON_SYNC_VALID, count_possible_coins)

local commands = {
    ["master-cap"] = {
        desc = "Toggle if Master Cap is allowed to appear.",
        function()
        end,
    },

}

local function chat_command(msg)
    local moderator = network_is_server() or network_is_moderator()
    local msgSplit = string_split(msg)

    if msgSplit[1] == "master-cap" then
        if moderator then
            if gGlobalSyncTable.allowMasterCapApi ~= nil then
                djui_chat_message_create("This option is being forced by the API.")
            else
                gGlobalSyncTable.allowMasterCap = not gGlobalSyncTable.allowMasterCap
                djui_chat_message_create("Master Cap has been turned ".. (gGlobalSyncTable.allowMasterCap and "On" or "Off")..".")
            end
        else
            djui_chat_message_create("This command is host only.")
        end
        return true
    end

    local askedForHelp = false
    if msgSplit[1] == "?" or msgSplit[1] == "help" then
        askedForHelp = true
    end

    if not askedForHelp then
        djui_chat_message_create("Invalid Command (/better-coins help)")
    end
    djui_chat_message_create("")

    return askedForHelp
end

hook_chat_command("better-coins", "- Toggle options for Better Coins\nUse \\#00ff00\\/better-coins help\\#ffffff\\ for command info!", chat_command)
