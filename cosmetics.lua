gPlayerSyncTable[0].cosmeticActive = mod_storage_load_integer("configCosmetic", 0)

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

local prevMarioGfxPos = {}
for i = 0, MAX_PLAYERS - 1 do
    prevMarioGfxPos[i] = {x = 0, y = 0, z = 0}
end

---@param o Object
local function bhv_particle_bubble_helmet_init(o)
    o.oFlags = OBJ_FLAG_UPDATE_GFX_POS_AND_ANGLE
    obj_set_billboard(o)
end

---@param o Object
local function bhv_particle_bubble_helmet_loop(o)
    local m = gMarioStates[network_local_index_from_global(o.globalPlayerIndex)] ---@type MarioState
    if not m then
        obj_mark_for_deletion(o)
        return
    end
    local p = gPlayerSyncTable[m.playerIndex]
    if p.cosmeticActive ~= 2 then
        obj_mark_for_deletion(o)
        return
    end
    obj_scale(o, 3)
    local headPos = {x = 0, y = 0, z = 0}
    local headRot = {x = 0, y = 0, z = 0}
    get_mario_anim_part_pos(m, MARIO_ANIM_PART_HEAD, headPos)
    get_mario_anim_part_rot(m, MARIO_ANIM_PART_HEAD, headRot)
    local headOffset = {x = 0, y = 0, z = 0}
    vec3f_rotate_zxy(headOffset, headRot)

    o.oPosX = headPos.x + headOffset.x + (m.marioObj.header.gfx.pos.x - prevMarioGfxPos[m.playerIndex].x)
    o.oPosY = headPos.y + headOffset.y + (m.marioObj.header.gfx.pos.y - prevMarioGfxPos[m.playerIndex].y)
    o.oPosZ = headPos.z + headOffset.z + (m.marioObj.header.gfx.pos.z - prevMarioGfxPos[m.playerIndex].z)
    -- Used for predicting gfx velocity
    prevMarioGfxPos[m.playerIndex].x = m.marioObj.header.gfx.pos.x
    prevMarioGfxPos[m.playerIndex].y = m.marioObj.header.gfx.pos.y
    prevMarioGfxPos[m.playerIndex].z = m.marioObj.header.gfx.pos.z

    o.header.gfx.pos.x = o.oPosX
    o.header.gfx.pos.y = o.oPosY
    o.header.gfx.pos.z = o.oPosZ
end 

id_bhvCosmeticBubbleHelmet = hook_behavior(nil, OBJ_LIST_UNIMPORTANT, true, bhv_particle_bubble_helmet_init, bhv_particle_bubble_helmet_loop)

local function mario_render_particle(o)
    if obj_has_behavior_id(o, id_bhvMario) ~= 0 then
        local m = get_mario_state_from_object(o)
        if not m then return end
        local p = gPlayerSyncTable[m.playerIndex]
        if p.cosmeticActive ~= 1 then return end
        local vel = math.sqrt(m.vel.x^2 + m.vel.y^2 + m.vel.z^2)
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
    end
end

---@param m MarioState
local function before_set_mario_action(m, nextAct)
    local p = gPlayerSyncTable[m.playerIndex]
    if p.cosmeticActive ~= 1 then return end
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

local function spawn_cosmetics()
    local m = gMarioStates[0]
    if gPlayerSyncTable[0].cosmeticActive == 2 then
        local oBubble = obj_get_first_with_behavior_id(id_bhvCosmeticBubbleHelmet)
        while oBubble do
            if network_local_index_from_global(oBubble.globalPlayerIndex) == 0 then
                return
            end
            oBubble = obj_get_next_with_same_behavior_id(oBubble)
        end

        spawn_sync_object(id_bhvCosmeticBubbleHelmet, E_MODEL_BUBBLE, m.pos.x, m.pos.y, m.pos.z, function(oBubble)
            oBubble.globalPlayerIndex = network_global_index_from_local(0)
        end)
    end
end

hook_event(HOOK_UPDATE, spawn_cosmetics)
hook_event(HOOK_BEFORE_SET_MARIO_ACTION, before_set_mario_action)
hook_event(HOOK_ON_OBJECT_RENDER, mario_render_particle)