local E_MODEL_FLOWER = smlua_model_util_get_id("unused_flower_geo")

local l = gLakituState
local prevMarioGfxPos = {}
for i = 0, MAX_PLAYERS - 1 do
    prevMarioGfxPos[i] = {x = 0, y = 0, z = 0}
end

local function bhv_particle_fire_init(o)
    cur_obj_hide()
    o.oFlags = OBJ_FLAG_UPDATE_GFX_POS_AND_ANGLE | OBJ_FLAG_SET_FACE_ANGLE_TO_MOVE_ANGLE
    obj_set_billboard(o)
end

---@param o Object
local function bhv_particle_fire_loop(o)
    if o.oIntangibleTimer > 0 then
        o.oIntangibleTimer = o.oIntangibleTimer - 1
        o.oTimer = 0
        cur_obj_hide()
        return
    end
    cur_obj_unhide()
    if o.oBehParams == 0 then
        o.oBehParams = 15
    end
    obj_scale(o, (o.oBehParams - o.oTimer)/10)
    --o.oAnimState = o.oAnimState + 1

    o.oPosX = o.oPosX + sins(o.oFaceAngleYaw)*o.oForwardVel + o.oVelX
    o.oPosY = o.oPosY + o.oForwardVel + o.oVelY
    o.oPosZ = o.oPosZ + coss(o.oFaceAngleYaw)*o.oForwardVel + o.oVelZ

    o.oVelX = math.lerp(o.oVelX, 0, 0.1)
    o.oVelY = math.lerp(o.oVelY, 0, 0.1)
    o.oVelZ = math.lerp(o.oVelZ, 0, 0.1)

    if o.oTimer > o.oBehParams then
        obj_mark_for_deletion(o)
    end
end

id_bhvCosmeticFireFoot = hook_behavior(nil, OBJ_LIST_UNIMPORTANT, true, bhv_particle_fire_init, bhv_particle_fire_loop)

---@param o Object
local function bhv_particle_bubble_helmet_init(o)
    o.oFlags = OBJ_FLAG_UPDATE_GFX_POS_AND_ANGLE
    obj_set_billboard(o)
end

---@param o Object
local function bhv_particle_bubble_helmet_loop(o)
    local m = gMarioStates[network_local_index_from_global(o.globalPlayerIndex)] ---@type MarioState
    if not m or is_player_active(m) == 0 then
        obj_mark_for_deletion(o)
        return
    end
    local p = gPlayerSyncTable[m.playerIndex]
    if p.cosmeticActive ~= 2 then
        obj_mark_for_deletion(o)
        return
    end
    obj_scale(o, 3.5)

    local headPos = {x = 0, y = 0, z = 0}
    local headRot = {x = 0, y = 0, z = 0}
    get_mario_anim_part_pos(m, MARIO_ANIM_PART_HEAD, headPos)
    get_mario_anim_part_rot(m, MARIO_ANIM_PART_HEAD, headRot)
    headRot.y = 0
    local headOffset = {x = 0, y = 40, z = 0}
    vec3f_rotate_zxy(headOffset, headRot)
    headOffset.y = headOffset.y - 40

    local camYaw = atan2s(headPos.z - l.pos.z, headPos.x - l.pos.x)
    local camLatDist = math.sqrt((headPos.z - l.pos.z)^2 + (headPos.x - l.pos.x)^2)
    local camPitch = atan2s(camYaw*camLatDist, headPos.y - l.curPos.y)
    local camRot = {x = 0, y = camYaw, z = 0}
    local camOffset = {x = 0, y = 0, z = -80}
    vec3f_rotate_zxy(camOffset, camRot)

    o.oPosX = headPos.x + headOffset.x + camOffset.x + (m.marioObj.header.gfx.pos.x - prevMarioGfxPos[m.playerIndex].x)
    o.oPosY = headPos.y + headOffset.y + camOffset.y + (m.marioObj.header.gfx.pos.y - prevMarioGfxPos[m.playerIndex].y)
    o.oPosZ = headPos.z + headOffset.z + camOffset.z + (m.marioObj.header.gfx.pos.z - prevMarioGfxPos[m.playerIndex].z)
    -- Used for predicting gfx velocity
    prevMarioGfxPos[m.playerIndex].x = m.marioObj.header.gfx.pos.x
    prevMarioGfxPos[m.playerIndex].y = m.marioObj.header.gfx.pos.y
    prevMarioGfxPos[m.playerIndex].z = m.marioObj.header.gfx.pos.z

    o.header.gfx.pos.x = o.oPosX
    o.header.gfx.pos.y = o.oPosY
    o.header.gfx.pos.z = o.oPosZ
end 

id_bhvCosmeticBubbleHelmet = hook_behavior(nil, OBJ_LIST_UNIMPORTANT, true, bhv_particle_bubble_helmet_init, bhv_particle_bubble_helmet_loop)


