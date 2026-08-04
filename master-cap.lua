LEVEL_MASTER_CAP_STAGE = level_register("level_master_cap_stage_entry", COURSE_MAX, "Master Cap in Paradise", "master_cap_stage", 28000, 0x28, 0x28, 0x28)

local MUSIC_MASTER_CAP = audio_stream_load("music-master-cap.ogg")
local MUSIC_MASTER_CAP_END = audio_stream_load("music-master-cap-end.ogg")

audio_stream_set_loop_points(MUSIC_MASTER_CAP, 000917230, 003175168)
audio_stream_set_looping(MUSIC_MASTER_CAP, true)
audio_stream_set_loop_points(MUSIC_MASTER_CAP_END, 000917230, 003175168)
audio_stream_set_looping(MUSIC_MASTER_CAP_END, true)

gGlobalSyncTable.allowMasterCap = true
gGlobalSyncTable.allowMasterCapApi = nil

local function save_file_prefix(str)
    return "saveFile"..tostring(get_current_save_file_num())..(save_file_get_using_backup_slot() and "B" or "")..str
end

local function update_save()
    if not network_is_server() then return end
    if save_file_get_flags() < mod_storage_load_number(save_file_prefix("progress"), 0) then
        -- Assume if progress is lost, that the save had been deleted
        log_to_console("Better Coins: Save Data Lost, Deleting Custom Save Flags!", CONSOLE_MESSAGE_WARNING)
        mod_storage_remove(save_file_prefix("defeatFinalBowser"))
        mod_storage_remove(save_file_prefix("unlockedMasterCap"))
    end
    mod_storage_save_integer(save_file_prefix("progress"), save_file_get_flags())

    gGlobalSyncTable.defeatFinalBowser = mod_storage_load_bool(save_file_prefix("defeatFinalBowser"), false)
    gGlobalSyncTable.unlockedMasterCap = mod_storage_load_bool(save_file_prefix("unlockedMasterCap"), false)
end
update_save()

---@return boolean
---@return string
function master_cap_allowed(ignoreSwitch)
    local reasons = ""
    if gGlobalSyncTable.allowMasterCapApi ~= nil then
        reasons = reasons .. "API, "
    else
        if GAMEMODE_ACTIVE then
            reasons = reasons .. "Gamemode, "
        end
        if hud_get_value(HUD_DISPLAY_STARS) < get_romhack_star_count() then
            reasons = reasons .. "Star Count, "
        end
        if not gGlobalSyncTable.defeatFinalBowser then
            reasons = reasons .. "Bowser, "
        end
        --[[
        if not gGlobalSyncTable.unlockedMasterCap and not ignoreSwitch then
            reasons = reasons .. "Master Cap Switch, "
        end
        ]]
    end
    return reasons == "", string.sub(reasons, 1, -3)
end

local levelFallbackMerge = {
    [LEVEL_BOWSER_1] = LEVEL_BITDW,
    [LEVEL_BOWSER_2] = LEVEL_BITFS,
    [LEVEL_BOWSER_3] = LEVEL_BITS,
    [LEVEL_CASTLE_GROUNDS] = -1,
    [LEVEL_CASTLE] = -1,
    [LEVEL_CASTLE_COURTYARD] = -1,
}

local modLevelCount = {
    [CURR_ROMHACK] = LEVEL_COUNT
}

function master_cap_get_merged_level_num(levelNum, areaNum)
    levelNum = levelNum or gNetworkPlayers[0].currLevelNum
    areaNum = areaNum or gNetworkPlayers[0].currAreaIndex
    local hack = get_romhack_data()
    if hack.areaIndexed then
        levelNum = levelNum*7 + (areaNum - 1)
    end
    
    if hack.masterCapSpawns[levelNum] then
        if hack.masterCapSpawns[levelNum].levelMerge then
            return hack.masterCapSpawns[levelNum].levelMerge
        else
            return levelNum
        end
    end
    return levelFallbackMerge[levelNum] or levelNum
end

function master_cap_get_merged_player_level_num(index)
    local np = gNetworkPlayers[index]
    if not np.connected then return -1 end
    return master_cap_get_merged_level_num(np.currLevelNum, np.currAreaIndex)
end

-- Gets the current Index and Level Data for the current area
function master_cap_get_level(index)
    index = index or 0
    local levelIndex = master_cap_get_merged_player_level_num(index) or -1
    if not gMasterCapServerState[levelIndex] then
        master_cap_init_level(levelIndex)
    end
    return levelIndex, gMasterCapServerState[levelIndex]
end

local recordPrefixCoins = "bestCoins"
local recordPrefixTime = "bestTime"

gMasterCapServerState = {
    [-1] = {
        levelName = "Dummy",
        romhack = CURR_ROMHACK,
        saveLevelNum = -1,
        runState = 0,
        newRecord = false,
        capTimer = 0,
        totalTimer = 0,
        coinTimer = 0,
        coins = 0,
        spawnedScarecrow = false,
    }
}

function master_cap_init_level(levelIndex)
    local hackData = get_romhack_data()
    local romhack = CURR_ROMHACK
    local saveLevelIndex = levelIndex
    if levelIndex >= LEVEL_COUNT then
        --romhack = get_active_mod().relativePath:gsub("[/\\]+$", ""):gsub(".*[/\\]", "")
        modLevelCount[romhack] = (modLevelCount[romhack] or 0) + 1
        saveLevelIndex = modLevelCount[romhack]
    end
    
    local levelNum = hackData.areaIndexed and math.floor(levelIndex/7) or levelIndex
    local areaNum = hackData.areaIndexed and levelIndex%7 + 1 or 1
    gMasterCapServerState[levelIndex] = {
        levelName = get_level_name(get_level_course_num(levelNum), levelNum, areaNum),
        romhack = romhack,
        saveLevelNum = saveLevelIndex,
        runState = 0,
        newRecord = false,
        capTimer = 0,
        totalTimer = 0,
        coinTimer = 0,
        coins = 0,
        spawnedScarecrow = false,
    }
    
    if network_is_server() then
        local level = tostring(saveLevelIndex)
        local coinSave = romhack .. recordPrefixCoins .. level
        local timeSave = romhack .. recordPrefixTime .. level
        gGlobalSyncTable[coinSave] = mod_storage_load_number(coinSave, 0)
        gGlobalSyncTable[timeSave] = mod_storage_load_number(timeSave, 0)
    end
