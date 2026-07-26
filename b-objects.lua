

--- @param m MarioState
--- @param o Object
--- @return boolean
local function obj_can_interact_with_mario(m, o)
    if not o or o.activeFlags == ACTIVE_FLAG_DEACTIVATED then return true end
    if m.action & ACT_FLAG_INTANGIBLE ~= 0 then return false end
    if o.oIntangibleTimer ~= 0 then return false end
    if master_cap_box_active() and get_level_timer() < 90 then return false end
    return true
end

--- @param o Object
local function bhv_coin_carry_init(o)
    o.oFlags = o.oFlags | OBJ_FLAG_UPDATE_GFX_POS_AND_ANGLE | OBJ_FLAG_COMPUTE_DIST_TO_MARIO
    o.oBobombFuseTimer = 90
    network_init_object(o, true, {})
end

local carrierMax = 30

--- @param o Object
local function bhv_coin_carry_loop(o)
    cur_obj_hide()
    if o.parentObj.oIsCarried == 0 then
        obj_mark_for_deletion(o)
        return
    end
    if o.globalPlayerIndex == MAX_PLAYERS then return end
    if o.parentObj.activeFlags == ACTIVE_FLAG_DEACTIVATED then
        network_send_object(o.parentObj, true)
        obj_mark_for_deletion(o)
        return
    end
    local m = gMarioStates[network_local_index_from_global(o.globalPlayerIndex)]
    if is_player_active(m) == 0 and o.parentObj.oSyncID ~= 0 then 
        m = nearest_mario_state_to_object(o)
        o.globalPlayerIndex = network_global_index_from_local(m.playerIndex)
        o.oForwardVel = 0
    end


    local velLerp = math.clamp(o.oForwardVel/carrierMax, 0, 1)
    local targetPos = {
        x = m.pos.x + m.vel.x*velLerp,
        y = m.pos.y + (m.action & ACT_FLAG_AIR ~= 0 and m.vel.y*velLerp or 0) + 70,
        z = m.pos.z + m.vel.z*velLerp,
    }

    -- Make objs circle mario when uninteractable
    if not obj_can_interact_with_mario(m, o.parentObj) then
        local total, curr = count_carrier_objects(m, o)
        local angle = 0x10000*((curr - 1)/total) + get_global_timer()*0x200
        targetPos.x = targetPos.x + sins(angle)*250
        targetPos.z = targetPos.z + coss(angle)*250
        o.oForwardVel = math.min(o.oForwardVel, carrierMax)
        o.parentObj.oTimer = o.parentObj.oTimer - 1
        o.oAction = 1
        velLerp = math.min(velLerp, 0.99)
    else
        if o.oAction == 1 then
            velLerp = 0
            o.oForwardVel = 0
            o.oAction = 0
        end
    end

    o.oPosX = math.lerp(o.oPosX + o.parentObj.oVelX, targetPos.x, velLerp)
    o.oPosY = math.lerp(o.oPosY + o.parentObj.oVelY, targetPos.y, velLerp)
    o.oPosZ = math.lerp(o.oPosZ + o.parentObj.oVelZ, targetPos.z, velLerp)

    -- Remove duplicate coins being stuck on other players
    if m.playerIndex ~= 0 and obj_check_hitbox_overlap(o.parentObj, m.marioObj) then
        if interact_coin(m, INTERACT_COIN, o.parentObj) == 0 then
            obj_mark_for_deletion(o.parentObj)
        end
    end

    if o.oPosY < (m.waterLevel or -0x8000) then
        o.oForwardVel = math.min(o.oForwardVel + 0.5, carrierMax*0.5)
    else
        o.oForwardVel = math.min(o.oForwardVel + 1, carrierMax)
    end

    -- Update Parent Obj
    o.parentObj.oPosX = o.oPosX
    o.parentObj.oPosY = o.oPosY
    o.parentObj.oPosZ = o.oPosZ
    --o.parentObj.oHomeX = o.oPosX
    --o.parentObj.oHomeY = o.oPosY
    --o.parentObj.oHomeZ = o.oPosZ
    o.parentObj.oVelX = approach_f32(o.oVelX, 0, 1, 1)
    o.parentObj.oVelY = approach_f32(o.oVelY, -o.parentObj.oGravity, 1, 1)
    o.parentObj.oVelZ = approach_f32(o.oVelZ, 0, 1, 1)
