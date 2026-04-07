-- name: Better Coins
-- description: Overhauls the coin collecting expirience to make 100 coin stars fun and satisfying to work towards\n\nMade by: Squishy6094

gLevelValues.previewBlueCoins = 1
gLevelValues.respawnBlueCoinsSwitch = 1

local starBhvs = {
    id_bhvStar,
    id_bhvSpawnedStar,
    id_bhvSpawnedStarNoLevelExit,
    id_bhvHiddenStar,
    id_bhvStarSpawnCoordinates,
}

-- Utils

--- @param obj Object
--- Replacement for DROP_TO_FLOOR()
function object_drop_to_floor(obj)
    local x = obj.oPosX
    local y = obj.oPosY
    local z = obj.oPosZ

    local floorHeight = find_floor_height(x, y + 200, z)
    obj.oPosY = floorHeight
    obj.oMoveFlags = (obj.oMoveFlags | OBJ_MOVE_ON_GROUND)
end

function obj_pos_to_vec3f(o)
    return {x = o.oPosX, y = o.oPosY, z = o.oPosZ}
end

-- Custom Behaviors

--- @param o Object
local function bhv_coin_carry_init(o)
    o.oFlags = o.oFlags | OBJ_FLAG_UPDATE_GFX_POS_AND_ANGLE | OBJ_FLAG_COMPUTE_DIST_TO_MARIO
    network_init_object(o, true, {})
end

local function obj_is_in_clam(o)
    local oClam = obj_get_nearest_object_with_behavior_id(o, id_bhvClamShell)
    if oClam ~= nil and vec3f_dist(obj_pos_to_vec3f(o), obj_pos_to_vec3f(oClam)) < 100 then
        if oClam.oAction ~= 1 or oClam.oTimer < 15 then
            return true
        end
    end
    return false
end

--- @param o Object
local function bhv_coin_carry_loop(o)
    if o.globalPlayerIndex == MAX_PLAYERS then return end
    if o.parentObj.activeFlags == ACTIVE_FLAG_DEACTIVATED then
        obj_mark_for_deletion(o)
        return
    end
    local m = gMarioStates[network_local_index_from_global(o.globalPlayerIndex)]
    if is_player_active(m) == 0 then 
        m = nearest_mario_state_to_object(o)
        o.globalPlayerIndex = network_global_index_from_local(m.playerIndex)
    end

    o.oPosX = math.lerp(o.oPosX + o.parentObj.oVelX, m.pos.x, math.clamp(o.oTimer^2/800, 0, 1))
    o.oPosY = math.lerp(o.oPosY + o.parentObj.oVelY, m.pos.y + 70, math.clamp(o.oTimer^2/800, 0, 1))
    o.oPosZ = math.lerp(o.oPosZ + o.parentObj.oVelZ, m.pos.z, math.clamp(o.oTimer^2/800, 0, 1))

    -- Update Parent Obj
    o.parentObj.oPosX = o.oPosX
    o.parentObj.oPosY = o.oPosY
    o.parentObj.oPosZ = o.oPosZ
    o.parentObj.oVelX = math.lerp(o.oVelX, 0, 0.6)
    o.parentObj.oVelY = math.lerp(o.oVelY, 0, 0.6)
    o.parentObj.oVelZ = math.lerp(o.oVelZ, 0, 0.6)
end

local id_bhvCoinCarry = hook_behavior(nil, OBJ_LIST_LEVEL, true, bhv_coin_carry_init, bhv_coin_carry_loop, "bhvCoinCarry")

--- @param m MarioState
--- @param o Object
local function carry_object_to_mario(m, o)
    local gIndex = network_global_index_from_local(m.playerIndex)
    --- @param oCarry Object
    return spawn_sync_object(id_bhvCoinCarry, E_MODEL_NONE, o.oPosX, o.oPosY, o.oPosZ, function(oCarry)
        oCarry.globalPlayerIndex = gIndex
        oCarry.parentObj = o
    end)
end

