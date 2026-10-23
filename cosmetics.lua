gPlayerSyncTable[0].particleActiveFoot = 0

--[[
    Particle Ideas
    - Boos

]]

local function bhv_particle_fire_init(o)
    o.oFlags = OBJ_FLAG_UPDATE_GFX_POS_AND_ANGLE | OBJ_FLAG_SET_FACE_ANGLE_TO_MOVE_ANGLE
    obj_set_billboard(o)
end

---@param o Object
local function bhv_particle_fire_loop(o)
    obj_scale(o, (15 - o.oTimer)/10)
    --o.oAnimState = o.oAnimState + 1

    o.oPosX = o.oPosX + sins(o.oFaceAngleYaw)*o.oForwardVel
    o.oPosY = o.oPosY + o.oForwardVel
    o.oPosZ = o.oPosZ + coss(o.oFaceAngleYaw)*o.oForwardVel

    if o.oTimer > 15 then
        obj_mark_for_deletion(o)
    end
end

id_bhvPlayerParticleFireFoot = hook_behavior(nil, OBJ_LIST_UNIMPORTANT, true, bhv_particle_fire_init, bhv_particle_fire_loop)

hook_event(HOOK_ON_OBJECT_RENDER, function (o)
    if obj_has_behavior_id(o, id_bhvMario) ~= 0 and false then
        local m = get_mario_state_from_object(o)
        if not m then return end
        spawn_non_sync_object(id_bhvPlayerParticleFireFoot, E_MODEL_RED_FLAME, 
            get_hand_foot_pos_x(m, 2) + m.vel.x,
            get_hand_foot_pos_y(m, 2) + m.vel.y,
            get_hand_foot_pos_z(m, 2) + m.vel.z, 
        function(o)
            o.oForwardVel = 5 + random_float()*2
            o.oMoveAngleYaw = m.faceAngle.y - 0x7000
        end)

        spawn_non_sync_object(id_bhvPlayerParticleFireFoot, E_MODEL_RED_FLAME, 
            get_hand_foot_pos_x(m, 3) + m.vel.x,
            get_hand_foot_pos_y(m, 3) + m.vel.y,
            get_hand_foot_pos_z(m, 3) + m.vel.z,
        function(o)
            o.oForwardVel = 5 + random_float()*2
            o.oMoveAngleYaw = m.faceAngle.y + 0x7000
        end)
    end
end)