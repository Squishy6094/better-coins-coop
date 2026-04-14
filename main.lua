-- name: Better Coins
-- description: Overhauls the coin collecting expirience to make 100 coin stars fun and satisfying to work towards\n\nMade by: Squishy6094

--[[
    - Todo:
        - Purple Switch gives coins
        - Stomp Toads (5 coins)
        - 1ups with blue coins
        - Falling in snow/sand gives 1-3 coins
        - Pound Pillars should give coins
        - Make killing all boos spawn coins from Eternal Star
        - Chairs give 2 coins
        - Books give blue on wall hit
        - Bosses spawn coins on despawn
        - Crazy box bounce gives coins
        - Bowser Bombs Explode into 5 coins
        - Vanish disables raycast check
        - Ground Pounding THI Moutain gives coins
        - Fix trans star check
        - Grand Star flings coins EVERYWHERE
        - Snowman body should give coins when under head
        - 
]]

gLevelValues.previewBlueCoins = 1
gLevelValues.respawnBlueCoinsSwitch = 1
gLevelValues.hudCapTimer = 1
gLevelValues.visibleSecrets = 1

gGlobalSyncTable.mouseGrab = false

local starBhvs = {
    id_bhvStar,
    id_bhvSpawnedStar,
    id_bhvSpawnedStarNoLevelExit,
    id_bhvHiddenStar,
    id_bhvStarSpawnCoordinates,
}

local magnetBhvs = {
    id_bhvOneCoin,
    id_bhvYellowCoin,
    id_bhvMovingYellowCoin,
    id_bhvSingleCoinGetsSpawned,
    id_bhvRedCoin,
    id_bhvMrIBlueCoin,
    id_bhvHiddenBlueCoin,
    id_bhvMovingBlueCoin,
    id_bhvHiddenStarTrigger,
    id_bhv1Up,
    id_bhv1upSliding,
}

local coinRange = 0
local mouseX = 0
local mouseY = 0
local function update()
    local m = gMarioStates[0]

    for i = 1, #magnetBhvs do
        local bhvID = magnetBhvs[i]
        if bhvID == nil then
            break
        end
        local o = obj_get_first_with_behavior_id(bhvID)
        while o ~= nil do
            if not is_object_being_carried(o) then
                local oPos = obj_pos_to_vec3f(o)

                -- Attract if coin is yours
                local mN = nearest_mario_state_to_object(o)
                if (m.playerIndex == mN.playerIndex) then
                    local dist = vec3f_dist(oPos, m.pos)
                    coinRange = 400
                    if m.flags & MARIO_METAL_CAP ~= 0 then
                        coinRange = coinRange * 3
                    end
                    if m.action & ACT_FLAG_FLYING ~= 0 then
                        coinRange = coinRange *1.25
                    end
                    if (dist < coinRange or o.oVelY < 0) and o.oVelY <= 0 and (bhvID ~= id_bhvHiddenBlueCoin or o.oAction == HIDDEN_BLUE_COIN_ACT_ACTIVE) then
                        local isWall = collision_find_surface_on_ray(m.pos.x, m.pos.y + 70, m.pos.z, o.oPosX - m.pos.x, o.oPosY - m.pos.y, o.oPosZ - m.pos.z, 128).surface ~= nil
                        if (not isWall and not obj_is_in_clam(o)) or (m.flags & MARIO_VANISH_CAP ~= 0) then
                            carry_object_to_mario(m, o)
                        end
                    end
                end

                -- Check Galaxy Controls
                if gGlobalSyncTable.mouseGrab then
                    djui_hud_set_resolution(RESOLUTION_N64)
                    local out = {x = 0, y = 0, z = 0}
                    djui_hud_world_pos_to_screen_pos(oPos, out)
                    local mouseDist = math.sqrt((out.x - mouseX)^2 + (out.y - mouseY)^2)
                    if mouseDist < 10 then
                        local isWall = collision_find_surface_on_ray(gLakituState.pos.x, gLakituState.pos.y, gLakituState.pos.z, o.oPosX - gLakituState.pos.x, (o.oPosY + 50) - gLakituState.pos.y, o.oPosZ - gLakituState.pos.z, 128).surface ~= nil
                        if not isWall then
                            carry_object_to_mario(m, o)
                        end
                    end
                end
            end

            o = obj_get_next_with_same_behavior_id(o)
        end
    end

    if m.controller.buttonPressed & (D_JPAD) ~= 0 then
        spawn_coin_spawner(m.pos.x, m.pos.y, m.pos.z, 1000, true)
    end
end

hook_event(HOOK_UPDATE, update)

