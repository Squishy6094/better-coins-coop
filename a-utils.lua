-- Load Libraries
oTagLib = require("libs/oTagLib")
hudDodge = require("libs/hudDodge")

CURR_ROMHACK = "sm64"
GAMEMODE_ACTIVE = false

for i in pairs(gActiveMods) do
    local mod = gActiveMods[i]
    if mod.incompatible ~= nil then
        if mod.incompatible:find("romhack") then
            CURR_ROMHACK = mod.relativePath
        end
        if mod.incompatible:find("gamemode") then
            GAMEMODE_ACTIVE = true
        end
    end
    if mod.category ~= nil then
        if mod.category:find("romhack") then
            CURR_ROMHACK = mod.relativePath
        end
        if mod.category:find("gamemode") then
            GAMEMODE_ACTIVE = true
        end
    end
    CURR_ROMHACK = CURR_ROMHACK:gsub("[/\\]+$", "")
    CURR_ROMHACK = CURR_ROMHACK:gsub(".*[/\\]", "")
    CURR_ROMHACK = CURR_ROMHACK:gsub(" ", "-")
    CURR_ROMHACK = string.lower(CURR_ROMHACK)
end

romhackData = {
    ["sm64"] = {
        starCount = 120,
        masterCapSpawns = {
            [LEVEL_BOB] = {
                [1] = {x = -6700, y = 350, z = 4600, yaw = 0},
            },
        },
        masterDoorSpawns = {
            [LEVEL_CASTLE_GROUNDS] = {
                [1] = {x = -5600, y = 260, z = 1990, yaw = 0x4000}
            },
        },
        scarecrowSpawns = {},
    },
    ["sm74"] = {
        starCount = 151,
        masterCapSpawns = {
            [LEVEL_BOB] = {
                --[1] = {x = -6700, y = 350, z = 4600},
            },
        },
        masterDoorSpawns = {
            [LEVEL_CASTLE_COURTYARD] = {
                [1] = {x = 3708, y = -714, z = -1200, yaw = -0x2000},
                [2] = {x = -3708, y = -765, z = -1200, yaw = 0x2000},
            },
        },
        scarecrowSpawns = {},
    },
}

if not romhackData[CURR_ROMHACK] then
    romhackData[CURR_ROMHACK] = {
        starCount = -1,
        masterCapSpawns = {},
        masterDoorSpawns = {},
        scarecrowSpawns = {},
    }
end

---@class Object
---@field oIsCarried integer
---@field oCustomCoins integer
---@field oThwompGroundPounded integer
---@field oThwompHitstun integer
---@field oHitMario integer
---@field oPrevHealth number
---@field oBooCoinFace integer
---@field oBooCoinAnimState integer
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
        --if (not mario_visible) then goto continue end
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
    a = math.s16(a)
    b = math.s16(b)

    local delta = b - a

    if delta > 0x8000 then
        delta = delta - 0x10000
    elseif delta < -0x8000 then
        delta = delta + 0x10000
    end

    return math.s16(a + delta * t)
end

--------------------------
-- Romhack Star Counter --
--------------------------

local function on_mods_loaded()

local sLevelTable = {
    LEVEL_BBH,
    LEVEL_CCM,
    LEVEL_CASTLE,
    LEVEL_HMC,
    LEVEL_SSL,
    LEVEL_BOB,
    LEVEL_SL,
    LEVEL_WDW,
    LEVEL_JRB,
    LEVEL_THI,
    LEVEL_TTC,
    LEVEL_RR,
    LEVEL_CASTLE_GROUNDS,
    LEVEL_BITDW,
    LEVEL_VCUTM,
    LEVEL_BITFS,
    LEVEL_SA,
    LEVEL_BITS,
    LEVEL_LLL,
    LEVEL_DDD,
    LEVEL_WF,
    LEVEL_ENDING,
    LEVEL_CASTLE_COURTYARD,
    LEVEL_PSS,
    LEVEL_COTMC,
    LEVEL_TOTWC,
    LEVEL_BOWSER_1,
    LEVEL_WMOTR,
    LEVEL_BOWSER_2,
    LEVEL_BOWSER_3,
    LEVEL_TTM
}

local isRomhack = false

for i = 1, #sLevelTable - 1 do
    if not level_is_vanilla_level(sLevelTable[i]) then
        isRomhack = true
    end
end

local function check_exclamation_box(bhvParams)
    local contents = get_exclamation_box_contents()
    local bparam2 = (bhvParams >> 16) & 0xFF


    for id, content in pairs(contents) do
        if content.id == bparam2 - 1 and gStarBehaviors[content.behavior] then
            return true
        end
    end
end

local function check_toad(bhvParams)

    local sStarDialogTable = {
        [gBehaviorValues.dialogs.ToadStar1Dialog] = true,
        [gBehaviorValues.dialogs.ToadStar2Dialog] = true,
        [gBehaviorValues.dialogs.ToadStar3Dialog] = true,
    }

    local dialog = (bhvParams >> 24) & 0xFF

    return sStarDialogTable[dialog]
end

