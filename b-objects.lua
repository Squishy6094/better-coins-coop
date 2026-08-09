

--- @param m MarioState
--- @param o Object
--- @return boolean
local function obj_can_interact_with_mario(m, o)
    if not o or o.activeFlags == ACTIVE_FLAG_DEACTIVATED then return true end
    if m.action & ACT_FLAG_INTANGIBLE ~= 0 then return false end
    if o.oIntangibleTimer ~= 0 then return false end
    if master_cap_box_active() and get_level_timer() < 150 then return false end
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

local sCourtyardSecretSolved = false

--- @param o Object
local function courtyard_condition_init(o)
    o.oBehParams = 1
    o.oBehParams2ndByte = 1
    o.oAction = 0
end

--- @param o Object
local function courtyard_condition_loop(o)
    if sCourtyardSecretSolved then
        obj_mark_for_deletion(o)
        return
    end
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
            sCourtyardSecretSolved = true
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
    o.oBuoyancy = 0
    o.oHomeX = o.oPosX
    o.oHomeY = o.oPosY
    o.oHomeZ = o.oPosZ
    o.oScarecrowLastY = o.oPosY

    o.header.gfx.animInfo.animFrame = 0
    o.header.gfx.animInfo.animTimer = 0

    local objHitbox = get_temp_object_hitbox()
    objHitbox.hurtboxRadius = 80
    objHitbox.hurtboxHeight = 200
    objHitbox.radius = 80
    objHitbox.height = 200
    objHitbox.health = 1
    obj_set_hitbox(o, objHitbox)
    play_sound_with_freq_scale(SOUND_MENU_EXIT_PIPE, o.header.gfx.cameraToObject, 1.5)
    cur_obj_disable_rendering()

    network_init_object(o, true, {
        "oMoveAngleYaw",
        "oHealth",
        "oPosX",
        "oPosY",
        "oPosZ",
        "oVelX",
        "oVelY",
        "oVelZ",
    })
end

