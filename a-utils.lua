-- Load Libraries
oTagLib = require("libs/oTagLib")
hudDodge = require("libs/hudDodge")

---@class Object
---@field oIsCarried integer
---@field oCustomCoins integer
---@field oThwompGroundPounded integer
---@field oThwompHitstun integer
---@field oHitMario integer
---@field oPrevHealth number
---@field oBooCoinFace integer
---@field oBooCoinAnimState integer
---@field oBooCoinSwitchMusic integer
---@field oScarecrowLastY integer
define_custom_obj_fields({
    oIsCarried = "u32",
    --oIsCarried = { type = "u32", global = true }, -- used in API
    oCustomCoins = "u32",
    oThwompGroundPounded = "u32",
    oThwompHitstun = "u32",
    oThwompPrevAngle = "u32",
    oHitMario = "u32",
    oPrevHealth = "f32",
    oBooCoinFace = "u32",
    oBooCoinAnimState = "u32",
    oBooCoinSwitchMusic = "u32",
    oScarecrowLastY = "f32",
})

evilFloorTypes = {
    [SURFACE_BURNING] = true,
    [SURFACE_DEEP_MOVING_QUICKSAND] = true,
    [SURFACE_DEEP_QUICKSAND] = true,
    [SURFACE_INSTANT_MOVING_QUICKSAND] = true,
    [SURFACE_INSTANT_QUICKSAND] = true,
    [SURFACE_DEATH_PLANE] = true,
    [SURFACE_VERY_SLIPPERY] = true,
    [SURFACE_VERTICAL_WIND] = true,
    [SURFACE_HORIZONTAL_WIND] = true,
}

--- @param obj Object
--- Replacement for DROP_TO_FLOOR()
function object_drop_to_floor(obj)
    local x = obj.oPosX
    local y = obj.oPosY
    local z = obj.oPosZ

    local floorHeight = find_floor_height(x, y + 200, z)
    obj.oPosY = floorHeight
    obj.oMoveFlags = (obj.oMoveFlags | OBJ_MOVE_ON_GROUND)
end

--[[
function obj_pos_to_vec3f(o)
    if not o then o = get_current_object() end
    return {x = o.oPosX, y = o.oPosY, z = o.oPosZ}
end
]]

function obj_to_obj_dist(o1, o2)
    if not o1 or not o2 then return 0x8000 end
    return math.sqrt((o1.oPosX - o2.oPosX)^2 + (o1.oPosY - o2.oPosY)^2 + (o1.oPosZ - o2.oPosZ)^2)
end

function obj_is_in_container(o)
    -- Check if inside Clam
    local oClam = obj_get_nearest_object_with_behavior_id(o, id_bhvClamShell)
    if oClam ~= nil and obj_to_obj_dist(o, oClam) < 100 then
        if oClam.oAction ~= 1 or oClam.oTimer < 15 then
            return true, oClam
        end
        return false, oClam
    end

    -- Check if inside breakable box
    local oBox = obj_get_nearest_object_with_behavior_id(o, id_bhvBreakableBox)
    if oBox ~= nil and obj_to_obj_dist(o, oBox) < 300 then
        return true, oBox
    end
    return false
end

-- Automatically check for if the objects is synced

local og_network_init_object = network_init_object
function network_init_object(object, standardSync, fieldTable)
    if object.oSyncID ~= 0 and sync_object_is_initialized(object.oSyncID) then
        return og_network_init_object(object, standardSync, fieldTable)
    end
end

local og_network_send_object = network_send_object
function network_send_object(object, reliable)
    if object.oSyncID ~= 0 and sync_object_is_initialized(object.oSyncID) then
        return og_network_send_object(object, reliable)
    end
end

