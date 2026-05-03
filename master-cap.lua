
local MUSIC_MASTER_CAP = audio_stream_load("music-master-cap.ogg")

audio_stream_set_loop_points(MUSIC_MASTER_CAP, 000917230, 003175168)
audio_stream_set_looping(MUSIC_MASTER_CAP, true)

local masterCapMusicFreq = 1

local MASTER_CAP_BOX_SCALE = 3

gMasterCapStates = {}
for i = 0, MAX_PLAYERS - 1 do
    gMasterCapStates[i] = {
        index = network_global_index_from_local(i),
        masterCapTimer = 0,
        masterCapTotalTimer = 0,
        masterCapCoinTimer = 0,
        masterCapCoins = 0,
        masterCapNewRecord = false,
        masterCapCrouchTimer = 0
    }
end

-- Load save into sync table
for i = 1, COURSE_MAX do
    gMasterCapStates[0]["masterCapRecordCoins"..i] = tonumber(mod_storage_load(ROMHACK.."recordCoins"..tostring(i))) or 0
    gMasterCapStates[0]["masterCapRecordTime"..i] = tonumber(mod_storage_load(ROMHACK.."recordTime"..tostring(i))) or 0
end

local function on_packet_recieve(data)
    local index = network_local_index_from_global(data.index)
    gMasterCapStates[index] = data
end

hook_event(HOOK_ON_PACKET_RECEIVE, on_packet_recieve)

local function get_master_cap_leaderboard(course, out)
    local leaderboard = out or {}
    -- Clear table
    for i in pairs(leaderboard) do
        out[i] = nil
    end
    course = course or gNetworkPlayers[0].currCourseNum
    for i = 0, MAX_PLAYERS - 1 do
        local name = get_uncolored_string(gNetworkPlayers[i].name)
        local coins = gMasterCapStates[i]["masterCapRecordCoins"..course]
        local time = gMasterCapStates[i]["masterCapRecordTime"..course]
        if name ~= "" and coins and (coins > 0 or i == 0) and time then
            table.insert(leaderboard, {
                name = name,
                coins = coins,
                time = time,
                displayCoins = tostring(coins),
                displayTime = timestamp(time),
            })
        end
    end
    table.sort(leaderboard, function(a, b)
        if a.coins ~= b.coins then
            return a.coins > b.coins
        else
            return a.time < b.time
        end
    end)
    return leaderboard
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
    o.oSubAction = 0

    o.areaTimerType = AREA_TIMER_TYPE_MAXIMUM
    o.areaTimer = 0
    o.areaTimerDuration = 300

    smlua_anim_util_set_animation(o, "idle")
end

---@param o Object
local function bhv_master_cap_box_loop(o)
    cur_obj_scale(MASTER_CAP_BOX_SCALE);
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
            o.oSubAction = 1
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

        if cur_obj_check_if_at_animation_end() ~= 0 then
            cur_obj_play_sound_1(SOUND_OBJ_BOWSER_SPINNING)
        end
    elseif o.oAction == 2 then
        cur_obj_move_using_fvel_and_gravity();
        if (o.oVelY < 0.0) then
            o.oVelY = 0.0;
            o.oGravity = 0.0;
        end
        o.oExclamationBoxUnkF8 = (sins(o.oExclamationBoxUnkFC) + 1.0) * 0.3 + 0.0;
        o.oExclamationBoxUnkF4 = (-sins(o.oExclamationBoxUnkFC) + 1.0) * 0.5 + 1.0;
        o.oGraphYOffset = (-sins(o.oExclamationBoxUnkFC) + 1.0) * (16.0 * MASTER_CAP_BOX_SCALE);
        o.oExclamationBoxUnkFC = o.oExclamationBoxUnkFC + 0x1000;
        o.header.gfx.scale.x = o.oExclamationBoxUnkF4 * MASTER_CAP_BOX_SCALE;
        o.header.gfx.scale.y = o.oExclamationBoxUnkF8 * MASTER_CAP_BOX_SCALE;
        o.header.gfx.scale.z = o.oExclamationBoxUnkF4 * MASTER_CAP_BOX_SCALE;
        if (o.oTimer == 7) then
            o.oAction = 3;
        end
    elseif o.oAction == 3 then
        --exclamation_box_spawn_contents(gExclamationBoxContents, o->oBehParams2ndByte);
        gMasterCapStates[0].masterCapTimer = gLevelValues.wingCapDuration*0.5--(gNetworkPlayers[0].currCourseNum <= 15 and 0.5 or 0.25)
        play_transition(WARP_TRANSITION_FADE_INTO_COLOR, 0, 255, 255, 255)
        play_transition(WARP_TRANSITION_FADE_FROM_COLOR, 30, 255, 255, 255)
        play_sound(SOUND_MENU_STAR_SOUND, gGlobalSoundSource)
        play_character_sound(gMarioStates[0], CHAR_SOUND_HERE_WE_GO)
        spawn_mist_particles_variable(0, 0, 46.0);
        spawn_triangle_break_particles(20, 139, 0.3, o.oAnimState);
        create_sound_spawner(SOUND_GENERAL_BREAK_BOX);
        cur_obj_hide();
        o.oAction = 4
        o.oSubAction = 2
    end
