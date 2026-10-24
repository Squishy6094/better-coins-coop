gPlayerSyncTable[0].particleActiveFoot = 1

--[[
    Particle Ideas
    - Boos

]]

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

id_bhvPlayerParticleFireFoot = hook_behavior(nil, OBJ_LIST_UNIMPORTANT, true, bhv_particle_fire_init, bhv_particle_fire_loop)

local function mario_render_particle(o)
    if obj_has_behavior_id(o, id_bhvMario) ~= 0 then
        local m = get_mario_state_from_object(o)
        if not m then return end
        local p = gPlayerSyncTable[m.playerIndex]
        if p.particleActiveFoot ~= 1 then return end
        if m.forwardVel < 10 then return end
        local flameModel = m.forwardVel > (60 + 40*random_float()) and E_MODEL_BLUE_FLAME or E_MODEL_RED_FLAME
        spawn_non_sync_object(id_bhvPlayerParticleFireFoot, flameModel, 
            get_hand_foot_pos_x(m, 2) + m.vel.x,
            get_hand_foot_pos_y(m, 2) + m.vel.y,
            get_hand_foot_pos_z(m, 2) + m.vel.z, 
        function(o)
            o.oForwardVel = 5 + random_float()*2
            o.oMoveAngleYaw = m.faceAngle.y - 0x4000 - 0x2000*random_float()
        end)

        spawn_non_sync_object(id_bhvPlayerParticleFireFoot, flameModel, 
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
    if p.particleActiveFoot ~= 1 then return end
    -- Wall Kick Flames
    if m.particleFlags & PARTICLE_VERTICAL_STAR ~= 0 or (nextAct == ACT_WALL_KICK_AIR and m.action & ACT_FLAG_ON_POLE == 0) then
        m.particleFlags = m.particleFlags & ~PARTICLE_VERTICAL_STAR
        for i = 0, 7 do
            spawn_non_sync_object(id_bhvPlayerParticleFireFoot, m.wallKickTimer == 0 and E_MODEL_BLUE_FLAME or E_MODEL_RED_FLAME, 
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
                spawn_non_sync_object(id_bhvPlayerParticleFireFoot, m.wallKickTimer == 0 and E_MODEL_BLUE_FLAME or E_MODEL_RED_FLAME, 
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

hook_event(HOOK_ON_OBJECT_RENDER, mario_render_particle)
hook_event(HOOK_BEFORE_SET_MARIO_ACTION, before_set_mario_action)