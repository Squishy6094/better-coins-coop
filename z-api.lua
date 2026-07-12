
---@param status boolean? Forces Master Cap On/Off (use nil to return to default functionality)
local function master_cap_allow_spawn(status)
    gGlobalSyncTable.allowMasterCapApi = status
end

_G.betterCoins = {
    bhv_init_for_magnitize = bhv_init_for_magnitize,
    bhv_check_for_magnitize = bhv_check_for_magnitize,
    is_object_being_carried = is_object_being_carried,

    -- Master Cap Funcs
    master_cap_init_level = master_cap_init_level,
    master_cap_set_merged_level_num = master_cap_set_merged_level_num,
    master_cap_get_merged_level_num = master_cap_get_merged_level_num,
    master_cap_get_box_spawn = master_cap_get_box_spawn,
    master_cap_set_box_spawn = master_cap_set_box_spawn,
    master_cap_get_door_spawn = master_cap_get_door_spawn,
    master_cap_set_door_spawn = master_cap_set_door_spawn,
    master_cap_allow_spawn = master_cap_allow_spawn,
}