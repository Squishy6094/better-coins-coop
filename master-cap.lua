local MUSIC_MASTER_CAP = audio_stream_load("music-master-cap.ogg")
local MUSIC_MASTER_CAP_END = audio_stream_load("music-master-cap-end.ogg")

audio_stream_set_loop_points(MUSIC_MASTER_CAP, 000917230, 003175168)
audio_stream_set_looping(MUSIC_MASTER_CAP, true)
audio_stream_set_loop_points(MUSIC_MASTER_CAP_END, 000917230, 003175168)
audio_stream_set_looping(MUSIC_MASTER_CAP_END, true)

local levelMerge = {
    [LEVEL_BOWSER_1] = LEVEL_BITDW,
    [LEVEL_BOWSER_2] = LEVEL_BITFS,
    [LEVEL_BOWSER_3] = LEVEL_BITS,
    [LEVEL_CASTLE_GROUNDS] = -1,
    [LEVEL_CASTLE] = -1,
    [LEVEL_CASTLE_COURTYARD] = -1,
}

local function get_merged_level_num(levelNum)
    levelNum = levelNum or gNetworkPlayers[0].currLevelNum
    return levelMerge[levelNum] or levelNum
end

local MASTER_CAP_BOX_SCALE = 3

local recordPrefixCoins = ROMHACK.."bestCoins"
local recordPrefixTime = ROMHACK.."bestTime"

local PACKET_TYPE_MASTER_CAP_START = 1
local PACKET_TYPE_MASTER_CAP_STOP = 2
local PACKET_TYPE_MASTER_CAP_COIN = 3
local PACKET_TYPE_MASTER_CAP_UPDATE = 4
gMasterCapServerState = {}
for i = 0, LEVEL_COUNT do
    levelNum = get_merged_level_num(i)
    gMasterCapServerState[levelNum] = {
        runActive = false,
        newRecord = false,
        capTimer = 0,
        totalTimer = 0,
        coinTimer = 0,
        coins = 0,
    }
    
    if network_is_server() then
        local level = tostring(levelNum)
        gGlobalSyncTable[recordPrefixCoins..level] = tonumber(mod_storage_load(recordPrefixCoins..level)) or 0
        gGlobalSyncTable[recordPrefixTime..level] = tonumber(mod_storage_load(recordPrefixTime..level)) or 0
    end
end

function master_cap_get_record(levelNum)
    level = tostring(get_merged_level_num(levelNum))
    return gGlobalSyncTable[recordPrefixCoins..level] or 0, gGlobalSyncTable[recordPrefixTime..level] or 0
end

function master_cap_set_record(levelNum, coins, time)
    level = tostring(get_merged_level_num(levelNum))
    gGlobalSyncTable[recordPrefixCoins..level] = coins
    gGlobalSyncTable[recordPrefixTime..level] = time
    mod_storage_save(recordPrefixCoins..level, tostring(math.round(coins)))
    mod_storage_save(recordPrefixTime..level, tostring(math.round(time)))
end

function master_cap_data_get_field(levelNum, field)
    levelNum = get_merged_level_num(levelNum)
    return gMasterCapServerState[levelNum][field]
end

function master_cap_data_set_field(levelNum, field, value)
    levelNum = get_merged_level_num(levelNum)
    gMasterCapServerState[levelNum][field] = value
end

---@param m MarioState
function mario_master_cap_active(m, levelNum)
    levelNum = get_merged_level_num(levelNum)
    if levelNum ~= get_merged_level_num(gNetworkPlayers[m.playerIndex].currLevelNum) then return false end
    return master_cap_data_get_field(levelNum, "runActive") and (m.action ~= ACT_MASTER_CAP_BUBBLED and m.action ~= ACT_MASTER_CAP_RESULTS)
end

function network_player_master_cap_count(currLevel)
    local count = 0
    for i = 0, MAX_PLAYERS - 1 do
        if mario_master_cap_active(gMarioStates[i], currLevel) then
            count = count + 1
        end
    end
    return count
end


function master_cap_start_course(levelNum, noSync)
    levelNum = get_merged_level_num(levelNum)
    masterCapMusicFreq = 1

    master_cap_data_set_field(levelNum, "runActive", true)
    master_cap_data_set_field(levelNum, "newRecord", false)
    master_cap_data_set_field(levelNum, "capTimer", math.floor(gLevelValues.wingCapDuration*0.5))
    master_cap_data_set_field(levelNum, "totalTimer", 0)
    master_cap_data_set_field(levelNum, "coinTimer", 0)
    master_cap_data_set_field(levelNum, "coins", 0)

    if not noSync then
        network_send(true, {
            packetType = PACKET_TYPE_MASTER_CAP_START,
            levelNum = levelNum,
        })
    end
end

