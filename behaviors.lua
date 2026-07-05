
---@param id BehaviorId|number
---@param override boolean
---@param init function?
---@param loop function?
local function hook_coins_behavior(id, override, init, loop)
    hook_behavior(id, get_object_list_from_behavior(get_behavior_from_id(id)), override, init, loop, (get_behavior_name_from_id(id):gsub("bhv", "bhvCoins", 1)))
end

-- Coin Magnitize Behaviors
---@param o Object
function bhv_init_for_magnitize(o)
    o.oIsCarried = 0
end

---@param o Object
function bhv_check_for_magnitize(o)
    local m = nearest_mario_state_to_object(o)
    if not m or m.marioObj.oIntangibleTimer ~= 0 or m.action == ACT_BUBBLED or m.action == ACT_MASTER_CAP_BUBBLED then return end
    if not is_object_being_carried(o) and o.oIntangibleTimer == 0 then
        -- Attract if coin is yours
        local dist = obj_to_obj_dist(o, m.marioObj)
        if (dist <= gMarioCoinRange[m.playerIndex] or o.oVelY < 0) then
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
            local mouseDist = math.sqrt((out.x - gMousePosX)^2 + (out.y - gMousePosY)^2)
            if mouseDist < 10 then
                local isWall = collision_find_surface_on_ray(gLakituState.pos.x, gLakituState.pos.y, gLakituState.pos.z, o.oPosX - gLakituState.pos.x, (o.oPosY + 50) - gLakituState.pos.y, o.oPosZ - gLakituState.pos.z, 128).surface ~= nil
                if not isWall then
                    carry_object_to_mario(m, o)
                end
            end
        end
    end

    -- Sneak in ceiling check
    local ceilHeight = find_ceil_height(o.oPosX, o.oPosY, o.oPosZ)
    if o.oVelY > 0 and o.oPosY + (o.hitboxHeight * o.header.gfx.scale.y) >= ceilHeight then
        o.oVelY = 0
    end
end

local function hook_coin_magnitize_behavior(bhvID)
    return hook_coins_behavior(bhvID, false, bhv_init_for_magnitize, bhv_check_for_magnitize)
end

hook_coin_magnitize_behavior(id_bhvOneCoin)
hook_coin_magnitize_behavior(id_bhvYellowCoin)
hook_coin_magnitize_behavior(id_bhvMovingYellowCoin)
hook_coin_magnitize_behavior(id_bhvSingleCoinGetsSpawned)
hook_coin_magnitize_behavior(id_bhvRedCoin)
hook_coin_magnitize_behavior(id_bhvMrIBlueCoin)
hook_coin_magnitize_behavior(id_bhvMovingBlueCoin)
hook_coin_magnitize_behavior(id_bhv1Up)
hook_coin_magnitize_behavior(id_bhv1upSliding)

local function bhv_merged_acts_delete(o)
    if gLevelValues.disableActs == 1 then
        obj_mark_for_deletion(o)
    end
end

local function bhv_merged_acts_move(o, relX, relY, relZ)
    if gLevelValues.disableActs == 1 then
        o.oPosX = o.oPosX + relX
        o.oPosY = o.oPosY + relY
        o.oPosZ = o.oPosZ + relZ
        o.oHomeX = o.oHomeX + relX
        o.oHomeY = o.oHomeY + relY
        o.oHomeZ = o.oHomeZ + relZ
    end
end


---@param o Object
local function bhv_moneybag_set_coins(o)
    -- in place of loot coins since the original func forces it to 0
    o.oCustomCoins = (o.parentObj ~= nil and o.parentObj.oCustomCoins ~= 0) and o.parentObj.oCustomCoins or 15
    network_init_object(o, false, {
        "oHomeX",
        "oHomeY",
        "oHomeZ",
        "oMoneybagJumpState",
        "oOpacity",
        "oCustomCoins",
    })
end

---@param o Object
local function bhv_moneybag_squirt_jump(o)
    -- Squirt Coins while moving
    if o.oCustomCoins > 5 and o.oMoneybagJumpState == MONEYBAG_JUMP_PREPARE and o.header.gfx.animInfo.animFrame == 5 then
        obj_spawn_yellow_coins(o, 1);
        o.oCustomCoins = o.oCustomCoins - 1
        network_send_object(o, true)
    end

    -- Spawn coins that haven't been given
    if o.oAction == MONEYBAG_ACT_DEATH then
        if (o.oTimer == 1 and o.oCustomCoins > 5) then
            obj_spawn_yellow_coins(o, o.oCustomCoins - 5);
        end
    end
end

hook_coins_behavior(id_bhvMoneybag, false, bhv_moneybag_set_coins, bhv_moneybag_squirt_jump)
hook_coins_behavior(id_bhvMoneybagHidden, false, bhv_moneybag_set_coins, nil)

