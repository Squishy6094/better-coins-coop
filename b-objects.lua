---@class Object
---@field oIsCarried integer
define_custom_obj_fields({
    oIsCarried = "u32"
})


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

    local masterCapStall = master_cap_box_active() and get_level_timer() < 90
    if m.action & ACT_FLAG_INTANGIBLE ~= 0 or masterCapStall then
        local total, curr = count_carrier_objects(o)
        local angle = 0x10000*((curr - 1)/total) + get_global_timer()*0x200
        targetPos.x = targetPos.x + sins(angle)*250
        targetPos.z = targetPos.z + coss(angle)*250
        o.oForwardVel = math.min(o.oForwardVel, carrierMax)
        o.parentObj.oTimer = o.parentObj.oTimer - 1
        o.oAction = 1
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

    if o.oPosY < (m.waterLevel or -0x8000) then
        o.oForwardVel = math.min(o.oForwardVel + 0.5, carrierMax*0.5)
    else
        o.oForwardVel = math.min(o.oForwardVel + 1, carrierMax)
    end

    -- Update Parent Obj
    o.parentObj.oPosX = o.oPosX
    o.parentObj.oPosY = o.oPosY
    o.parentObj.oPosZ = o.oPosZ
    o.parentObj.oVelX = approach_f32(o.oVelX, 0, 1, 1)
    o.parentObj.oVelY = approach_f32(o.oVelY, -o.parentObj.oGravity, 1, 1)
    o.parentObj.oVelZ = approach_f32(o.oVelZ, 0, 1, 1)
end

local id_bhvCoinCarry = hook_behavior(nil, OBJ_LIST_LEVEL, true, bhv_coin_carry_init, bhv_coin_carry_loop, "bhvCoinCarry")

--- @param m MarioState
--- @param o Object
function carry_object_to_mario(m, o)
    local gIndex = network_global_index_from_local(m.playerIndex)
    local spawn_func = o.oSyncID ~= 0 and spawn_sync_object or spawn_non_sync_object
    o.oIsCarried = 1
    --- @param oCarry Object
    return spawn_func(id_bhvCoinCarry, E_MODEL_NONE, o.oPosX, o.oPosY, o.oPosZ, function(oCarry)
        oCarry.globalPlayerIndex = gIndex
        oCarry.parentObj = o
    end)
end

function is_object_being_carried(o)
    return o.oIsCarried ~= 0
end

function count_carrier_objects(oTarget)
    local totalCount = 0
    local objCount = 0
    local oCarry = obj_get_first_with_behavior_id(id_bhvCoinCarry)
    while oCarry ~= nil do
        totalCount = totalCount + 1
        if oTarget == oCarry then
            objCount = totalCount
        end

        oCarry = obj_get_next_with_same_behavior_id(oCarry)
    end
    return totalCount, objCount
end

--- @param o Object
local function coin_spawner_init(o)
    network_init_object(o, false, {
        "oCustomCoins",
    })
end

--- @param o Object
local function coin_spawner_loop(o)
    if o.oCustomCoins > 0 then
        local m = nearest_mario_state_to_object(o)
        if m and m.playerIndex == 0 then
            if o.oCustomCoins >= 5 and o.oAction == 0 and (math.random() > 0.25 or o.oCustomCoins == 5) then
                o.oNumLootCoins = 5
                cur_obj_spawn_loot_blue_coin();
                o.oCustomCoins = o.oCustomCoins - 5
                network_send_object(o, false)
            else
                o.oNumLootCoins = 1
                obj_spawn_yellow_coins(o, 1);
                o.oCustomCoins = o.oCustomCoins - 1
                network_send_object(o, false)
            end
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

        if obj_get_first_with_behavior_id(id_bhvBooWithCage) ~= nil then
            booCount = booCount + 1
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
            spawn_coin_spawner(o, 241)
            gGlobalSyncTable.courtyardSecretSolved = true
            obj_mark_for_deletion(o)
        end
    end
    o.oBehParams2ndByte = math.max(o.oBehParams2ndByte, o.oBehParams)
end

id_bhvCourtyardCondition = hook_behavior(nil, OBJ_LIST_SPAWNER, true, courtyard_condition_init, courtyard_condition_loop, "bhvCourtyardCondition")

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