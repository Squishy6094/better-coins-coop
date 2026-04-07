--- @param o Object
local function bhv_coin_carry_init(o)
    o.oFlags = o.oFlags | OBJ_FLAG_UPDATE_GFX_POS_AND_ANGLE | OBJ_FLAG_COMPUTE_DIST_TO_MARIO
    network_init_object(o, true, {})
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
function carry_object_to_mario(m, o)
    local gIndex = network_global_index_from_local(m.playerIndex)
    --- @param oCarry Object
    return spawn_sync_object(id_bhvCoinCarry, E_MODEL_NONE, o.oPosX, o.oPosY, o.oPosZ, function(oCarry)
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
