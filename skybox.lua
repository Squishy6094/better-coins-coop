local replace = {}

for i = 0, 63 do
    local hex = num_to_hex(i)
    hex = string.sub(hex, 3, #hex)
    if #hex < 2 then
        hex = "0"..hex
    end
    replace["ccm_skybox_texture_000" .. hex] = get_texture_info("pink_cloud_sky." .. string.format("%02d", i))
end

local function replace_skybox()
    if gNetworkPlayers[0].currLevelNum == LEVEL_MASTER_CAP_STAGE then
        for name, tex in pairs(replace) do
            texture_override_set(name, tex)
        end
    end
end

hook_event(HOOK_ON_LEVEL_INIT, replace_skybox)