--[[
---@param o Object
local function bhv_message_panel_set_coins(o)
    o.oCustomCoins = 1
    network_init_object(o, false, {
        "oCustomCoins",
    })
end

---@param o Object
local function bhv_message_panel_reward(o)
    if o.oCustomCoins > 0 and is_point_within_radius_of_mario(o.oPosX, o.oPosY, o.oPosZ, 200) ~= 0 and nearest_mario_state_to_object(o).prevAction == ACT_READING_SIGN then
        local m = nearest_mario_state_to_object(o)
        spawn_coin_spawner((m.pos.x + o.oPosX)*0.5, math.max(m.pos.y, o.oPosY) + 100, (m.pos.z + o.oPosZ)*0.5, o.oCustomCoins, true);
        o.oCustomCoins = 0
        network_send_object(o, true)
    end
end

hook_coins_behavior(id_bhvMessagePanel, false, bhv_message_panel_set_coins, bhv_message_panel_reward)
hook_coins_behavior(id_bhvSignOnWall, false, bhv_message_panel_set_coins, bhv_message_panel_reward)
]]

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
        spawn_coin_spawner(o, 100 * (gBetterCoinValues.numCoinsToLife or 50))
        spawn_non_sync_object(id_bhvExplosion, E_MODEL_EXPLOSION, o.oPosX, o.oPosY, o.oPosZ, nil)
        obj_mark_for_deletion(o)
    end
end

hook_coins_behavior(id_bhvYoshi, false, bhv_yoshi_blew_up, bhv_yoshi_reward)

---@param o Object
local function bhv_recovery_heart_set_coins(o)
    o.oCustomCoins = o.oBehParams & 0x100 == 0 and 5 or o.oCustomCoins
    network_init_object(o, false, {
        "oCustomCoins",
    })
end

---@param o Object
local function bhv_recovery_heart_squirt_coins(o)
    if o.oAngleVelYaw > 800 and o.oSpinningHeartTotalSpin - o.oAngleVelYaw < 0 and o.oCustomCoins > 0 then
        obj_spawn_yellow_coins(o, 1)
        o.oCustomCoins = o.oCustomCoins - 1
        set_object_respawn_info_bits(o, 1);
        network_send_object(o, true)
    end
end


hook_coins_behavior(id_bhvRecoveryHeart, false, bhv_recovery_heart_set_coins, bhv_recovery_heart_squirt_coins)

---@param o Object
local function bhv_bubble_cannon_init(o)
    local nBombomb = obj_get_nearest_object_with_behavior_id(o, id_bhvBobomb)
    local nBobombBuddy = obj_get_nearest_object_with_behavior_id(o, id_bhvBobombBuddy)
    o.parentObj = obj_to_obj_dist(o, nBombomb) < obj_to_obj_dist(o, nBobombBuddy) and nBombomb or nBobombBuddy
    if o.parentObj == nBombomb then
        oTagLib.obj_set_nametag(o.parentObj, "Jim", {r = 50, g = 50, b = 100})
    end
end


---@param o Object
local function bhv_bubble_cannon_explode(o)
    local owner = o.parentObj
    if owner ~= nil and obj_has_behavior_id(owner, id_bhvBobomb) ~= 0 then
        if owner.oAction == BOBOMB_ACT_EXPLODE and owner.oTimer >= 5 then
            spawn_coin_spawner(o, 10, true)
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
        "oCustomCoins",
    })
end

---@param o Object
local function bhv_whomp_loop(o)
    if o.oAction ~= 8 then
        -- Check if player is activly ground pounding whomp
        if o.oAction == 6 and o.oBehParams2ndByte == 0 and o.oSubAction == 0 and cur_obj_is_any_player_on_platform() ~= 0 and cur_obj_is_mario_ground_pounding_platform() ~= 0 then
            -- Do nothing if pounding whomp
        else
            o.oCustomCoins = o.oNumLootCoins
        end
    else
        if o.oCustomCoins > 0 then
            obj_spawn_yellow_coins(o, o.oCustomCoins)
            o.oCustomCoins = 0
        end
    end
end

hook_coins_behavior(id_bhvSmallWhomp, false, bhv_whomp_init, bhv_whomp_loop)

---@param o Object
local function thwomp_break_init(o)
    o.oHealth = 5
    o.oThwompPrevAngle = o.oFaceAngleYaw
    network_init_object(o, true, {
        "oAction",
        "oPosY",
        "oThwompRandomTimer",
        "oTimer",
        "oVelY",

        "oThwompGroundPounded",
        "oHealth",
        "oThwompHitstun",
    })
end