function master_cap_stop_course(levelNum, newRecord, coinTimer, noSync)
    levelNum = get_merged_level_num(levelNum)

    master_cap_data_set_field(levelNum, "capTimer", math.floor(gLevelValues.wingCapDuration*0.5))
    master_cap_data_set_field(levelNum, "runActive", false)
    if newRecord then
        master_cap_data_set_field(levelNum, "newRecord", true)
    end
    if coinTimer then
        master_cap_data_set_field(levelNum, "coinTimer", coinTimer)
    end

    if network_is_server() then
        local saveCoins, saveTime = master_cap_get_record(levelNum)
        local currCoins = master_cap_data_get_field(levelNum, "coins")
        local currTime = master_cap_data_get_field(levelNum, "coinTimer") or 0
        if currCoins > 0 and
        currCoins > saveCoins or
        (currCoins == saveCoins and
        currTime < saveTime) then
            master_cap_set_record(levelNum, currCoins, currTime)
            master_cap_data_set_field(levelNum, "newRecord", true)
            newRecord = true
        end
    end

    if levelNum == get_merged_level_num() then
        set_mario_finished_master_cap(gMarioStates[0])
    end

    if not noSync then
        network_send(true, {
            packetType = PACKET_TYPE_MASTER_CAP_STOP,
            levelNum = levelNum,
            newRecord = newRecord,
            coinTimer = master_cap_data_get_field(levelNum, "coinTimer"),
        })
    end
end

function master_cap_add_coin(levelNum, value, noSync)
    levelNum = get_merged_level_num(levelNum)
    
    local prevCapTimer = master_cap_data_get_field(levelNum, "capTimer")
    local prevCoins = master_cap_data_get_field(levelNum, "coins")

    master_cap_data_set_field(levelNum, "capTimer", prevCapTimer + value*25*(1/network_player_master_cap_count(levelNum)))
    master_cap_data_set_field(levelNum, "coins", prevCoins + value)

    if network_is_server() then
        master_cap_data_set_field(levelNum, "coinTimer", master_cap_data_get_field(levelNum, "totalTimer"))
    end

    if not noSync then
        network_send(true, {
            packetType = PACKET_TYPE_MASTER_CAP_COIN,
            levelNum = levelNum,
            coinsAdd = value,
        })
    end
end

--local function update_master_cap_courses 

local function on_packet_recieve(data)
    if data.packetType == PACKET_TYPE_MASTER_CAP_START then
        master_cap_start_course(data.levelNum, true)
    elseif data.packetType == PACKET_TYPE_MASTER_CAP_STOP then
        master_cap_stop_course(data.levelNum, data.newRecord, data.coinTimer, true)
    elseif data.packetType == PACKET_TYPE_MASTER_CAP_COIN then
        master_cap_add_coin(data.levelNum, data.coinsAdd, true)
    elseif data.packetType == PACKET_TYPE_MASTER_CAP_UPDATE then
        master_cap_data_set_field(data.levelNum, "capTimer", data.capTimer)
    end
end

hook_event(HOOK_ON_PACKET_RECEIVE, on_packet_recieve)

-------------
-- Actions --
-------------

ACT_MASTER_CAP_RESULTS = allocate_mario_action(ACT_GROUP_CUTSCENE | ACT_FLAG_INTANGIBLE)
ACT_MASTER_CAP_BUBBLED = allocate_mario_action(ACT_FLAG_MOVING)

local sPrevAct = {}
for i = 0, MAX_PLAYERS - 1 do
    sPrevAct[i] = {
        prevActionAnimFrame = 0,
        prevActionAnimAccel = 0,
        prevAction = 0,
        prevActionTimer = 0,
        prevActionState = 0,
        prevActionArg = 0,
    }
end
---@param m MarioState
local function act_master_cap_results(m)
    if not m then return end
    local pA = sPrevAct[m.playerIndex]
    local masterCapCoins = master_cap_data_get_field(nil, "coins")
    local masterCapCoinTimer = master_cap_data_get_field(nil, "coinTimer")
    m.marioObj.header.gfx.animInfo.animFrame = pA.prevActionAnimFrame or 0
    m.marioObj.header.gfx.animInfo.animAccel = 0
    m.flags = m.flags & ~(MARIO_WING_CAP | MARIO_VANISH_CAP | MARIO_METAL_CAP)
    --camera_freeze()
    if m.playerIndex == 0 then
        game_unpause()
        set_menu_mode(-1)
    end
    local pressedA = m.controller.buttonPressed & A_BUTTON ~= 0
    if m.actionState == 0 then -- Stall
        if m.actionTimer > 10 then
            m.actionState = m.actionState + 1
            m.actionTimer = 0
        end
    elseif m.actionState == 1 then -- Count Coins
        if m.actionTimer > math.min(masterCapCoins, 150) or pressedA then
            m.actionState = m.actionState + 1
            m.actionTimer = 0
        end
    elseif m.actionState == 2 then -- Stall
        if m.actionTimer > 10 then
            m.actionState = m.actionState + 1
            m.actionTimer = 0
        end
    elseif m.actionState == 3 then -- Count Time
        if m.actionTimer > math.min(masterCapCoinTimer/30, 150) or pressedA then
            m.actionState = m.actionState + 1
            m.actionTimer = 0
        end
    elseif m.actionState == 4 then -- Await Input
        if pressedA then
            m.actionState = m.actionState + 1
            m.actionTimer = 0
        end
    else
        --camera_unfreeze()
        if pA.prevAction == ACT_MASTER_CAP_BUBBLED then
            m.marioObj.oIntangibleTimer = 0;
            mario_pop_bubble(m)
        else
            m.action = pA.prevAction
            m.marioObj.header.gfx.animInfo.animAccel = pA.prevActionAnimAccel
            m.actionArg = pA.prevActionArg
            m.actionTimer = pA.prevActionTimer
            m.actionState = pA.prevActionState
        end
    end


    m.actionTimer = m.actionTimer + 1