end

function master_cap_data_exists(levelIndex)
    return gMasterCapServerState[levelIndex] ~= nil
end

function master_cap_get_record(levelIndex)
    levelIndex = levelIndex or master_cap_get_level()
    local levelData = gMasterCapServerState[levelIndex]
    local coinSave = levelData.romhack .. recordPrefixCoins .. tostring(levelData.saveLevelNum)
    local timeSave = levelData.romhack .. recordPrefixTime .. tostring(levelData.saveLevelNum)
    return gGlobalSyncTable[coinSave] or 0, gGlobalSyncTable[timeSave] or 0
end

function master_cap_set_record(levelIndex, coins, time)
    local levelData = gMasterCapServerState[levelIndex]
    local coinSave = levelData.romhack .. recordPrefixCoins .. tostring(levelData.saveLevelNum)
    local timeSave = levelData.romhack .. recordPrefixTime .. tostring(levelData.saveLevelNum)
    gGlobalSyncTable[coinSave] = coins
    gGlobalSyncTable[timeSave] = time
    mod_storage_save(coinSave, tostring(math.round(coins)))
    mod_storage_save(timeSave, tostring(math.round(time)))
end

---@param m MarioState
function mario_master_cap_active(m, levelIndex)
    levelIndex = levelIndex or master_cap_get_level()
    local levelData = gMasterCapServerState[levelIndex]
    if levelIndex ~= master_cap_get_level(m.playerIndex) then return false end
    return levelData.runState == 1 and not gPlayerSyncTable[m.playerIndex].diedInRun
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

local PACKET_TYPE_MASTER_CAP_START = 1
local PACKET_TYPE_MASTER_CAP_STOP = 2
local PACKET_TYPE_MASTER_CAP_COIN = 3
local PACKET_TYPE_MASTER_CAP_UPDATE = 4
local PACKET_TYPE_MASTER_CAP_SCARECROW = 5
local PACKET_TYPE_MASTER_CAP_LEVEL_RESET = 6
function master_cap_start_course(levelIndex, noSync)
    levelIndex = levelIndex or master_cap_get_level()
    local levelData = gMasterCapServerState[levelIndex]
    masterCapMusicFreq = 1

    levelData.runState = 1
    levelData.newRecord = false
    levelData.capTimer = math.floor(gLevelValues.wingCapDuration*0.5)
    levelData.totalTimer = 0
    levelData.coinTimer = 0
    levelData.coins = 0

    play_transition(WARP_TRANSITION_FADE_INTO_COLOR, 10, 230, 230, 230)
    play_transition(WARP_TRANSITION_FADE_FROM_COLOR, 30, 230, 230, 230)
    play_sound(SOUND_MENU_STAR_SOUND, gGlobalSoundSource)

    if not noSync then
        network_send(true, {
            packetType = PACKET_TYPE_MASTER_CAP_START,
            levelIndex = levelIndex,
        })
    end
end

function master_cap_stop_course(levelIndex, newRecord, coinTimer, noSync)
    local levelData = gMasterCapServerState[levelIndex]

    levelData.capTimer = math.floor(gLevelValues.wingCapDuration*0.5)
    levelData.runState = 2
    if newRecord then
        levelData.newRecord = true
    end
    if coinTimer then
        levelData.coinTimer = coinTimer
    end

    if network_is_server() then
        local saveCoins, saveTime = master_cap_get_record(levelIndex)
        local currCoins = levelData.coins
        local currTime = levelData.coinTimer or 0
        if currCoins > 0 and
        currCoins > saveCoins or
        (currCoins == saveCoins and
        currTime < saveTime) then
            master_cap_set_record(levelIndex, currCoins, currTime)
            levelData.newRecord = true
            newRecord = true
        end
    end

    if levelIndex == master_cap_get_merged_level_num() then
        set_mario_finished_master_cap(gMarioStates[0])
    end

    if not noSync then
        network_send(true, {
            packetType = PACKET_TYPE_MASTER_CAP_STOP,
            levelIndex = levelIndex,
            newRecord = newRecord,
            coinTimer = levelData.coinTimer,
        })
    end
end

function master_cap_add_coin(levelIndex, value, index)
    levelIndex = levelIndex or master_cap_get_level(index)
    local levelData = gMasterCapServerState[levelIndex]

    levelData.capTimer = levelData.capTimer + value*30*(gPlayerSyncTable[index or 0].coinDensity)*(1/(network_player_master_cap_count(levelIndex)*0.5 + 0.5))
    levelData.coins = math.clamp(levelData.coins + value, 0, 999)

    if network_is_server() then
        levelData.coinTimer = levelData.totalTimer
    end

    if not index then
        network_send(true, {
            packetType = PACKET_TYPE_MASTER_CAP_COIN,
            index = network_global_index_from_local(0),
            levelIndex = levelIndex,
            coinsAdd = value,
        })
    end
end

--local function update_master_cap_courses 

local function on_packet_recieve(data)
    local levelIndex = data.levelIndex 
    local levelData = gMasterCapServerState[levelIndex]
    if data.packetType == PACKET_TYPE_MASTER_CAP_START then
        master_cap_start_course(levelIndex, true)
    elseif data.packetType == PACKET_TYPE_MASTER_CAP_STOP then
        master_cap_stop_course(levelIndex, data.newRecord, data.coinTimer, true)
    elseif data.packetType == PACKET_TYPE_MASTER_CAP_COIN then
        master_cap_add_coin(levelIndex, data.coinsAdd, network_local_index_from_global(data.index))
    elseif data.packetType == PACKET_TYPE_MASTER_CAP_UPDATE then
        levelData.capTimer = data.capTimer
        levelData.runState = 1 -- Hopefully fix Mel Bug
    elseif data.packetType == PACKET_TYPE_MASTER_CAP_SCARECROW then
        master_cap_request_scarecrow_spawn()
    elseif data.packetType == PACKET_TYPE_MASTER_CAP_LEVEL_RESET then
        levelData.runState = 0
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
    local levelIndex = master_cap_get_merged_player_level_num(m.playerIndex)
    local levelData = gMasterCapServerState[levelIndex]
    local masterCapCoins = levelData.coins
    local masterCapCoinTimer = levelData.coinTimer
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
            gPlayerSyncTable[0].diedInRun = false
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
    local levelIndex = master_cap_get_merged_player_level_num(m.playerIndex)
    local levelData = gMasterCapServerState[levelIndex]
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
        if levelData.runState ~= 1 then
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
    if (m.playerIndex == 0) {
        if (m.numLives <= -1) {
            m.marioObj.header.gfx.node.flags |= GRAPH_RENDER_INVISIBLE;
            level_trigger_warp(m, WARP_OP_DEATH);
            return set_mario_action(m, ACT_SOFT_BONK, 0);
        } else {
            m.marioObj.header.gfx.node.flags &= ~GRAPH_RENDER_INVISIBLE;
        }
    }
    ]]

    --if (gLocalBubbleCounter > 0) then gLocalBubbleCounter--; }

    -- pop bubble
    --[[
    if (m.playerIndex == 0 && distanceToPlayer < 120 && is_player_active(targetMarioState) && m.numLives != -1 && gLocalBubbleCounter == 0) {
        mario_pop_bubble(m);
        return TRUE;
    }
    ]]

    return 0;
