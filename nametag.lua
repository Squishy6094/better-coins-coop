
local function djui_hud_print_outlined_text_interpolated(text, prevX, prevY, prevScale, x, y, scale, r, g, b, a, outlineDarkness)
    local offset = 1 * (scale * 2);
    local prevOffset = 1 * (prevScale * 2);

    -- render outline
    djui_hud_set_color(r * outlineDarkness, g * outlineDarkness, b * outlineDarkness, a);
    djui_hud_print_text_interpolated(text, prevX - prevOffset, prevY,              prevScale, x - offset, y,          scale);
    djui_hud_print_text_interpolated(text, prevX + prevOffset, prevY,              prevScale, x + offset, y,          scale);
    djui_hud_print_text_interpolated(text, prevX,              prevY - prevOffset, prevScale, x,          y - offset, scale);
    djui_hud_print_text_interpolated(text, prevX,              prevY + prevOffset, prevScale, x,          y + offset, scale);
    -- render text
    djui_hud_set_color(r, g, b, a);
    djui_hud_print_text_interpolated(text, prevX, prevY, prevScale, x, y, scale);
    djui_hud_set_color(255, 255, 255, 255);
end

local objTag = {}

---@param o Object
function obj_set_nametag(o, name, color)
    --o.oFlyGuyUnusedJitter = 1
    objTag[o] = {
        name = name,
        color = color,
        prevPos = {x = 0, y = 0, z = 0};
        prevScale = 0;
        inited = false;
    }
end

function obj_remove_nametag(o)
    objTag[o] = nil
end

local function nametags_render()
    djui_hud_set_resolution(RESOLUTION_N64);
    djui_hud_set_font(FONT_SPECIAL);

    for o, tag in pairs(objTag) do
        local pos = {x = o.oPosX, y = o.oPosY + o.hitboxHeight, z = o.oPosZ};
        local out = {x = 0, y = 0, z = 0};
        pos.y = pos.y + 50;

        djui_hud_world_pos_to_screen_pos(pos, out)

        if (not djui_hud_world_pos_to_screen_pos(pos, out) --[[or o.oFlyGuyUnusedJitter == 0]]) then
            goto continue;
        end

        local scale = -300 / out.z * djui_hud_get_fov_coeff();
        local measure = djui_hud_measure_text(tag.name) * scale * 0.5;
        out.y = out.y - 16 * scale;

        local alpha = (255) * math.clamp(4 - scale, 0, 1);

        if (not tag.inited) then
            vec3f_copy(tag.prevPos, out);
            tag.prevScale = scale;
            tag.inited = true;
        end

        djui_hud_print_outlined_text_interpolated(tag.name, tag.prevPos.x - measure, tag.prevPos.y, tag.prevScale, out.x - measure, out.y, scale, tag.color.r, tag.color.g, tag.color.b, alpha, 0.25);

        --[[
        if (i != 0 && gNametagsSettings.showHealth) {
            djui_hud_set_color(255, 255, 255, alpha);
            f32 healthScale = 90 * scale;
            f32 prevHealthScale = 90 * e->prevScale;
            hud_render_power_meter_interpolated(m->health,
                e->prevPos[0] - (prevHealthScale * 0.5f), e->prevPos[1] - 72 * scale, prevHealthScale, prevHealthScale,
                        out[0] - (    healthScale * 0.5f),        out[1] - 72 * scale,     healthScale,     healthScale
            );
        }
        ]]

        -- Reset viewport

        vec3f_copy(tag.prevPos, out);
        tag.prevScale = scale;

        ::continue::
    end
end

local function level_init()
    objTag = {}
end

hook_event(HOOK_ON_HUD_RENDER_BEHIND, nametags_render)
hook_event(HOOK_ON_LEVEL_INIT, level_init)