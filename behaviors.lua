local function hook_coins_behavior(id, override, init_f, loop_f)
    hook_behavior(id, get_object_list_from_behavior(get_behavior_from_id(id)), override, init_f, loop_f, "bhvCoins" .. get_behavior_name_from_id(id):sub(4))
end

-- Behaviors

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
    if o.parentObj == nBombomb then
        obj_set_nametag(o.parentObj, "Jim", {r = 50, g = 50, b = 100})
    end
end


---@param o Object
local function bhv_bubble_cannon_explode(o)
    local owner = o.parentObj
    if owner ~= nil and obj_has_behavior_id(owner, id_bhvBobomb) ~= 0 then
        if owner.oAction == BOBOMB_ACT_EXPLODE and owner.oTimer >= 5 then
            obj_remove_nametag(owner)
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
    o.oFishYawVel = o.oMoveAngleYaw
    network_init_object(o, true, {
        "oAction",
        "oPosY",
        "oThwompRandomTimer",
        "oTimer",
        "oVelY",

        "oDorrieGroundPounded",
        "oHealth",
        "oBooOscillationTimer",
    })
end

---@param o Object
local function thwomp_break_loop(o)
    if cur_obj_is_any_player_on_platform() ~= 0 and cur_obj_is_mario_ground_pounding_platform() ~= 0 then
        if (o.oSyncID == 0 or sync_object_is_owned_locally(o.oSyncID)) and o.oDorrieGroundPounded == 0 then
            local m = nearest_mario_state_to_object(o)
            o.oDorrieGroundPounded = 1
            o.oHealth = math.max(o.oHealth - (m.flags & MARIO_METAL_CAP ~= 0 and 3 or 1), 0)
            --djui_chat_message_create(tostring(o.oHealth))
            network_send_object(o, true)
        end
    else
        o.oDorrieGroundPounded = 0
    end
    djui_chat_message_create(tostring(o.oDorrieGroundPounded))


    if o.oHealth > 0 then
        if o.oDorrieGroundPounded == 1 then
            o.oDorrieGroundPounded = 2
            o.oBooOscillationTimer = o.oBooOscillationTimer + 30
            o.oThwompRandomTimer = o.oThwompRandomTimer + 30
            spawn_triangle_break_particles(5, 138, 1.0, 4);
            play_sound_with_freq_scale(SOUND_OBJ_THWOMP, o.header.gfx.cameraToObject, 1 + (5 - o.oHealth)/5*0.3)
        end
    else
        if sync_object_is_owned_locally(o.oSyncID) then
            obj_spawn_yellow_coins(o, 10)
        end
        spawn_triangle_break_particles(20, 138, 3.0, 4);
        play_sound_with_freq_scale(SOUND_OBJ_THWOMP, o.header.gfx.cameraToObject, 0.8)
        obj_mark_for_deletion(o)
    end

    if o.oBooOscillationTimer > 0 then
        o.oMoveAngleYaw = o.oFishYawVel + math.sin(o.oBooOscillationTimer/3)*0x1000*(5 - o.oHealth)/5*o.oBooOscillationTimer/30
        o.oBooOscillationTimer = o.oBooOscillationTimer - 1
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
            obj_spawn_yellow_coins(o, o.oNumLootCoins)
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
        spawn_coin_spawner(o.oPosX, o.oPosY + 100, o.oPosZ, o.oNumLootCoins, true)
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
        spawn_coin_spawner(o.oPosX, o.oPosY, o.oPosZ, 10, true)
    end
end

hook_coins_behavior(id_bhvWfBreakableWallLeft, false, nil, breakable_wall_coins)
hook_coins_behavior(id_bhvWfBreakableWallRight, false, nil, breakable_wall_coins)

---@param o Object
local function bhv_boss_death_coins(o)
    -- Assume going invis means they're dead
    if (o.oSyncDeath ~= 0 or o.header.gfx.node.flags & GRAPH_RENDER_INVISIBLE ~= 0) and o.oCoinUnk110 == 0 then
        spawn_coin_spawner(o.oPosX, o.oPosY, o.oPosZ, 15, true)
        o.oCoinUnk110 = 1
    end
end

hook_coins_behavior(id_bhvKingBobomb, false, nil, bhv_boss_death_coins)
hook_coins_behavior(id_bhvWhompKingBoss, false, nil, bhv_boss_death_coins)
hook_coins_behavior(id_bhvEyerokHand, false, nil, bhv_boss_death_coins)

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
    o.oAnimState = o.oTimer%7
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
    if obj_has_model_extended(o, E_MODEL_1UP) ~= 0 then
        obj_set_model_extended(o, E_MODEL_BLUE_COIN)
    end

    network_init_object(o, true, {})
end

---@param o Object
local function bhv_blue_coin_loop(o)
    cur_obj_enable_rendering();
    cur_obj_become_tangible();

    -- Delete the coin once collected
    if (o.oInteractStatus & INT_STATUS_INTERACTED ~= 0) then
        spawn_non_sync_object(id_bhvGoldenCoinSparkles, E_MODEL_SPARKLES, o.oPosX, o.oPosY, o.oPosZ, function (o) end);
        obj_mark_for_deletion(o);
    end

    o.oAnimState = o.oTimer%7
    o.oInteractStatus = 0;