end

local function act_master_cap_bubbled(m)
    if not m then return end
    if (m.playerIndex == 0 and m.area.camera.mode == CAMERA_MODE_WATER_SURFACE) then
        set_camera_mode(m.area.camera, CAMERA_MODE_FREE_ROAM, 1);
    end
    local targetMarioState = nearest_antibubble_mario_state_to_object(m.marioObj);
    if not targetMarioState then
        targetMarioState = gMarioStates[0];
    end

    local target = targetMarioState.marioObj;
    local angleToPlayer = obj_angle_to_object(m.marioObj, target);
    local pitchToPlayer = obj_pitch_to_object(m.marioObj, target);
    local distanceToPlayer = dist_between_objects(m.marioObj, target);

    -- Show results if run has ended
    if (m.playerIndex == 0) then
        if not master_cap_data_get_field(nil, "runActive") then
            return set_mario_finished_master_cap(m)
        end
    end

    -- create bubble
    if (m.bubbleObj == nil and is_player_in_local_area(m) ~= 0) then
        m.bubbleObj = spawn_non_sync_object(id_bhvMasterCapBubblePlayer, E_MODEL_BUBBLE_PLAYER, m.marioObj.oPosX, m.marioObj.oPosY, m.marioObj.oPosZ, function(o)
            if (m.bubbleObj ~= nil) then
                m.bubbleObj.heldByPlayerIndex = m.playerIndex;
            end
        end);
    end

    -- force inactive state
    if (m.heldObj ~= nil) then mario_drop_held_object(m); end
    m.heldByObj = nil;
    m.marioObj.oIntangibleTimer = -1;
    m.squishTimer = 0;
    m.bounceSquishTimer = 0;
    set_character_animation(m, CHAR_ANIM_SLEEP_IDLE);

    -- force inputs
    local oldPitch = m.faceAngle.x;
    local oldYaw   = m.faceAngle.y;
    m.faceAngle.x = 0;
    m.faceAngle.y = m.intendedYaw;
    m.forwardVel = m.intendedMag * 1.6;
    if (m.input & INPUT_A_DOWN ~= 0) then m.vel.y = m.vel.y + 5.5; end
    if (m.input & INPUT_Z_DOWN ~= 0) then m.vel.y = m.vel.y - 5.5; end

    -- set and smooth velocity
    local oldVel = { x = m.vel.x, y = m.vel.y, z = m.vel.z };
    set_vel_from_pitch_and_yaw(m);
    m.vel.x = (oldVel.x * 0.9 + m.vel.x * 0.1);
    m.vel.y = (oldVel.y * 0.9 + m.vel.y * 0.1);
    m.vel.z = (oldVel.z * 0.9 + m.vel.z * 0.1);

    -- enforce minimum y for the level
    local hasMinY, minY = get_area_minimum_y();
    if (hasMinY and m.pos.y < minY) then
        m.vel.y = math.max(0, m.vel.y);
        m.pos.y = m.pos.y + 25;
    end

    -- move player
    local step = perform_air_step(m, 0)
    if step == AIR_STEP_LANDED then
        m.vel.y = m.vel.y + 10.0;
    elseif step == AIR_STEP_HIT_LAVA_WALL then
        m.vel.x = m.vel.x * -0.99;
        m.vel.z = m.vel.z * -0.99;
    end
    -- always look toward target
    m.faceAngle.x = pitchToPlayer - approach_s32(math.s16(pitchToPlayer - oldPitch), 0, 0x600, 0x600);
    m.faceAngle.y = angleToPlayer - approach_s32(math.s16(angleToPlayer - oldYaw  ), 0, 0x600, 0x600);
    m.marioObj.header.gfx.angle.x = m.faceAngle.x;
    m.marioObj.header.gfx.angle.y = m.faceAngle.y;

    -- offset the player model to be in the center of the bubble
    bubbled_offset_visual(m);

    -- make invisible on -1 lives
    --[[
    if (m->playerIndex == 0) {
        if (m->numLives <= -1) {
            m->marioObj->header.gfx.node.flags |= GRAPH_RENDER_INVISIBLE;
            level_trigger_warp(m, WARP_OP_DEATH);
            return set_mario_action(m, ACT_SOFT_BONK, 0);
        } else {
            m->marioObj->header.gfx.node.flags &= ~GRAPH_RENDER_INVISIBLE;
        }
    }
    ]]

    --if (gLocalBubbleCounter > 0) then gLocalBubbleCounter--; }

    -- pop bubble
    --[[
    if (m->playerIndex == 0 && distanceToPlayer < 120 && is_player_active(targetMarioState) && m->numLives != -1 && gLocalBubbleCounter == 0) {
        mario_pop_bubble(m);
        return TRUE;
    }
    ]]

    return 0;