end

hook_mario_action(ACT_MASTER_CAP_RESULTS, act_master_cap_results)
hook_mario_action(ACT_MASTER_CAP_BUBBLED, {every_frame = act_master_cap_bubbled, gravity = function(m) return 1 end})

function set_mario_finished_master_cap(m)
    gPlayerSyncTable[0].diedInRun = true
    if network_player_master_cap_count() <= 0 then
        if m.action ~= ACT_MASTER_CAP_RESULTS then
            set_mario_action(m, ACT_MASTER_CAP_RESULTS, 0)
        end
    else
        mario_set_master_cap_bubbled(m)
    end
end

function master_cap_box_active()
    local o = obj_get_first_with_behavior_id(id_bhvMasterCapBox)
    if not o then return false end
    if o.oSubAction > 0 then return false end
    return true, o
end

local E_MODEL_MASTER_CAP = smlua_model_util_get_id("master_box_geo")

local capSpawnRadius = 400
local function find_master_cap_spawn_position()
    local m = gMarioStates[0] ---@type MarioState
    local spawnPos = nil
    math.randomseed(hash(CURR_ROMHACK))
    local startPos = m.spawnInfo.startPos
    local startYaw = m.spawnInfo.startAngle.y
    local startFloorHeight, startFloor = find_floor(startPos.x, startPos.y, startPos.z)
    local minX = startPos.x - 1000
    local maxX = startPos.x + 1000
    local minZ = startPos.z - 1000
    local maxZ = startPos.z + 1000
    local spawnStart = get_time()
    local spawnIteration = 0
    while spawnPos == nil do
        local spawnStep = 0
        spawnIteration = spawnIteration + 1
        local findFloorX = math.random(minX, maxX)
        local findFloorZ = math.random(minZ, maxZ)
        local findFloorHeight, findFloor = find_floor(findFloorX, 0x4000, findFloorZ)
        if findFloor and findFloor ~= startFloor and not evilFloorTypes[findFloor.type] and math.ceil(findFloor.normal.y*50) == 50 then
            spawnStep = spawnStep + 1
            local surfaceX = (findFloor.vertex1.x + findFloor.vertex2.x + findFloor.vertex3.x)/3
            local surfaceY = (findFloor.vertex1.y + findFloor.vertex2.y + findFloor.vertex3.y)/3
            local surfaceZ = (findFloor.vertex1.z + findFloor.vertex2.z + findFloor.vertex3.z)/3
            local surfaceDist = math.sqrt((surfaceX - startPos.x)^2 + (surfaceZ - startPos.z)^2)

            local smallestEdge = nil
            for i = 0, 2 do
                local currNum = (i%3) + 1
                local nextNum = ((i+1)%3) + 1
                local currPos = findFloor["vertex"..tostring(currNum)]
                local nextPos = findFloor["vertex"..tostring(nextNum)]
                local edgeDist = math.sqrt((currPos.x - nextPos.x)^2 + (currPos.z - nextPos.z)^2)
                if not smallestEdge or smallestEdge > edgeDist then
                    smallestEdge = edgeDist
                end
            end

            if smallestEdge > math.max(1500 - math.floor(spawnIteration/250)*100, 100) then --- math.floor(spawnIteration/100)*100 then
                spawnStep = spawnStep + 1
                -- Be in eye-shot of mario without being too close
                local marioPos = {
                    x = startPos.x + sins(startYaw)*10*math.floor(spawnIteration/50),
                    y = startFloorHeight + 160,
                    z = startPos.z + coss(startYaw)*10*math.floor(spawnIteration/50),
                }
                local rayMario = collision_find_surface_on_ray(marioPos.x, marioPos.y, marioPos.z, surfaceX - marioPos.x, (surfaceY + 200) - marioPos.y, surfaceZ - marioPos.z, 64)
                if (not rayMario.surface --[[and surfaceDist > 500]]) then --or (spawnIteration > 500 and surfaceDist < 10000) then
                    spawnStep = spawnStep + 1
                    -- Avoid spawning close to trees
                    local nTree, nTreeDist = nearest_object_with_behavior_id_to_pos(surfaceX, surfaceY, surfaceZ, id_bhvTree)
                    if true then --not nTree or nTreeDist > 300 then
                        spawnStep = spawnStep + 1

                        -- Colc Angle
                        local doorWallAngle = atan2s(surfaceZ - startPos.z, surfaceX - startPos.x)
                        local doorWallDist = nil
                        for i = 0, 7 do
                            local ray = collision_find_surface_on_ray(surfaceX, surfaceY + 200, surfaceZ, sins(i*0x2000)*1000, 0, coss(i*0x2000)*1000, 1)
                            if ray.surface then
                                rayDist = math.sqrt((ray.hitPos.x - surfaceX)^2 + (ray.hitPos.z - surfaceZ)^2)
                                if not doorWallDist or doorWallDist > rayDist then
                                    doorWallAngle = i*0x2000
                                    doorWallDist = rayDist
                                end
                            end
                        end
                        spawnPos = {
                            x = surfaceX,
                            y = math.max(find_water_level(findFloorX, findFloorZ) - 100, surfaceY) + 300,
                            z = surfaceZ,
                            yaw = doorWallAngle + 0x8000,
                        }
                    end
                end
            end
        end 

        if m.action & ACT_FLAG_SWIMMING_OR_FLYING ~= 0 then
            return {x = 0, y = 0, z = 0, yaw = 0}
        end

        if get_time() - spawnStart > 10 then
            log_to_console(tostring("Better Coins: Master Cap took 10 Seconds after "..tostring(spawnIteration).." iterations, got stuck on Step "..tostring(spawnStep)..", giving up."), CONSOLE_MESSAGE_ERROR)
            return {x = 0, y = 0, z = 0, yaw = 0}
        end
    end

    log_to_console(tostring("Better Coins: Master Cap Spawned at ("..math.round(spawnPos.x)..", "..math.round(spawnPos.y)..", "..math.round(spawnPos.z)..") in [Level "..gNetworkPlayers[0].currLevelNum.." / Area "..gNetworkPlayers[0].currAreaIndex.."] on iteration "..tostring(spawnIteration)..", Took "..tostring(get_time() - spawnStart).." Seconds."))
    return spawnPos
