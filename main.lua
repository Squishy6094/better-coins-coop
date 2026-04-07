-- name: Better Coins
-- description: Overhauls the coin collecting expirience to make 100 coin stars fun and satisfying to work towards\n\nMade by: Squishy6094

gLevelValues.previewBlueCoins = 1
gLevelValues.respawnBlueCoinsSwitch = 1
gLevelValues.hudCapTimer = 1

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
}

local function update()
    local m = gMarioStates[0]
    local gIndex = network_global_index_from_local(0) + 1
    for i = 1, #magnetBhvs do
        local bhvID = magnetBhvs[i]
        if bhvID == nil then
            break
        end
        local o = obj_get_first_with_behavior_id(bhvID)
        while o ~= nil do
            -- Attract is coin is yours
            local mN = nearest_mario_state_to_object(o)
            if (m.playerIndex == mN.playerIndex) and not is_object_being_carried(o) then
                local dist = vec3f_dist(obj_pos_to_vec3f(o), m.pos)
                if (dist < (m.flags & MARIO_METAL_CAP ~= 0 and 1200 or 500) or o.oVelY < 0) and o.oVelY <= 0 and (bhvID ~= id_bhvHiddenBlueCoin or o.oAction == HIDDEN_BLUE_COIN_ACT_ACTIVE) then
                    local isWall = collision_find_surface_on_ray(m.pos.x, m.pos.y + 70, m.pos.z, o.oPosX - m.pos.x, o.oPosY - m.pos.y, o.oPosZ - m.pos.z, 10).surface ~= nil
                    if not isWall and not obj_is_in_clam(o) then
                        carry_object_to_mario(m, o)
                    end
                end
            end

            o = obj_get_next_with_same_behavior_id(o)
        end
    end

    --if m.controller.buttonPressed & (D_JPAD) ~= 0 then
    --    spawn_coin_spawner(m.pos.x, m.pos.y, m.pos.z, 1000, true)
    --end
end

hook_event(HOOK_UPDATE, update)

-- Updates / Hooks --

local customCoinHudValue = 0
local customCoinBelow100 = true
local function coin_counter()
    local m = gMarioStates[0]
    customCoinHudValue = math.min(customCoinHudValue, m.numCoins)
    customCoinHudValue = math.lerp(customCoinHudValue, m.numCoins, 0.3)

    -- Ensure 100 is successfully hit before couting higher for star
    if customCoinBelow100 then
        customCoinHudValue = math.min(customCoinHudValue, gLevelValues.coinsRequiredForCoinStar)
    end

    hud_set_value(HUD_DISPLAY_COINS, math.round(customCoinHudValue))
    customCoinBelow100 = customCoinHudValue < gLevelValues.coinsRequiredForCoinStar
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
            m.capTimer = m.capTimer + o.oDamageOrCoinValue*20
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

hook_event(HOOK_ON_HUD_RENDER_BEHIND, coin_counter)
hook_event(HOOK_ALLOW_INTERACT, allow_interact)
hook_event(HOOK_ON_OBJECT_UNLOAD, object_unload)
hook_event(HOOK_ON_INTERACT, interact)
--hook_event(HOOK_ON_SYNC_VALID, count_possible_coins)