---@param o Object
local function bhv_scarecrow_loop(o)
    local startAction = o.oAction
    local startForwardVel = o.oForwardVel
    local startYVel = o.oVelY
    local step = object_step_without_floor_orient()
    o.oFloorHeight, o.oFloor = find_floor(o.oPosX + o.oVelX, o.oPosY, o.oPosZ + o.oVelZ)

    -- Remove effects of being underwater
    local isInWater = step & OBJ_COL_FLAG_UNDERWATER ~= 0
    if isInWater then
        o.oForwardVel = startForwardVel
        o.oVelY = startYVel - o.oGravity*0.8
    end

    local m = nearest_mario_state_to_object(o)
    local dist = math.sqrt((o.oPosX - m.pos.x)^2 + (o.oPosY - m.pos.y)^2 + (o.oPosZ - m.pos.z)^2)

    if o.oAction ~= 3 and o.oPosY < o.oFloorHeight + 10 then
        obj_check_floor_death(step, o.oFloor)
    end

    local deathPlaneKill = (o.oAction == OBJ_ACT_DEATH_PLANE_DEATH or o.oAction == OBJ_ACT_LAVA_DEATH or not o.oFloor)
    if o.oHealth > 0 and ((obj_check_hitbox_overlap(o, m.marioObj) and (determine_interaction(m, o) ~= 0 or isInWater)) or deathPlaneKill) then
        o.oHealth = 0
        if deathPlaneKill then
            o.oAction = 3
        end
        play_sound(SOUND_ACTION_UNSTUCK_FROM_GROUND, o.header.gfx.cameraToObject)
        --spawn_coin_spawner(o, 25, false, 0, 200, 0)
        if sync_object_is_owned_locally(o.oSyncID) then
            ---@param oHead Object 
            spawn_sync_object(id_bhvMasterCapScarecrowHead, E_MODEL_SCARECROW_HEAD, o.oPosX, o.oPosY + 100, o.oPosZ, function (oHead)
                local floorDifVel = math.max(0, math.sqrt(2 * 4 * (o.oScarecrowLastY - o.oPosY)) - 50)
                oHead.oMoveAngleYaw = (deathPlaneKill and o.oMoveAngleYaw + 0x8000 or lerp_s16(o.oMoveAngleYaw, atan2s(m.vel.z, m.vel.x), 0.5))
                oHead.oFaceAngleYaw = oHead.oMoveAngleYaw + 0x8000
                oHead.oVelY = floorDifVel + (deathPlaneKill and 0 or math.max(m.vel.y, 0))
                oHead.oForwardVel = 30 + (deathPlaneKill and -1 or m.forwardVel)
            end)
        end
        network_send_object(o, true)
    end

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
        o.oForwardVel = isInWater and 15 or 35
        if step & (OBJ_COL_FLAG_GROUNDED | OBJ_COL_FLAG_HIT_WALL) ~= 0 and o.oHealth > 0 then
            local isOnFloor = step & OBJ_COL_FLAG_GROUNDED ~= 0
            o.header.gfx.animInfo.animFrame = 0
            o.header.gfx.animInfo.animTimer = 0
            smlua_anim_util_set_animation(o, ANIM_SCARECROW_BOUNCE)
            local bounceRng = random_float() > 0.5
            local baitRng = isOnFloor and dist < 500 and m.forwardVel > 30 and random_float() < 0.2
            if not baitRng then
                o.oVelY = (isOnFloor and random_float() < 0.2) and 35 or 55
                play_sound(bounceRng and SOUND_GENERAL_BOING1 or SOUND_GENERAL_BOING2, o.header.gfx.cameraToObject)
                if isOnFloor then
                    o.oMoveAngleYaw = math.round(atan2s(o.oPosZ - m.pos.z, o.oPosX - m.pos.x)/0x4000)*0x4000 + 0x2000*(bounceRng and 1 or -1)
                    for i = 0, 7 do
                        local targetAngle = o.oMoveAngleYaw + 0x2000*i*(bounceRng and 1 or -1)
                        local angleValid = nil
                        local emulate = {
                            oPosX = o.oPosX,
                            oPosY = o.oPosY,
                            oPosZ = o.oPosZ,
                            oMoveAngle = targetAngle,
                            oVelX = o.oForwardVel*sins(targetAngle),
                            oVelY = o.oVelY,
                            oVelZ = o.oForwardVel*coss(targetAngle),
                            frame = 0
                        }
                        repeat
                            local floorRay = collision_find_surface_on_ray(emulate.oPosX, emulate.oPosY + 100, emulate.oPosZ, 0, -0x8000, 0)
                            local floorHeight, floor = floorRay.hitPos.y, floorRay.surface
                            local velAngle = atan2s(emulate.oVelZ, emulate.oVelX)
                            local velHitboxX = sins(velAngle)*o.hitboxRadius
                            local velHitboxZ = coss(velAngle)*o.hitboxRadius
                            local wall = nil
                            for i = 0, 2 do
                                if not wall or not wall.surface then
                                    wall = collision_find_surface_on_ray(emulate.oPosX, emulate.oPosY + o.hitboxHeight*(i/2), emulate.oPosZ, velHitboxX, 0, velHitboxZ, 128)
                                end
                            end
                            if wall.surface and wall.surface.normal.y == 0 then
                                local nX = wall.surface.normal.x
                                local nZ = wall.surface.normal.z
                                
                                local objYawX = (nZ * nZ - nX * nX) * emulate.oVelX / (nX * nX + nZ * nZ)
                                        - 2 * emulate.oVelZ * (nX * nZ) / (nX * nX + nZ * nZ);

                                local objYawZ = (nX * nX - nZ * nZ) * emulate.oVelZ / (nX * nX + nZ * nZ)
                                        - 2 * emulate.oVelX * (nX * nZ) / (nX * nX + nZ * nZ);
                                emulate.oMoveAngle = atan2s(objYawZ, objYawX);
                                emulate.oVelX = o.oForwardVel*sins(emulate.oMoveAngle)
                                emulate.oVelY = 50
                                emulate.oVelZ = o.oForwardVel*coss(emulate.oMoveAngle)
                            elseif not floor then
                                angleValid = false
                                break
                            end

                            log_to_console(emulate.oPosY .. " - " .. floorHeight)
                            if emulate.oVelY < 0 and emulate.oPosY > floorHeight - math.abs(emulate.oVelY) and emulate.oPosY < floorHeight + math.abs(emulate.oVelY) then
                                if floor.normal.y > 0.825 and not evilFloorTypes[floor.type] and (isInWater or emulate.oPosY > find_water_level(emulate.oPosX, emulate.oPosZ)) then
                                    angleValid = true
                                    break
                                end
                            end
                            --spawn_non_sync_object(id_bhvSparkle, E_MODEL_METALLIC_BALL, emulate.oPosX, emulate.oPosY, emulate.oPosZ, function (o) end)

                            emulate.oPosX = emulate.oPosX + emulate.oVelX
                            emulate.oPosY = emulate.oPosY + emulate.oVelY
                            emulate.oPosZ = emulate.oPosZ + emulate.oVelZ
                            emulate.oVelY = math.clamp(emulate.oVelY - o.oGravity, -75, 75)
                            emulate.frame = emulate.frame + 1
                            if emulate.frame > 5000 then
                                angleValid = false
                            end
                        until angleValid ~= nil

                        if angleValid then
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
            if sync_object_is_owned_locally(o.oSyncID) then
                network_send_object(o, true)
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

    if step & OBJ_COL_FLAG_GROUNDED ~= 0 then
        if o.oHealth == 0 then
            o.oAction = 3
            return
        elseif not m then
            o.oAction = 1
        else
            o.oScarecrowLastY = o.oPosY + 300
        end
    end

    if startAction ~= o.oAction then
        o.header.gfx.animInfo.animFrame = 0
        o.header.gfx.animInfo.animTimer = 0
        obj_anim_skip_interpolation(o)
    end