end

function master_cap_get_box_spawn(level, area)
    if not romhackData[CURR_ROMHACK].masterCapSpawns[level] then
        romhackData[CURR_ROMHACK].masterCapSpawns[level] = {}
    end
    if not romhackData[CURR_ROMHACK].masterCapSpawns[level][area] and gNetworkPlayers[0].currLevelNum == level and gNetworkPlayers[0].currAreaIndex == area then
        romhackData[CURR_ROMHACK].masterCapSpawns[level][area] = find_master_cap_spawn_position()
    end
    return romhackData[CURR_ROMHACK].masterCapSpawns[level][area]
end

romhackData[CURR_ROMHACK].masterCapSpawns[LEVEL_MASTER_CAP_STAGE] = {
    [1] = {x = -6600, y = 400, z = -900}
}

local function find_master_door_spawn_position()
    local m = gMarioStates[0] ---@type MarioState
    local spawnPos = nil
    math.randomseed(hash(CURR_ROMHACK))
    local startPos = m.spawnInfo.startPos
    local startYaw = m.spawnInfo.startAngle.y
    local minX = startPos.x - 0x1000
    local maxX = startPos.x + 0x1000
    local minZ = startPos.z - 0x1000
    local maxZ = startPos.z + 0x1000
    local spawnStart = get_time()
    local spawnIteration = 0
    while spawnPos == nil do
        local spawnStep = 0
        spawnIteration = spawnIteration + 1
        local rayFloor = collision_find_surface_on_ray(math.random(minX, maxX), 0x4000, math.random(minZ, maxZ), 0, -0x8000, 0, 1)
        if rayFloor.surface and not evilFloorTypes[rayFloor.surface.type] and math.ceil(rayFloor.surface.normal.y*50) == 50 and rayFloor.hitPos.y > find_water_level(rayFloor.hitPos.x, rayFloor.hitPos.z) then
            spawnStep = spawnStep + 1
            local surfaceX = (rayFloor.surface.vertex1.x + rayFloor.surface.vertex2.x + rayFloor.surface.vertex3.x)/3
            local surfaceY = (rayFloor.surface.vertex1.y + rayFloor.surface.vertex2.y + rayFloor.surface.vertex3.y)/3
            local surfaceZ = (rayFloor.surface.vertex1.z + rayFloor.surface.vertex2.z + rayFloor.surface.vertex3.z)/3
            local surfaceDist = math.sqrt((surfaceX - startPos.x)^2 + (surfaceZ - startPos.z)^2)

            local smallestEdge = nil
            for i = 0, 2 do
                local currNum = (i%3) + 1
                local nextNum = ((i+1)%3) + 1
                local currPos = rayFloor.surface["vertex"..tostring(currNum)]
                local nextPos = rayFloor.surface["vertex"..tostring(nextNum)]
                local edgeDist = math.sqrt((currPos.x - nextPos.x)^2 + (currPos.z - nextPos.z)^2)
                if not smallestEdge or smallestEdge > edgeDist then
                    smallestEdge = edgeDist
                end
            end

            if smallestEdge > math.max(1500 - math.floor(spawnIteration/250)*100, 100) then --- math.floor(spawnIteration/100)*100 then
                spawnStep = spawnStep + 1
                -- Be in eye-shot of mario without being too close
                local marioPos = {
                    x = startPos.x + sins(startYaw)*10*math.floor(spawnIteration/50),
                    y = find_floor(startPos.x, startPos.y, startPos.z) + 160, --+ 50*math.floor(spawnIteration/50),
                    z = startPos.z + coss(startYaw)*10*math.floor(spawnIteration/50),
                }
                local rayMario = collision_find_surface_on_ray(marioPos.x, marioPos.y + 160, marioPos.z, surfaceX - marioPos.x, (surfaceY + 200) - marioPos.y, surfaceZ - marioPos.z, 64)
                if (not rayMario.surface and surfaceDist > 1000) then --or (spawnIteration > 500 and surfaceDist < 10000) then
                    spawnStep = spawnStep + 1
                    -- Avoid spawning close to trees
                    local nTree, nTreeDist = nearest_object_with_behavior_id_to_pos(surfaceX, surfaceY, surfaceZ, id_bhvTree)
                    if not nTree or nTreeDist > 300 then
                        spawnStep = spawnStep + 1

                        -- Colc Angle
                        local doorWallAngle = atan2s(surfaceZ - startPos.z, surfaceX - startPos.x)
                        local doorWallDist = nil
                        for i = 0, 7 do
                            local ray = collision_find_surface_on_ray(surfaceX, surfaceY + 200, surfaceZ, sins(i*0x2000)*1000, 0, coss(i*0x2000)*1000, 1)
                            if ray.surface then
                                rayDist = math.sqrt((ray.hitPos.x - surfaceX)^2 + (ray.hitPos.z - surfaceZ)^2)
                                if not doorWallDist or doorWallDist > rayDist then
                                    doorWallAngle = i*0x2000
                                    doorWallDist = rayDist
                                end
                            end
                        end
                        spawnPos = {
                            x = surfaceX,
                            y = surfaceY,
                            z = surfaceZ,
                            yaw = doorWallAngle + 0x8000,
                        }
                    end
                end
            end
        end 

        if get_time() - spawnStart > 10 then
            log_to_console(tostring("Better Coins: Master Door took 10 Seconds after "..tostring(spawnIteration).." iterations, got stuck on Step "..tostring(spawnStep)..", giving up."), CONSOLE_MESSAGE_ERROR)
            return {x = 0, y = 0, z = 0, yaw = 0}
        end
    end

    log_to_console(tostring("Better Coins: Master Door Spawned at ("..math.round(spawnPos.x)..", "..math.round(spawnPos.y)..", "..math.round(spawnPos.z)..") in [Level "..gNetworkPlayers[0].currLevelNum.." / Area "..gNetworkPlayers[0].currAreaIndex.."] on iteration "..tostring(spawnIteration)..", Took "..tostring(get_time() - spawnStart).." Seconds."))
    return spawnPos