---@param o Object
local function thwomp_break_loop(o)
    if cur_obj_is_any_player_on_platform() ~= 0 and cur_obj_is_mario_ground_pounding_platform() ~= 0 then
        if (o.oSyncID == 0 or sync_object_is_owned_locally(o.oSyncID)) and o.oThwompGroundPounded == 0 then
            local m = nearest_mario_state_to_object(o)
            o.oThwompGroundPounded = 1
            o.oHealth = math.max(o.oHealth - (m.flags & MARIO_METAL_CAP ~= 0 and 3 or 1), 0)
            network_send_object(o, true)
        end
    else
        o.oThwompGroundPounded = 0
    end


    if o.oHealth > 0 then
        if o.oThwompGroundPounded == 1 then
            o.oThwompGroundPounded = 2
            o.oThwompHitstun = o.oThwompHitstun + 30
            o.oThwompRandomTimer = o.oThwompRandomTimer + 30
            spawn_triangle_break_particles(5, 138, 1.0, 4);
            play_sound_with_freq_scale(SOUND_OBJ_THWOMP, o.header.gfx.cameraToObject, 1 + (5 - o.oHealth)/5*0.3)
        end
    else
        spawn_coin_spawner(o, 10, true)
        spawn_triangle_break_particles(20, 138, 3.0, 4);
        play_sound_with_freq_scale(SOUND_OBJ_THWOMP, o.header.gfx.cameraToObject, 0.8)
        obj_mark_for_deletion(o)
    end

    if o.oThwompHitstun > 0 then
        o.oMoveAngleYaw = o.oThwompPrevAngle + math.sin(o.oThwompHitstun/3)*0x1000*(5 - o.oHealth)/5*o.oThwompHitstun/30
        o.oThwompHitstun = o.oThwompHitstun - 1
    else
        o.oThwompPrevAngle = o.oMoveAngleYaw
    end
end

hook_coins_behavior(id_bhvThwomp, false, thwomp_break_init, thwomp_break_loop)
hook_coins_behavior(id_bhvThwomp2, false, thwomp_break_init, thwomp_break_loop)
hook_coins_behavior(id_bhvGrindel, false, thwomp_break_init, thwomp_break_loop)

---@param o Object
local function bhv_small_box_kickable_init(o)
    o.oInteractionSubtype = INT_SUBTYPE_KICKABLE;
end

---@param o Object
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

---@param o Object
local function bhv_bowser_init_loot(o)
    o.oNumLootCoins = 50
end

---@param o Object
local function bhv_bowser_spawn_coins(o)
    if o.oAction == 4 then
        if (o.oSubAction == 4 or o.oSubAction == 11) and o.oNumLootCoins > 0 then
            spawn_coin_spawner(o, o.oNumLootCoins, true)
            o.oNumLootCoins = 0
        end
    end
end

hook_coins_behavior(id_bhvBowser, false, bhv_bowser_init_loot, bhv_bowser_spawn_coins)

---@param o Object
local function bhv_chest_loot_init(o)
    o.oNumLootCoins = o.oBehParams2ndByte
end

---@param o Object
local function bhv_chest_loot_loop(o)
    if (o.parentObj.oTreasureChestCurrentAnswer - 1) == o.oBehParams2ndByte and o.oNumLootCoins > 0 then
        spawn_coin_spawner(o, o.oNumLootCoins, true, 0, 100, 0)
        o.oNumLootCoins = 0
    end
end

hook_coins_behavior(id_bhvTreasureChestBottom, false, bhv_chest_loot_init, bhv_chest_loot_loop)

---@param o Object
local function breakable_wall_coins(o)
    if cur_obj_is_any_player_on_platform() ~= 0 and cur_obj_is_mario_ground_pounding_platform() ~= 0 then
        local m = nearest_mario_state_to_object(o)
        if (m.flags & MARIO_METAL_CAP ~= 0) then
            o.oBreakableWallForce = 1
        end
    end
    if o.oBreakableWallForce == 1 then
        spawn_coin_spawner(o, 10, true)
    end
end

hook_coins_behavior(id_bhvWfBreakableWallLeft, false, nil, breakable_wall_coins)
hook_coins_behavior(id_bhvWfBreakableWallRight, false, nil, breakable_wall_coins)

---@param o Object
local function bhv_1up_to_blue_coin(o)
    o.oNumLootCoins = 5
    cur_obj_spawn_loot_blue_coin()
    obj_mark_for_deletion(o)
end

---@param o Object
local function bhv_1up_hidden_in_pole_loop(o)
    if o.oAction == 0 then
        obj_set_model_extended(o, E_MODEL_BLUE_COIN)
    elseif o.oAction == 1 then
        o.oNumLootCoins = 5
        bhv_1up_to_blue_coin(o)
    end
    o.oAnimState = o.oAnimState + 1
end