end

id_bhvMasterCapScarecrow = hook_behavior(nil, OBJ_LIST_DEFAULT, true, bhv_scarecrow_init, bhv_scarecrow_loop, "bhvMasterCapScarecrow")

---@param o Object
local function bhv_scarecrow_head_init(o)
    o.oFlags = OBJ_FLAG_UPDATE_GFX_POS_AND_ANGLE
    o.oGravity = 4
    o.oVelY = o.oVelY + 60
    network_init_object(o, true, {
        "oMoveAngleYaw",
    })
end

---@param o Object
local function bhv_scarecrow_head_loop(o)
    -- Jank workaround to uncapping Y Vel
    local prevVelY = o.oVelY
    o.oVelY = 0
    local step = object_step_without_floor_orient()
    o.oVelY = prevVelY - o.oGravity
    o.oPosY = o.oPosY + o.oVelY

    o.oFaceAnglePitch = o.oFaceAnglePitch + 0x800
    if o.oVelY < -40 or step & OBJ_COL_FLAG_GROUNDED ~= 0 then
        play_sound(SOUND_GENERAL_DONUT_PLATFORM_EXPLOSION, o.header.gfx.cameraToObject)
        spawn_coin_spawner(o, 25, true)
        spawn_mist_particles()
        obj_mark_for_deletion(o)
    end
end

id_bhvMasterCapScarecrowHead = hook_behavior(nil, OBJ_LIST_DEFAULT, true, bhv_scarecrow_head_init, bhv_scarecrow_head_loop, "bhvMasterCapScarecrowHead")

local MASTER_CAP_BOX_SCALE = 3

---@param o Object
local function bhv_master_cap_box_init(o)
    o.oFlags = o.oFlags | OBJ_FLAG_SET_FACE_YAW_TO_MOVE_YAW | OBJ_FLAG_UPDATE_GFX_POS_AND_ANGLE
    o.collisionData = gGlobalObjectCollisionData.exclamation_box_outline_seg8_collision_08025F78
    o.oCollisionDistance = 450

    cur_obj_set_home_once()

    o.oPosY = o.oHomeY + 0x8000
    o.oSubAction = 0

    o.areaTimerType = AREA_TIMER_TYPE_MAXIMUM
    o.areaTimer = 0
    o.areaTimerDuration = 300

    smlua_anim_util_set_animation(o, ANIM_MASTER_CAP_BOX_IDLE)

    network_init_object(o, true, {
        "oExclamationBoxForce",
        "areaTimer",
        "oAction",
        "oSubAction",
    })
end