end

function master_cap_get_door_spawn(level, area)
    if not romhackData[CURR_ROMHACK].masterDoorSpawns[level] then
        romhackData[CURR_ROMHACK].masterDoorSpawns[level] = {}
    end
    if not romhackData[CURR_ROMHACK].masterDoorSpawns[level][area] and gNetworkPlayers[0].currLevelNum == level and gNetworkPlayers[0].currAreaIndex == area then
        romhackData[CURR_ROMHACK].masterDoorSpawns[level][area] = find_master_door_spawn_position()
    end
    return romhackData[CURR_ROMHACK].masterDoorSpawns[level][area]
end

function master_cap_set_door_spawn(level, area, x, y, z, yaw)
    if not romhackData[CURR_ROMHACK].masterDoorSpawns[level] then
        romhackData[CURR_ROMHACK].masterDoorSpawns[level] = {}
    end
    romhackData[CURR_ROMHACK].masterDoorSpawns[level][area] = {x = x, y = y, z = z, yaw = yaw}
end

local function find_scarecrow_spawn_position()
    local spawnPos = nil
    math.randomseed(hash(CURR_ROMHACK))
    local minX = -0x2000
    local maxX = 0x2000
    local minZ = -0x2000
    local maxZ = 0x2000
    local spawnStart = get_time()
    local spawnIteration = 0
    while spawnPos == nil do
        local spawnStep = 0
        spawnIteration = spawnIteration + 1
        local rayFloor = collision_find_surface_on_ray(math.random(minX, maxX), 0x4000, math.random(minZ, maxZ), 0, -0x8000, 0, 1)
        if rayFloor.surface and not evilFloorTypes[rayFloor.surface.type] and rayFloor.surface.normal.y > 0.95 and rayFloor.hitPos.y > find_water_level(rayFloor.hitPos.x, rayFloor.hitPos.z) then
            spawnStep = spawnStep + 1
            local surfaceX = (rayFloor.surface.vertex1.x + rayFloor.surface.vertex2.x + rayFloor.surface.vertex3.x)/3
            local surfaceY = (rayFloor.surface.vertex1.y + rayFloor.surface.vertex2.y + rayFloor.surface.vertex3.y)/3
            local surfaceZ = (rayFloor.surface.vertex1.z + rayFloor.surface.vertex2.z + rayFloor.surface.vertex3.z)/3

            local smallestEdge = nil
            for i = 0, 2 do
                local currNum = (i%3) + 1
                local nextNum = ((i+1)%3) + 1
                local currPos = rayFloor.surface["vertex"..tostring(currNum)]
                local nextPos = rayFloor.surface["vertex"..tostring(nextNum)]
                local edgeDist = math.sqrt((currPos.x - nextPos.x)^2 + (currPos.z - nextPos.z)^2)
                if not smallestEdge or smallestEdge > edgeDist then
                    smallestEdge = edgeDist
                end
            end

            if smallestEdge > math.max(1500 - math.floor(spawnIteration/250)*100, 100) then --- math.floor(spawnIteration/100)*100 then
                spawnStep = spawnStep + 1
                spawnPos = {
                    x = surfaceX,
                    y = surfaceY,
                    z = surfaceZ,
                    yaw = 0,
                }
            end
        end 

        if get_time() - spawnStart > 10 then
            log_to_console(tostring("Better Coins: Scarecrow took 10 Seconds after "..tostring(spawnIteration).." iterations, got stuck on Step "..tostring(spawnStep)..", giving up."), CONSOLE_MESSAGE_ERROR)
            return {x = 0, y = 0, z = 0, yaw = 0}
        end
    end

    log_to_console(tostring("Better Coins: Scarecrow Spawned at ("..math.round(spawnPos.x)..", "..math.round(spawnPos.y)..", "..math.round(spawnPos.z)..") in [Level "..gNetworkPlayers[0].currLevelNum.." / Area "..gNetworkPlayers[0].currAreaIndex.."] on iteration "..tostring(spawnIteration)..", Took "..tostring(get_time() - spawnStart).." Seconds."))
    return spawnPos
end

function master_cap_get_scarecrow_spawn(level, area)
    level = level or gNetworkPlayers[0].currLevelNum
    area = area or gNetworkPlayers[0].currAreaIndex
    if not romhackData[CURR_ROMHACK].scarecrowSpawns[level] then
        romhackData[CURR_ROMHACK].scarecrowSpawns[level] = {}
    end
    if not romhackData[CURR_ROMHACK].scarecrowSpawns[level][area] and gNetworkPlayers[0].currLevelNum == level and gNetworkPlayers[0].currAreaIndex == area then
        romhackData[CURR_ROMHACK].scarecrowSpawns[level][area] = find_scarecrow_spawn_position()
    end
    return romhackData[CURR_ROMHACK].scarecrowSpawns[level][area]
end

function master_cap_set_scarecrow_spawn(level, area, x, y, z, yaw)
    if not romhackData[CURR_ROMHACK].scarecrowSpawns[level] then
        romhackData[CURR_ROMHACK].scarecrowSpawns[level] = {}
    end
    romhackData[CURR_ROMHACK].scarecrowSpawns[level][area] = {x = x, y = y, z = z, yaw = yaw}
end

-- Handles only spawning one scarecrow
function master_cap_request_scarecrow_spawn()
    local scarecrowSpawnPos = master_cap_get_scarecrow_spawn()
    spawn_sync_object(id_bhvMasterCapScarecrow, E_MODEL_SCARECROW, scarecrowSpawnPos.x, scarecrowSpawnPos.y, scarecrowSpawnPos.z, function(o)
        
    end)