end

---@param o Object
local function bhv_moving_blue_coin_capped_loop(o)
    bhv_moving_blue_coin_loop()
    if (o.oForwardVel > 40.0) then
        o.oForwardVel = 40.0
    end
    o.oAnimState = o.oTimer%7
end

hook_coins_behavior(id_bhv1Up, true, bhv_blue_coin_init, bhv_blue_coin_loop)
hook_coins_behavior(id_bhv1upWalking, false, nil, bhv_1up_hidden_in_pole_loop)
hook_coins_behavior(id_bhv1upRunningAway, false, nil, bhv_1up_hidden_in_pole_loop)
hook_coins_behavior(id_bhv1upSliding, true, function (o); bhv_blue_coin_init(o); bhv_moving_blue_coin_init() end, bhv_moving_blue_coin_capped_loop)
hook_coins_behavior(id_bhvHidden1up, false, nil, bhv_1up_hidden_in_pole_loop)
hook_coins_behavior(id_bhvHidden1upInPole, false, nil, bhv_1up_hidden_in_pole_loop)

---@param o Object
local function bhv_purple_switch_coins_init(o)
    o.oNumLootCoins = 3
    network_init_object(o, true, {
        "oAction",
        "oTimer",
        "oNumLootCoins",
    })
end

---@param o Object
local function bhv_purple_switch_coins_loop(o)
    if o.oAction == PURPLE_SWITCH_PRESSED and o.oNumLootCoins > 0 then
        spawn_coin_spawner(o.oPosX, o.oPosY, o.oPosZ, o.oNumLootCoins, true)
        o.oNumLootCoins = 0
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
        spawn_coin_spawner(o.oPosX, o.oPosY, o.oPosZ, 15, true)
    end
end

hook_coins_behavior(id_bhvBowserBombExplosion, false, nil, bhv_bowser_bomb_explosion_coins_loop)

---@param o Object
local function bhv_bookend_death_coins(o)
    if o.oNumLootCoins == 0 and o.oMoveFlags & (OBJ_MOVE_MASK_ON_GROUND | OBJ_MOVE_HIT_WALL) ~= 0 then
        spawn_coin_spawner(o.oPosX, o.oPosY, o.oPosZ, 5)
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

        "oCoinUnk110",
        "oMarioBurnTimer",
    })
    o.oMarioBurnTimer = 0
end

---@param o Object
local function bhv_haunted_chair_coin_loop(o)
    local m = nearest_mario_state_to_object(o)
    if o.oAction == 0 or o.oMarioBurnTimer ~= 0 or m == nil then return end
    if m.interactObj == o then
        o.oMarioBurnTimer = 1
        play_sound_with_freq_scale(SOUND_OBJ_BOO_LAUGH_LONG, o.header.gfx.cameraToObject, 0.5)
        if o.oSyncID ~= 0 then
            network_send_object(o, true)
        end
        return
    end
    
    if o.oTimer >= 70 and o.oMoveFlags & (OBJ_MOVE_MASK_ON_GROUND | OBJ_MOVE_HIT_WALL) ~= 0 then
        spawn_coin_spawner(o.oPosX, o.oPosY, o.oPosZ, 2)
        o.oMarioBurnTimer = 1
        if o.oSyncID ~= 0 then
            network_send_object(o, true)
        end
    end
end

hook_coins_behavior(id_bhvHauntedChair, false, bhv_haunted_chair_coin_init, bhv_haunted_chair_coin_loop)

---@param o Object
local function bhv_snowmans_head_coins_init(o)
    o.oNumLootCoins = 15
    network_init_object(o, true, {
        "oAction",
        "oNumLootCoins",
    })
end

---@param o Object
local function bhv_snowmans_head_coins_loop(o)
    if o.oAction == 4 and o.oNumLootCoins > 0 then
        spawn_coin_spawner(o.oPosX, o.oPosY + o.hitboxHeight, o.oPosZ, o.oNumLootCoins, true)
        o.oNumLootCoins = 0
        network_send_object(o, true)
    end
end

hook_coins_behavior(id_bhvSnowmansHead, false, bhv_snowmans_head_coins_init, bhv_snowmans_head_coins_loop)

---@param o Object
local function bhv_water_pillar_init(o)
    o.oNumLootCoins = gLevelValues.numCoinsToLife
end

---@param o Object
local function bhv_water_pillar_loop(o)
    if o.oAction == 4 and o.oNumLootCoins > 0 then
        otherWaterPillar = cur_obj_nearest_object_with_behavior(o.behavior)
        spawn_coin_spawner(o.oPosX, o.oPosY, o.oPosZ, o.oNumLootCoins*0.5, true)
        spawn_coin_spawner(otherWaterPillar.oPosX, otherWaterPillar.oPosY, otherWaterPillar.oPosZ, o.oNumLootCoins*0.5, true)
        o.oNumLootCoins = 0
    end
end

hook_coins_behavior(id_bhvWaterLevelPillar, false, bhv_water_pillar_init, bhv_water_pillar_loop)