local modIndex = get_active_mod().index
local appendBhvs = {}
local hookedBhvs = {}
local fieldTable = {}
local og_hook_behavior = hook_behavior
local og_define_custom_obj_fields = define_custom_obj_fields

local function inject_bhvs()
    for id, hookInfo in pairs(hookedBhvs) do
        og_hook_behavior(id, hookInfo.objectList, hookInfo.replaceBehavior, hookInfo.initFunction, hookInfo.loopFunction, hookInfo.behaviorName)
    end
end

_G.define_custom_obj_fields = function(objFieldTable)
    for id, type in pairs(objFieldTable) do
        fieldTable[id] = type
    end
    og_define_custom_obj_fields(fieldTable)
    inject_bhvs()
end

local function hook_behavior_local(behaviorId, objectList, replaceBehavior, initFunction, loopFunction, behaviorName)
    if not behaviorId then return end
    -- Create external-compatible init func
    local function initFunc(o)
        local returnValue = nil
        if initFunction ~= nil then
            returnValue = initFunction(o)
        end
        local append = appendBhvs[behaviorId]
        if append and append.init then
            appendValue = append.init(o)
            if appendValue ~= nil then
                returnValue = appendValue
            end
        end
        return returnValue
    end

    local function loopFunc(o)
        local returnValue = nil
        if loopFunction ~= nil then
            returnValue = loopFunction(o)
        end
        local append = appendBhvs[behaviorId]
        if append and append.loop then
            appendValue = append.loop(o)
            if appendValue ~= nil then
                returnValue = appendValue
            end
        end
        return returnValue
    end

    --og_hook_behavior(id, get_object_list_from_behavior(get_behavior_from_id(id)), override, initFunc, loopFunc, "bhvCoins" .. get_behavior_name_from_id(id):gsub("id_bhv", "", 1):gsub("bhv", "", 1))
    hookedBhvs[behaviorId] = {
        objectList = objectList,
        replaceBehavior = replaceBehavior,
        initFunction = initFunc,
        loopFunction = loopFunc,
        behaviorName = behaviorName
    }
end

local function hook_behavior_remote(behaviorId, objectList, replaceBehavior, initFunction, loopFunction, behaviorName)
    if appendBhvs[behaviorId] == nil then
        appendBhvs[behaviorId] = {
            init = initFunction,
            loop = loopFunction,
            blame = get_active_mod().name
        }
    else
        log_to_console("[Compatible Behaviors "..modIndex.."] "..get_active_mod().name.." attempted to append a behavior, it is recommended to add Compatible Behaviors to "..appendBhvs[behaviorId].blame.."!", CONSOLE_MESSAGE_WARNING)
    end
    return behaviorId
end

_G.hook_behavior = function(behaviorId, objectList, replaceBehavior, initFunction, loopFunction, behaviorName)
    if replaceBehavior or behaviorId == nil then
        return og_hook_behavior(behaviorId, objectList, replaceBehavior, initFunction, loopFunction, behaviorName)
    else
        if modIndex == get_active_mod().index then
            return hook_behavior_local(behaviorId, objectList, replaceBehavior, initFunction, loopFunction, behaviorName)
        else
            return hook_behavior_remote(behaviorId, objectList, replaceBehavior, initFunction, loopFunction, behaviorName)
        end
    end
end