local function is_object_being_carried(o)
    local carried = false
    local oCarry = obj_get_first_with_behavior_id(id_bhvCoinCarry)
    while oCarry ~= nil do
        if oCarry.parentObj == o then
            carried = true
        end

        oCarry = obj_get_next_with_same_behavior_id(oCarry)
    end
    return carried
end

--- @param o Object
local function coin_spawner_init(o)
    network_init_object(o, false, {
        "oNumLootCoins",
    })
end

--- @param o Object
local function coin_spawner_loop(o)
    if o.oNumLootCoins > 0 then
        if sync_object_is_owned_locally(o.oSyncID) then
            if o.oNumLootCoins >= 5 and o.oAction == 0 and math.random() > 0.25 then
                cur_obj_spawn_loot_blue_coin();
                o.oNumLootCoins = o.oNumLootCoins - 5
                network_send_object(o, false)
            else
                obj_spawn_yellow_coins(o, 1);
                o.oNumLootCoins = o.oNumLootCoins - 1
                network_send_object(o, false)
            end
        end
    else
        obj_mark_for_deletion(o)
        network_send_object(o, true)
    end
end

local id_bhvCoinSpawner = hook_behavior(nil, OBJ_LIST_SPAWNER, true, coin_spawner_init, coin_spawner_loop, "bhvCoinSpawner")

---@param x integer
---@param y integer
---@param z integer
---@param coins integer
---@param forceYellow boolean?
---@return Object?
function spawn_coin_spawner(x, y, z, coins, forceYellow)
    if coins < 1 then return end
    --- @param o Object
    return spawn_sync_object(id_bhvCoinSpawner, E_MODEL_NONE, x, y, z, function(o)
        o.oNumLootCoins = coins
        o.oAction = forceYellow and 1 or 0
    end)
end

-- update

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
                if (dist < 500 or o.oVelY < 0) and o.oVelY <= 0 and (bhvID ~= id_bhvHiddenBlueCoin or o.oAction == HIDDEN_BLUE_COIN_ACT_ACTIVE) then
                    local isWall = collision_find_surface_on_ray(m.pos.x, m.pos.y + 70, m.pos.z, o.oPosX - m.pos.x, o.oPosY - m.pos.y, o.oPosZ - m.pos.z, 10).surface ~= nil
                    if not isWall and not obj_is_in_clam(o) then
                        carry_object_to_mario(m, o)
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

---------------------------
-- Replacement Behaviors --
---------------------------

function hook_coins_behavior(id, override, init_f, loop_f)
    hook_behavior(id, get_object_list_from_behavior(get_behavior_from_id(id)), override, init_f, loop_f, "bhvCoins" .. get_behavior_name_from_id(id):sub(4))
end

---@param o Object
local function bhv_moneybag_set_coins(o)
    -- in place of loot coins since the original func forces it to 0
    o.oCoinUnk110 = (o.parentObj ~= nil and o.parentObj.oCoinUnk110 ~= 0) and o.parentObj.oCoinUnk110 or 15
    network_init_object(o, false, {
        "oHomeX",
        "oHomeY",
        "oHomeZ",
        "oMoneybagJumpState",
        "oOpacity",
        "oCoinUnk110",
    })
end

---@param o Object
local function bhv_moneybag_squirt_jump(o)
    -- Squirt Coins while moving
    if o.oCoinUnk110 > 5 and o.oMoneybagJumpState == MONEYBAG_JUMP_PREPARE and o.header.gfx.animInfo.animFrame == 5 then
        obj_spawn_yellow_coins(o, 1);
        o.oCoinUnk110 = o.oCoinUnk110 - 1
        network_send_object(o, true)
    end

    -- Spawn coins that haven't been given
    if o.oAction == MONEYBAG_ACT_DEATH then
        if (o.oTimer == 1 and o.oCoinUnk110 > 5) then
            obj_spawn_yellow_coins(o, o.oCoinUnk110 - 5);
        end
    end
end

hook_coins_behavior(id_bhvMoneybag, false, bhv_moneybag_set_coins, bhv_moneybag_squirt_jump)
hook_coins_behavior(id_bhvMoneybagHidden, false, bhv_moneybag_set_coins, nil)


