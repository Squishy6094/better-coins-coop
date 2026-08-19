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
        areaBasedLevels = false,
        [LEVEL_CASTLE_GROUNDS] = {
            [1] = {
                masterCap = 0,
                masterDoor = {x = -5600, y = 260, z = 1990, yaw = 0x4000},
            },
        },
        [LEVEL_CASTLE] = {
            [1] = {
                masterCap = 0,
            },
            [2] = {
                masterCap = 0,
            },
            [3] = {
                masterCap = 0,
            },
        },
        [LEVEL_CASTLE_COURTYARD] = {
            [1] = {
                masterCap = 0,
            },
        },
        [LEVEL_BOB] = {
            [1] = {
                masterCap = {x = -6700, y = 350, z = 4600, yaw = 0}
            }
        },
        [LEVEL_WF] = {
            [1] = {
                masterCap = {x = 3000, y = 600, z = 4610, yaw = 0x4000}
            }
        },
        [LEVEL_CCM] = {
            [1] = {
                masterCap = {x = -1350, y = 2900, z = -1600, yaw = 0x4000}
            }
        },
        [LEVEL_JRB] = {
            [1] = {
                masterCap = {x = -6800, y = 1500, z = -500, yaw = -0x2000}
            }
        },
        [LEVEL_SA] = {
            [1] = {
                masterCap = {x = 800, y = -1800, z = 800, yaw = -0x2000}
            }
        },
        [LEVEL_PSS] = {
            [1] = {
                masterCap = {x = 5423, y = 6400, z = -4754, yaw = -0x4000}
            }
        },
        [LEVEL_TOTWC] = {
            [1] = {
                masterCap = {x = 0, y = 2400, z = 0, yaw = 0}
            }
        },
        [LEVEL_BITDW] = {
            [1] = {
                masterCap = {x = -7150, y = -2700, z = 3550, yaw = 0}
            }
        },
        [LEVEL_BITFS] = {
            [1] = {
                masterCap = {x = -7150, y = -2700, z = 3550, yaw = 0}
            }
        },
        [LEVEL_BITS] = {
            [1] = {
                masterCap = {x = -7150, y = -2700, z = 3550, yaw = 0}
            }
        },
    },
    --[[
    ["sm74"] = {
        starCount = 151,
        areaBasedLevels = false,
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
    ]]
}

if not romhackData[CURR_ROMHACK] then
    romhackData[CURR_ROMHACK] = {
        starCount = -1,
        areaBasedLevels = false,
        [LEVEL_CASTLE_GROUNDS] = {},
        [LEVEL_CASTLE] = {},
        [LEVEL_CASTLE_COURTYARD] = {},
        [LEVEL_BOWSER_1] = {
            levelMerge = LEVEL_BITDW,
        },
        [LEVEL_BOWSER_2] = {
            levelMerge = LEVEL_BITFS,
        },
        [LEVEL_BOWSER_3] = {
            levelMerge = LEVEL_BITS,
        },
    }
    for i = 1, 7 do
        romhackData[CURR_ROMHACK][LEVEL_CASTLE_GROUNDS][i] = {
            masterCap = 0,
        }
        romhackData[CURR_ROMHACK][LEVEL_CASTLE][i] = {
            masterCap = 0,
        }
        romhackData[CURR_ROMHACK][LEVEL_CASTLE_COURTYARD][i] = {
            masterCap = 0,
        }
    end
end

function get_romhack_data(romhack)
    romhack = romhack or CURR_ROMHACK
    return romhackData[romhack]
end

function get_romhack_level_data(romhack, level, area)
    local hackData = get_romhack_data(romhack)
    local level = hackData.areaBasedLevels and level*7 + area or level
    repeat
        if hackData[level] then
            if hackData[level].levelMerge then
                level = hackData[level].levelMerge
            end
        else
            hackData[level] = {}
            break
        end
    until hackData[level].levelMerge == nil
    if not hackData.areaBasedLevels then
        if not hackData[level][area] then
            hackData[level][area] = {}
        end
    end
    return hackData.areaBasedLevels and hackData[level] or hackData[level][area], level
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