end

local id_bhvCoinCarry = hook_behavior(nil, OBJ_LIST_LEVEL, true, bhv_coin_carry_init, bhv_coin_carry_loop, "bhvCoinCarry")

--- @param m MarioState
--- @param o Object
function carry_object_to_mario(m, o)
    if o.oIsCarried ~= 0 then return end
    local gIndex = network_global_index_from_local(m.playerIndex)
    local spawn_func = o.oSyncID ~= 0 and spawn_sync_object or spawn_non_sync_object
    o.oIsCarried = 1
    --- @param oCarry Object
    return spawn_func(id_bhvCoinCarry, E_MODEL_NONE, o.oPosX, o.oPosY, o.oPosZ, function(oCarry)
        oCarry.globalPlayerIndex = gIndex
        oCarry.parentObj = o
    end)
end

function stop_object_carry(o)
    if o.oIsCarried == 0 then return end
    o.oIsCarried = 0
end

function is_object_being_carried(o)
    return o.oIsCarried ~= 0
end

function count_carrier_objects(marioTarget, oTarget)
    local totalCount = 0
    local objCount = 0
    local oCarry = obj_get_first_with_behavior_id(id_bhvCoinCarry)
    while oCarry ~= nil do
        if oCarry.globalPlayerIndex == network_global_index_from_local(marioTarget.playerIndex) and not obj_can_interact_with_mario(marioTarget, oCarry.parentObj) then
            totalCount = totalCount + 1
            if oTarget == oCarry then
                objCount = totalCount
            end
        end

        oCarry = obj_get_next_with_same_behavior_id(oCarry)
    end
    return totalCount, objCount
end

--- @param o Object
local function coin_spawner_init(o)
    network_init_object(o, false, {
        "oCustomCoins",
        "oAction",
    })
end



--- @param o Object
local function coin_spawner_loop(o)
    if o.oCustomCoins > 0 then
        local m = nearest_mario_state_to_object(o)
        local isNearest = (m and m.playerIndex == 0)
        if o.oCustomCoins >= 5 and o.oAction == 0 and (random_float() > 0.25 or o.oCustomCoins == 5) then
            o.oNumLootCoins = 5
            cur_obj_spawn_loot_blue_coin();
            o.oCustomCoins = o.oCustomCoins - 5
            network_send_object(o, true)
        else
            o.oNumLootCoins = 1
            obj_spawn_yellow_coins(o, 1);
            o.oCustomCoins = o.oCustomCoins - 1
            network_send_object(o, true)
        end
    else
        obj_mark_for_deletion(o)
        network_send_object(o, true)
    end
end

local id_bhvCoinSpawner = hook_behavior(nil, OBJ_LIST_SPAWNER, true, coin_spawner_init, coin_spawner_loop, "bhvCoinSpawner")

---@param o Object?
---@param coins integer
---@param forceYellow boolean?
---@param rX integer?
---@param rY integer?
---@param rZ integer?
---@return Object?
function spawn_coin_spawner(o, coins, forceYellow, rX, rY, rZ)
    if coins < 1 then return end
    rX = rX or 0
    rY = rY or 0
    rZ = rZ or 0
    if o then
        --if not sync_object_is_owned_locally(o.oSyncID) then return end
        local m = nearest_mario_state_to_object(o)
        if not m or m.playerIndex ~= 0 then return end
        rX = rX + o.oPosX
        rY = rY + o.oPosY
        rZ = rZ + o.oPosZ
    else
        local m = nearest_mario_state_to_pos(rX, rY, rZ)
        if not m or m.playerIndex ~= 0 then return end
    end
    --- @param oCoins Object
    return spawn_sync_object(id_bhvCoinSpawner, E_MODEL_NONE, rX, rY, rZ, function(oCoins)
        oCoins.oCustomCoins = coins
        oCoins.oAction = forceYellow and 1 or 0
    end)