end

id_bhvMasterCapBox = hook_behavior(id_bhvMasterCapBox, OBJ_LIST_SURFACE, true, bhv_master_cap_box_init, bhv_master_cap_box_loop, "bhvMasterCapBox")

function master_cap_box_active()
    local o = obj_get_first_with_behavior_id(id_bhvMasterCapBox)
    if not o then return false end
    if o.oSubAction > 0 then return false end
    return true, o
end

---@param m MarioState
function mario_master_cap_active(m)
    return gMasterCapStates[m.playerIndex].masterCapTimer > 0
end

local E_MODEL_MASTER_CAP = smlua_model_util_get_id("master_box_geo")

local nearestObjPos = {x = 0, y = 0, z = 0}
local capSpawnRadius = 400
local function level_init()
    local m = gMarioStates[0]
    local e = gMasterCapStates[0]

    if obj_get_first_with_behavior_id(id_bhvBowser) == nil then
        e.masterCapTimer = 0
        e.masterCapTotalTimer = 0
    end
    if hud_get_value(HUD_DISPLAY_STARS) >= get_max_possible_stars() and gNetworkPlayers[0].currCourseNum > 0 and e.masterCapTimer <= 0 and m.numCoins <= 0 then
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
        spawn_non_sync_object(id_bhvMasterCapBox, E_MODEL_MASTER_CAP, objX, objY, objZ, function (o) end)
        --djui_chat_message_create(tostring(objX) .."|".. tostring(objY) .."|".. tostring(objZ))
    end
end
local ACT_MASTER_CAP_RESULTS = allocate_mario_action(ACT_GROUP_CUTSCENE | ACT_FLAG_INTANGIBLE)

---@param m MarioState
local function act_master_cap_results(m)
    local e = gMasterCapStates[m.playerIndex]
    m.marioObj.header.gfx.animInfo.animFrame = e.prevActionAnimFrame
    m.marioObj.header.gfx.animInfo.animAccel = 0
    --camera_freeze()
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
    elseif m.actionState == 4 then
        -- Save high score
        if m.playerIndex == 0 then
            local course = gNetworkPlayers[0].currCourseNum

            local prevCoins = e["masterCapRecordCoins"..course]
            local currCoins = e.masterCapCoins
            local prevTime = e["masterCapRecordTime"..course]
            local currTime = e.masterCapCoinTimer
            if prevCoins and (currCoins > prevCoins or (currCoins == prevCoins and currTime < prevTime)) then
                e["masterCapRecordCoins"..course] = e.masterCapCoins
                mod_storage_save(ROMHACK.."recordCoins"..tostring(course), tostring(e.masterCapCoins))
                e["masterCapRecordTime"..course] = e.masterCapCoinTimer
                mod_storage_save(ROMHACK.."recordTime"..tostring(course), tostring(e.masterCapCoinTimer))
                e.masterCapNewRecord = true
                if m.playerIndex == 0 then
                    play_star_fanfare()
                end
            end
            m.actionState = m.actionState + 1
        end
    elseif m.actionState == 5 then -- Await Input
        if pressedA then
            m.actionState = m.actionState + 1
            m.actionTimer = 0
        end
    else

        --camera_unfreeze()
        m.action = e.prevAction
        m.marioObj.header.gfx.animInfo.animAccel = e.prevActionAnimAccel
        m.actionArg = e.prevActionArg
        m.actionTimer = e.prevActionTimer
        m.actionState = e.prevActionState
        e.masterCapNewRecord = false
    end


    m.actionTimer = m.actionTimer + 1
