gMasterCapStates = {}
for i = 0, MAX_PLAYERS - 1 do
    gMasterCapStates[i] = {
        masterCapTimer = 0,
        masterCapTotalTimer = 0,
        masterCapCoinTimer = 0,
        masterCapCoins = 0,
    }
end


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
        if nearestM and nearestM.numCoins > 0 then
            o.oHomeY = o.oHomeY + o.oVelY
            o.oVelY = o.oVelY + 1
        end

        local isNearest = (nearestM ~= nil and nearestM == gMarioStates[0]);
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
        gMasterCapStates[0].masterCapTimer = gLevelValues.wingCapDuration*0.5--(gNetworkPlayers[0].currCourseNum <= 15 and 0.5 or 0.25)
        spawn_mist_particles_variable(0, 0, 46.0);
        spawn_triangle_break_particles(20, 139, 0.3, o.oAnimState);
        create_sound_spawner(SOUND_GENERAL_BREAK_BOX);
        cur_obj_hide();
        o.oAction = 4
    end
end

id_bhvMasterCapBox = hook_behavior(id_bhvMasterCapBox, OBJ_LIST_SURFACE, true, bhv_master_cap_box_init, bhv_master_cap_box_loop, "bhvMasterCapBox")


local nearestObjPos = {x = 0, y = 0, z = 0}
local capSpawnRadius = 400
local function level_init()
    local m = gMarioStates[0]
    local e = gMasterCapStates[0]
    if obj_get_first_with_behavior_id(id_bhvBowser) == nil then
        e.masterCapTimer = 0
        e.masterCapTotalTimer = 0
    end
    if m.numStars >= get_max_possible_stars() and gNetworkPlayers[0].currCourseNum > 0 and e.masterCapTimer <= 0 and m.numCoins <= 0 then
        local castFloorSpawn = collision_find_surface_on_ray(m.pos.x, m.pos.y + 160, m.pos.z, 0, -0x8000, 0, 128).hitPos
        castFloorSpawn = {x = castFloorSpawn.x, y = math.max(castFloorSpawn.y, (m.waterLevel or -0x8000) - 200), z = castFloorSpawn.z}
        nearestObjPos.x = m.pos.x
        nearestObjPos.y = 0x8000
        nearestObjPos.z = m.pos.z
        local prevDist = 0x8000
        for i = 0, NUM_OBJ_LISTS - 1 do
            if i ~= OBJ_LIST_PLAYER then
                local o = obj_get_first(i)
                while o ~= nil do
                    if obj_has_model_extended(o, E_MODEL_NONE) == 0 and (m.waterLevel == nil or o.oPosY > m.waterLevel) then
                        local objPos = obj_pos_to_vec3f(o)
                        local currDist = math.sqrt((castFloorSpawn.x - objPos.x)^2 + (castFloorSpawn.y - objPos.y)^2 + (objPos.z - nearestObjPos.z)^2)
                        --djui_chat_message_create(get_behavior_name_from_id(get_id_from_behavior(o.behavior)))
                        --djui_chat_message_create(tostring(currDist))
                        --djui_chat_message_create(tostring(rayHit))
                        if (currDist < prevDist) then
                            nearestObjPos.x = objPos.x
                            nearestObjPos.y = objPos.y
                            nearestObjPos.z = objPos.z
                            prevDist = math.sqrt((castFloorSpawn.x - nearestObjPos.x)^2 + (castFloorSpawn.y - nearestObjPos.y)^2 + (castFloorSpawn.z - nearestObjPos.z)^2)
                            --djui_chat_message_create(get_behavior_name_from_id(get_id_from_behavior(o.behavior)))
                            --djui_chat_message_create(tostring(currDist))
                        end
                    end
                    o = obj_get_next(o)
                end
            end
        end

        nearestObjPos = (collision_find_surface_on_ray(m.pos.x, m.pos.y + 160, m.pos.z, nearestObjPos.x - m.pos.x, nearestObjPos.y - m.pos.y, nearestObjPos.z - m.pos.z, 128).hitPos)
        
        local objX = math.clamp(math.lerp(castFloorSpawn.x, nearestObjPos.x, 0.5), castFloorSpawn.x - capSpawnRadius, castFloorSpawn.x + capSpawnRadius)
        local objY = math.clamp(math.lerp(castFloorSpawn.y, nearestObjPos.y, 0.5), castFloorSpawn.y - 300, castFloorSpawn.y) + 350
        local objZ = math.clamp(math.lerp(castFloorSpawn.z, nearestObjPos.z, 0.5), castFloorSpawn.z - capSpawnRadius, castFloorSpawn.z + capSpawnRadius)
        spawn_non_sync_object(id_bhvMasterCapBox, E_MODEL_EXCLAMATION_BOX, objX, objY, objZ, function (o) end)
        --djui_chat_message_create(tostring(objX) .."|".. tostring(objY) .."|".. tostring(objZ))
    end