end

hook_mario_action(ACT_MASTER_CAP_RESULTS, act_master_cap_results)
hook_mario_action(ACT_MASTER_CAP_BUBBLED, {every_frame = act_master_cap_bubbled, gravity = function(m) return 1 end})

function set_mario_finished_master_cap(m)
    if network_player_master_cap_count() == 0 then
        set_mario_action(m, ACT_MASTER_CAP_RESULTS, 0)
    else
        mario_set_master_cap_bubbled(m)
    end
end

---@param o Object
local function bhv_master_cap_box_init(o)
    o.oFlags = o.oFlags | OBJ_FLAG_SET_FACE_YAW_TO_MOVE_YAW | OBJ_FLAG_UPDATE_GFX_POS_AND_ANGLE
    o.collisionData = gGlobalObjectCollisionData.exclamation_box_outline_seg8_collision_08025F78
    o.oCollisionDistance = 450

    cur_obj_set_home_once()

    o.oPosY = o.oHomeY + 0x8000
    o.oSubAction = 0

    o.areaTimerType = AREA_TIMER_TYPE_MAXIMUM
    o.areaTimer = 0
    o.areaTimerDuration = 300

    smlua_anim_util_set_animation(o, ANIM_MASTER_CAP_BOX_IDLE)

    network_init_object(o, true, {
        "oExclamationBoxForce",
        "areaTimer",
    })
end