---@param o Object
local function bhv_blue_coin_init(o)
    bhv_1up_common_init()
    o.oMoveAngleYaw = o.oFaceAngleYaw
    o.oInteractType = INTERACT_COIN
    o.oFlags = o.oFlags | (OBJ_FLAG_ACTIVE_FROM_AFAR | OBJ_FLAG_COMPUTE_DIST_TO_MARIO | OBJ_FLAG_UPDATE_GFX_POS_AND_ANGLE)
    o.hitboxRadius = 100
    o.hitboxHeight = 64
    o.oDamageOrCoinValue = 5
    o.oAnimState = -1
    obj_set_billboard(o)
    obj_set_model_extended(o, E_MODEL_BLUE_COIN)

    network_init_object(o, true, {})
end

---@param o Object
local function bhv_blue_coin_loop(o)
    obj_set_model_extended(o, E_MODEL_BLUE_COIN)
    cur_obj_enable_rendering();
    cur_obj_become_tangible();

    -- Delete the coin once collected
    if (o.oInteractStatus & INT_STATUS_INTERACTED ~= 0) then
        spawn_non_sync_object(id_bhvGoldenCoinSparkles, E_MODEL_SPARKLES, o.oPosX, o.oPosY, o.oPosZ, function (o) end);
        obj_mark_for_deletion(o);
    end

    o.oAnimState = o.oAnimState + 1
    o.oInteractStatus = 0;
end

---@param o Object
local function bhv_moving_blue_coin_capped_loop(o)
    bhv_moving_blue_coin_loop()
    obj_set_model_extended(o, E_MODEL_BLUE_COIN)
    if (o.oForwardVel > 40.0) then
        o.oForwardVel = 40.0
    end
    o.oAnimState = o.oAnimState + 1
end

hook_coins_behavior(id_bhv1Up, true, bhv_blue_coin_init, bhv_blue_coin_loop)
hook_coins_behavior(id_bhv1upWalking, false, nil, bhv_1up_hidden_in_pole_loop)
hook_coins_behavior(id_bhv1upRunningAway, false, nil, bhv_1up_hidden_in_pole_loop)
hook_coins_behavior(id_bhv1upSliding, true, function (o); bhv_blue_coin_init(o); bhv_moving_blue_coin_init() end, bhv_moving_blue_coin_capped_loop)
hook_coins_behavior(id_bhvHidden1up, false, nil, bhv_1up_hidden_in_pole_loop)
hook_coins_behavior(id_bhvHidden1upInPole, false, nil, bhv_1up_hidden_in_pole_loop)

---@param o Object
function bhv_purple_switch_coins_init(o)
    o.oCustomCoins = 3
    network_init_object(o, false, {
        "oAction",
        "oTimer",
        "oCustomCoins",
    })
end

---@param o Object
function bhv_purple_switch_coins_loop(o)
    if o.oAction == PURPLE_SWITCH_PRESSED and o.oCustomCoins > 0 then
        spawn_coin_spawner(o, o.oCustomCoins, true)
        o.oCustomCoins = 0
        network_send_object(o, true)
    end
end

hook_coins_behavior(id_bhvFloorSwitchHardcodedModel, false, bhv_purple_switch_coins_init, bhv_purple_switch_coins_loop)
hook_coins_behavior(id_bhvFloorSwitchAnimatesObject, false, bhv_purple_switch_coins_init, bhv_purple_switch_coins_loop)
hook_coins_behavior(id_bhvFloorSwitchHiddenObjects, false, bhv_purple_switch_coins_init, bhv_purple_switch_coins_loop)
hook_coins_behavior(id_bhvFloorSwitchGrills, false, bhv_purple_switch_coins_init, bhv_purple_switch_coins_loop)

---@param o Object
local function bhv_bowser_bomb_explosion_coins_loop(o)
    if o.oTimer == 4 then
        spawn_coin_spawner(o, 15, true)
    end
end

hook_coins_behavior(id_bhvBowserBombExplosion, false, nil, bhv_bowser_bomb_explosion_coins_loop)

---@param o Object
local function bhv_bookend_death_coins(o)
    if o.oNumLootCoins == 0 and o.oMoveFlags & (OBJ_MOVE_MASK_ON_GROUND | OBJ_MOVE_HIT_WALL) ~= 0 and o.oDamageOrCoinValue == 2 then
        spawn_coin_spawner(o, 5)
        o.oNumLootCoins = -1
    end
end

hook_coins_behavior(id_bhvFlyingBookend, false, nil, bhv_bookend_death_coins)

---@param o Object
local function bhv_haunted_chair_coin_init(o)
    network_init_object(o, true, {
        "oFaceAnglePitch",
        "oFaceAngleRoll",
        "oFaceAngleYaw",
        "oHauntedChairUnk104",
        "oHauntedChairUnkF4",
        "oHauntedChairUnkF8",
        "oHauntedChairUnkFC",
        "oMoveAnglePitch",
        "oMoveAngleYaw",

        "oCustomCoins",
        "oHitMario",
    })
    o.oHitMario = 0
end