local function check_mips()
    local count = 0

    if gBehaviorValues.MipsStar1Requirement < 182 then
        count = count + 1
    end

    if gBehaviorValues.MipsStar2Requirement < 182 then
        count = count + 1
    end

    return count
end

local sGaslightStars = {}

gStarBehaviors = {
    [id_bhvEyerokBoss] = function (bhvParams) return true end,
    [id_bhvTreasureChestsJrb] = function (bhvParams) return true end,
    [id_bhvTreasureChests] = function (bhvParams) return true end,
    [id_bhvMerryGoRoundBooManager] = function (bhvParams) return true end,
    [id_bhvBalconyBigBoo] = function (bhvParams) return true end,
    [id_bhvBigChillBully] = function (bhvParams) return true end,
    [id_bhvTuxiesMother] = function (bhvParams) return true end,
    [id_bhvWigglerHead] = function (bhvParams) return true end,
    [id_bhvKingBobomb] = function (bhvParams) return true end,
    [id_bhvWhompKingBoss] = function (bhvParams) return true end,
    [id_bhvBigBully] = function (bhvParams) return true end,
    [id_bhvBigBullyWithMinions] = function (bhvParams) return true end,
    [id_bhvMantaRay] = function (bhvParams) return true end,
    [id_bhvCcmTouchedStarSpawn] = function (bhvParams) return true end,
    [id_bhvSnowmansHead] = function (bhvParams) return true end,
    [id_bhvJetStreamRingSpawner] = function (bhvParams) return true end,
    [id_bhvGhostHuntBigBoo] = function (bhvParams) return true end,
    [id_bhvUkikiCage] = function (bhvParams) return true end,
    [id_bhvRacingPenguin] = function (bhvParams) return true end,
    [id_bhvKoopaRaceEndpoint] = function (bhvParams) return true end,

    [id_bhvStar] = function (bhvParams) return true end,
    [id_bhvSpawnedStar] = function (bhvParams) return true end,
    [id_bhvHiddenStar] = function (bhvParams) return true end,
    [id_bhvHiddenRedCoinStar] = function (bhvParams) return true end,
    [id_bhvBowserCourseRedCoinStar] = function (bhvParams) return true end,

    [id_bhvExclamationBox] = check_exclamation_box,

    [id_bhvKlepto] = function (bhvParams) return (bhvParams & 0x00FF0000) ~= 0 end,
    [id_bhvMrI] = function (bhvParams) return (bhvParams & 0x00FF0000) ~= 0 end,
    [id_bhvFirePiranhaPlant] = function (bhvParams, count) return ((bhvParams & 0x00FF0000) ~= 0 and count == 1) end,
    [id_bhvUnagi] = function (bhvParams) return ((bhvParams >> 16) & 0xFF) == 1 end,
    [id_bhvToadMessage] = check_toad,

    [id_bhvMips] = check_mips, -- how do i even check this he can appears multiple times..
}

local function get_all_possible_level_stars(level)
    local stars = 0
    local behaviorCounts = {}

    local function check_bhv_for_star(behavior, bhvParams)
        if not behavior then return 0 end
        if not gStarBehaviors[behavior] then return 0 end

        behaviorCounts[behavior] = (behaviorCounts[behavior] or 0) + 1
        local count = behaviorCounts[behavior]

        bhvParams = bhvParams or 0

        local result = gStarBehaviors[behavior](bhvParams, count)

        if result == true then return 1 end
        if result == false or result == nil then return 0 end

        return result
    end

    level_script_parse(level, function (_, bhvData, macroBhvIds, macroBhvArgs)
        if macroBhvIds and macroBhvArgs then
            for i, macroBhvId in pairs(macroBhvIds) do
                stars = stars + check_bhv_for_star(macroBhvId, macroBhvArgs[i])
            end
        end

        if bhvData then
            stars = stars + check_bhv_for_star(bhvData.behavior, bhvData.behaviorArg)
        end
    end)

    if gLevelValues.coinsRequiredForCoinStar > 0 and course_is_main_course(get_level_course_num(level)) then
        stars = stars + 1
    end

    --if sGaslightStars[level] then stars = stars + 1 end

    if isRomhack and level_is_vanilla_level(level) then return 0 end

    return stars
end

local function get_max_possible_stars()
    local count = 0
    for i = 1, #sLevelTable - 1 do
        count = count + get_all_possible_level_stars(sLevelTable[i])
    end

    return count
end

if romhackData[CURR_ROMHACK].starCount == -1 then
    romhackData[CURR_ROMHACK].starCount = get_max_possible_stars()
end

function get_romhack_star_count()
    return romhackData[CURR_ROMHACK].starCount
end

log_to_console('Better Coins: Hack - "'..CURR_ROMHACK..'" | Stars - '..tostring(get_romhack_star_count()))

local function mario_update(m)
    if m.playerIndex ~= 0 then return end

    if m.floor and m.floor.type == SURFACE_TIMER_END then
        sGaslightStars[gNetworkPlayers[0].currLevelNum] = true
    end

end

--hook_event(HOOK_MARIO_UPDATE, mario_update)

end

hook_event(HOOK_ON_MODS_LOADED, on_mods_loaded) -- needs to be done so romhacks can set their values and shit in time