---@param o Object
local function bhv_master_cap_box_loop(o)
    cur_obj_scale(MASTER_CAP_BOX_SCALE)
    local masterCapHitbox = get_temp_object_hitbox()
    masterCapHitbox.interactType = INTERACT_BREAKABLE
    masterCapHitbox.downOffset = 0
    masterCapHitbox.damageOrCoinValue = 0
    masterCapHitbox.health = 1
    masterCapHitbox.numLootCoins = 0
    masterCapHitbox.radius = 30
    masterCapHitbox.height = 30
    masterCapHitbox.hurtboxRadius = 30
    masterCapHitbox.hurtboxHeight = 30
    obj_set_hitbox(o, masterCapHitbox)
    local nearestM = nearest_mario_state_to_object(o)

    if o.oAction == 0 then
        o.oExclamationBoxForce = 0
        o.oAction = 1
    elseif o.oAction == 1 then
        if (o.oTimer == 0) then
            cur_obj_unhide()
            cur_obj_become_tangible()
            o.oInteractStatus = 0
            --o.oPosY = o.oHomeY
            o.oGraphYOffset = 0.0
        end

        o.oPosY = math.lerp(o.oPosY, o.oHomeY + math.sin(o.areaTimer/10)*30, 0.1)
        if nearestM and nearestM.numCoins > 0 then
            o.oHomeY = o.oHomeY + o.oVelY
            o.oVelY = o.oVelY + 1
            o.oSubAction = 1
        end

        local isNearest = (nearestM ~= nil and nearestM == gMarioStates[0])
        if (o.oExclamationBoxForce ~= 0 or isNearest) then
            if (o.oExclamationBoxForce ~= 0 or (isNearest and cur_obj_was_attacked_or_ground_pounded() ~= 0)) then
                if (o.oExclamationBoxForce == 0) then
                    o.oExclamationBoxForce = 1
                    network_send_object(o, true)
                    o.oExclamationBoxForce = 0
                end
                o.oExclamationBoxUnkFC = 0x4000
                o.oVelY = 30.0
                o.oGravity = -8.0
                o.oFloorHeight = o.oPosY
                o.oAction = 2
                spawn_mist_particles()
                cur_obj_play_sound_1(SOUND_OBJ_KING_BOBOMB_JUMP)
                queue_rumble_data_object(o, 5, 80)
                cur_obj_become_intangible()
            end
        end
        load_object_collision_model()

        if cur_obj_check_if_at_animation_end() ~= 0 then
            cur_obj_play_sound_1(SOUND_OBJ_BOWSER_SPINNING)
        end
    elseif o.oAction == 2 then
        cur_obj_move_using_fvel_and_gravity()
        if o.oPosY <= o.oHomeY then
            o.oPosY = o.oHomeY
            if o.oVelY < -4.0 then
                o.oVelY = -o.oVelY * 0.35
            else
                o.oVelY = 0.0
                o.oGravity = 0.0
            end
        end

        local t = o.oTimer

        o.oExclamationBoxUnkFC = o.oExclamationBoxUnkFC + 0x1800
        local sin = sins(o.oExclamationBoxUnkFC)
        local cos = coss(o.oExclamationBoxUnkFC)

        local impact = math.max(0, 1 - t / 10)
        local squash = 1.0 - 0.6 * impact * math.abs(sin)
        local stretch = 1.0 + 0.8 * impact * math.abs(sin)

        local increase = 1.0
        if t < 5 then
            increase = 1.0 + 0.35 * (1 - t / 5)
        elseif t < 10 then
            increase = 1.0 + 0.15 * ((t - 5) / 5)
        end

        local bounce = sin * (14.0 * MASTER_CAP_BOX_SCALE) * (0.8 ^ (t / 6))
        o.oGraphYOffset = bounce

        o.oFaceAngleYaw = o.oFaceAngleYaw + 0x900
        o.oFaceAngleRoll = sin * 0x1200 * impact
        o.oFaceAnglePitch = cos * 0x800 * impact

        local scale = MASTER_CAP_BOX_SCALE * increase
        o.header.gfx.scale.x = stretch * scale
        o.header.gfx.scale.y = squash * scale
        o.header.gfx.scale.z = stretch * scale

        if t >= 14 then
            o.oAction = 3
        end
        if t >= 4 then
            play_transition(WARP_TRANSITION_FADE_INTO_COLOR, 10, 230, 230, 230)
        end
    elseif o.oAction == 3 then
        if sync_object_is_owned_locally(o.oSyncID) ~= 0 then
            master_cap_start_course()
        end
        play_transition(WARP_TRANSITION_FADE_FROM_COLOR, 30, 230, 230, 230)
        play_sound(SOUND_MENU_STAR_SOUND, gGlobalSoundSource)
        play_character_sound(gMarioStates[0], CHAR_SOUND_HERE_WE_GO)
        spawn_mist_particles_variable(0, 0, 46.0)
        spawn_triangle_break_particles(20, 139, 0.3, o.oAnimState)
        create_sound_spawner(SOUND_GENERAL_BREAK_BOX)
        cur_obj_hide()
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

local E_MODEL_MASTER_CAP = smlua_model_util_get_id("master_box_geo")

local nearestObjPos = {x = 0, y = 0, z = 0}
local capSpawnRadius = 400
local prevCoinsBest = 0
local prevTimeBest = 0
local prevLevelNum = 0
local function on_sync()
    if hud_get_value(HUD_DISPLAY_STARS) >= ROMHACK_STARS then
        gLevelValues.disableActs = true
    end

    local m = gMarioStates[0]
    local levelNum = get_merged_level_num()

    prevCoinsBest, prevTimeBest = master_cap_get_record(levelNum)

    if hud_get_value(HUD_DISPLAY_STARS) >= ROMHACK_STARS and levelNum ~= -1 then
        if prevLevelNum ~= levelNum then
            prevLevelNum = levelNum
            if master_cap_data_get_field(levelNum, "runActive") then
                set_mario_finished_master_cap(m)
                return
            end
        end
        if obj_get_first_with_behavior_id(id_bhvMasterCapBox) ~= nil then return end

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
                        local currDist = math.sqrt((castFloorSpawn.x - o.oPosX)^2 + (castFloorSpawn.y - o.oPosY)^2 + (nearestObjPos.z - o.oPosZ)^2)
                        if (currDist < prevDist) then
                            nearestObjPos.x = o.oPosX
                            nearestObjPos.y = o.oPosY
                            nearestObjPos.z = o.oPosZ
                            prevDist = math.sqrt((castFloorSpawn.x - nearestObjPos.x)^2 + (castFloorSpawn.y - nearestObjPos.y)^2 + (castFloorSpawn.z - nearestObjPos.z)^2)
                        end
                    end
                    o = obj_get_next(o)
                end
            end
        end

        nearestObjPos = (collision_find_surface_on_ray(m.pos.x, m.pos.y + 160, m.pos.z, nearestObjPos.x - m.pos.x, nearestObjPos.y - m.pos.y, nearestObjPos.z - m.pos.z, 128).hitPos)

        local objX = math.clamp(math.lerp(castFloorSpawn.x, nearestObjPos.x, 0.5), castFloorSpawn.x - capSpawnRadius, castFloorSpawn.x + capSpawnRadius)
        local objY = math.clamp(nearestObjPos.y, castFloorSpawn.y - 300, castFloorSpawn.y) + 300
        local objZ = math.clamp(math.lerp(castFloorSpawn.z, nearestObjPos.z, 0.5), castFloorSpawn.z - capSpawnRadius, castFloorSpawn.z + capSpawnRadius)
        spawn_sync_object(id_bhvMasterCapBox, E_MODEL_MASTER_CAP, objX, objY, objZ, function (o) end)
    end