---@param o Object
local function bhv_haunted_chair_coin_loop(o)
    local m = nearest_mario_state_to_object(o)
    if o.oAction == 0 or o.oHitMario ~= 0 or m == nil then return end
    if m.interactObj == o then
        o.oHitMario = 1
        play_sound_with_freq_scale(SOUND_OBJ_BOO_LAUGH_LONG, o.header.gfx.cameraToObject, 0.5)
        network_send_object(o, true)
        return
    end
    
    if o.oTimer >= 70 and o.oMoveFlags & (OBJ_MOVE_MASK_ON_GROUND | OBJ_MOVE_HIT_WALL) ~= 0 then
        spawn_coin_spawner(o, 2)
        o.oHitMario = 1
        network_send_object(o, true)
    end
end

hook_coins_behavior(id_bhvHauntedChair, false, bhv_haunted_chair_coin_init, bhv_haunted_chair_coin_loop)

---@param o Object
local function bhv_snowmans_head_coins_init(o)
    o.oCustomCoins = 15
    network_init_object(o, true, {
        "oAction",
        "oCustomCoins",
    })

    if gLevelValues.disableActs == 1 then
        o.oPosY = find_floor(o.oPosX, o.oPosY, o.oPosZ)
    end
end

---@param o Object
local function bhv_snowmans_head_coins_loop(o)
    if o.oAction == 4 and o.oCustomCoins > 0 then
        spawn_coin_spawner(o, o.oCustomCoins, true, 0, o.hitboxHeight, 0)
        o.oCustomCoins = 0
        network_send_object(o, true)
    end
end

hook_coins_behavior(id_bhvSnowmansHead, false, bhv_snowmans_head_coins_init, bhv_snowmans_head_coins_loop)
hook_coins_behavior(id_bhvBigSnowmanWhole, false, bhv_merged_acts_delete)

---@param o Object
local function bhv_water_pillar_init(o)
    o.oCustomCoins = gLevelValues.numCoinsToLife
end

---@param o Object
local function bhv_water_pillar_loop(o)
    if o.oAction == 4 and o.oCustomCoins > 0 then
        otherWaterPillar = cur_obj_nearest_object_with_behavior(o.behavior)
        spawn_coin_spawner(o, o.oCustomCoins*0.5, true)
        spawn_coin_spawner(otherWaterPillar, o.oCustomCoins*0.5, true)
        o.oCustomCoins = 0
    end
end

hook_coins_behavior(id_bhvWaterLevelPillar, false, bhv_water_pillar_init, bhv_water_pillar_loop)

---@param o Object
local function bhv_secret_follow_coin_loop(o)
    if o.parentObj ~= nil and obj_has_behavior_id(o.parentObj, id_bhvYellowCoin) ~= 0 then
        o.oPosX = o.parentObj.oPosX
        o.oPosY = o.parentObj.oPosY
        o.oPosZ = o.parentObj.oPosZ

        o.oVelX = o.parentObj.oVelX
        o.oVelY = o.parentObj.oVelY
        o.oVelZ = o.parentObj.oVelZ

        if o.parentObj.activeFlags == ACTIVE_FLAG_DEACTIVATED and sync_object_is_owned_locally(o.oSyncID) then
            local oCarry = carry_object_to_mario(gMarioStates[0], o)
            if oCarry ~= nil then
                oCarry.oTimer = math.sqrt(800)
            end
            network_send_object(o, true)
        end
    else
        if o.oTimer < 5 then
            local oCoin = obj_get_nearest_object_with_behavior_id(o, id_bhvYellowCoin)
            if oCoin ~= nil and obj_to_obj_dist(o, oCoin) < 100 then
                o.parentObj = oCoin
            end
        end
    end
end

hook_coins_behavior(id_bhvHiddenStarTrigger, false, nil, bhv_secret_follow_coin_loop)
hook_coins_behavior(id_bhvHidden1upTrigger, false, nil, bhv_secret_follow_coin_loop)

---@param o Object
local function bhv_thi_pound_coins_init(o)
    o.oCustomCoins = 5
    network_init_object(o, true, {
        "oAction",
        "oPrevAction",
        "oTimer",
        "oCustomCoins",
    })
end

---@param o Object
local function bhv_thi_pound_coins_loop(o)
    if o.oAction > 0 and o.oCustomCoins > 0 then
        spawn_coin_spawner(o, o.oCustomCoins)
        o.oCustomCoins = 0
    end
end

hook_coins_behavior(id_bhvThiTinyIslandTop, false, bhv_thi_pound_coins_init, bhv_thi_pound_coins_loop)

---@param o Object
local function bhv_generic_boss_coins_init(o)
    local health = o.oHealth ~= 2048 and o.oHealth or 4
    o.oCustomCoins = health*5
    o.oPrevHealth = health
end

