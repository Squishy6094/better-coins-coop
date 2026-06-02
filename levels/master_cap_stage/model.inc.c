Lights1 master_cap_stage_dl_Material_lights = gdSPDefLights1(
	0x7F, 0x7F, 0x7F,
	0xFF, 0xFF, 0xFF, 0x28, 0x28, 0x28);

Vtx master_cap_stage_dl_Level_mesh_layer_1_vtx_cull[8] = {
	{{{-200, 0, 200}, 0, {0, 0}, {0x00, 0x00, 0x00, 0x00}}},
	{{{-200, 0, 200}, 0, {0, 0}, {0x00, 0x00, 0x00, 0x00}}},
	{{{-200, 0, -200}, 0, {0, 0}, {0x00, 0x00, 0x00, 0x00}}},
	{{{-200, 0, -200}, 0, {0, 0}, {0x00, 0x00, 0x00, 0x00}}},
	{{{200, 0, 200}, 0, {0, 0}, {0x00, 0x00, 0x00, 0x00}}},
	{{{200, 0, 200}, 0, {0, 0}, {0x00, 0x00, 0x00, 0x00}}},
	{{{200, 0, -200}, 0, {0, 0}, {0x00, 0x00, 0x00, 0x00}}},
	{{{200, 0, -200}, 0, {0, 0}, {0x00, 0x00, 0x00, 0x00}}},
};

Vtx master_cap_stage_dl_Level_mesh_layer_1_vtx_0[4] = {
	{{{200, 0, -200}, 0, {624, 496}, {0x00, 0x7F, 0x00, 0xFF}}},
	{{{-200, 0, -200}, 0, {880, 496}, {0x00, 0x7F, 0x00, 0xFF}}},
	{{{-200, 0, 200}, 0, {880, 240}, {0x00, 0x7F, 0x00, 0xFF}}},
	{{{200, 0, 200}, 0, {624, 240}, {0x00, 0x7F, 0x00, 0xFF}}},
};

Gfx master_cap_stage_dl_Level_mesh_layer_1_tri_0[] = {
	gsSPVertex(master_cap_stage_dl_Level_mesh_layer_1_vtx_0 + 0, 4, 0),
	gsSP2Triangles(0, 1, 2, 0, 0, 2, 3, 0),
	gsSPEndDisplayList(),
};

Gfx mat_master_cap_stage_dl_Material[] = {
	gsSPSetLights1(master_cap_stage_dl_Material_lights),
	gsDPPipeSync(),
	gsDPSetCombineLERP(0, 0, 0, SHADE, 0, 0, 0, ENVIRONMENT, 0, 0, 0, SHADE, 0, 0, 0, ENVIRONMENT),
	gsDPSetAlphaDither(G_AD_NOISE),
	gsSPTexture(65535, 65535, 0, 0, 1),
	gsSPEndDisplayList(),
};

Gfx mat_revert_master_cap_stage_dl_Material[] = {
	gsDPPipeSync(),
	gsDPSetAlphaDither(G_AD_DISABLE),
	gsSPEndDisplayList(),
};

Gfx master_cap_stage_dl_Level_mesh_layer_1[] = {
	gsSPClearGeometryMode(G_LIGHTING),
	gsSPVertex(master_cap_stage_dl_Level_mesh_layer_1_vtx_cull + 0, 8, 0),
	gsSPSetGeometryMode(G_LIGHTING),
	gsSPCullDisplayList(0, 7),
	gsSPDisplayList(mat_master_cap_stage_dl_Material),
	gsSPDisplayList(master_cap_stage_dl_Level_mesh_layer_1_tri_0),
	gsSPDisplayList(mat_revert_master_cap_stage_dl_Material),
	gsSPEndDisplayList(),
};

Gfx master_cap_stage_dl_material_revert_render_settings[] = {
	gsDPPipeSync(),
	gsSPSetGeometryMode(G_LIGHTING),
	gsSPClearGeometryMode(G_TEXTURE_GEN),
	gsDPSetCombineLERP(0, 0, 0, SHADE, 0, 0, 0, ENVIRONMENT, 0, 0, 0, SHADE, 0, 0, 0, ENVIRONMENT),
	gsSPTexture(65535, 65535, 0, 0, 0),
	gsDPSetEnvColor(255, 255, 255, 255),
	gsDPSetAlphaCompare(G_AC_NONE),
	gsDPSetTextureImage(G_IM_FMT_RGBA, G_IM_SIZ_16b_LOAD_BLOCK, 1, 0),
	gsDPSetTile(G_IM_FMT_RGBA, G_IM_SIZ_16b_LOAD_BLOCK, 0, 0, 7, 0, G_TX_WRAP | G_TX_NOMIRROR, 0, 0, G_TX_WRAP  | G_TX_NOMIRROR, 0, 0),
	gsDPLoadBlock(7, 0, 0, 1023, 256),
	gsDPSetTile(G_IM_FMT_RGBA, G_IM_SIZ_16b, 8, 0, 0, 0, G_TX_CLAMP | G_TX_NOMIRROR, 5, 0, G_TX_CLAMP | G_TX_NOMIRROR, 5, 0),
	gsDPSetTileSize(0, 0, 0, 124, 124),
	gsDPSetTextureImage(G_IM_FMT_RGBA, G_IM_SIZ_16b_LOAD_BLOCK, 1, 0),
	gsDPSetTile(G_IM_FMT_RGBA, G_IM_SIZ_16b_LOAD_BLOCK, 0, 256, 6, 0, G_TX_WRAP | G_TX_NOMIRROR, 0, 0, G_TX_WRAP | G_TX_NOMIRROR, 0, 0),
	gsDPLoadBlock(6, 0, 0, 1023, 256),
	gsDPSetTile(G_IM_FMT_RGBA, G_IM_SIZ_16b, 8, 256, 1, 0, G_TX_CLAMP | G_TX_NOMIRROR, 5, 0, G_TX_CLAMP | G_TX_NOMIRROR, 5, 0),
	gsDPSetTileSize(1, 0, 0, 124, 124),
	gsSPEndDisplayList(),
};

