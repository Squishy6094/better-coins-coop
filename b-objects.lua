--- @param o Object
local function bhv_coin_carry_init(o)
    o.oFlags = o.oFlags | OBJ_FLAG_UPDATE_GFX_POS_AND_ANGLE | OBJ_FLAG_COMPUTE_DIST_TO_MARIO
    if o.oSyncID ~= 0 then
        network_init_object(o, true, {})
    end
end

--- @param o Object
local function bhv_coin_carry_loop(o)
    if o.globalPlayerIndex == MAX_PLAYERS then return end
    if o.parentObj.activeFlags == ACTIVE_FLAG_DEACTIVATED then
        obj_mark_for_deletion(o)
        return
    end
    local m = gMarioStates[network_local_index_from_global(o.globalPlayerIndex)]
    if is_player_active(m) == 0 and o.parentObj.oSyncID ~= 0 then 
        m = nearest_mario_state_to_object(o)
        o.globalPlayerIndex = network_global_index_from_local(m.playerIndex)
        o.oTimer = 0
    end

    local targetPos = {
        x = m.pos.x,
        y = m.pos.y + 70,
        z = m.pos.z,
    }

    -- Make objs circle mario when uninteractable
    if m.action & ACT_GROUP_CUTSCENE ~= 0 then
        local total, curr = count_carrier_objects(o)
        local angle = 0x10000*((curr - 1)/total) + get_global_timer()*0x200
        targetPos.x = targetPos.x + sins(angle)*250
        targetPos.z = targetPos.z + coss(angle)*250
        o.oTimer = math.min(o.oTimer, 10)
        o.parentObj.oTimer = o.parentObj.oTimer - 1
    end

    o.oPosX = math.lerp(o.oPosX + o.parentObj.oVelX, targetPos.x, math.clamp(o.oTimer^2/800, 0, 1))
    o.oPosY = math.lerp(o.oPosY + o.parentObj.oVelY, targetPos.y, math.clamp(o.oTimer^2/800, 0, 1))
    o.oPosZ = math.lerp(o.oPosZ + o.parentObj.oVelZ, targetPos.z, math.clamp(o.oTimer^2/800, 0, 1))

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
    --- @param oCarry Object
    return spawn_func(id_bhvCoinCarry, E_MODEL_NONE, o.oPosX, o.oPosY, o.oPosZ, function(oCarry)
        oCarry.globalPlayerIndex = gIndex
        oCarry.parentObj = o
    end)
end

function is_object_being_carried(o)
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
            spawn_coin_spawner(o.oPosX, o.oPosY, o.oPosZ, 241)
            gGlobalSyncTable.courtyardSecretSolved = true
            obj_mark_for_deletion(o)
        end
    end
    o.oBehParams2ndByte = math.max(o.oBehParams2ndByte, o.oBehParams)
end

id_bhvCourtyardCondition = hook_behavior(nil, OBJ_LIST_SPAWNER, true, courtyard_condition_init, courtyard_condition_loop, "bhvCourtyardCondition")