function nearest_mario_state_to_pos(x, y, z)
    if not x or not y or not z then return end
    local nearest = nil;
    local nearestDist = 0;
    for i = 0, MAX_PLAYERS - 1 do
        local m = gMarioStates[i]
        if (not m.marioObj) then goto continue end
        if (not m.visibleToObjects) then goto continue end
        if (not is_player_active(gMarioStates[i])) then goto continue end
        local dist = math.sqrt((gMarioStates[i].pos.x - x)^2 + (gMarioStates[i].pos.y - y)^2 + (gMarioStates[i].pos.z - z)^2);
        if (nearest == nil or dist < nearestDist) then
            nearest = gMarioStates[i];
            nearestDist = dist;
        end
        ::continue::
    end

    return nearest;
end

function nearest_object_with_behavior_id_to_pos(x, y, z, bhvId)
    if not x or not y or not z or not bhvId then return end
    local nearest = nil;
    local nearestDist = 0;
    local o = obj_get_first_with_behavior_id(bhvId)
    while o do
        local dist = math.sqrt((o.oPosX - x)^2 + (o.oPosY - y)^2 + (o.oPosZ - z)^2);
        if (nearest == nil or dist < nearestDist) then
            nearest = o;
            nearestDist = dist;
        end
        o = obj_get_next_with_same_behavior_id(o)
    end

    return nearest, nearestDist
end

function timestamp(frames)
    if type(frames) ~= "number" then return "x:xx:x" end
    local seconds = math.round(frames) / 30
    local minutes = math.floor(seconds / 60)
    local milliseconds = math.floor((seconds - math.floor(seconds)) * 10)
    seconds = math.floor(seconds % 60)
    return minutes > 0 and string.format("%d:%02d.%01d", minutes, seconds, milliseconds) or string.format("%01d.%01d", seconds, milliseconds)
end

function ordinal(n)
    local s = tostring(n)
    -- Handle 11, 12, 13
    if #s >= 2 then
        local lastTwo = tonumber(string.sub(s, -2))
        if lastTwo >= 11 and lastTwo <= 13 then
            return s .. "th"
        end
    end
    
    local lastDigit = tonumber(string.sub(s, -1))
    if lastDigit == 1 then return s .. "st"
    elseif lastDigit == 2 then return s .. "nd"
    elseif lastDigit == 3 then return s .. "rd"
    else return s .. "th"
    end
end

function hash(word)
    local result = 5381
    for i = 1, #word do
        result = (result << 5) + result + word:byte(i)
    end
    return result
end

---@param string string
--- Splits a string into a table by spaces
function string_split(string, splitAt)
    if splitAt == nil then
        splitAt = " "
    end
    local result = {}
    for match in string:gmatch(string.format("[^%s]+", splitAt)) do
        table.insert(result, match)
    end
    return result
end

function nearest_antibubble_mario_state_to_object(obj)
    if (not obj) then return nil end
    local nearest = nil;
    local nearestDist = 0;
    for i = 0, MAX_PLAYERS - 1 do
        local m = gMarioStates[i];
        if (not m.marioObj) then goto continue end
        if (m.marioObj == obj) then goto continue end
        if (m.action == ACT_BUBBLED or m.action == ACT_MASTER_CAP_BUBBLED) then goto continue end
        if (is_player_active(m) == 0) then goto continue end

        if m.action == ACT_DEATH_ON_BACK then
            goto continue
        end

        local dist = dist_between_objects(obj, m.marioObj);
        if (nearest == nil or dist < nearestDist) then
            nearest = m;
            nearestDist = dist;
        end

        ::continue::
    end

    return nearest;
end

function get_area_minimum_y()
    local m = gMarioStates[0] ---@type MarioState
    local np = gNetworkPlayers[0]
    if (m.area.camera and m.area.camera.mode == CAMERA_MODE_ROM_HACK) then return end
    if np.currCourseNum == COURSE_WF then    return true, 8; end;
    if np.currCourseNum == COURSE_CCM then   return true, (np.currAreaIndex == 2) and -5856 or -5068; end;
    if np.currCourseNum == COURSE_PSS then   return true, -4600; end;
    if np.currCourseNum == COURSE_BITDW then return true, -3416; end;
    if np.currCourseNum == COURSE_TTM then   return (np.currAreaIndex == 1) and true, -6000 or false end
    if np.currCourseNum == COURSE_RR then    return true, -4790; end;
    if np.currCourseNum == COURSE_BITS then  return true, -5065; end;