end

local prevRunState = 0

local function master_cap_music_update()
    local m = gMarioStates[0]
    local runActive = master_cap_data_get_field(nil, "runActive")
    local masterCapTimer = master_cap_data_get_field(nil, "capTimer")
    local runState = 0
    if runActive then
        runState = 1
    end
    if m.action == ACT_MASTER_CAP_RESULTS or m.action == ACT_MASTER_CAP_BUBBLED then
        runState = 2
    end

    if runState > 0 then
        local volume = is_game_paused() and 0.25 or 0.80
        local volShift = runState ~= 2 and 1 or math.clamp((masterCapMusicFreq - 0.7)/0.6, 0, 1)
        local volShiftInv = 1 - volShift
        if prevRunState ~= runState then
            stop_cap_music()
            audio_stream_play(MUSIC_MASTER_CAP, false, 0.75)
            audio_stream_play(MUSIC_MASTER_CAP_END, false, 0.75)
            prevRunState = runState
        end
        if runState == 1 then
            play_secondary_music(0, 0, 0, 50)
        end
        local freqTargetTime = 1 + (math.max(450 - masterCapTimer, 0)/450)*0.3
        local freqTargetEnd = 1 --+ (e.masterCapCrouchTimer/90)*0.3
        local freqTarget = runState == 2 and 0.7 or math.max(freqTargetTime, freqTargetEnd)

        masterCapMusicFreq = math.lerp(masterCapMusicFreq, freqTarget, 0.02)
        audio_stream_set_frequency(MUSIC_MASTER_CAP, masterCapMusicFreq)
        audio_stream_set_frequency(MUSIC_MASTER_CAP_END, masterCapMusicFreq)
        audio_stream_set_volume(MUSIC_MASTER_CAP, volume * volShift)
        audio_stream_set_volume(MUSIC_MASTER_CAP_END, volume * volShiftInv)
    else
        if prevRunState ~= runState then
            audio_stream_set_position(MUSIC_MASTER_CAP, 0)
            audio_stream_set_position(MUSIC_MASTER_CAP_END, 0)
            audio_stream_set_frequency(MUSIC_MASTER_CAP, 1)
            audio_stream_set_frequency(MUSIC_MASTER_CAP_END, 1)
            audio_stream_stop(MUSIC_MASTER_CAP)
            audio_stream_stop(MUSIC_MASTER_CAP_END)
            stop_secondary_music(50)
            masterCapMusicFreq = 0
        end
    end
end