end

hook_mario_action(ACT_MASTER_CAP_RESULTS, act_master_cap_results)

local function set_mario_finished_master_cap(m)
    local e = gMasterCapStates[m.playerIndex]
    e.masterCapTimer = 0
    e.masterCapCrouchTimer = 0
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
        if m.action & ACT_FLAG_INTANGIBLE == 0 then
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
        if m.action == ACT_STAR_DANCE_EXIT or m.action == ACT_JUMBO_STAR_CUTSCENE then
            set_mario_finished_master_cap(m)
        end

        if m.playerIndex == 0 then
        end

        m.capTimer = e.masterCapTimer
        e.masterCapCoins = math.clamp(m.numCoins, 0, 999)
        if e.masterCapTimer > 0 then
            m.flags = m.flags | (MARIO_WING_CAP | MARIO_VANISH_CAP | MARIO_METAL_CAP)
        else
            set_mario_finished_master_cap(m)
        end

        if m.action == ACT_CROUCHING then
            e.masterCapCrouchTimer = e.masterCapCrouchTimer + 1
            if e.masterCapCrouchTimer > 90 then
                set_mario_finished_master_cap(m)
            end
        else
            e.masterCapCrouchTimer = math.max(e.masterCapCrouchTimer - 3, 0)
        end
    end

    if m.playerIndex == 0 then 
        network_send(false, gMasterCapStates[0])
    end
end

local prevRunState = 0
local function master_cap_music_update()
    local m = gMarioStates[0]
    local e = gMasterCapStates[0]
    local runState = 0
    if e.masterCapTimer > 0 then
        runState = 1
    elseif m.action == ACT_MASTER_CAP_RESULTS then
        runState = 2
    end

    if runState > 0 then
        audio_stream_set_volume(MUSIC_MASTER_CAP, is_game_paused() and 0 or 0.75)
        if prevRunState ~= runState then
            stop_cap_music()
            audio_stream_play(MUSIC_MASTER_CAP, false, 1)
            play_secondary_music(0, 0, 0, 50)
            prevRunState = runState
        end
        local freqTargetTime = 1 + (math.max(300 - e.masterCapTimer, 0)/300)*0.3
        local freqTargetEnd = 1 + (e.masterCapCrouchTimer/90)*0.3
        local freqTarget = runState == 2 and 0.7 or math.max(freqTargetTime, freqTargetEnd)
        masterCapMusicFreq = math.lerp(masterCapMusicFreq, freqTarget, 0.1)
        audio_stream_set_frequency(MUSIC_MASTER_CAP, masterCapMusicFreq)

    else
        if prevRunState ~= runState then
            audio_stream_set_position(MUSIC_MASTER_CAP, 0)
            audio_stream_set_frequency(MUSIC_MASTER_CAP, 1)
            masterCapMusicFreq = 0
            audio_stream_stop(MUSIC_MASTER_CAP)
            stop_secondary_music(50)
            prevRunState = runState
        end
    end
end