---@param o Object
local function bhv_coins_on_damage_loop(o)
    if o.oPrevHealth > o.oHealth and (o.oCustomCoins > 0) then
        spawn_coin_spawner(o, 5, true, 0, o.hitboxHeight, 0)
        o.oCustomCoins = o.oCustomCoins - 5
    end
    o.oPrevHealth = math.min(o.oPrevHealth, o.oHealth)
end

---@param o Object
local function bhv_coins_on_damage_at_mario_loop(o)
    if o.oPrevHealth > o.oHealth and (o.oCustomCoins > 0) then
        local marioState = nearest_mario_state_to_object(o);
        if (marioState) then
            spawn_coin_spawner(o, 5, true, marioState.pos.x - o.oPosX, marioState.pos.y - o.oPosY, marioState.pos.z - o.oPosZ)
            o.oCustomCoins = o.oCustomCoins - 5
        end
    end
    o.oPrevHealth = math.min(o.oPrevHealth, o.oHealth)
end

hook_coins_behavior(id_bhvKingBobomb, false, bhv_generic_boss_coins_init, bhv_coins_on_damage_loop)
hook_coins_behavior(id_bhvWhompKingBoss, false, function (o)
    bhv_generic_boss_coins_init(o)
    bhv_merged_acts_move(o, 400, 0, 1200)
end, bhv_coins_on_damage_at_mario_loop)
hook_coins_behavior(id_bhvBalconyBigBoo, false, bhv_generic_boss_coins_init, bhv_coins_on_damage_loop)
hook_coins_behavior(id_bhvGhostHuntBigBoo, false, bhv_generic_boss_coins_init, bhv_coins_on_damage_loop)
hook_coins_behavior(id_bhvMerryGoRoundBigBoo, false, bhv_generic_boss_coins_init, bhv_coins_on_damage_loop)
hook_coins_behavior(id_bhvEyerokHand, false, bhv_generic_boss_coins_init, bhv_coins_on_damage_at_mario_loop)
hook_coins_behavior(id_bhvWigglerHead, false, bhv_generic_boss_coins_init, bhv_coins_on_damage_loop)

---@param o Object
local function bhv_big_bully_coins(o)
    if o.oAction == BULLY_ACT_LAVA_DEATH and o.oTimer == 1 then
        spawn_coin_spawner(o, 10, true, 0, 310, 0)
    end
end

hook_coins_behavior(id_bhvBigBully, false, nil, bhv_big_bully_coins)
hook_coins_behavior(id_bhvBigBullyWithMinions, false, nil, bhv_big_bully_coins)
hook_coins_behavior(id_bhvBigChillBully, false, nil, bhv_big_bully_coins)

---@param o Object
local function bhv_big_goomba_loop(o)
    if o.oGoombaSize == 1 then
        o.oNumLootCoins = -1
        local m = nearest_mario_state_to_object(o)
        if o.oAction == GOOMBA_ACT_ATTACKED_MARIO and m and (m.flags & MARIO_METAL_CAP ~= 0 or m.action & ACT_FLAG_RIDING_SHELL ~= 0) then
            obj_set_knockback_action(o.oInteractStatus & INT_STATUS_ATTACK_MASK)
        end
    end
end

hook_coins_behavior(id_bhvGoomba, false, nil, bhv_big_goomba_loop)

---@param o Object
local function bhv_breakable_box_coins(o)
    if o.oNumLootCoins < 3 then
        o.oNumLootCoins = 3
    end
end

hook_coins_behavior(id_bhvBreakableBox, false, nil, bhv_breakable_box_coins)

---@param o Object
local function bhv_wooden_post_loop(o)
    local m = nearest_mario_state_to_object(o)
    if cur_obj_is_mario_ground_pounding_platform() ~= 0 then
        if m.flags & MARIO_METAL_CAP ~= 0 then
            o.oWoodenPostSpeedY = -85
            network_send_object(o, true)
        end
    end

    if o.oBehParams ~= WOODEN_POST_BP_NO_COINS_MASK and o.oWoodenPostOffsetY == -190.0 then
        spawn_coin_spawner(o, 5, true, 0, -o.oWoodenPostOffsetY, 0);
        set_object_respawn_info_bits(o, 1);
        o.oBehParams = WOODEN_POST_BP_NO_COINS_MASK;
        network_send_object(o, true);
    end
end

hook_coins_behavior(id_bhvWoodenPost, false, nil, bhv_wooden_post_loop)

---@param o Object
local function bhv_exclamation_box_edit_contents(o)
    local m = nearest_mario_state_to_object(o)
    if m and mario_master_cap_active(m) then
        -- Edit contents to 10 coins if box is a cap
        if o.oBehParams2ndByte < 3 then
            o.oBehParams2ndByte = 6
        end
    end
end

hook_coins_behavior(id_bhvExclamationBox, false, nil, bhv_exclamation_box_edit_contents)

---@param o Object
local function bhv_kickable_board_coins_init(o)
    o.oCustomCoins = 5
end

