local masterCapTimer = 0

---@param o Object
local function bhv_master_cap_box_init(o)
    o.oFlags = o.oFlags | OBJ_FLAG_SET_FACE_YAW_TO_MOVE_YAW | OBJ_FLAG_UPDATE_GFX_POS_AND_ANGLE
    o.collisionData = gGlobalObjectCollisionData.exclamation_box_outline_seg8_collision_08025F78
    o.oCollisionDistance = 300

    o.oHomeX = o.oPosX
    o.oHomeY = o.oPosY
    o.oHomeZ = o.oPosZ

    o.oPosY = o.oHomeY + 0x8000

    o.areaTimerType = AREA_TIMER_TYPE_MAXIMUM
    o.areaTimer = 0
    o.areaTimerDuration = 300
end

---@param o Object
local function bhv_master_cap_box_loop(o)
    cur_obj_scale(2.0);
    o.oInteractType = INTERACT_BREAKABLE
    o.hitboxDownOffset = 5
    o.oDamageOrCoinValue = 0
    o.oHealth = 1
    o.oNumLootCoins = 0
    o.hurtboxRadius = 40
    o.hurtboxHeight = 30
    local nearestM = nearest_mario_state_to_object(o)

    if o.oAction == 0 then
        o.oExclamationBoxForce = 0;
        o.oAction = 1
    elseif o.oAction == 1 then
        if (o.oTimer == 0) then
            cur_obj_unhide();
            cur_obj_become_tangible();
            o.oInteractStatus = 0;
            --o.oPosY = o.oHomeY;
            o.oGraphYOffset = 0.0;
        end

        o.oPosY = math.lerp(o.oPosY, o.oHomeY + math.sin(get_global_timer()/10)*30, 0.1)
        if nearestM.numCoins > 0 then
            o.oHomeY = o.oHomeY + o.oVelY
            o.oVelY = o.oVelY + 1
        end

        local isNearest = (nearestM == gMarioStates[0]);
        if (o.oExclamationBoxForce ~= 0 or isNearest) then
            if (o.oExclamationBoxForce ~= 0 or (isNearest and cur_obj_was_attacked_or_ground_pounded() ~= 0)) then
                if (o.oExclamationBoxForce == 0) then
                    o.oExclamationBoxForce = 1;
                    --network_send_object(o);
                    o.oExclamationBoxForce = 0;
                end
                cur_obj_become_intangible();
                o.oExclamationBoxUnkFC = 0x4000;
                o.oVelY = 30.0;
                o.oGravity = -8.0;
                o.oFloorHeight = o.oPosY;
                o.oAction = 2;
                queue_rumble_data_object(o, 5, 80);
            end
        end
        load_object_collision_model()
    elseif o.oAction == 2 then
        cur_obj_move_using_fvel_and_gravity();
        if (o.oVelY < 0.0) then
            o.oVelY = 0.0;
            o.oGravity = 0.0;
        end
        o.oExclamationBoxUnkF8 = (sins(o.oExclamationBoxUnkFC) + 1.0) * 0.3 + 0.0;
        o.oExclamationBoxUnkF4 = (-sins(o.oExclamationBoxUnkFC) + 1.0) * 0.5 + 1.0;
        o.oGraphYOffset = (-sins(o.oExclamationBoxUnkFC) + 1.0) * 26.0;
        o.oExclamationBoxUnkFC = o.oExclamationBoxUnkFC + 0x1000;
        o.header.gfx.scale.x = o.oExclamationBoxUnkF4 * 2.0;
        o.header.gfx.scale.y = o.oExclamationBoxUnkF8 * 2.0;
        o.header.gfx.scale.z = o.oExclamationBoxUnkF4 * 2.0;
        if (o.oTimer == 7) then
            o.oAction = 3;
        end
    elseif o.oAction == 3 then
        --exclamation_box_spawn_contents(gExclamationBoxContents, o->oBehParams2ndByte);
        masterCapTimer = gLevelValues.wingCapDuration*0.5--(gNetworkPlayers[0].currCourseNum <= 15 and 0.5 or 0.25)
        spawn_mist_particles_variable(0, 0, 46.0);
        spawn_triangle_break_particles(20, 139, 0.3, o.oAnimState);
        create_sound_spawner(SOUND_GENERAL_BREAK_BOX);
        cur_obj_hide();
        o.oAction = 4
    end
end

id_bhvMasterCapBox = hook_behavior(id_bhvMasterCapBox, OBJ_LIST_SURFACE, true, bhv_master_cap_box_init, bhv_master_cap_box_loop)

local function level_init()
    local m = gMarioStates[0]
    masterCapTimer = 0
    if gNetworkPlayers[0].currCourseNum > 0 then
        local castFloor = collision_find_surface_on_ray(m.pos.x, m.pos.y + 160, m.pos.z, 0, -0x8000, 0, 128).hitPos
        local nearestObjPos = nil
        for i = 0, NUM_OBJ_LISTS - 1 do
            local o = obj_get_first(i)
            while o ~= nil do
                local objPos = obj_pos_to_vec3f(o)
                if nearestObjPos == nil or vec3f_dist(objPos, castFloor) < vec3f_dist(nearestObjPos, castFloor) then
                    nearestObjPos = objPos
                end
                o = obj_get_next(o)
            end
        end
        
        spawn_non_sync_object(id_bhvMasterCapBox, E_MODEL_EXCLAMATION_BOX, (castFloor.x + (nearestObjPos.x or 300))*0.5, (castFloor.y + (nearestObjPos.y or 0))*0.5 + 400, (castFloor.z + (nearestObjPos.z or 300))*0.5, function (o)

        end)
    end
end

local noCountdown = {
    [ACT_READING_AUTOMATIC_DIALOG] = true,
    [ACT_READING_NPC_DIALOG] = true,
    [ACT_READING_SIGN] = true,
    [ACT_IN_CANNON] = true,
}

local function master_cap_update(m)
    if m.playerIndex ~= 0 then return end
    if masterCapTimer > 0 then
        masterCapTimer = math.max(m.capTimer, masterCapTimer)
        if not noCountdown[m.action] then
            masterCapTimer = masterCapTimer - 1
        end
        m.capTimer = masterCapTimer
        if masterCapTimer > 0 then
            m.flags = m.flags | MARIO_WING_CAP | MARIO_VANISH_CAP | MARIO_METAL_CAP
        end
    end
end

local TEXT_MASTER_CAP = "Collect as many coins as possible!"
local function hud_render()
    djui_hud_set_resolution(RESOLUTION_N64)
    local sWidth = djui_hud_get_screen_width()
    local sHeight = djui_hud_get_screen_height()
    if masterCapTimer > 0 then
        djui_hud_set_font(FONT_RECOLOR_HUD)
        djui_hud_print_text(TEXT_MASTER_CAP, 10, 10, 1)
    end
end

hook_event(HOOK_ON_LEVEL_INIT, level_init)
hook_event(HOOK_MARIO_UPDATE, master_cap_update)
hook_event(HOOK_ON_HUD_RENDER_BEHIND, hud_render)