---@param o Object
local function bhv_message_panel_set_coins(o)
    o.oCoinUnk110 = 1
    network_init_object(o, false, {
        "oCoinUnk110",
    })
end

---@param o Object
local function bhv_message_panel_reward(o)
    if o.oCoinUnk110 > 0 and is_point_within_radius_of_mario(o.oPosX, o.oPosY, o.oPosZ, 200) ~= 0 and nearest_mario_state_to_object(o).prevAction == ACT_READING_SIGN then
        local m = nearest_mario_state_to_object(o)
        spawn_coin_spawner((m.pos.x + o.oPosX)*0.5, math.max(m.pos.y, o.oPosY) + 100, (m.pos.z + o.oPosZ)*0.5, o.oCoinUnk110, true);
        o.oCoinUnk110 = 0
        network_send_object(o, true)
    end
end

hook_coins_behavior(id_bhvMessagePanel, false, bhv_message_panel_set_coins, bhv_message_panel_reward)
hook_coins_behavior(id_bhvSignOnWall, false, bhv_message_panel_set_coins, bhv_message_panel_reward)

local sYoshiShouldExplode = false
---@param o Object
local function bhv_yoshi_blew_up(o)
    if sYoshiShouldExplode then
        obj_mark_for_deletion(o)
    end
end

---@param o Object
local function bhv_yoshi_reward(o)
    if o.oAction == YOSHI_ACT_TALK then
        sYoshiShouldExplode = true
    elseif sYoshiShouldExplode then
        spawn_coin_spawner(o.oPosX, o.oPosY, o.oPosZ, 100 * gLevelValues.numCoinsToLife)
        spawn_non_sync_object(id_bhvExplosion, E_MODEL_EXPLOSION, o.oPosX, o.oPosY, o.oPosZ, nil)
        obj_mark_for_deletion(o)
    end
end

hook_coins_behavior(id_bhvYoshi, false, bhv_yoshi_blew_up, bhv_yoshi_reward)

---@param o Object
local function bhv_recovery_heart_set_coins(o)
    o.oCoinUnk110 = 5
    network_init_object(o, false, {
        "oCoinUnk110",
    })
end

---@param o Object
local function bhv_recovery_heart_squirt_coins(o)
    if o.oAngleVelYaw > 400 and o.oSpinningHeartTotalSpin - o.oAngleVelYaw < 0 and o.oCoinUnk110 > 0 then
        obj_spawn_yellow_coins(o, 1)
        o.oCoinUnk110 = o.oCoinUnk110 - 1
        network_send_object(o, true)
    end
end


hook_coins_behavior(id_bhvRecoveryHeart, false, bhv_recovery_heart_set_coins, bhv_recovery_heart_squirt_coins)

---@param o Object
local function bhv_bubble_cannon_init(o)
    local cannonPos = obj_pos_to_vec3f(o)
    local nBombomb = obj_get_nearest_object_with_behavior_id(o, id_bhvBobomb)
    local nBobombBuddy = obj_get_nearest_object_with_behavior_id(o, id_bhvBobombBuddy)
    o.parentObj = vec3f_dist(cannonPos, obj_pos_to_vec3f(nBombomb)) < vec3f_dist(cannonPos, obj_pos_to_vec3f(nBobombBuddy)) and nBombomb or nBobombBuddy
end


---@param o Object
local function bhv_bubble_cannon_explode(o)
    local owner = o.parentObj
    if owner ~= nil and obj_has_behavior_id(owner, id_bhvBobomb) ~= 0 then
        if owner.oAction == BOBOMB_ACT_EXPLODE and owner.oTimer >= 5 then
            spawn_coin_spawner(o.oPosX, o.oPosY, o.oPosZ, 10, true)
            obj_mark_for_deletion(o)
        end
    end
end