---@param o Object
local function bhv_kickable_board_coins_loop(o)
    if o.oAction == 3 and o.oCustomCoins > 0 then
        spawn_coin_spawner(o, o.oCustomCoins, false, sins(o.oMoveAngleYaw + 0x8000)*o.hitboxHeight, o.hitboxRadius, coss(o.oMoveAngleYaw + 0x8000)*o.hitboxHeight)
        o.oCustomCoins = 0
    end
end


hook_coins_behavior(id_bhvKickableBoard, false, bhv_kickable_board_coins_init, bhv_kickable_board_coins_loop)

-- Boo Coins --
_G.HIDDEN_BLUE_COIN_ACT_CAUGHT = 3
local E_MODEL_BOO_COIN = smlua_model_util_get_id("boo_coin_geo")

function bhv_boo_coin_switch(node, matStackIndex)
    local asSwitchNode = cast_graph_node(node)
    local o = geo_get_current_object()
    local toNode = 0
    
    if o.oAction ~= HIDDEN_BLUE_COIN_ACT_CAUGHT then
        toNode = (1 + math.floor(o.oBooCoinAnimState*0.5)%4 + 4*o.oBooCoinFace)
    end

    asSwitchNode.selectedCase = toNode
end

function bhv_boo_coin_shadow_solidity(node, matStackIndex)
    local asSwitchNode = cast_graph_node(node.next)
    local o = geo_get_current_object()
    
    asSwitchNode.shadowSolidity = o.oOpacity*0.7
end

---@param o Object
local function bhv_ghost_coin_init(o)
    --o.oInteractType = INTERACT_COIN
    o.oFlags = OBJ_FLAG_ACTIVE_FROM_AFAR | OBJ_FLAG_COMPUTE_DIST_TO_MARIO | OBJ_FLAG_UPDATE_GFX_POS_AND_ANGLE
    obj_set_billboard(o)
    o.hitboxRadius = 100
    o.hitboxHeight = 64
    o.oDamageOrCoinValue = 5
    o.oIntangibleTimer = -1
    o.oHealth = 15

    o.oHomeX = o.oPosX
    o.oHomeY = o.oPosY
    o.oHomeZ = o.oPosZ

    o.oIsCarried = 0
    o.oBooCoinFace = math.random(0, 4)

    obj_set_model_extended(o, E_MODEL_BOO_COIN)
    obj_scale(o, 1.3)
end

---@param o Object
local function bhv_ghost_coin_loop(o)
    if o.oAction == HIDDEN_BLUE_COIN_ACT_INACTIVE then
        -- Set action to HIDDEN_BLUE_COIN_ACT_WAITING after the blue coin switch is found.
        o.oHiddenBlueCoinSwitch = cur_obj_nearest_object_with_behavior(get_behavior_from_id(id_bhvBlueCoinSwitch));

        if (o.oHiddenBlueCoinSwitch ~= nil) then
            o.oAction = o.oAction + 1;
        end
        cur_obj_enable_rendering();
        cur_obj_become_tangible();
    elseif o.oAction == HIDDEN_BLUE_COIN_ACT_WAITING then
        -- Wait until the blue coin switch starts ticking to activate.
        local blueCoinSwitch = o.oHiddenBlueCoinSwitch;

        o.oPosX = math.lerp(o.oPosX, o.oHomeX, 0.1)
        o.oPosY = math.lerp(o.oPosY, o.oHomeY, 0.1)
        o.oPosZ = math.lerp(o.oPosZ, o.oHomeZ, 0.1)

        if (blueCoinSwitch and blueCoinSwitch.oAction == BLUE_COIN_SWITCH_ACT_TICKING) then
            o.oAction = o.oAction + 1;
        end

        -- Show blue coins if a Mario is standing on the blue coins switch
        local preview = false
        if (gLevelValues.previewBlueCoins) then
            for i = 0, MAX_PLAYERS - 1 do
                if (gMarioStates[i].marioObj and gMarioStates[i].marioObj.platform == blueCoinSwitch) then
                    preview = true
                    break;
                end
            end
        end

        o.oOpacity = math.clamp(o.oOpacity + (preview and 15 or -10), 0, 150)
    elseif o.oAction == HIDDEN_BLUE_COIN_ACT_ACTIVE then
        local m = nearest_mario_state_to_object(o)
        if not m then return end
        local blueCoinSwitch = o.oHiddenBlueCoinSwitch;

        -- Delete the coin once collected
        if not is_object_being_carried(o) then
            if dist_between_objects(m.marioObj, o) < 400 then
                carry_object_to_mario(m, o)
                play_sound_with_freq_scale(SOUND_OBJ_BOO_LAUGH_LONG, o.header.gfx.cameraToObject, 0.9 + math.random()*0.3)
            end
        end

        o.oOpacity = math.clamp(o.oOpacity + 15, 0, 255)

        if blueCoinSwitch and blueCoinSwitch.activeFlags == ACTIVE_FLAG_DEACTIVATED then
            play_sound_with_freq_scale(SOUND_OBJ_BOO_LAUGH_SHORT, o.header.gfx.cameraToObject, 0.9 + math.random()*0.3)
            o.oAction = o.oAction + 1
        end

        if blueCoinSwitch and blueCoinSwitch.oAction ~= BLUE_COIN_SWITCH_ACT_TICKING then
            stop_object_carry(o)
            o.oAction = HIDDEN_BLUE_COIN_ACT_WAITING
        end

        -- After 200 frames of waiting and 20 2-frame blinks (for 240 frames total),
        -- delete the object.
        --[[
        if (cur_obj_wait_then_blink(200, 20)) then
            if (gLevelValues.respawnBlueCoinsSwitch) then
                o.oAction = HIDDEN_BLUE_COIN_ACT_INACTIVE;
                cur_obj_unhide();
            else
                obj_mark_for_deletion(o);
            end
        end
        ]]
    elseif o.oAction == HIDDEN_BLUE_COIN_ACT_CAUGHT then
        if o.oHealth <= 0 then
            spawn_mist_particles()
            spawn_coin_spawner(o, 5)
            play_sound(SOUND_OBJ_DEFAULT_DEATH, o.header.gfx.cameraToObject)
            
            obj_mark_for_deletion(o)
        else
            o.oHealth = o.oHealth - 1
        end
    end

    o.oIntangibleTimer = -1
    o.oInteractStatus = 0;
    o.oBooCoinAnimState = o.oBooCoinAnimState + 1