local levelsProcessed = {}
local function master_cap_update()
    local m = gMarioStates[0]
    gPlayerSyncTable[0].starExitAct = (m.action == ACT_STAR_DANCE_EXIT or m.action == ACT_JUMBO_STAR_CUTSCENE)
    master_cap_music_update()
    --if m.playerIndex ~= 0 then return end
    -- Locally Apply Master Cap
    local runActive = master_cap_data_get_field(nil, "runActive")
    if runActive then
        m.capTimer = master_cap_data_get_field(nil, "capTimer")
        m.flags = m.flags | (MARIO_WING_CAP | MARIO_VANISH_CAP | MARIO_METAL_CAP)
        if m and m.area ~= nil and m.area.camera ~= nil and (m.area.camera.cutscene == CUTSCENE_STAR_SPAWN) or (m.area.camera.cutscene == CUTSCENE_RED_COIN_STAR_SPAWN) then
            disable_time_stop_including_mario()
            m.freeze = 1
            m.area.camera.cutscene = 0
        end
        if m.action ~= ACT_MASTER_CAP_RESULTS then
            sPrevAct[m.playerIndex].prevActionAnimFrame = m.marioObj.header.gfx.animInfo.animFrame
            sPrevAct[m.playerIndex].prevActionAnimAccel = m.marioObj.header.gfx.animInfo.animAccel
            sPrevAct[m.playerIndex].prevAction = m.action
            sPrevAct[m.playerIndex].prevActionTimer = m.actionTimer
            sPrevAct[m.playerIndex].prevActionState = m.actionState
            sPrevAct[m.playerIndex].prevActionArg = m.actionArg
        end
    end

    prevRunState = master_cap_data_get_field(nil, "runActive")

    if network_is_server() then
        -- Update All Levels' Runs
        for i = 1, LEVEL_COUNT do
            local levelNum = get_merged_level_num(i)
            if master_cap_data_get_field(levelNum, "runActive") and not levelsProcessed[levelNum] then
                levelsProcessed[levelNum] = true
                local capTimer = master_cap_data_get_field(levelNum, "capTimer")
                if capTimer > 0 then
                    if network_player_connected_count() <= 1 and (m.action & ACT_FLAG_INTANGIBLE ~= 0 or is_game_paused()) then
                        -- Don't decrease
                    else
                        capTimer = capTimer - 1
                    end
                    if network_player_master_cap_count(levelNum) == 0 then
                        local stallNoPlayers = master_cap_data_get_field(levelNum, "stallNoPlayers")
                        stallNoPlayers = stallNoPlayers + 1
                        master_cap_data_set_field(levelNum, "stallNoPlayers", stallNoPlayers)

                        if stallNoPlayers > 30 then
                            master_cap_stop_course(levelNum)
                            local courseNum = get_level_course_num(levelNum)
                            djui_popup_create_global(get_level_name(courseNum, levelNum, 1).."'s\nMaster Cap Challenge\nwas Ditched...", 3)
                        end
                    else
                        master_cap_data_set_field(levelNum, "stallNoPlayers", 0)
                    end
                else
                    master_cap_stop_course(levelNum)
                end

                local coins = master_cap_data_get_field(levelNum, "coins")
                if coins > 999 then
                    master_cap_stop_course(levelNum)
                end

                for pI = 0, MAX_PLAYERS - 1 do
                    local m = gMarioStates[pI]
                    if mario_master_cap_active(m, levelNum) and gPlayerSyncTable[pI].starExitAct then
                        master_cap_stop_course(levelNum)
                    end
                end

                master_cap_data_set_field(levelNum, "capTimer", capTimer)
                if capTimer%30 == 0 then
                    network_send(false, {
                        packetType = PACKET_TYPE_MASTER_CAP_UPDATE,
                        levelNum = levelNum,
                        capTimer = capTimer,
                    })
                end

                local totalTimer = master_cap_data_get_field(levelNum, "totalTimer")
                totalTimer = totalTimer + 1
                master_cap_data_set_field(levelNum, "totalTimer", totalTimer)
            end
        end

        for i = 1, LEVEL_COUNT do
            levelsProcessed[i] = false
        end
    else
        local capTimer = master_cap_data_get_field(nil, "capTimer")
        if capTimer > 0 then
            if m.action & ACT_FLAG_INTANGIBLE == 0 or network_player_connected_count() > 1 then
                capTimer = math.max(capTimer - 1, 5)
            end
        end
        master_cap_data_set_field(nil, "capTimer", capTimer)
    end



        --set_mario_finished_master_cap(m)
        
        -- Hold timer on acts
        --if m.action & ACT_FLAG_INTANGIBLE == 0 then
        --    e.masterCapTimer = math.max(e.masterCapTimer - 1, 0)
        --    e.masterCapTotalTimer = e.masterCapTotalTimer + 1
        --end

        -- Get best active mario stats
        --[[


        if m.action == ACT_CROUCHING then
            e.masterCapCrouchTimer = e.masterCapCrouchTimer + 1
            if e.masterCapCrouchTimer > 90 then
                set_mario_finished_master_cap(m)
            end
        else
            e.masterCapCrouchTimer = math.max(e.masterCapCrouchTimer - 3, 0)
        end
        ]]

    -- Network sync shitt
    --if m.playerIndex == 0 and get_global_timer()%10 == 0 then 
    --    network_send(false, gMasterCapStates[0])
    --end
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
    djui_hud_set_resolution(RESOLUTION_N64)
    local sWidth = djui_hud_get_screen_width() + 1
    local sHeight = djui_hud_get_screen_height()
    local runActive = master_cap_data_get_field(nil, "runActive")
    if runActive then
        djui_hud_set_font(FONT_HUD)
        local textW, textH = djui_hud_measure_text(TEXT_MASTER_CAP)
        local textScale = math.min(sWidth/(textW + 32), 1)
        --djui_hud_print_text(TEXT_MASTER_CAP, sWidth*0.5 - textW*textScale*0.5, sHeight - (32 + math.abs(math.sin(e.masterCapTotalTimer/30))*8)*textScale, textScale)

        --[[
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
        ]]
    end

    if m.action == ACT_MASTER_CAP_RESULTS then
        local record = master_cap_data_get_field(nil, "newRecord") and m.actionState > 3
        local recordFlash = record and sins(m.actionTimer*0x1000) * 50.0 + 200.0 or 255
        djui_hud_set_color(0, 0, 0, 150)
        djui_hud_render_rect(0, 0, sWidth, sHeight)
        djui_hud_set_color(255, 255, 255, 255)

        local currCoins = master_cap_data_get_field(nil, "coins")
        local currTime = master_cap_data_get_field(nil, "coinTimer")

        -- Render Personal and Server Best
        djui_hud_set_font(FONT_NORMAL)
        local printCoinsBest = record and currCoins or prevCoinsBest
        local printTimeBest = record and currTime or prevTimeBest
        local printBest = TEXT_RESULT_PB .. tostring(printCoinsBest) .. " - " .. timestamp(printTimeBest)
        djui_hud_set_color(recordFlash, recordFlash, record and 0 or 255, 255)
        djui_hud_print_text(printBest, sWidth*0.5 - djui_hud_measure_text(printBest)*0.25, sHeight - 22, 0.5)

        -- Render Coins Collected
        djui_hud_set_color(255, 255, 255, 255)
        djui_hud_set_font(FONT_NORMAL)
        djui_hud_print_text(TEXT_RESULT_COINS, sWidth*0.5 - djui_hud_measure_text(TEXT_RESULT_COINS)*0.25, 60, 0.5)
        local coinCount = m.actionState < 1 and 0 or currCoins
        if m.actionState == 1 then
            coinCount = math.ceil(math.lerp(0, currCoins, math.clamp(m.actionTimer/math.min(currCoins, 150), 0, 1)))
        end
        local coinRender = tostring(coinCount)
        djui_hud_set_font(FONT_RECOLOR_HUD)
        djui_hud_print_text(coinRender, sWidth*0.5 - djui_hud_measure_text(coinRender) - 4, 80, 2)
        if m.actionState > 1 then
            local coinTimeRender = tostring(math.round(currCoins/(math.max(currTime, 1)/30)*10)*0.1).."/s"
            djui_hud_print_text(coinTimeRender, sWidth*0.5 + djui_hud_measure_text(coinRender) + 16, 80 + 16, 1)
        end

        -- Render Timestamp
        djui_hud_set_font(FONT_NORMAL)
        djui_hud_print_text(TEXT_RESULT_TIME, sWidth*0.5 - djui_hud_measure_text(TEXT_RESULT_TIME)*0.25, 120, 0.5)
        local timeCount = m.actionState < 3 and 0 or currTime
        if m.actionState == 3 then
            timeCount = math.lerp(0, currTime, math.clamp(m.actionTimer/math.min(currTime/30, 150), 0, 1))
        end
        local timeRender = timestamp(timeCount)
        djui_hud_set_font(FONT_RECOLOR_HUD)
        djui_hud_print_text(timeRender, sWidth*0.5 - djui_hud_measure_text(timeRender)*0.5 - 2, 140, 1)

        if record then
            djui_hud_set_font(FONT_HUD)
            djui_hud_set_color(recordFlash, recordFlash, recordFlash, 255)
            djui_hud_print_text(TEXT_RECORD, sWidth*0.5 - djui_hud_measure_text(TEXT_RECORD)*0.5 - 2, sHeight - 70, 1)
        end
    end
