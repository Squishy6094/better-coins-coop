-- name: Better Coins
-- description: Overhauls the coin collecting expirience to make 100 coin stars fun and satisfying to work towards\n\nMade by: Squishy6094

--[[
    - Todo:
        - Big Plants give blues
        - Chain Chomp gate should give coins
]]

gLevelValues.previewBlueCoins = 1
gLevelValues.respawnBlueCoinsSwitch = 1
gLevelValues.hudCapTimer = 1
gLevelValues.hudRedCoinsRadar = 1

gGlobalSyncTable.mouseGrab = false
gGlobalSyncTable.courtyardSecretSolved = false

-- Handle Level and Server Settings
gBetterCoinValues = {}
local function on_mods_loaded()
    -- Force Radar Off since we have our own

    -- Handle coin lives ourselves
    gBetterCoinValues.numCoinsToLife = gLevelValues.numCoinsToLife
    gLevelValues.numCoinsToLife = 0
end

hook_event(HOOK_ON_MODS_LOADED, on_mods_loaded)

local coinRange = 0
local mouseX = 0
local mouseY = 0
local function obj_attempt_magnetize(m, o)
    if o.oIntangibleTimer == 0 and not is_object_being_carried(o) and o.oDamageOrCoinValue > 0 then
        -- Attract if coin is yours
        local dist = obj_to_obj_dist(o, m.marioObj)
        if (dist <= coinRange or o.oVelY < 0) then
            local isWall = collision_find_surface_on_ray(m.pos.x, m.pos.y + 70, m.pos.z, o.oPosX - m.pos.x, o.oPosY - m.pos.y, o.oPosZ - m.pos.z, 128).surface ~= nil
            if (not isWall and not obj_is_in_container(o)) or (m.flags & MARIO_VANISH_CAP ~= 0) then
                carry_object_to_mario(m, o)
            end
        end

        -- Check Galaxy Controls
        if gGlobalSyncTable.mouseGrab == true then
            djui_hud_set_resolution(RESOLUTION_N64)
            local out = {x = 0, y = 0, z = 0}
            djui_hud_world_pos_to_screen_pos({x = o.oPosX, y = o.oPosY, z = o.oPosZ}, out)
            local mouseDist = math.sqrt((out.x - mouseX)^2 + (out.y - mouseY)^2)
            if mouseDist < 10 then
                local isWall = collision_find_surface_on_ray(gLakituState.pos.x, gLakituState.pos.y, gLakituState.pos.z, o.oPosX - gLakituState.pos.x, (o.oPosY + 50) - gLakituState.pos.y, o.oPosZ - gLakituState.pos.z, 128).surface ~= nil
                if not isWall then
                    carry_object_to_mario(m, o)
                end
            end
        end
    end
end

local prevNumCoinsToLifeCount = 0
local function update()
    local m = gMarioStates[0]
    if m.action == ACT_BUBBLED or m.action == ACT_MASTER_CAP_BUBBLED then return end

    coinRange = 400 + math.sqrt(m.vel.x^2 + m.vel.y^2 + m.vel.z^2)
    if m.flags & MARIO_METAL_CAP ~= 0 then
        coinRange = coinRange * 3
    end
    if m.action & (ACT_FLAG_FLYING | ACT_FLAG_SWIMMING | ACT_FLAG_RIDING_SHELL) ~= 0 then
        coinRange = coinRange * 1.25
    end

    local o = obj_get_first(OBJ_LIST_LEVEL)
    while o ~= nil do
        if o.oInteractType == INTERACT_COIN then
            obj_attempt_magnetize(m, o)
        end

        o = obj_get_next(o)
    end

    --[[
    if m.controller.buttonPressed & (U_JPAD) ~= 0 then
        spawn_coin_spawner(nil, 1000, nil, m.pos.x, m.pos.y, m.pos.z)
    end
    if m.controller.buttonPressed & (R_JPAD) ~= 0 then
        spawn_non_sync_object(id_bhvMasterCapGoldDemon, E_MODEL_1UP, m.pos.x, m.pos.y, m.pos.z, function(o)
        
        end)
    end
    ]]

    if hud_get_value(HUD_DISPLAY_COINS) > (prevNumCoinsToLifeCount + gBetterCoinValues.numCoinsToLife) then
        m.numLives = m.numLives + 1
        play_sound(SOUND_GENERAL_COLLECT_1UP, gGlobalSoundSource)
        prevNumCoinsToLifeCount = prevNumCoinsToLifeCount + gBetterCoinValues.numCoinsToLife
    end
end

hook_event(HOOK_UPDATE, update)

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