end

local ACT_MASTER_CAP_RESULTS = allocate_mario_action(ACT_GROUP_CUTSCENE | ACT_FLAG_INTANGIBLE)

---@param m MarioState
local function act_master_cap_results(m)
    local e = gMasterCapStates[m.playerIndex]
    m.marioObj.header.gfx.animInfo.animFrame = e.prevActionAnimFrame
    m.marioObj.header.gfx.animInfo.animAccel = 0
    camera_freeze()
    game_unpause()
    local pressedA = m.controller.buttonPressed & A_BUTTON ~= 0

    if m.actionState == 0 then -- Stall
        if m.actionTimer > 10 then
            m.actionState = m.actionState + 1
            m.actionTimer = 0
        end
    elseif m.actionState == 1 then -- Count Coins
        if m.actionTimer > math.min(e.masterCapCoins, 150) or pressedA then
            m.actionState = m.actionState + 1
            m.actionTimer = 0
        end
    elseif m.actionState == 2 then -- Stall
        if m.actionTimer > 10 then
            m.actionState = m.actionState + 1
            m.actionTimer = 0
        end
    elseif m.actionState == 3 then -- Count Time
        if m.actionTimer > math.min(e.masterCapCoinTimer/30, 150) or pressedA then
            m.actionState = m.actionState + 1
            m.actionTimer = 0
        end
    elseif m.actionState == 4 then -- Await Input
        if pressedA then
            m.actionState = m.actionState + 1
            m.actionTimer = 0
        end
    else
        camera_unfreeze()
        m.action = e.prevAction
        m.marioObj.header.gfx.animInfo.animAccel = e.prevActionAnimAccel
        m.actionArg = e.prevActionArg
        m.actionTimer = e.prevActionTimer
        m.actionState = e.prevActionState
    end


    m.actionTimer = m.actionTimer + 1
end

hook_mario_action(ACT_MASTER_CAP_RESULTS, act_master_cap_results)

local function set_mario_finished_master_cap(m)
    local e = gMasterCapStates[m.playerIndex]
    e.masterCapTimer = 0
    m.flags = m.flags & ~(MARIO_WING_CAP | MARIO_VANISH_CAP | MARIO_METAL_CAP)
    set_mario_action(m, ACT_MASTER_CAP_RESULTS, 0)
end

local noCountdown = {
    [ACT_READING_AUTOMATIC_DIALOG] = true,
    [ACT_READING_NPC_DIALOG] = true,
    [ACT_READING_SIGN] = true,
    [ACT_IN_CANNON] = true,
    -- New
    [ACT_TELEPORT_FADE_IN] = true,
    [ACT_TELEPORT_FADE_OUT] = true,
}