end


--- @param o Object
local function courtyard_condition_init(o)
    o.oBehParams = 1
    o.oBehParams2ndByte = 1
    o.oAction = 0
end

--- @param o Object
local function courtyard_condition_loop(o)
    if o.oAction == 0 then
        local oBoo = obj_get_first_with_behavior_id(id_bhvGhostHuntBoo)
        local booCount = 0
        while oBoo ~= nil do
            booCount = booCount + 1
            oBoo = obj_get_next_with_same_behavior_id(oBoo)
        end

        if booCount < o.oBehParams and o.oTimer > 30 then
            o.oBehParams = o.oBehParams - 1
            if o.oBehParams > 0 then
                spawn_orange_number(o.oBehParams, 0, 10, 0)
                play_sound_with_freq_scale(SOUND_MENU_COLLECT_SECRET, gGlobalSoundSource, 1 + (o.oBehParams2ndByte - o.oBehParams)/o.oBehParams2ndByte*0.5)
            else
                o.oAction = o.oAction + 1
            end
            o.oTimer = 0
        end

        o.oBehParams = math.max(booCount, o.oBehParams)
    elseif o.oAction == 1 then
        play_puzzle_jingle()
        o.oAction = o.oAction + 1     
    else
        if o.oTimer > 60 then
            spawn_coin_spawner(o, 241 - gMarioStates[0].numCoins)
            gGlobalSyncTable.courtyardSecretSolved = true
            obj_mark_for_deletion(o)
        end
    end
    o.oBehParams2ndByte = math.max(o.oBehParams2ndByte, o.oBehParams)
end

id_bhvCourtyardCondition = hook_behavior(nil, OBJ_LIST_SPAWNER, true, courtyard_condition_init, courtyard_condition_loop, "bhvCourtyardCondition")

-- Master Cap Objects

function bhv_master_cap_bubble_player_loop(o)
    if (o.heldByPlayerIndex >= MAX_PLAYERS) then return end
    o.oFlags = OBJ_FLAG_UPDATE_GFX_POS_AND_ANGLE
    local marioState = gMarioStates[o.heldByPlayerIndex];
    if (not marioState) then return end

    -- set position
    o.oPosX = marioState.pos.x;
    o.oPosY = marioState.pos.y + 35;
    o.oPosZ = marioState.pos.z;

    -- slowly rotate the bubble
    o.oFaceAnglePitch = o.oFaceAnglePitch + 300;
    o.oFaceAngleYaw = o.oFaceAngleYaw + 230;
    o.oFaceAngleRoll = o.oFaceAngleRoll + 170;

    -- scale the bubble
    local scale = sins(get_global_timer() * 800) * 0.1 + 1.4;
    o.header.gfx.scale.x = scale;
    o.header.gfx.scale.y = sins(get_global_timer() * 1500) * 0.2 + scale;
    o.header.gfx.scale.z = scale;

    -- check if the bubble popped
    if (marioState.action ~= ACT_MASTER_CAP_BUBBLED or is_player_in_local_area(marioState) == 0) then
        spawn_mist_particles();
        create_sound_spawner(SOUND_OBJ_DIVING_IN_WATER);
        marioState.bubbleObj = nil;
        obj_mark_for_deletion(o);
    end
end

id_bhvMasterCapBubblePlayer = hook_behavior(nil, OBJ_LIST_SPAWNER, true, nil, bhv_master_cap_bubble_player_loop, "bhvMasterCapBubblePlayer")

E_MODEL_SCARECROW = smlua_model_util_get_id("mc_scarecrow_geo")
E_MODEL_SCARECROW_HEAD = smlua_model_util_get_id("mc_scarecrow_decap_head_geo")