local customCoinHudValue = 0
local coinAnim = 0
local coinSpeed = 0
local secretAnim = 0
local secretSpeed = 0
local function coin_counter()
    local m = gMarioStates[0]
    djui_hud_set_resolution(RESOLUTION_N64)
    local screenWidth = djui_hud_get_screen_width()
    local screenHeight = djui_hud_get_screen_height()

    customCoinHudValue = math.min(math.ceil(math.lerp(customCoinHudValue, m.numCoins, 0.1)), m.numCoins)
    --hud_set_value(HUD_DISPLAY_FLAGS, hud_get_value(HUD_DISPLAY_FLAGS) | HUD_DISPLAY_FLAGS_COIN_COUNT)
    hud_set_value(HUD_DISPLAY_COINS, customCoinHudValue)

    if (m.marioObj) then
        -- Red Coin Radar
        gLevelValues.hudRedCoinsRadar = 0
        local redCoin = obj_get_nearest_object_with_behavior_id(m.marioObj, id_bhvRedCoin);
        if (redCoin) then
            local dist = math.sqrt((redCoin.oPosX - m.pos.x)^2 + (redCoin.oPosY - m.pos.y)^2 + (redCoin.oPosZ - m.pos.z)^2)
            coinSpeed = math.lerp(coinSpeed, math.clamp((400*5 / dist), 0, 1), 0.1)
        else
            coinSpeed = math.lerp(coinSpeed, 0, 0.1)
        end

        coinAnim = (coinAnim + coinSpeed*0.5) % #sRedCoinTextures
        djui_hud_set_color(255, 0, 0, 255*coinSpeed)
        djui_hud_render_texture(sRedCoinTextures[math.floor(coinAnim)], screenWidth*0.25 + 18, 15, 0.5, 0.5)

        -- Secret Radar
        gLevelValues.hudSecretsRadar = 0
        local secret = obj_get_nearest_object_with_behavior_id(m.marioObj, id_bhvHiddenStarTrigger);
        if (secret) then
            local dist = math.sqrt((secret.oPosX - m.pos.x)^2 + (secret.oPosY - m.pos.y)^2 + (secret.oPosZ - m.pos.z)^2)
            secretSpeed = math.lerp(secretSpeed, math.clamp((400*5 / dist), 0, 1), 0.1)
        else
            secretSpeed = math.lerp(secretSpeed, 0, 0.1)
        end

        secretAnim = (secretAnim + secretSpeed*0.5) % #sSecretTextures
        djui_hud_set_color(255, 255, 255, 255*secretSpeed)
        djui_hud_render_texture(sSecretTextures[math.floor(secretAnim)], screenWidth*0.25, 15, 0.5, 0.5)
    end

    -- Mouse
    if gGlobalSyncTable.mouseGrab == true then
        djui_hud_set_resolution(RESOLUTION_DJUI)
        local djuiWidth = djui_hud_get_screen_width()
        local djuiHeight = djui_hud_get_screen_height()
        djui_hud_set_resolution(RESOLUTION_N64)
        local newMouseX = djui_hud_get_mouse_x() * (djui_hud_get_screen_width()/djuiWidth)
        local nemMouseY = djui_hud_get_mouse_y() * (djui_hud_get_screen_height()/djuiHeight)
        djui_hud_render_rect_interpolated(mouseX, mouseY, 16, 16, mouseX, mouseY, 16, 16)
        mouseX = newMouseX
        mouseY = nemMouseY
    end
end

local function level_init()
    prevNumCoinsToLifeCount = 0
    gMarioStates[0].numCoins = 0
    coinCounter = 0
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
local customCoin = false
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
        customCoin = true
        play_sound_with_freq_scale(SOUND_GENERAL_COIN, gGlobalSoundSource, freqScale)
        --audio_stream_set_frequency(currCoinSound, math.lerp(0.95, 1.5, math.clamp(coinSoundCombo/50, 0, 1)))
        --audio_stream_play(currCoinSound, true, 1.25)
        coinSoundCount = (coinSoundCount + 1)%4
        coinSoundComboEnd = get_global_timer() + 90

        if mario_master_cap_active(m) then
            master_cap_add_coin(nil, o.oDamageOrCoinValue)
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

local function count_possible_coins()
    local areaCoinCount = 0
    -- Replace all Object Models
    for i = 0, NUM_OBJ_LISTS - 1 do
        local o = obj_get_first(i)
        while o ~= nil do
            areaCoinCount = areaCoinCount + math.max(o.oNumLootCoins, o.oDamageOrCoinValue)
            o = obj_get_next(o)
        end
    end
    --djui_chat_message_create(tostring(areaCoinCount))
end

local function on_coin_sound(sound, pos)
    if sound == SOUND_GENERAL_COIN and not customCoin then
        return NO_SOUND
    end
    customCoin = false
end

local function courtyard_secret()
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
hook_event(HOOK_ON_LEVEL_INIT, level_init)