---@param m MarioState
local function master_cap_update(m)
    local e = gMasterCapStates[m.playerIndex]
    --if m.playerIndex ~= 0 then return end
    if e.masterCapTimer > 0 then
        e.masterCapTimer = math.max(m.capTimer, e.masterCapTimer)
        -- Hold timer on acts
        if not noCountdown[m.action] then
            e.masterCapTimer = e.masterCapTimer - 1
            e.masterCapTotalTimer = e.masterCapTotalTimer + 1
        end

        -- Save previous actions to unfreeze from
        if m.action ~= ACT_MASTER_CAP_RESULTS then
            e.prevActionAnimFrame = m.marioObj.header.gfx.animInfo.animFrame
            e.prevActionAnimAccel = m.marioObj.header.gfx.animInfo.animAccel
            e.prevAction = m.action
            e.prevActionTimer = m.actionTimer
            e.prevActionState = m.actionState
            e.prevActionArg = m.actionArg
        end
        
        -- End at 999 coins
        if m.numCoins >= 999 then
            set_mario_finished_master_cap(m)
        end

        -- End on key collect
        if m.action == ACT_STAR_DANCE_EXIT then
            set_mario_finished_master_cap(m)
        end

        m.capTimer = e.masterCapTimer
        e.masterCapCoins = math.clamp(m.numCoins, 0, 999)
        if e.masterCapTimer > 0 then
            m.flags = m.flags | (MARIO_WING_CAP | MARIO_VANISH_CAP | MARIO_METAL_CAP)
        else
            set_mario_finished_master_cap(m)
        end
    end
end

local TEXT_MASTER_CAP = "Collect as many coins as possible!"
local TEXT_RESULT_COINS = "Coins Collected:"
local TEXT_RESULT_TIME = "Time Spent:"
local function hud_render()
    local m = gMarioStates[0]
    local e = gMasterCapStates[0]
    djui_hud_set_resolution(RESOLUTION_N64)
    local sWidth = djui_hud_get_screen_width() + 1
    local sHeight = djui_hud_get_screen_height()
    if e.masterCapTimer > 0 then
        djui_hud_set_font(FONT_HUD)
        local textW, textH = djui_hud_measure_text(TEXT_MASTER_CAP)
        local textScale = math.min(sWidth/(textW + 32), 1)
        djui_hud_print_text(TEXT_MASTER_CAP, sWidth*0.5 - textW*textScale*0.5, sHeight - (32 + math.abs(math.sin(e.masterCapTotalTimer/30))*8)*textScale, textScale)
    end

    if m.action == ACT_MASTER_CAP_RESULTS then
        djui_hud_set_color(0, 0, 0, 150)
        djui_hud_render_rect(0, 0, sWidth, sHeight)
        djui_hud_set_color(255, 255, 255, 255)

        -- Render Coins Collected
        djui_hud_set_font(FONT_NORMAL)
        djui_hud_print_text(TEXT_RESULT_COINS, sWidth*0.5 - djui_hud_measure_text(TEXT_RESULT_COINS)*0.25, 60, 0.5)
        local coinCount = m.actionState < 1 and 0 or e.masterCapCoins
        if m.actionState == 1 then
            coinCount = math.ceil(math.lerp(0, e.masterCapCoins, m.actionTimer/math.min(e.masterCapCoins, 150)))
        end
        local coinRender = tostring(coinCount)
        djui_hud_set_font(FONT_RECOLOR_HUD)
        djui_hud_print_text(coinRender, sWidth*0.5 - djui_hud_measure_text(coinRender) - 4, 80, 2)

        -- Render Timestamp
        djui_hud_set_font(FONT_NORMAL)
        djui_hud_print_text(TEXT_RESULT_TIME, sWidth*0.5 - djui_hud_measure_text(TEXT_RESULT_TIME)*0.25, 120, 0.5)
        local timeCount = m.actionState < 3 and 0 or e.masterCapCoinTimer
        if m.actionState == 3 then
            timeCount = math.lerp(0, e.masterCapCoinTimer, m.actionTimer/math.min(e.masterCapCoinTimer/30, 150))
        end
        local timeRender = timestamp(timeCount)
        djui_hud_set_font(FONT_RECOLOR_HUD)
        djui_hud_print_text(timeRender, sWidth*0.5 - djui_hud_measure_text(timeRender)*0.5 - 2, 140, 1)
    end
end

hook_event(HOOK_ON_LEVEL_INIT, level_init)
hook_event(HOOK_MARIO_UPDATE, master_cap_update)
hook_event(HOOK_ON_HUD_RENDER_BEHIND, hud_render)