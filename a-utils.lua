-- Load Libraries
--require("libs/compatBhvs")
require("libs/oTagLib")

ROMHACK = "sm64"

local function get_romhack_name()
    for i in pairs(gActiveMods) do
        local mod = gActiveMods[i]
        if mod.incompatible ~= nil then
            if mod.incompatible:find("romhack") then
                ROMHACK = mod.relativePath
            end
        end
        if mod.category ~= nil then
            if mod.category:find("romhack") then
                ROMHACK = mod.relativePath
            end
        end
        ROMHACK = ROMHACK:gsub("[/\\]+$", "")
        ROMHACK = ROMHACK:gsub(".*[/\\]", "")
    end
end


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

function obj_pos_to_vec3f(o)
    if not o then o = get_current_object() end
    return {x = o.oPosX, y = o.oPosY, z = o.oPosZ}
end

function obj_is_in_container(o)
    -- Check if inside Clam
    local oClam = obj_get_nearest_object_with_behavior_id(o, id_bhvClamShell)
    if oClam ~= nil and vec3f_dist(obj_pos_to_vec3f(o), obj_pos_to_vec3f(oClam)) < 100 then
        if oClam.oAction ~= 1 or oClam.oTimer < 15 then
            return true, oClam
        end
        return false, oClam
    end

    -- Check if inside breakable box
    local oBox = obj_get_nearest_object_with_behavior_id(o, id_bhvBreakableBox)
    if oBox ~= nil and vec3f_dist(obj_pos_to_vec3f(o), obj_pos_to_vec3f(oBox)) < 300 then
        return true, oBox
    end
    return false
end

-- Automatically check for if the objects is synced

local og_network_init_object = network_init_object
function network_init_object(object, standardSync, fieldTable)
    if object.oSyncID ~= 0 then
        return og_network_init_object(object, standardSync, fieldTable)
    end
end

local og_network_send_object = network_send_object
function network_send_object(object, reliable)
    if object.oSyncID ~= 0 then
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

--------------------------
-- Romhack Star Counter --
--------------------------

local function on_mods_loaded()

get_romhack_name()

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
            --djui_chat_message_create("content.id "..content.id)
            --djui_chat_message_create("bparam2 "..bparam2 - 1)
            --djui_chat_message_create("STAR ID "..content.firstByte)
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

function get_max_possible_stars()
    local count = 0
    for i = 1, #sLevelTable - 1 do
        count = count + get_all_possible_level_stars(sLevelTable[i])
    end

    --djui_chat_message_create(tostring(count))
    return count
end

local function mario_update(m)
    if m.playerIndex ~= 0 then return end

    if m.floor and m.floor.type == SURFACE_TIMER_END then
        sGaslightStars[gNetworkPlayers[0].currLevelNum] = true
    end

    --djui_chat_message_create("all "..get_max_possible_stars())
end

hook_event(HOOK_MARIO_UPDATE, mario_update)

end

hook_event(HOOK_ON_MODS_LOADED, on_mods_loaded) -- needs to be done so romhacks can set their values and shit in time