-- Updates / Hooks --

local customCoinHudValue = 0
local customCoinBelow100 = true
local function coin_counter()
    local m = gMarioStates[0]
    customCoinHudValue = math.min(customCoinHudValue, m.numCoins)
    customCoinHudValue = math.ceil(math.lerp(customCoinHudValue, m.numCoins, 0.3))

    -- Ensure 100 is successfully hit before couting higher for star
    if customCoinBelow100 then
        customCoinHudValue = math.min(customCoinHudValue, gLevelValues.coinsRequiredForCoinStar)
    end

    hud_set_value(HUD_DISPLAY_COINS, math.round(customCoinHudValue))
    customCoinBelow100 = customCoinHudValue < gLevelValues.coinsRequiredForCoinStar

    -- Mouse
    djui_hud_set_resolution(RESOLUTION_DJUI)
    local djuiWidth = djui_hud_get_screen_width()
    local djuiHeight = djui_hud_get_screen_height()
    djui_hud_set_resolution(RESOLUTION_N64)
    if gGlobalSyncTable.mouseGrab then
        local newMouseX = djui_hud_get_mouse_x() * (djui_hud_get_screen_width()/djuiWidth)
        local nemMouseY = djui_hud_get_mouse_y() * (djui_hud_get_screen_height()/djuiHeight)
        djui_hud_render_rect_interpolated(mouseX, mouseY, 16, 16, mouseX, mouseY, 16, 16)
        mouseX = newMouseX
        mouseY = nemMouseY
    end
end

local saveFile = get_current_save_file_num()
local function obj_is_star_collected(o)
    local starId = o.oBehParams >> 24;
    local currentLevelStarFlags = save_file_get_star_flags(saveFile - 1, (gLevelValues.useGlobalStarIds and (starId / 7) - 1 or gNetworkPlayers[0].currCourseNum - 1));
    return (currentLevelStarFlags & (1 << (gLevelValues.useGlobalStarIds and starId % 7 or starId)) ~= 0)
end

local originalStayInLevel = gServerSettings.stayInLevelAfterStar
local function allow_interact(m, o, int)
    for i = 1, #starBhvs do
        local bhvID = starBhvs[i]
        if obj_has_behavior_id(o, bhvID) ~= 0 then
            -- Make Transparent Stars turn off stay in level
            if obj_is_star_collected(o) then
                originalStayInLevel = gServerSettings.stayInLevelAfterStar
                gServerSettings.stayInLevelAfterStar = 2
            end
        end
    end
end

---@param m MarioState
local function interact(m, o, int)
    if int == INTERACT_COIN then
        if m.capTimer ~= 0 then
            m.capTimer = m.capTimer + o.oDamageOrCoinValue*25
        end
    end

    for i = 1, #starBhvs do
        local bhvID = starBhvs[i]
        if obj_has_behavior_id(o, bhvID) ~= 0 then
            -- Spawn Coins and turn it back on
            if gServerSettings.stayInLevelAfterStar == 2 then
                spawn_coin_spawner(o.oPosX, o.oPosY, o.oPosZ, 10, true)
            end
            gServerSettings.stayInLevelAfterStar = originalStayInLevel
        end
    end
end

local function object_unload(o)
    -- Handle Celebration Stars poofing into coins
    if obj_has_behavior_id(o, id_bhvCelebrationStar) ~= 0 then
        spawn_mist_from_global()
        spawn_coin_spawner(o.oPosX, o.oPosY, o.oPosZ, 10, true)
    end
end

local areaCoinCount = 0
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

local coinSoundCount = 0
local coinsSounds = {
    [0] = audio_stream_load("coin1.ogg"),
    [1] = audio_stream_load("coin2.ogg"),
    [2] = audio_stream_load("coin3.ogg"),
    [3] = audio_stream_load("coin4.ogg"),
}

local function on_coin_sound(sound, pos)
    if sound == SOUND_GENERAL_COIN then
        audio_stream_play(coinsSounds[coinSoundCount], true, 1.5)
        coinSoundCount = (coinSoundCount + 1)%4
        return NO_SOUND
    end
end

hook_event(HOOK_ON_HUD_RENDER_BEHIND, coin_counter)
hook_event(HOOK_ALLOW_INTERACT, allow_interact)
hook_event(HOOK_ON_OBJECT_UNLOAD, object_unload)
hook_event(HOOK_ON_INTERACT, interact)
hook_event(HOOK_ON_PLAY_SOUND, on_coin_sound)
--hook_event(HOOK_ON_SYNC_VALID, count_possible_coins)