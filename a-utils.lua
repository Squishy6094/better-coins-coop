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
    return {x = o.oPosX, y = o.oPosY, z = o.oPosZ}
end

function obj_is_in_clam(o)
    local oClam = obj_get_nearest_object_with_behavior_id(o, id_bhvClamShell)
    if oClam ~= nil and vec3f_dist(obj_pos_to_vec3f(o), obj_pos_to_vec3f(oClam)) < 100 then
        if oClam.oAction ~= 1 or oClam.oTimer < 15 then
            return true
        end
    end
    return false
end