local TEXT_MASTER_CAP = "Collect as many coins as possible!"
local TEXT_RESULT_COINS = "Coins Collected:"
local TEXT_RESULT_PB = "Personal Best: "
local TEXT_RESULT_SB = "Server Best: "
local TEXT_RESULT_TIME = "Time Spent:"
local TEXT_RECORD = "HI SCORE"
local TEXT_ENDING_RUN = "ENDING RUN EARLY..."
local leaderboardTop = nil
local leaderboard = nil
local function master_cap_render()
    local m = gMarioStates[0]
    local e = gMasterCapStates[0]
    local course = gNetworkPlayers[0].currCourseNum
    local isSingle = network_player_connected_count() <= 1
    djui_hud_set_resolution(RESOLUTION_N64)
    local sWidth = djui_hud_get_screen_width() + 1
    local sHeight = djui_hud_get_screen_height()
    if e.masterCapTimer > 0 then
        djui_hud_set_font(FONT_HUD)
        local textW, textH = djui_hud_measure_text(TEXT_MASTER_CAP)
        local textScale = math.min(sWidth/(textW + 32), 1)
        djui_hud_print_text(TEXT_MASTER_CAP, sWidth*0.5 - textW*textScale*0.5, sHeight - (32 + math.abs(math.sin(e.masterCapTotalTimer/30))*8)*textScale, textScale)

        if e.masterCapCrouchTimer > 15 then
            local untilCancelInterp = math.max(e.masterCapCrouchTimer + (m.action == ACT_CROUCHING and -1 or 3) - 15, 0)/75
            local untilCancel = math.max(e.masterCapCrouchTimer - 15, 0)/75
            local cancelColor = 127 - 127*untilCancel
            djui_hud_set_color(255, cancelColor, cancelColor, 255)
            djui_hud_render_rect_interpolated(0, 0, sWidth*untilCancelInterp, 2, 0, 0, sWidth*untilCancel, 2)
            djui_hud_set_color(255, cancelColor, cancelColor, 255*untilCancel)
            djui_hud_set_font(FONT_RECOLOR_HUD)
            local xShake = math.random(-2, 2)*untilCancel
            local yShake = math.random(-2, 2)*untilCancel
            djui_hud_print_text(TEXT_ENDING_RUN, sWidth*0.5 - djui_hud_measure_text(TEXT_ENDING_RUN)*0.5 + xShake, sHeight*0.5 - 8 + yShake, 1)
        end
    end

    if m.action == ACT_MASTER_CAP_RESULTS then
        local record = (e.masterCapNewRecord and m.actionState > 3)
        local recordFlash = record and sins(m.actionTimer*0x1000) * 50.0 + 200.0 or 255
        djui_hud_set_color(0, 0, 0, 150)
        djui_hud_render_rect(0, 0, sWidth, sHeight)
        djui_hud_set_color(255, 255, 255, 255)


        -- Render Personal and Server Best
        djui_hud_set_font(FONT_NORMAL)
        local bestPersonal = TEXT_RESULT_PB .. tostring(e["masterCapRecordCoins"..course]) .. " - " .. timestamp(e["masterCapRecordTime"..course])
        djui_hud_set_color(recordFlash, recordFlash, record and 0 or 255, 255)
        djui_hud_print_text(bestPersonal, sWidth*(isSingle and 0.5 or 0.25) - djui_hud_measure_text(bestPersonal)*0.25, sHeight - 22, 0.5)

        if not isSingle then
            if leaderboardTop == nil then
                leaderboardTop = get_master_cap_leaderboard()[1]
            end
            local bestServer = TEXT_RESULT_SB .. leaderboardTop.displayCoins .. " - " .. leaderboardTop.displayTime
            local serverRecord = (e.masterCapCoins > leaderboardTop.coins or (e.masterCapCoins == leaderboardTop.coins and e.masterCapTimer < leaderboardTop.time)) and m.actionState > 3
            local serverRecordFlash = serverRecord and recordFlash or 1
            djui_hud_set_color(serverRecordFlash, serverRecordFlash, serverRecord and 0 or 255, 255)
            djui_hud_print_text(bestServer, sWidth*0.75 - djui_hud_measure_text(bestServer)*0.25, sHeight - 22, 0.5)
        end

        -- Render Coins Collected
        djui_hud_set_color(255, 255, 255, 255)
        djui_hud_set_font(FONT_NORMAL)
        djui_hud_print_text(TEXT_RESULT_COINS, sWidth*0.5 - djui_hud_measure_text(TEXT_RESULT_COINS)*0.25, 60, 0.5)
        local coinCount = m.actionState < 1 and 0 or e.masterCapCoins
        if m.actionState == 1 then
            coinCount = math.ceil(math.lerp(0, e.masterCapCoins, math.clamp(m.actionTimer/math.min(e.masterCapCoins, 150), 0, 1)))
        end
        local coinRender = tostring(coinCount)
        djui_hud_set_font(FONT_RECOLOR_HUD)
        djui_hud_print_text(coinRender, sWidth*0.5 - djui_hud_measure_text(coinRender) - 4, 80, 2)
        if m.actionState > 1 then
            local coinTimeRender = tostring(math.round(e.masterCapCoins/((e.masterCapCoinTimer > 0 and e.masterCapCoinTimer or 1)/30)*10)*0.1).."/s"
            djui_hud_print_text(coinTimeRender, sWidth*0.5 + djui_hud_measure_text(coinRender) + 16, 80 + 16, 1)
        end

        -- Render Timestamp
        djui_hud_set_font(FONT_NORMAL)
        djui_hud_print_text(TEXT_RESULT_TIME, sWidth*0.5 - djui_hud_measure_text(TEXT_RESULT_TIME)*0.25, 120, 0.5)
        local timeCount = m.actionState < 3 and 0 or e.masterCapCoinTimer
        if m.actionState == 3 then
            timeCount = math.lerp(0, e.masterCapCoinTimer, math.clamp(m.actionTimer/math.min(e.masterCapCoinTimer/30, 150), 0, 1))
        end
        local timeRender = timestamp(timeCount)
        djui_hud_set_font(FONT_RECOLOR_HUD)
        djui_hud_print_text(timeRender, sWidth*0.5 - djui_hud_measure_text(timeRender)*0.5 - 2, 140, 1)

        if m.actionState > 3 and e.masterCapNewRecord then
            djui_hud_set_font(FONT_HUD)
            djui_hud_set_color(recordFlash, recordFlash, recordFlash, 255)
            djui_hud_print_text(TEXT_RECORD, sWidth*0.5 - djui_hud_measure_text(TEXT_RECORD)*0.5 - 2, sHeight - 70, 1)
        end
    else
        leaderboardTop = nil
    end