end

--[[
local leaderboardView = false
local TEXT_LEADERBOARD = "Master Cap Challenge Leaderboard"
local TEXT_LEADERBOARD_TOGGLE = "R Button - Toggle Leaderboard"
local function star_select_leaderboard()
    if obj_get_first_with_behavior_id(id_bhvActSelector) == nil then
        leaderboardView = false
        leaderboard = nil
        --log_to_console(tostring(hud_get_value(HUD_DISPLAY_STARS)), CONSOLE_MESSAGE_INFO)
        --log_to_console(tostring(ROMHACK_STARS), CONSOLE_MESSAGE_INFO)
        return
    end
    if hud_get_value(HUD_DISPLAY_STARS) < ROMHACK_STARS then return end
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
    if not is_game_paused() or djui_hud_is_pause_menu_created() then--or gNetworkPlayers[0].currLevelNum == 0 then
        return
    end
    if hud_get_value(HUD_DISPLAY_STARS) < ROMHACK_STARS then return end
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
    --star_select_leaderboard()
    --pause_leaderboard()
end
]]

local function on_death()
    local m = gMarioStates[0]
    if master_cap_data_get_field(nil, "runActive") then
        set_mario_finished_master_cap(m)
        return false
    end
    if m.action == ACT_MASTER_CAP_RESULTS or m.action == ACT_MASTER_CAP_BUBBLED then
        return false
    end
end

hook_event(HOOK_ON_SYNC_VALID, on_sync)
hook_event(HOOK_UPDATE, master_cap_update)
hook_event(HOOK_ON_HUD_RENDER_BEHIND, master_cap_render)
--hook_event(HOOK_ON_HUD_RENDER, hud_render)
hook_event(HOOK_ON_DEATH, on_death)