end

local prevCoinDensity = {}

local prevCoinsBest = 0
local prevTimeBest = 0
local function on_sync()
    if not master_cap_allowed(true) then return end
    local levelIndex, levelData = master_cap_get_level()
    local hackData = get_romhack_data()
    gLevelValues.disableActs = true
    set_ttc_speed_setting(TTC_SPEED_STOPPED)

    local np = gNetworkPlayers[0]

    prevCoinsBest, prevTimeBest = master_cap_get_record(levelIndex)

    -- Count Coin Density for area
    gPlayerSyncTable[0].coinDensity = 1
    local areaCoinDistance = 0
    local areaCoinCount = 0
    -- Replace all Object Models
    for i = 0, NUM_OBJ_LISTS - 1 do
        local o = obj_get_first(i)
        local prevO = o
        while o ~= nil do
            local coinValue = math.max(o.oNumLootCoins, o.oDamageOrCoinValue, o.oCustomCoins)
            if coinValue > 0 then
                areaCoinCount = areaCoinCount + coinValue
                prevO = o
                areaCoinDistance = (areaCoinDistance + math.sqrt((o.oPosX + prevO.oPosX)^2 + (o.oPosY + prevO.oPosY)^2 + (o.oPosZ + prevO.oPosZ)^2))*0.5
            end
            o = obj_get_next(o)
        end
    end
    gPlayerSyncTable[0].coinDensity = areaCoinCount > 0 and math.ceil(areaCoinDistance / areaCoinCount)/100*0.8 + 0.2 or 1

    -- Failsafe exiting and reentering
    if not prevCoinDensity[np.currLevelNum] then
        prevCoinDensity[np.currLevelNum] = {}
    end
    if prevCoinDensity[np.currLevelNum][np.currAreaIndex] then
        gPlayerSyncTable[0].coinDensity = math.min(gPlayerSyncTable[0].coinDensity, prevCoinDensity[np.currLevelNum][np.currAreaIndex])
    end
    prevCoinDensity[np.currLevelNum][np.currAreaIndex] = gPlayerSyncTable[0].coinDensity

    log_to_console("Better Coins: Master Cap Coin Density set to " .. tostring(gPlayerSyncTable[0].coinDensity) .. " Seconds per Coin")

    local levelNum = gNetworkPlayers[0].currLevelNum
    local areaNum = gNetworkPlayers[0].currAreaIndex

    if hud_get_value(HUD_DISPLAY_STARS) >= get_romhack_star_count() then
        local doorSpawnsExist = false
        for _, _ in pairs(romhackData[CURR_ROMHACK].masterDoorSpawns) do
            doorSpawnsExist = true
            break
        end

        -- Check if another door already exists
        local doorCheck = false
        local o = obj_get_first_with_behavior_id(id_bhvDoorWarp)
        while o ~= nil and not doorCheck do
            doorCheck = obj_get_model_id_extended(o) == E_MODEL_MASTER_DOOR
            o = obj_get_next_with_same_behavior_id(o)
        end

        -- Spawn Door
        if not doorCheck and not doorSpawnsExist or (hackData.masterDoorSpawns[levelNum] and hackData.masterDoorSpawns[levelNum][areaNum]) then
            local masterDoorSpawn = master_cap_get_door_spawn(levelNum, areaNum)
            spawn_sync_object(id_bhvDoorWarp, E_MODEL_MASTER_DOOR, masterDoorSpawn.x, masterDoorSpawn.y, masterDoorSpawn.z, function(o)
                o.oFaceAnglePitch = 0
                o.oFaceAngleYaw = masterDoorSpawn.yaw or 0
                o.oFaceAngleRoll = 0

                o.oMoveAnglePitch = o.oFaceAnglePitch
                o.oMoveAngleYaw = o.oFaceAngleYaw
                o.oMoveAngleRoll = o.oFaceAngleRoll
                oTagLib.obj_set_nametag(o, "WORK IN PROGRESS\n  DO NOT ENTER", {r = 255, g = 0, b = 0})
            end)
        end
        
        -- Spawn Cap
        if master_cap_allowed() and levelIndex ~= -1 or (romhackData[CURR_ROMHACK].masterCapSpawns[levelNum] and romhackData[CURR_ROMHACK].masterCapSpawns[levelNum][areaNum]) then
            --if master_cap_data_exists(levelNum) then return end
            if hud_get_value(HUD_DISPLAY_COINS) > 0 then return end
            if obj_get_first_with_behavior_id(id_bhvMasterCapBox) ~= nil then return end

            local masterCapSpawn = master_cap_get_box_spawn(levelNum, areaNum)
            if levelData ~= nil and levelData.runState == 0 then
                spawn_sync_object(id_bhvMasterCapBox, E_MODEL_MASTER_CAP, masterCapSpawn.x, masterCapSpawn.y, masterCapSpawn.z, function (o)
                    o.oFaceAnglePitch = 0
                    o.oFaceAngleYaw = masterCapSpawn.yaw or 0
                    o.oFaceAngleRoll = 0

                    o.oMoveAnglePitch = o.oFaceAnglePitch
                    o.oMoveAngleYaw = o.oFaceAngleYaw
                    o.oMoveAngleRoll = o.oFaceAngleRoll
                end)
            end
        end
    end
end

local prevRunState = 0
local runCrouchTimer = 0
local function master_cap_music_update(levelData)
    local m = gMarioStates[0]
    local runState = levelData and levelData.runState or 0
    if gPlayerSyncTable[0].diedInRun then
        runState = 2
    elseif runState == 2 and not (m.action == ACT_MASTER_CAP_BUBBLED or m.action == ACT_MASTER_CAP_RESULTS) then
        runState = 0
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
        local freqTargetTime = 1 + (math.max(450 - levelData.capTimer, 0)/450)*0.3
        local freqTargetEnd = 1 + (runCrouchTimer/90)*0.3
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
            prevRunState = runState
        end
    end
end