function bhv_scarecrow_head_switch(node, matStackIndex)
    local asSwitchNode = cast_graph_node(node)
    local o = geo_get_current_object()
    local toNode = 0

    toNode = o.oHealth > 0 and 0 or 1

    asSwitchNode.selectedCase = toNode
end

---@param o Object
local function bhv_scarecrow_init(o)
    o.oFlags = OBJ_FLAG_UPDATE_GFX_POS_AND_ANGLE
    o.oHealth = 1
    o.oGravity = 5
    o.oBuoyancy = 1.3
    o.oHomeX = o.oPosX
    o.oHomeY = o.oPosY
    o.oHomeZ = o.oPosZ

    o.header.gfx.animInfo.animFrame = 0
    o.header.gfx.animInfo.animTimer = 0

    local objHitbox = get_temp_object_hitbox()
    objHitbox.hurtboxRadius = 80
    objHitbox.hurtboxHeight = 180
    objHitbox.radius = 80
    objHitbox.height = 180
    objHitbox.health = 1
    obj_set_hitbox(o, objHitbox)
    play_sound_with_freq_scale(SOUND_MENU_EXIT_PIPE, o.header.gfx.cameraToObject, 1.5)
    cur_obj_disable_rendering()

    network_init_object(o, true, {
        "oMoveAngleYaw",
    })
end

---@param o Object
local function bhv_scarecrow_loop(o)
    local startAction = o.oAction
    local step = object_step()

    local floorHeight, floor = find_floor(o.oPosX + o.oVelX, o.oPosY + 50, o.oPosZ + o.oVelZ)
    local m = nearest_mario_state_to_object(o)
    local dist = math.sqrt((o.oPosX - m.pos.x)^2 + (o.oPosY - m.pos.y)^2 + (o.oPosZ - m.pos.z)^2)

    if o.oAction == 0 then -- Spawn Animation
        cur_obj_enable_rendering()
        smlua_anim_util_set_animation(o, ANIM_SCARECROW_SPAWN)
        o.oFaceAngleYaw = atan2s(o.oPosZ - m.pos.z, o.oPosX - m.pos.x) + 0x8000
        if cur_obj_check_if_at_animation_end() ~= 0 then
            o.oAction = 1
        end
    elseif o.oAction == 1 then -- Idle action
        smlua_anim_util_set_animation(o, ANIM_SCARECROW_IDLE)
        if dist < 2000 then
            o.oAction = 2
        end
    elseif o.oAction == 2 then -- Bounce Away from Mario
        if o.oHealth > 0 then
            o.oFaceAngleYaw = atan2s(o.oPosZ - m.pos.z, o.oPosX - m.pos.x) + 0x8000
        end
        if step & (OBJ_COL_FLAG_GROUNDED | OBJ_COL_FLAG_HIT_WALL) ~= 0 and o.oHealth > 0 then
            local isOnFloor = step & OBJ_COL_FLAG_GROUNDED ~= 0
            o.oForwardVel = find_water_level(o.oPosX, o.oPosZ) - 30 < o.oPosY and 30 or 15
            o.header.gfx.animInfo.animFrame = 0
            o.header.gfx.animInfo.animTimer = 0
            smlua_anim_util_set_animation(o, ANIM_SCARECROW_BOUNCE)
            local bounceRng = random_float() > 0.5
            local baitRng = isOnFloor and dist < 500 and m.forwardVel > 30 and random_float() > 0.66
            if not baitRng then
                o.oVelY = 50
                play_sound(bounceRng and SOUND_GENERAL_BOING1 or SOUND_GENERAL_BOING2, o.header.gfx.cameraToObject)
                if floor and floor.normal.y < 0.9 then
                    o.oMoveAngleYaw = atan2s(floor.normal.z, floor.normal.x)
                elseif isOnFloor then
                    o.oMoveAngleYaw = math.round(atan2s(o.oPosZ - m.pos.z, o.oPosX - m.pos.x)/0x4000)*0x4000 + (bounceRng and 0x2000 or -0x2000)
                    for i = 0, 7 do
                        local targetAngle = o.oMoveAngleYaw + 0x2000*i
                        local floorHeight, floor = find_floor(o.oPosX + sins(targetAngle)*600, o.oPosY + 500, o.oPosZ + coss(targetAngle)*600)
                        if floor and floor.normal.y > 0.9 and math.abs(floorHeight - o.oPosY) < 300 then
                            o.oMoveAngleYaw = targetAngle
                            break
                        end
                    end
                end
            else
                o.oVelY = 80
                play_sound_with_freq_scale(SOUND_GENERAL_BOING1, o.header.gfx.cameraToObject, 0.8)
                o.oMoveAngleYaw = lerp_s16(atan2s(o.oPosZ - m.pos.z, o.oPosX - m.pos.x), m.faceAngle.y, 0.5) + 0x8000
            end
        end

        if dist > 4000 then
            o.oAction = 1
        end
    elseif o.oAction == 3 then -- Fall over when hit
        smlua_anim_util_set_animation(o, ANIM_SCARECROW_FALL_BACKWARDS)
        if cur_obj_check_if_at_animation_end() == 0 then
            o.oTimer = 0
        end
        if o.oTimer > 15 then
            obj_mark_for_deletion(o)
            spawn_mist_particles()
        end
    end

    if o.oHealth > 0 and obj_check_hitbox_overlap(o, m.marioObj) and determine_interaction(m, o) ~= 0 then
        o.oHealth = 0
        play_sound(SOUND_ACTION_UNSTUCK_FROM_GROUND, o.header.gfx.cameraToObject)
        --spawn_coin_spawner(o, 25, false, 0, 200, 0)
        if sync_object_is_owned_locally(o.oSyncID) then
            spawn_sync_object(id_bhvMasterCapScarecrowHead, E_MODEL_SCARECROW_HEAD, o.oPosX, o.oPosY + 100, o.oPosZ, function (oHead)
                oHead.oMoveAngleYaw = lerp_s16(o.oMoveAngleYaw, atan2s(m.vel.z, m.vel.x), 0.5)
                oHead.oFaceAngleYaw = oHead.oMoveAngleYaw + 0x8000
                o.oVelY = m.vel.y
            end)
        end
    end

    if step & OBJ_COL_FLAG_GROUNDED ~= 0 then
        if o.oHealth == 0 then
            o.oAction = 3
            return
        elseif not m then
            o.oAction = 1
        end
    end

    if startAction ~= o.oAction then
        o.header.gfx.animInfo.animFrame = 0
        o.header.gfx.animInfo.animTimer = 0
        obj_anim_skip_interpolation(o)
    end
