Lights1 mc_scarecrow_head_switch_head_tip_lights = gdSPDefLights1(
	0x7F, 0x7F, 0x7F,
	0xFF, 0xFF, 0xFF, 0x28, 0x28, 0x28);

Gfx mc_scarecrow_head_switch_head_alpha_ci8_aligner[] = {gsSPEndDisplayList()};
u8 mc_scarecrow_head_switch_head_alpha_ci8[] = {
	#include "actors/mc_scarecrow_head_switch/head_alpha.ci8.inc.c"
};

Gfx mc_scarecrow_head_switch_head_alpha_pal_rgba16_aligner[] = {gsSPEndDisplayList()};
u8 mc_scarecrow_head_switch_head_alpha_pal_rgba16[] = {
	#include "actors/mc_scarecrow_head_switch/head_alpha.rgba16.pal"
};

Vtx mc_scarecrow_head_switch_head_switch_mesh_layer_4_vtx_0[16] = {
	{{{-22, 9, 0}, 0, {1264, 496}, {0xAE, 0x9F, 0x00, 0xFF}}},
	{{{-44, 24, 0}, 0, {1264, -16}, {0xAE, 0x9F, 0x00, 0xFF}}},
	{{{0, 34, -44}, 0, {752, -16}, {0x00, 0xA7, 0xA6, 0xFF}}},
	{{{0, 9, -22}, 0, {752, 496}, {0x00, 0xA7, 0xA6, 0xFF}}},
	{{{44, 24, 0}, 0, {240, -16}, {0x52, 0x9F, 0x00, 0xFF}}},
	{{{22, 9, 0}, 0, {240, 496}, {0x52, 0x9F, 0x00, 0xFF}}},
	{{{0, 34, 44}, 0, {-272, -16}, {0x00, 0xA7, 0x5A, 0xFF}}},
	{{{0, 9, 22}, 0, {-272, 496}, {0x00, 0xA7, 0x5A, 0xFF}}},
	{{{-44, 24, 0}, 0, {-784, -16}, {0xAE, 0x9F, 0x00, 0xFF}}},
	{{{-22, 9, 0}, 0, {-784, 496}, {0xAE, 0x9F, 0x00, 0xFF}}},
	{{{-16, 9, 9}, 0, {752, 496}, {0x94, 0xC2, 0x19, 0xFF}}},
	{{{-27, 33, 24}, 0, {752, -16}, {0xA5, 0xB8, 0x34, 0xFF}}},
	{{{6, 38, -26}, 0, {240, -16}, {0x09, 0xD3, 0x89, 0xFF}}},
	{{{16, 9, 9}, 0, {-272, 496}, {0x53, 0xA5, 0x1F, 0xFF}}},
	{{{38, 33, 24}, 0, {-272, -16}, {0x50, 0xA4, 0x23, 0xFF}}},
	{{{0, 9, -16}, 0, {240, 496}, {0xEF, 0xD9, 0x89, 0xFF}}},
};

Gfx mc_scarecrow_head_switch_head_switch_mesh_layer_4_tri_0[] = {
	gsSPVertex(mc_scarecrow_head_switch_head_switch_mesh_layer_4_vtx_0 + 0, 16, 0),
	gsSP2Triangles(0, 1, 2, 0, 0, 2, 3, 0),
	gsSP2Triangles(3, 2, 4, 0, 3, 4, 5, 0),
	gsSP2Triangles(5, 4, 6, 0, 5, 6, 7, 0),
	gsSP2Triangles(7, 6, 8, 0, 7, 8, 9, 0),
	gsSP2Triangles(10, 11, 12, 0, 13, 11, 10, 0),
	gsSP2Triangles(13, 14, 11, 0, 15, 14, 13, 0),
	gsSP2Triangles(15, 12, 14, 0, 10, 12, 15, 0),
	gsSPEndDisplayList(),
};


Gfx mat_mc_scarecrow_head_switch_head_tip[] = {
	gsSPClearGeometryMode(G_CULL_BACK),
	gsSPSetLights1(mc_scarecrow_head_switch_head_tip_lights),
	gsDPPipeSync(),
	gsDPSetCombineLERP(TEXEL0, 0, SHADE, 0, TEXEL0, 0, ENVIRONMENT, 0, TEXEL0, 0, SHADE, 0, TEXEL0, 0, ENVIRONMENT, 0),
	gsDPSetAlphaDither(G_AD_NOISE),
	gsDPSetTextureLUT(G_TT_RGBA16),
	gsSPTexture(65535, 65535, 0, 0, 1),
	gsDPSetTextureImage(G_IM_FMT_RGBA, G_IM_SIZ_16b, 1, mc_scarecrow_head_switch_head_alpha_pal_rgba16),
	gsDPSetTile(0, 0, 0, 256, 5, 0, G_TX_WRAP | G_TX_NOMIRROR, 0, 0, G_TX_WRAP | G_TX_NOMIRROR, 0, 0),
	gsDPLoadTLUTCmd(5, 18),
	gsDPSetTextureImage(G_IM_FMT_CI, G_IM_SIZ_8b_LOAD_BLOCK, 1, mc_scarecrow_head_switch_head_alpha_ci8),
	gsDPSetTile(G_IM_FMT_CI, G_IM_SIZ_8b_LOAD_BLOCK, 0, 0, 7, 0, G_TX_WRAP | G_TX_NOMIRROR, 0, 0, G_TX_WRAP | G_TX_NOMIRROR, 0, 0),
	gsDPLoadBlock(7, 0, 0, 127, 1024),
	gsDPSetTile(G_IM_FMT_CI, G_IM_SIZ_8b, 2, 0, 0, 0, G_TX_CLAMP | G_TX_NOMIRROR, 4, 0, G_TX_WRAP | G_TX_NOMIRROR, 4, 0),
	gsDPSetTileSize(0, 0, 0, 60, 60),
	gsSPEndDisplayList(),
};

Gfx mat_revert_mc_scarecrow_head_switch_head_tip[] = {
	gsSPSetGeometryMode(G_CULL_BACK),
	gsDPPipeSync(),
	gsDPSetAlphaDither(G_AD_DISABLE),
	gsDPSetTextureLUT(G_TT_NONE),
	gsSPEndDisplayList(),
};

Gfx mc_scarecrow_head_switch_head_switch_mesh_layer_4[] = {
	gsSPDisplayList(mat_mc_scarecrow_head_switch_head_tip),
	gsSPDisplayList(mc_scarecrow_head_switch_head_switch_mesh_layer_4_tri_0),
	gsSPDisplayList(mat_revert_mc_scarecrow_head_switch_head_tip),
	gsDPPipeSync(),
	gsSPSetGeometryMode(G_LIGHTING),
	gsSPClearGeometryMode(G_TEXTURE_GEN),
	gsDPSetCombineLERP(0, 0, 0, SHADE, 0, 0, 0, ENVIRONMENT, 0, 0, 0, SHADE, 0, 0, 0, ENVIRONMENT),
	gsSPTexture(65535, 65535, 0, 0, 0),
	gsDPSetEnvColor(255, 255, 255, 255),
	gsDPSetAlphaCompare(G_AC_NONE),
	gsSPEndDisplayList(),
};