end

function bubbled_offset_visual(m)
    if not m then return end
    -- scary 3d trig ahead

    local forwardOffset = 25;
    local upOffset = -35;

    -- figure out forward vector
    local forward = {
        x = sins(m.faceAngle.y) * coss(m.faceAngle.x),
        y = -sins(m.faceAngle.x),
        z = coss(m.faceAngle.y) * coss(m.faceAngle.x),
    };
    vec3f_normalize(forward);

    -- figure out right vector
    local globalUp = { x = 0, y = 1, z = 0 };
    local right = { x = 0, y = 0, z = 0 };
    vec3f_cross(right, forward, globalUp);
    vec3f_normalize(right);

    -- figure out up vector
    local up = { x = 0, y = 0, z = 0 };
    vec3f_cross(up, right, forward);
    vec3f_normalize(up);

    -- offset forward direction
    vec3f_mul(forward, forwardOffset);
    vec3f_add(m.marioObj.header.gfx.pos, forward);

    -- offset up direction
    vec3f_mul(up, upOffset);
    vec3f_add(m.marioObj.header.gfx.pos, up);

    -- offset global up direction
    m.marioObj.header.gfx.pos.y = m.marioObj.header.gfx.pos.y - upOffset;
end

function mario_set_master_cap_bubbled(m)
    if not m then return end
    if (m.playerIndex ~= 0) then return end
    if (m.action == ACT_MASTER_CAP_BUBBLED) then return end

    gLocalBubbleCounter = 20;

    --if (m.numLives > -1) {
    --    m.numLives--;
    --}
    m.health = 0x880
    m.healCounter = 0;
    m.hurtCounter = 0;
    m.area.camera.cutscene = 0;
    m.statusForCamera.action = m.action;
    m.statusForCamera.cameraEvent = 0;
    m.marioObj.activeFlags = m.marioObj.activeFlags | ACTIVE_FLAG_MOVE_THROUGH_GRATE;
    set_mario_action(m, ACT_MASTER_CAP_BUBBLED, 0);

    --extern s16 gCutsceneTimer;
    --gCutsceneTimer = 0;
    soft_reset_camera(m.area.camera);
end


local levelTimer = 0
function get_level_timer() return levelTimer end

local function level_timer_update() levelTimer = levelTimer + 1 end
local function level_timer_reset() levelTimer = 0 end
hook_event(HOOK_UPDATE, level_timer_update)
hook_event(HOOK_ON_LEVEL_INIT, level_timer_reset)

function num_to_hex(num)
    if num == 0 then
        return '0'
    end
    local neg = false
    if num < 0 then
        neg = true
        num = num * -1
    end
    local hexstr = "0123456789ABCDEF"
    local result = ""
    while num > 0 do
        local n = (num%16)
        result = string.sub(hexstr, n + 1, n + 1) .. result
        num = math.floor(num / 16)
    end
    result = '0x'..result
    if neg then
        result = '-' .. result
    end
    return result
end

function lerp_s16(a, b, t)
    a = math.s16(math.round(a))
    b = math.s16(math.round(b))

    local delta = b - a

    if delta > 0x8000 then
        delta = delta - 0x10000
    elseif delta < -0x8000 then
        delta = delta + 0x10000
    end

    return math.s16(a + delta * t)
end

function obj_get_nearest_object(o)
    local minDist = 0x20000;
    local closestObj = nil;

    if (o) then
        for i = 0, NUM_OBJ_LISTS - 1 do
            local obj = obj_get_first(i)
            repeat
                if obj ~= nil then
                    if o ~= obj and obj.activeFlags ~= ACTIVE_FLAG_DEACTIVATED then
                        local objDist = dist_between_objects(o, obj);
                        if (objDist < minDist) then
                            closestObj = obj;
                            minDist = objDist;
                            djui_chat_message_create(tostring(objDist))
                        end
                    end
                    obj = obj_get_next(obj)
                end
            until obj == nil
        end
    end
    return closestObj;
end