---@param o Object
local function bhv_master_cap_box_loop(o)
    cur_obj_scale(MASTER_CAP_BOX_SCALE)
    local masterCapHitbox = get_temp_object_hitbox()
    masterCapHitbox.interactType = INTERACT_BREAKABLE
    masterCapHitbox.downOffset = 0
    masterCapHitbox.damageOrCoinValue = 0
    masterCapHitbox.health = 1
    masterCapHitbox.numLootCoins = 0
    masterCapHitbox.radius = 30
    masterCapHitbox.height = 30
    masterCapHitbox.hurtboxRadius = 30
    masterCapHitbox.hurtboxHeight = 30
    obj_set_hitbox(o, masterCapHitbox)
    local nearestM = nearest_mario_state_to_object(o)

    local levelIndex, levelData = master_cap_get_level()
    if not master_cap_allowed() or levelData.runState ~= 0 then
        obj_mark_for_deletion(o)
        return
    end

    if o.oAction == 0 then
        o.oExclamationBoxForce = 0
        o.oAction = 1
    elseif o.oAction == 1 then
        if (o.oTimer == 0) then
            cur_obj_unhide()
            cur_obj_become_tangible()
            o.oInteractStatus = 0
            --o.oPosY = o.oHomeY
            o.oGraphYOffset = 0.0
        end

        o.oPosY = math.lerp(o.oPosY, o.oHomeY + math.sin(o.areaTimer/10)*30, 0.1)
        if hud_get_value(HUD_DISPLAY_COINS) > 0 then
            o.oHomeY = o.oHomeY + o.oVelY
            o.oVelY = math.clamp(o.oVelY + 1, 0, 50)
            o.oSubAction = 1
            o.header.gfx.animInfo.animAccel = 0x10000 + 0x600*o.oVelY
        end

        local isNearest = (nearestM ~= nil and nearestM == gMarioStates[0])
        if (o.oExclamationBoxForce ~= 0 or isNearest) then
            local neicheActs = nearestM.action & ACT_FLAG_SWIMMING_OR_FLYING ~= 0 and dist_between_objects(nearestM.marioObj, o) < o.hitboxRadius*2
            if (o.oExclamationBoxForce ~= 0 or (isNearest and (cur_obj_was_attacked_or_ground_pounded() ~= 0 or neicheActs))) then
                if (o.oExclamationBoxForce == 0) then
                    o.oExclamationBoxForce = 1
                    network_send_object(o, true)
                    o.oExclamationBoxForce = 0
                end
                o.oExclamationBoxUnkFC = 0x4000
                o.oVelY = 30.0
                o.oGravity = -8.0
                o.oFloorHeight = o.oPosY
                o.oAction = 2
                spawn_mist_particles()
                play_sound(SOUND_OBJ_KING_BOBOMB_JUMP, o.header.gfx.cameraToObject)
                queue_rumble_data_object(o, 5, 80)
                cur_obj_become_intangible()
                network_send_object(o, true)
            end
        end
        if nearestM.action & ACT_FLAG_SWIMMING_OR_FLYING == 0 then
            load_object_collision_model()
        end

        if cur_obj_check_if_at_animation_end() ~= 0 then
            play_sound(SOUND_OBJ_BOWSER_SPINNING, o.header.gfx.cameraToObject)
        end
    elseif o.oAction == 2 then
        cur_obj_move_using_fvel_and_gravity()
        if o.oPosY <= o.oHomeY then
            o.oPosY = o.oHomeY
            if o.oVelY < -4.0 then
                o.oVelY = -o.oVelY * 0.35
            else
                o.oVelY = 0.0
                o.oGravity = 0.0
            end
        end

        local t = o.oTimer

        o.oExclamationBoxUnkFC = o.oExclamationBoxUnkFC + 0x1800
        local sin = sins(o.oExclamationBoxUnkFC)
        local cos = coss(o.oExclamationBoxUnkFC)

        local impact = math.max(0, 1 - t / 10)
        local squash = 1.0 - 0.6 * impact * math.abs(sin)
        local stretch = 1.0 + 0.8 * impact * math.abs(sin)

        local increase = 1.0
        if t < 5 then
            increase = 1.0 + 0.35 * (1 - t / 5)
        elseif t < 10 then
            increase = 1.0 + 0.15 * ((t - 5) / 5)
        end

        local bounce = sin * (14.0 * MASTER_CAP_BOX_SCALE) * (0.8 ^ (t / 6))
        o.oGraphYOffset = bounce

        o.oFaceAngleYaw = o.oFaceAngleYaw + 0x900
        o.oFaceAngleRoll = sin * 0x1200 * impact
        o.oFaceAnglePitch = cos * 0x800 * impact

        local scale = MASTER_CAP_BOX_SCALE * increase
        o.header.gfx.scale.x = stretch * scale
        o.header.gfx.scale.y = squash * scale
        o.header.gfx.scale.z = stretch * scale

        if t >= 14 then
            o.oAction = 3
        end
    elseif o.oAction == 3 then
        if sync_object_is_owned_locally(o.oSyncID) ~= 0 then
            master_cap_start_course()
        end
        play_character_sound(gMarioStates[0], CHAR_SOUND_HERE_WE_GO)
        spawn_mist_particles_variable(0, 0, 46.0)
        spawn_triangle_break_particles(20, 139, 0.3, o.oAnimState)
        create_sound_spawner(SOUND_GENERAL_BREAK_BOX)
        cur_obj_hide()
        o.oAction = 4
        o.oSubAction = 2
        network_send_object(o, true)
    end
end

id_bhvMasterCapBox = hook_behavior(id_bhvMasterCapBox, OBJ_LIST_SURFACE, true, bhv_master_cap_box_init, bhv_master_cap_box_loop, "bhvMasterCapBox")