for i = 1, #sLevelTable do
    if not level_is_vanilla_level(sLevelTable[i]) then
        isRomhack = true
    end
end

local function check_exclamation_box(bhvParams)
    local contents = get_exclamation_box_contents()
    local bhvParams2ndByte = (bhvParams >> 16) & 0xFF
    --log_to_console(tostring(bhvParams2ndByte))

    for id, content in pairs(contents) do
        if content.id == bhvParams2ndByte and gStarBehaviors[content.behavior] then
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

-- Check for common custom behaviors
if get_id_from_behavior_name("bhvFlipswitch_Panel_MOP") then
    gStarBehaviors[get_id_from_behavior_name("bhvFlipswitch_Panel_MOP")] = function (bhvParams, count) return ((bhvParams & 0x00FF0000) ~= 0 and count == 1) end
end

local behaviorCounts = {}
local function check_bhv_for_star(behavior, bhvParams)
    if not behavior then return 0 end
    if not gStarBehaviors[behavior] then return 0 end

    behaviorCounts[behavior] = (behaviorCounts[behavior] or 0) + 1
    local count = behaviorCounts[behavior]

    bhvParams = bhvParams or 0

    local result = gStarBehaviors[behavior](bhvParams, count)

    if result then
        --log_to_console(get_behavior_name_from_id(behavior) .. " - " .. tostring(result))
    end

    if result == true then return 1 end
    if result == false or result == nil then return 0 end

    return result
end

local function get_all_possible_level_stars(level)
    if isRomhack and level_is_vanilla_level(level) then return 0 end
    local stars = 0

    level_script_parse(level, function (_, bhvData, macroBhvIds, macroBhvArgs)
        if macroBhvIds and macroBhvArgs then
            for i, macroBhvId in pairs(macroBhvIds) do
                stars = stars + check_bhv_for_star(macroBhvId, macroBhvArgs[i])
            end
        else
            if bhvData then
                stars = stars + check_bhv_for_star(bhvData.behavior, bhvData.behaviorArg)
            end
        end
    end)

    if stars ~= 7 and gLevelValues.coinsRequiredForCoinStar > 0 and course_is_main_course(get_level_course_num(level)) then
        stars = stars + 1
    end

    --if sGaslightStars[level] then stars = stars + 1 end

    return stars
end

local function get_max_possible_stars()
    log_to_console("Better Coins: Running Star Parser...")
    local count = 0
    for i = 1, #sLevelTable do
        local courseNum = get_level_course_num(sLevelTable[i])
        local levelCollected = save_file_get_course_star_count(get_current_save_file_num() - 1, courseNum - 1)
        local levelCount = get_all_possible_level_stars(sLevelTable[i])
        count = count + levelCount
        log_to_console("   "..i.. " - " .. get_level_name(courseNum, sLevelTable[i], 1) .. " - " .. tostring(levelCollected) .. "/" .. tostring(levelCount) .. " ("..tostring(count)..")", (levelCollected < levelCount) and CONSOLE_MESSAGE_WARNING or CONSOLE_MESSAGE_INFO)
    end

    -- Account for slide stars
    if isRomhack then
        if gLevelValues.pssSlideStarTime ~= 630 or gLevelValues.pssSlideStarIndex ~= 1 then
            count = count + 1
        end
    else
        count = count + 1
    end

    return count
end

romhackData[CURR_ROMHACK].parsedStars = get_max_possible_stars()
if romhackData[CURR_ROMHACK].starCount == -1 then
    romhackData[CURR_ROMHACK].starCount = romhackData[CURR_ROMHACK].parsedStars
end

function get_romhack_star_count()
    return romhackData[CURR_ROMHACK].starCount
end

local unlocked, reason = master_cap_allowed()
log_to_console('Better Coins: Hack - "'..CURR_ROMHACK..'" | Stars - '..tostring(get_romhack_star_count()).." ("..tostring(romhackData[CURR_ROMHACK].parsedStars)..") | Master Cap " .. (unlocked and "Unlocked" or "Locked - (" .. reason .. ")"))
end

hook_event(HOOK_ON_MODS_LOADED, on_mods_loaded)