end

id_bhvMasterCapScarecrow = hook_behavior(nil, OBJ_LIST_DEFAULT, true, bhv_scarecrow_init, bhv_scarecrow_loop, "id_bhvMasterCapScarecrow")

local function bhv_scarecrow_head_init(o)
    o.oFlags = OBJ_FLAG_UPDATE_GFX_POS_AND_ANGLE
    o.oGravity = 4
    o.oVelY = o.oVelY + 60
    network_init_object(o, true, {
        "oMoveAngleYaw",
    })
end

local function bhv_scarecrow_head_loop(o)
    local step = object_step_without_floor_orient()
    o.oForwardVel = 60
    o.oFaceAnglePitch = o.oFaceAnglePitch + 0x800
    if o.oVelY < -40 or step & OBJ_COL_FLAG_GROUNDED ~= 0 then
        play_sound(SOUND_GENERAL_DONUT_PLATFORM_EXPLOSION, o.header.gfx.cameraToObject)
        spawn_coin_spawner(o, 25, true)
        spawn_mist_particles()
        obj_mark_for_deletion(o)
    end
end

id_bhvMasterCapScarecrowHead = hook_behavior(nil, OBJ_LIST_DEFAULT, true, bhv_scarecrow_head_init, bhv_scarecrow_head_loop, "id_bhvMasterCapScarecrow")