---@param o Object
local function bhv_bubble_cannon_barrel_explode(o)
    local owner = o.parentObj.parentObj
    if owner ~= nil and obj_has_behavior_id(owner, id_bhvBobomb) ~= 0 then
        if owner.oAction == BOBOMB_ACT_EXPLODE and owner.oTimer >= 5 then
            spawn_non_sync_object(id_bhvExplosion, E_MODEL_EXPLOSION, o.oPosX, o.oPosY, o.oPosZ, nil)
            obj_mark_for_deletion(o)
        end
    end
end

hook_coins_behavior(id_bhvWaterBombCannon, false, bhv_bubble_cannon_init, bhv_bubble_cannon_explode)
hook_coins_behavior(id_bhvCannonBarrelBubbles, false, nil, bhv_bubble_cannon_barrel_explode)

---@param o Object
local function bhv_whomp_init(o)
    network_init_object(o, true, {
        "oAngleVelPitch",
        "oFaceAnglePitch",
        "oForwardVel",
        "oHealth",
        "oFaceAnglePitch",
        "oCoinUnk110",
    })
end

---@param o Object
local function bhv_whomp_loop(o)
    if o.oAction ~= 8 then
        -- Check if player is activly ground pounding whomp
        if o.oAction == 6 and o.oBehParams2ndByte == 0 and o.oSubAction == 0 and cur_obj_is_any_player_on_platform() ~= 0 and cur_obj_is_mario_ground_pounding_platform() ~= 0 then
            -- Do nothing if pounding whomp
            djui_chat_message_create(tostring(o.oCoinUnk110))
        else
            o.oCoinUnk110 = o.oNumLootCoins
        end
    else
        if o.oCoinUnk110 > 0 then
            obj_spawn_yellow_coins(o, o.oCoinUnk110)
            o.oCoinUnk110 = 0
        end
    end
end

hook_coins_behavior(id_bhvSmallWhomp, false, bhv_whomp_init, bhv_whomp_loop)

---@param o Object
local function thwomp_break_init(o)
    o.oHealth = 5
    network_init_object(o, true, {
        "oAction",
        "oPosY",
        "oThwompRandomTimer",
        "oTimer",
        "oVelY",

        "oDorrieGroundPounded",
        "oHealth",
    })
end

---@param o Object
local function thwomp_break_loop(o)
    if cur_obj_is_any_player_on_platform() ~= 0 and cur_obj_is_mario_ground_pounding_platform() ~= 0 then
        if o.oDorrieGroundPounded == 0 then
            o.oHealth = o.oHealth - 1
            if o.oHealth > 0 then
                o.oThwompRandomTimer = o.oThwompRandomTimer + 30
                play_sound_with_freq_scale(SOUND_OBJ_THWOMP, o.header.gfx.cameraToObject, 0.9 + math.random()*0.2)
            else
                obj_spawn_yellow_coins(o, 5)
                spawn_triangle_break_particles(20, 138, 3.0, 4);
                play_sound_with_freq_scale(SOUND_OBJ_THWOMP, o.header.gfx.cameraToObject, 0.8)
                obj_mark_for_deletion(o)
            end
            o.oDorrieGroundPounded = 1
        end
    else
        o.oDorrieGroundPounded = 0
    end
end

hook_coins_behavior(id_bhvThwomp, false, thwomp_break_init, thwomp_break_loop)
hook_coins_behavior(id_bhvThwomp2, false, thwomp_break_init, thwomp_break_loop)

local function bhv_small_box_kickable_init(o)
    o.oInteractionSubtype = INT_SUBTYPE_KICKABLE;
end

local function bhv_small_box_kickable_loop(o)
    local m = nearest_mario_state_to_object(o);
    if not m then return end
    if obj_check_hitbox_overlap(o, m.marioObj) and determine_interaction(m,o) == INT_KICK then
        o.oMoveAngleYaw = m.marioObj.header.gfx.angle.y;
        o.oForwardVel = math.max(m.forwardVel, 25.0);
        o.oVelY = 30.0;
    end
end

hook_coins_behavior(id_bhvBreakableBoxSmall, false, bhv_small_box_kickable_init, bhv_small_box_kickable_loop)

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

local function interact(m, o, int)
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