local prevBowserBeat = gGlobalSyncTable.defeatFinalBowser
local prevFileProgress = save_file_get_flags()
local function master_cap_update()
    local levelIndex, levelData = master_cap_get_level()
    local m = gMarioStates[0] ---@type MarioState
    local p = gPlayerSyncTable[0]
    local np = gNetworkPlayers[0]

    p.starExitAct = (m.action == ACT_STAR_DANCE_EXIT or m.action == ACT_JUMBO_STAR_CUTSCENE)

    -- Check for Defeating Final Bowser
    if m.action == ACT_JUMBO_STAR_CUTSCENE or np.currLevelNum == LEVEL_ENDING then
        gGlobalSyncTable.defeatFinalBowser = true
    end
    if network_is_server() then
        -- Saves if someone has defeated bowser
        if prevBowserBeat ~= gGlobalSyncTable.defeatFinalBowser then
            prevBowserBeat = gGlobalSyncTable.defeatFinalBowser
            mod_storage_save_bool(save_file_prefix("defeatFinalBowser"), true)
            log_to_console("Better Coins: Saved Bowser Being Defeated")
        end

        -- Saves progress updating and saving
        if not get_save_file_modified() and save_file_get_flags() > prevFileProgress then
            update_save()
        end
    end

    --[[
    if m.controller.buttonPressed & Y_BUTTON ~= 0 then
        spawn_sync_object(id_bhvMasterCapScarecrow, E_MODEL_SCARECROW, m.pos.x, m.pos.y, m.pos.z - 300, function(o)
            
        end)
    end
    ]]

    -- Actual Master Cap Stuffs

    if not master_cap_allowed(true) then return end
    master_cap_music_update(levelData)
    
    -- Locally Apply Master Cap
    local runActive = levelData ~= nil and levelData.runState == 1
    if runActive then
        m.capTimer = levelData.capTimer
        m.flags = m.flags | (MARIO_WING_CAP | MARIO_VANISH_CAP | MARIO_METAL_CAP)
        if m and m.area and m.area.camera then
            if (m.area.camera.cutscene == CUTSCENE_STAR_SPAWN) or (m.area.camera.cutscene == CUTSCENE_RED_COIN_STAR_SPAWN) then
                disable_time_stop_including_mario()
                m.freeze = 1
                m.area.camera.cutscene = 0
            end
        end

        if m.action ~= ACT_MASTER_CAP_RESULTS then
            sPrevAct[m.playerIndex].prevActionAnimFrame = m.marioObj.header.gfx.animInfo.animFrame
            sPrevAct[m.playerIndex].prevActionAnimAccel = m.marioObj.header.gfx.animInfo.animAccel
            sPrevAct[m.playerIndex].prevAction = m.action
            sPrevAct[m.playerIndex].prevActionTimer = m.actionTimer
            sPrevAct[m.playerIndex].prevActionState = m.actionState
            sPrevAct[m.playerIndex].prevActionArg = m.actionArg
        end

        if (m.action & ACT_FLAG_AIR == 0 and (m.forwardVel == 0 and m.vel.y <= 0) and m.controller.buttonDown & Z_TRIG ~= 0) and not p.diedInRun then
            runCrouchTimer = runCrouchTimer + 1
            if runCrouchTimer > 90 then
                set_mario_finished_master_cap(m)
                runCrouchTimer = 0
            end
        else
            runCrouchTimer = math.max(runCrouchTimer - 3, 0)
        end

        if p.diedInRun then
            set_mario_finished_master_cap(m)
        end
    else
        p.diedInRun = false
    end

    -- Ensure there's a master cap table to push info to
    for pI = 0, MAX_PLAYERS - 1 do
        local levelIndex, levelData = master_cap_get_level(pI)
        if levelIndex ~= -1 and not levelData then
            master_cap_init_level(levelIndex)
        end
    end

    if network_is_server() then
        -- Update All Levels' Runs
        for levelIndex, levelData in pairs(gMasterCapServerState) do
            if levelData.runState == 1 then
                if levelData.coins >= 999 then
                    master_cap_stop_course(levelIndex)
                end
                if levelData.coins >= gLevelValues.coinsRequiredForCoinStar*1.5 then
                    if not levelData.spawnedScarecrow then
                        local targetIndex = 0
                        for pI = 0, MAX_PLAYERS - 1 do
                            if levelIndex == master_cap_get_level(pI) then
                                targetIndex = pI
                                break
                            end
                        end
                        if targetIndex ~= 0 then
                            network_send_to(targetIndex, true, {packetType = PACKET_TYPE_MASTER_CAP_SCARECROW})
                        else
                            master_cap_request_scarecrow_spawn()
                        end
                        log_to_console("Better Coins: Master Cap - Requested index "..tostring(targetIndex).." to spawn a Scarecrow")
                    end
                    levelData.spawnedScarecrow = true
                else
                    levelData.spawnedScarecrow = false
                end

                if levelData.capTimer > 0 then
                    if network_player_connected_count() <= 1 and (m.action & ACT_FLAG_INTANGIBLE ~= 0 or is_game_paused()) then
                        -- Don't decrease
                    else
                        levelData.capTimer = levelData.capTimer - 1
                    end

                    if network_player_master_cap_count(levelIndex) == 0 then
                        levelData.stallNoPlayers = levelData.stallNoPlayers + 1
                        
                        if levelData.stallNoPlayers > 30 then
                            master_cap_stop_course(levelIndex)
                            local isRecord = levelData.newRecord
                            local noOneInLevel = true
                            for pI = 0, MAX_PLAYERS - 1 do
                                if levelIndex == master_cap_get_level(pI) then
                                    noOneInLevel = false
                                end
                            end

                            -- Check if no one is in the level to report "ditched"
                            if noOneInLevel then
                                djui_popup_create_global(levelData.levelName..(levelData.levelName:sub(-1):lower() == "s" and "'" or "'s").."\nMaster Cap Challenge\nwas Ditched...\n\n" .. (isRecord and "\\#ffff00\\New Record!\n" or "") .. "Coins: " .. tostring(levelData.coins) .. " | Time: " .. timestamp(levelData.coinTimer), isRecord and 6 or 5)
                                levelData.runState = 2
                            end
                        end
                    else
                        levelData.stallNoPlayers = 0
                    end
                else
                    master_cap_stop_course(levelIndex)
                end

                for pI = 0, MAX_PLAYERS - 1 do
                    local m = gMarioStates[pI]
                    if mario_master_cap_active(m, levelIndex) and gPlayerSyncTable[pI].starExitAct then
                        master_cap_stop_course(levelIndex)
                    end
                end

                if levelData.capTimer%30 == 0 then
                    network_send(false, {
                        packetType = PACKET_TYPE_MASTER_CAP_UPDATE,
                        levelIndex = levelIndex,
                        capTimer = levelData.capTimer,
                    })
                end

                levelData.totalTimer = levelData.totalTimer + 1
            elseif levelData.runState == 2 then
                local noOneInLevel = true
                for pI = 0, MAX_PLAYERS - 1 do
                    if levelIndex == master_cap_get_level(pI) then
                        noOneInLevel = false
                    end
                end
                if noOneInLevel then
                    log_to_console("Better Coins: Master Cap / Level" .. tostring(levelIndex) .. " - Setting Run State to 0")
                    levelData.runState = 0
                    network_send(true, {
                        packetType = PACKET_TYPE_MASTER_CAP_LEVEL_RESET,
                        levelIndex = levelIndex,
                    })
                end
            end
        end
    else
        if levelData.capTimer > 0 then
            if m.action & ACT_FLAG_INTANGIBLE == 0 or network_player_connected_count() > 1 then
                levelData.capTimer = math.max(levelData.capTimer - 1, 5)
            end
        end
    end