---@param o Object
local function bhv_particle_flower_init(o)
    o.oFlags = OBJ_FLAG_UPDATE_GFX_POS_AND_ANGLE | OBJ_FLAG_SET_FACE_ANGLE_TO_MOVE_ANGLE
    obj_set_billboard(o)
    cur_obj_scale(0)
    o.oBehParams = math.random(0, 3)
end

---@param o Object
local function bhv_particle_flower_loop(o)
    local m = nearest_mario_state_to_object(o)
    
    o.oAnimState = math.round((get_global_timer())/3 + o.oBehParams)%6
    if o.oAction == 0 then
        cur_obj_scale(o.oTimer/5)
        if o.oTimer > 5 then
            o.oAction = o.oAction + 1
        end
    elseif o.oAction == 1 then
        if not m or is_player_active(m) == 0 then
            o.oAction = o.oAction + 1
            return
        end
        local timerMax = 30
        if obj_to_obj_dist(m.marioObj, o) < 300 and gPlayerSyncTable[m.playerIndex].cosmeticActive == COSMETIC_GARDEN_GROWER then
            timerMax = 90
        end
        if o.oTimer > timerMax then
            o.oAction = o.oAction + 1
        end
    elseif o.oAction == 2 then
        cur_obj_scale((30-o.oTimer)/30)
        if o.oTimer > 30 then
            obj_mark_for_deletion(o)
        end
    end
end

id_bhvCosmeticFlower = hook_behavior(nil, OBJ_LIST_UNIMPORTANT, true, bhv_particle_flower_init, bhv_particle_flower_loop)

cosmeticList = {
    {
        name = "Hot Footed",
        key = "HotFoot",
        desc = "A Cosmetic that causes your\nboots to catch ablaze! This gives\nmovement and impacts a little\nmore spice!",
        hooks = {
            [HOOK_MARIO_UPDATE] = function(m)
                local vel = math.sqrt(m.vel.x^2 + (m.action & ACT_FLAG_AIR ~= 0 and m.vel.y or 0)^2 + m.vel.z^2)
                if vel < 10 then return end
                local flameModel = vel > (80 + 20*random_float()) and E_MODEL_BLUE_FLAME or E_MODEL_RED_FLAME
                spawn_non_sync_object(id_bhvCosmeticFireFoot, flameModel, 
                    get_hand_foot_pos_x(m, 2) + m.vel.x,
                    get_hand_foot_pos_y(m, 2) + m.vel.y,
                    get_hand_foot_pos_z(m, 2) + m.vel.z, 
                function(o)
                    o.oForwardVel = 5 + random_float()*2
                    o.oMoveAngleYaw = m.faceAngle.y - 0x4000 - 0x2000*random_float()
                end)

                spawn_non_sync_object(id_bhvCosmeticFireFoot, flameModel, 
                    get_hand_foot_pos_x(m, 3) + m.vel.x,
                    get_hand_foot_pos_y(m, 3) + m.vel.y,
                    get_hand_foot_pos_z(m, 3) + m.vel.z,
                function(o)
                    o.oForwardVel = 5 + random_float()*2
                    o.oMoveAngleYaw = m.faceAngle.y + 0x4000 + 0x2000*random_float()
                end)
            end,
            [HOOK_BEFORE_SET_MARIO_ACTION] = function(m, nextAct)
                -- Wall Kick Flames
                if m.particleFlags & PARTICLE_VERTICAL_STAR ~= 0 or (nextAct == ACT_WALL_KICK_AIR and m.action & ACT_FLAG_ON_POLE == 0) then
                    m.particleFlags = m.particleFlags & ~PARTICLE_VERTICAL_STAR
                    for i = 0, 7 do
                        spawn_non_sync_object(id_bhvCosmeticFireFoot, m.wallKickTimer == 0 and E_MODEL_BLUE_FLAME or E_MODEL_RED_FLAME, 
                            m.pos.x,
                            m.pos.y,
                            m.pos.z,
                        function(o)
                            o.oIntangibleTimer = i
                            o.oBehParams = 25
                            local circleAngle = 0x2000*i
                            local wallAngle = atan2s(m.wallNormal.z, m.wallNormal.x)
                            o.oVelX = sins(circleAngle)*30*sins(wallAngle+0x4000) + coss(wallAngle-0x4000)*5
                            o.oVelY = coss(circleAngle)*30
                            o.oVelZ = sins(circleAngle)*30*coss(wallAngle+0x4000) + sins(wallAngle-0x4000)*5
                        end)
                    end
                end

                -- Ground Pound Flames
                if m.particleFlags & PARTICLE_HORIZONTAL_STAR ~= 0 then
                    m.particleFlags = m.particleFlags & ~PARTICLE_HORIZONTAL_STAR
                    for c = 1, 5 do
                        for i = 0, 7 do
                            local circleAngle = 0x2000*i + 0x800*c
                            local circleDist = 50*c
                            spawn_non_sync_object(id_bhvCosmeticFireFoot, m.wallKickTimer == 0 and E_MODEL_BLUE_FLAME or E_MODEL_RED_FLAME, 
                                m.pos.x + sins(circleAngle)*circleDist,
                                m.pos.y,
                                m.pos.z + coss(circleAngle)*circleDist,
                            function(o)
                                o.oIntangibleTimer = c
                                o.oBehParams = 5*c
                                o.oVelY = 5*c
                            end)
                        end
                    end
                end
            end
        },
    },
    {
        name = "Garden Grower",
        key = "Flowers",
        desc = "A Cosmetic that grows flowers\nwherever you step!",
        hooks = {
            [HOOK_MARIO_UPDATE] = function(m)
                if get_global_timer()%3 == 0 then
                    local latVel = math.sqrt(m.vel.x^2 + m.vel.z^2)
                    local randRot = random_u16()
                    local randDist = random_float()*150 + 150
                    local randX = m.pos.x + sins(m.faceAngle.y)*latVel*5 + sins(randRot)*randDist
                    local randZ = m.pos.z + coss(m.faceAngle.y)*latVel*5 + coss(randRot)*randDist
                    local floorHeight = find_floor(randX, m.pos.y, randZ)
                    spawn_non_sync_object(id_bhvCosmeticFlower, E_MODEL_FLOWER, 
                        randX,
                        floorHeight,
                        randZ,
                    function(o)
                    end)
                end
            end
        }
    },
}