end

hook_coins_behavior(id_bhvHiddenBlueCoin, true, bhv_ghost_coin_init, bhv_ghost_coin_loop)

local SEQ_MUSICBOX = smlua_audio_utils_allocate_sequence()
smlua_audio_utils_replace_sequence(SEQ_MUSICBOX, 0x14, 1, "musicbox")

local function bhv_boo_coin_switch_delete(o)

    if o.oAction == BLUE_COIN_SWITCH_ACT_TICKING then
        -- Boo Coin Switch Deletes
        local isActive = false
        local oHiddenBlueCoin = obj_get_first_with_behavior_id(id_bhvHiddenBlueCoin)
        while oHiddenBlueCoin ~= nil do
            if oHiddenBlueCoin.oHiddenBlueCoinSwitch == o and not is_object_being_carried(oHiddenBlueCoin) then
                isActive = true
            end
            oHiddenBlueCoin = obj_get_next_with_same_behavior_id(oHiddenBlueCoin)
        end
        if not isActive then
            obj_mark_for_deletion(o)
        end
    end

    local distanceToLocalPlayer = gMarioStates[0].marioObj and dist_between_objects(o, gMarioStates[0].marioObj) or 10000;
    if (distanceToLocalPlayer < 500.0 and o.oAction ~= BLUE_COIN_SWITCH_ACT_TICKING) then
        play_secondary_music(SEQ_MUSICBOX, 0, 255, 1000);
        o.oBooCoinSwitchMusic = 1;
    elseif (o.oBooCoinSwitchMusic == 1) then
        o.oBooCoinSwitchMusic = 0;
        stop_secondary_music(50);
    end
end

hook_coins_behavior(id_bhvBlueCoinSwitch, false, nil, bhv_boo_coin_switch_delete)

local function coin_star_no_ceiling_clip(o)
    local ceilHeight = find_ceil_height(o.oPosX, o.oPosY, o.oPosZ)
    o.oPosY = math.min(o.oPosY + o.hitboxHeight, ceilHeight) - o.hitboxHeight
end

hook_coins_behavior(id_bhvSpawnedStarNoLevelExit, false, nil, coin_star_no_ceiling_clip)

local towerRelX = -300
local towerRelZ = -400
local function bhv_offset_tower(o, o2bhvID)
    bhv_merged_acts_move(o, towerRelX, 0, towerRelZ)
    if o2bhvID then
        local o2 = obj_get_nearest_object_with_behavior_id(o, o2bhvID)
        if o2 then
            bhv_merged_acts_move(o2, towerRelX, 0, towerRelZ)
        end
    end
end

local function update_collision(o)
    load_object_collision_model()
end

hook_coins_behavior(id_bhvTower, false, function(o)
    bhv_offset_tower(o, id_bhvStar)
end)
hook_coins_behavior(id_bhvTowerDoor, false, function(o)
    bhv_offset_tower(o, id_bhv1Up)
end, update_collision)
hook_coins_behavior(id_bhvWfSolidTowerPlatform, false, bhv_offset_tower, update_collision)
hook_coins_behavior(id_bhvWfSlidingTowerPlatform, false, bhv_offset_tower, update_collision)
hook_coins_behavior(id_bhvWfElevatorTowerPlatform, false, bhv_offset_tower, update_collision)