local UvScroll = require("libs/uv-scroll")

local function linear_uv_scroll(speed)
    return function(triangles, originalUV, currentUV)
        currentUV[2] = currentUV[2] + speed
    end
end

UvScroll.hook_scrolling_function('master_door_004_offset_mesh_layer_6_tri_0', linear_uv_scroll(15))