-- Adds a cosmetic to the shop, running the associated hooks and restricting use of other cosmetics while active
function add_cosmetic(cosmetic)
    if not cosmetic then return end
    table.insert(cosmeticList, cosmetic)
end

local function get_cosmetic_from_name(name)
    for id, cosmetic in pairs(cosmeticList) do
        if cosmetic.name == name or cosmetic.key == name then
            return id, cosmetic
        end
    end
end

local function get_mario_state(m) return m end
local function run_cosmetic_func(m, hook, ...)
    if not m then return end
    local cosmetic = gPlayerSyncTable[m.playerIndex].cosmeticActive
    if cosmetic == 0 then return end
    if cosmeticList[cosmetic] and cosmeticList[cosmetic].hooks and cosmeticList[cosmetic].hooks[hook] then
        return cosmeticList[cosmetic].hooks[hook](...)
    end
end

local getIndex = {
    [HOOK_MARIO_UPDATE] = get_mario_state,
    [HOOK_BEFORE_MARIO_UPDATE] = get_mario_state,
    [HOOK_ON_SET_MARIO_ACTION] = get_mario_state,
    [HOOK_BEFORE_PHYS_STEP] = get_mario_state,
    [HOOK_ON_PLAYER_CONNECTED] = get_mario_state,
    [HOOK_ON_PLAYER_DISCONNECTED] = get_mario_state,
    [HOOK_ALLOW_INTERACT] = get_mario_state,
    [HOOK_ON_INTERACT] = get_mario_state,
    [HOOK_ON_DEATH] = get_mario_state,
    [HOOK_ALLOW_HAZARD_SURFACE] = get_mario_state,
    [HOOK_ON_CHAT_MESSAGE] = get_mario_state,
    [HOOK_CHARACTER_SOUND] = get_mario_state,
    [HOOK_BEFORE_SET_MARIO_ACTION] = get_mario_state,
    [HOOK_ON_COLLIDE_LEVEL_BOUNDS] = get_mario_state,
    [HOOK_MARIO_OVERRIDE_PHYS_STEP_DEFACTO_SPEED] = get_mario_state,
    [HOOK_ON_ATTACK_OBJECT] = get_mario_state,
    [HOOK_MARIO_OVERRIDE_GEOMETRY_INPUTS] = get_mario_state,
    [HOOK_ON_INTERACTIONS] = get_mario_state,
    [HOOK_ALLOW_FORCE_WATER_ACTION] = get_mario_state,
    [HOOK_MARIO_OVERRIDE_FLOOR_CLASS] = get_mario_state,
}

-- Hook everything after other mods
hook_event(HOOK_ON_MODS_LOADED, function ()
    for hookId = 0, HOOK_MAX - 1 do
        hook_event(hookId, function (...)
            -- special case for PVP
            if hookId == HOOK_ALLOW_PVP_ATTACK or hookId == HOOK_ON_PVP_ATTACK then
                local a, v = ...
                local rtrnVar = run_cosmetic_func(a, hookId, ...)
                local rtrnVarV = run_cosmetic_func(v, hookId, ...)
                if rtrnVarV ~= nil then return rtrnVarV
                else return rtrnVar end
            else
                local get = getIndex[hookId]
                local m = get and get(...) or gMarioStates[0]

                run_cosmetic_func(m, hookId, ...)
            end
        end)
    end
end)

local function on_sync()
    gPlayerSyncTable[0].cosmeticActive = get_cosmetic_from_name(modfs_storage_load("configCosmetic")) or 0
end

hook_event(HOOK_ON_SYNC_VALID, on_sync)