end

local leaderboardView = false
local TEXT_LEADERBOARD = "Master Cap Challenge Leaderboard"
local TEXT_LEADERBOARD_TOGGLE = "R Button - Toggle Leaderboard"
local function star_select_leaderboard()
    if obj_get_first_with_behavior_id(id_bhvActSelector) == nil then
        leaderboardView = false
        leaderboard = nil
        --log_to_console(tostring(hud_get_value(HUD_DISPLAY_STARS)), CONSOLE_MESSAGE_INFO)
        --log_to_console(tostring(get_max_possible_stars()), CONSOLE_MESSAGE_INFO)
        return
    end
    if hud_get_value(HUD_DISPLAY_STARS) < get_max_possible_stars() then return end
    djui_hud_set_resolution(RESOLUTION_N64)
    local sWidth = djui_hud_get_screen_width() + 1
    local sHeight = djui_hud_get_screen_height()
    local m = gMarioStates[0]

    if m.controller.buttonPressed & R_TRIG ~= 0 then
        play_sound(SOUND_MENU_CLICK_CHANGE_VIEW, gGlobalSoundSource)
        leaderboardView = not leaderboardView
    end

    if leaderboardView then
        djui_hud_set_color(255, 255, 255, 255)
        djui_hud_render_rect(0, 0, sWidth, sHeight)
        djui_hud_set_color(0, 0, 0, 255)
        djui_hud_set_font(FONT_NORMAL)
        djui_hud_print_text(TEXT_LEADERBOARD, sWidth*0.5 - djui_hud_measure_text(TEXT_LEADERBOARD)*0.25 - 1, 10, 0.5)
        if leaderboard == nil then -- Load and sort table when loaded
            leaderboard = get_master_cap_leaderboard()
        else
            for i = 1, #leaderboard do
                local name = leaderboard[i].name
                local coins = leaderboard[i].displayCoins
                local time = leaderboard[i].displayTime
                local row = math.floor((i-1)/3)
                local x = sWidth*(1/(math.min(#leaderboard - row*3, 3) + 1))*(((i - 1)%3) + 1)
                local y = sHeight*0.5 - 24*(math.floor((#leaderboard)/3) + 1)*0.5 + 24*row
                djui_hud_render_rect(x - 0.5, y + 2, 1, 19)
                djui_hud_print_text(ordinal(i), x - djui_hud_measure_text(ordinal(i))*0.4 - 2, y, 0.4)
                djui_hud_print_text(name, x + 2, y, 0.4)
                y = y + 12
                djui_hud_print_text(coins, x - djui_hud_measure_text(coins)*0.3 - 2, y, 0.3)
                djui_hud_print_text(time, x + 2, y, 0.3)
            end
        end
    end

    djui_hud_set_color(0, 0, 0, 255)
    djui_hud_set_font(FONT_NORMAL)
    djui_hud_print_text(TEXT_LEADERBOARD_TOGGLE, sWidth - djui_hud_measure_text(TEXT_LEADERBOARD_TOGGLE)*0.3 - 5, sHeight - 14, 0.3)
end


local function pause_leaderboard()
    if not is_game_paused() or djui_hud_is_pause_menu_created() then--or gNetworkPlayers[0].currCourseNum == 0 then
        return
    end
    if hud_get_value(HUD_DISPLAY_STARS) < get_max_possible_stars() then return end
    djui_hud_set_resolution(RESOLUTION_N64)
    local sWidth = djui_hud_get_screen_width() + 1
    local sHeight = djui_hud_get_screen_height()

    djui_hud_set_color(255, 255, 255, 255)
    djui_hud_set_font(FONT_NORMAL)
    djui_hud_print_text(TEXT_LEADERBOARD, sWidth*0.2 - djui_hud_measure_text(TEXT_LEADERBOARD)*0.125 - 1, 10, 0.25)
    local leaderboard = get_master_cap_leaderboard()
    for i = 1, #leaderboard do
        local name = leaderboard[i].name
        local coins = leaderboard[i].displayCoins
        local time = leaderboard[i].displayTime
        local row = math.floor((i-1)/3)
        local x = 10
        local y = sHeight*0.5 - 24*(math.floor((#leaderboard)/3) + 1)*0.5 + 24*row
        djui_hud_print_text(ordinal(i) .. " " .. name .. " | " .. coins .. " - " .. time, x + 2, y, 0.4)
        y = y + 12
    end
end

local function hud_render()
    star_select_leaderboard()
    pause_leaderboard()
end

local function on_death()
    if gMasterCapStates[0].masterCapTimer > 0 then
        set_mario_finished_master_cap(gMarioStates[0])
        return false
    end
    if gMarioStates[0].action == ACT_MASTER_CAP_RESULTS then
        return false
    end
end

hook_event(HOOK_ON_LEVEL_INIT, level_init)
hook_event(HOOK_MARIO_UPDATE, master_cap_update)
hook_event(HOOK_UPDATE, master_cap_music_update)
hook_event(HOOK_ON_HUD_RENDER_BEHIND, master_cap_render)
hook_event(HOOK_ON_HUD_RENDER, hud_render)
hook_event(HOOK_ON_DEATH, on_death)