end

local TEXT_MASTER_CAP = "Collect as many coins as possible!"
local TEXT_RESULT_COINS = "Coins Collected:"
local TEXT_RESULT_PB = "Personal Best: "
local TEXT_RESULT_TIME = "Time Spent:"
local TEXT_RECORD = "HI SCORE"
local TEXT_ENDING_RUN = "ENDING RUN EARLY..."
local TEXT_GIVING_UP = "GIVING UP..."
local function master_cap_render()
    local m = gMarioStates[0]
    local levelIndex, levelData = master_cap_get_level()
    djui_hud_set_resolution(RESOLUTION_N64)
    local sWidth = djui_hud_get_screen_width() + 1
    local sHeight = djui_hud_get_screen_height()
    local runState = levelData ~= nil and levelData.runState == 1
    if runState then
        djui_hud_set_font(FONT_HUD)
        local textW, textH = djui_hud_measure_text(TEXT_MASTER_CAP)
        local textScale = math.min(sWidth/(textW + 32), 1)
        --djui_hud_print_text(TEXT_MASTER_CAP, sWidth*0.5 - textW*textScale*0.5, sHeight - (32 + math.abs(math.sin(e.masterCapTotalTimer/30))*8)*textScale, textScale)

        if runCrouchTimer > 15 then
            local untilCancelInterp = math.max(runCrouchTimer + (m.action == ACT_CROUCHING and -1 or 3) - 15, 0)/75
            local untilCancel = math.max(runCrouchTimer - 15, 0)/75
            local cancelColor = 127 - 127*untilCancel
            djui_hud_set_color(255, cancelColor, cancelColor, 255)
            djui_hud_render_rect_interpolated(0, 0, sWidth*untilCancelInterp, 2, 0, 0, sWidth*untilCancel, 2)
            djui_hud_set_color(255, cancelColor, cancelColor, 255*untilCancel)
            djui_hud_set_font(FONT_RECOLOR_HUD)
            local xShake = math.random(-2, 2)*untilCancel
            local yShake = math.random(-2, 2)*untilCancel
            local text = network_player_master_cap_count() > 1 and TEXT_GIVING_UP or TEXT_ENDING_RUN
            djui_hud_print_text(text, sWidth*0.5 - djui_hud_measure_text(text)*0.5 + xShake, sHeight*0.5 - 8 + yShake, 1)
        end
    end

    if m.action == ACT_MASTER_CAP_RESULTS then
        local record = levelData.newRecord and m.actionState > 3
        local recordFlash = record and sins(m.actionTimer*0x1000) * 50.0 + 200.0 or 255
        djui_hud_set_color(0, 0, 0, 150)
        djui_hud_render_rect(0, 0, sWidth, sHeight)
        djui_hud_set_color(255, 255, 255, 255)

        local currCoins = levelData.coins
        local currTime = levelData.coinTimer

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

local function on_death()
    local m = gMarioStates[0]
    local levelIndex, levelData = master_cap_get_level()
    if levelData.runState == 1 then
        set_mario_finished_master_cap(m)
        return false
    end
    if gPlayerSyncTable[0].diedInRun then
        return false
    end
end

local function allow_force_water_interaction(m, water)
    return m.action ~= ACT_MASTER_CAP_BUBBLED and m.action ~= ACT_MASTER_CAP_RESULTS
end

local function easier_mario_viewing_expirience(m)
    local levelIndex, levelData = master_cap_get_level()
    if levelData.runState == 1 then
        local bodyState = m.marioBodyState
        m.fadeWarpOpacity = 245
        bodyState.modelState = (MODEL_STATE_METAL | MODEL_STATE_NOISE_ALPHA) | (0x100 | 245)
    end
end

local function check_late_entry()
    if not master_cap_allowed() then return end
    gLevelValues.disableActs = true
    set_ttc_speed_setting(TTC_SPEED_STOPPED)

    --[[
    local levelNum = gNetworkPlayers[0].currLevelNum
    if master_cap_data_get_field(nil, "runState") == 1 and levelNum == master_cap_get_merged_level_num() then
        gPlayerSyncTable[0].diedInRun = true
    end
    ]]
end

local function on_mods_loaded()
    -- Block Character Select from Opening Mid-Run
    if _G.charSelectExists then
        _G.charSelect.hook_allow_menu_open(function ()
            local levelIndex, levelData = master_cap_get_level()
            return not levelData.runState ~= 1
        end)
    end
end

hook_event(HOOK_ON_SYNC_VALID, on_sync)
hook_event(HOOK_UPDATE, master_cap_update)
hook_event(HOOK_ON_HUD_RENDER_BEHIND, master_cap_render)
hook_event(HOOK_ON_DEATH, on_death)
hook_event(HOOK_MARIO_UPDATE, easier_mario_viewing_expirience)
hook_event(HOOK_ALLOW_FORCE_WATER_ACTION, allow_force_water_interaction)
hook_event(HOOK_ON_LEVEL_INIT, check_late_entry)
hook_event(HOOK_ON_MODS_LOADED, on_mods_loaded)