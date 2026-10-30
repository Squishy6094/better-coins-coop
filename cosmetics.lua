local E_MODEL_FLOWER = smlua_model_util_get_id("unused_flower_geo")

COSMETIC_HOT_FOOT = 1
COSMETIC_AIR_HEAD = 2
COSMETIC_GARDEN_GROWER = 3

gPlayerSyncTable[0].cosmeticActive = mod_storage_load_integer("configCosmetic", 0)

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
    if not m then
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
    local p = gPlayerSyncTable[m.playerIndex]
    
    o.oAnimState = math.round((get_global_timer())/3 + o.oBehParams)%6
    if o.oAction == 0 then
        cur_obj_scale(o.oTimer/5)
        if o.oTimer > 5 then
            o.oAction = o.oAction + 1
        end
    elseif o.oAction == 1 then
        local timerMax = 30
        if obj_to_obj_dist(m.marioObj, o) < 300 and p.cosmeticActive == COSMETIC_GARDEN_GROWER then
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

local function mario_update(m)
    if not m then return end
    local p = gPlayerSyncTable[m.playerIndex]
    local vel = math.sqrt(m.vel.x^2 + (m.action & ACT_FLAG_AIR ~= 0 and m.vel.y or 0)^2 + m.vel.z^2)
    local latVel = math.sqrt(m.vel.x^2 + m.vel.z^2)
    if p.cosmeticActive == COSMETIC_HOT_FOOT then
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

    if p.cosmeticActive == COSMETIC_GARDEN_GROWER and get_global_timer()%3 == 0 then
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

---@param m MarioState
local function before_set_mario_action(m, nextAct)
    local p = gPlayerSyncTable[m.playerIndex]
    if p.cosmeticActive == COSMETIC_HOT_FOOT then
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
end

local function spawn_cosmetics()
    local m = gMarioStates[0]
    if gPlayerSyncTable[0].cosmeticActive == COSMETIC_AIR_HEAD then
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
hook_event(HOOK_MARIO_UPDATE, mario_update)

cosmeticShopEntries = {
    [COSMETIC_HOT_FOOT] = {
        name = "Hot Footed",
        key = "HotFoot",
        desc = "A Cosmetic Badge that causes your\nboots to catch ablaze! This gives\nmovement and impacts a little\nmore spice!"
    },
    [COSMETIC_AIR_HEAD] = {
        name = "Air Headed",
        key = "AirHead",
        desc = "A Cosmetic Badge that surrounds\nyour head in a bubble!"
    },
    [COSMETIC_GARDEN_GROWER] = {
        name = "Garden Grower",
        key = "Flowers",
        desc = "A Cosmetic Badge that grows flowers\nwherever you step!"
    },
}