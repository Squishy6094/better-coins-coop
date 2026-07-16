Lights1 mc_scarecrow_wood2_lights = gdSPDefLights1(
	0x7F, 0x7F, 0x7F,
	0xFF, 0xFF, 0xFF, 0x28, 0x28, 0x28);

Lights1 mc_scarecrow_wood1_lights = gdSPDefLights1(
	0x7F, 0x7F, 0x7F,
	0xFF, 0xFF, 0xFF, 0x28, 0x28, 0x28);

Lights1 mc_scarecrow_spring_lights = gdSPDefLights1(
	0x7F, 0x7F, 0x7F,
	0xFF, 0xFF, 0xFF, 0x28, 0x28, 0x28);

Lights1 mc_scarecrow_shirt_lights = gdSPDefLights1(
	0x7F, 0x7F, 0x7F,
	0xFF, 0xFF, 0xFF, 0x28, 0x28, 0x28);

Lights1 mc_scarecrow_crown_lights = gdSPDefLights1(
	0x7F, 0x59, 0x22,
	0xFF, 0xB6, 0x4D, 0x28, 0x28, 0x28);

Lights1 mc_scarecrow_gloves_lights = gdSPDefLights1(
	0x73, 0x73, 0x73,
	0xE7, 0xE7, 0xE7, 0x28, 0x28, 0x28);

Lights1 mc_scarecrow_head_lights = gdSPDefLights1(
	0x7F, 0x7F, 0x7F,
	0xFF, 0xFF, 0xFF, 0x28, 0x28, 0x28);

Lights1 mc_scarecrow_eye_lights = gdSPDefLights1(
	0x7F, 0x7F, 0x7F,
	0xFF, 0xFF, 0xFF, 0x28, 0x28, 0x28);

Lights1 mc_scarecrow_head_tip_lights = gdSPDefLights1(
	0x7F, 0x7F, 0x7F,
	0xFF, 0xFF, 0xFF, 0x28, 0x28, 0x28);

Gfx mc_scarecrow_wood2_ci4_aligner[] = {gsSPEndDisplayList()};
u8 mc_scarecrow_wood2_ci4[] = {
	#include "actors/mc_scarecrow/wood2.ci4.inc.c"
};

Gfx mc_scarecrow_wood2_pal_rgba16_aligner[] = {gsSPEndDisplayList()};
u8 mc_scarecrow_wood2_pal_rgba16[] = {
	#include "actors/mc_scarecrow/wood2.rgba16.pal"
};

Gfx mc_scarecrow_wood1_ci4_aligner[] = {gsSPEndDisplayList()};
u8 mc_scarecrow_wood1_ci4[] = {
	#include "actors/mc_scarecrow/wood1.ci4.inc.c"
};

Gfx mc_scarecrow_wood1_pal_rgba16_aligner[] = {gsSPEndDisplayList()};
u8 mc_scarecrow_wood1_pal_rgba16[] = {
	#include "actors/mc_scarecrow/wood1.rgba16.pal"
};

Gfx mc_scarecrow_spring_ci4_aligner[] = {gsSPEndDisplayList()};
u8 mc_scarecrow_spring_ci4[] = {
	#include "actors/mc_scarecrow/spring.ci4.inc.c"
};

Gfx mc_scarecrow_spring_pal_rgba16_aligner[] = {gsSPEndDisplayList()};
u8 mc_scarecrow_spring_pal_rgba16[] = {
	#include "actors/mc_scarecrow/spring.rgba16.pal"
};

Gfx mc_scarecrow_cloth_ci4_aligner[] = {gsSPEndDisplayList()};
u8 mc_scarecrow_cloth_ci4[] = {
	#include "actors/mc_scarecrow/cloth.ci4.inc.c"
};

Gfx mc_scarecrow_cloth_pal_rgba16_aligner[] = {gsSPEndDisplayList()};
u8 mc_scarecrow_cloth_pal_rgba16[] = {
	#include "actors/mc_scarecrow/cloth.rgba16.pal"
};

Gfx mc_scarecrow_crown_ci4_aligner[] = {gsSPEndDisplayList()};
u8 mc_scarecrow_crown_ci4[] = {
	#include "actors/mc_scarecrow/crown.ci4.inc.c"
};

Gfx mc_scarecrow_crown_pal_rgba16_aligner[] = {gsSPEndDisplayList()};
u8 mc_scarecrow_crown_pal_rgba16[] = {
	#include "actors/mc_scarecrow/crown.rgba16.pal"
};

Gfx mc_scarecrow_head_ci4_aligner[] = {gsSPEndDisplayList()};
u8 mc_scarecrow_head_ci4[] = {
	#include "actors/mc_scarecrow/head.ci4.inc.c"
};

Gfx mc_scarecrow_head_pal_rgba16_aligner[] = {gsSPEndDisplayList()};
u8 mc_scarecrow_head_pal_rgba16[] = {
	#include "actors/mc_scarecrow/head.rgba16.pal"
};

Gfx mc_scarecrow_eye_ia8_aligner[] = {gsSPEndDisplayList()};
u8 mc_scarecrow_eye_ia8[] = {
	#include "actors/mc_scarecrow/eye.ia8.inc.c"
};

Gfx mc_scarecrow_head_alpha_ci8_aligner[] = {gsSPEndDisplayList()};
u8 mc_scarecrow_head_alpha_ci8[] = {
	#include "actors/mc_scarecrow/head_alpha.ci8.inc.c"
};

Gfx mc_scarecrow_head_alpha_pal_rgba16_aligner[] = {gsSPEndDisplayList()};
u8 mc_scarecrow_head_alpha_pal_rgba16[] = {
	#include "actors/mc_scarecrow/head_alpha.rgba16.pal"
};

Vtx mc_scarecrow_root_mesh_layer_1_vtx_0[20] = {
	{{{-18, 56, -31}, 0, {-13, 98}, {0xC1, 0x00, 0x92, 0xFF}}},
	{{{18, 26, -31}, 0, {156, 828}, {0x3F, 0x00, 0x92, 0xFF}}},
	{{{-18, 26, -31}, 0, {-13, 894}, {0xC1, 0x00, 0x92, 0xFF}}},
	{{{18, 56, -31}, 0, {156, 33}, {0x3F, 0x00, 0x92, 0xFF}}},
	{{{36, 26, 0}, 0, {326, 1004}, {0x7F, 0x00, 0x00, 0xFF}}},
	{{{36, 56, 0}, 0, {326, 209}, {0x7F, 0x00, 0x00, 0xFF}}},
	{{{18, 26, 31}, 0, {496, 894}, {0x3F, 0x00, 0x6E, 0xFF}}},
	{{{18, 56, 31}, 0, {496, 98}, {0x3F, 0x00, 0x6E, 0xFF}}},
	{{{-18, 26, 31}, 0, {665, 819}, {0xC1, 0x00, 0x6E, 0xFF}}},
	{{{-18, 56, 31}, 0, {665, 24}, {0xC1, 0x00, 0x6E, 0xFF}}},
	{{{-36, 26, 0}, 0, {835, 939}, {0x81, 0x00, 0x00, 0xFF}}},
	{{{-36, 56, 0}, 0, {835, 144}, {0x81, 0x00, 0x00, 0xFF}}},
	{{{-18, 26, -31}, 0, {1005, 894}, {0xC1, 0x00, 0x92, 0xFF}}},
	{{{-18, 56, -31}, 0, {1005, 98}, {0xC1, 0x00, 0x92, 0xFF}}},
	{{{-36, 56, 0}, 0, {-16, 496}, {0x00, 0x7F, 0x00, 0xFF}}},
	{{{-18, 56, 31}, 0, {240, 1008}, {0x00, 0x7F, 0x00, 0xFF}}},
	{{{-18, 56, -31}, 0, {240, -16}, {0x00, 0x7F, 0x00, 0xFF}}},
	{{{18, 56, 31}, 0, {752, 1008}, {0x00, 0x7F, 0x00, 0xFF}}},
	{{{18, 56, -31}, 0, {752, -16}, {0x00, 0x7F, 0x00, 0xFF}}},
	{{{36, 56, 0}, 0, {1008, 496}, {0x00, 0x7F, 0x00, 0xFF}}},
};

Gfx mc_scarecrow_root_mesh_layer_1_tri_0[] = {
	gsSPVertex(mc_scarecrow_root_mesh_layer_1_vtx_0 + 0, 20, 0),
	gsSP2Triangles(0, 1, 2, 0, 0, 3, 1, 0),
	gsSP2Triangles(3, 4, 1, 0, 3, 5, 4, 0),
	gsSP2Triangles(5, 6, 4, 0, 5, 7, 6, 0),
	gsSP2Triangles(7, 8, 6, 0, 7, 9, 8, 0),
	gsSP2Triangles(9, 10, 8, 0, 9, 11, 10, 0),
	gsSP2Triangles(11, 12, 10, 0, 11, 13, 12, 0),
	gsSP2Triangles(14, 15, 16, 0, 17, 16, 15, 0),
	gsSP2Triangles(17, 18, 16, 0, 19, 18, 17, 0),
	gsSPEndDisplayList(),
};

Vtx mc_scarecrow_root_mesh_layer_1_vtx_1[34] = {
	{{{0, 26, -70}, 0, {-16, 411}, {0x00, 0x00, 0x81, 0xFF}}},
	{{{0, 0, -70}, 0, {-16, 581}, {0x00, 0x00, 0x81, 0xFF}}},
	{{{-50, 0, -50}, 0, {112, 581}, {0xA6, 0x00, 0xA6, 0xFF}}},
	{{{-50, 26, -50}, 0, {112, 411}, {0xA6, 0x00, 0xA6, 0xFF}}},
	{{{-70, 0, 0}, 0, {240, 581}, {0x81, 0x00, 0x00, 0xFF}}},
	{{{-70, 26, 0}, 0, {240, 411}, {0x81, 0x00, 0x00, 0xFF}}},
	{{{-50, 0, 50}, 0, {368, 581}, {0xA6, 0x00, 0x5A, 0xFF}}},
	{{{-50, 26, 50}, 0, {368, 411}, {0xA6, 0x00, 0x5A, 0xFF}}},
	{{{0, 0, 70}, 0, {496, 581}, {0x00, 0x00, 0x7F, 0xFF}}},
	{{{0, 26, 70}, 0, {496, 411}, {0x00, 0x00, 0x7F, 0xFF}}},
	{{{50, 0, 50}, 0, {624, 581}, {0x5A, 0x00, 0x5A, 0xFF}}},
	{{{50, 26, 50}, 0, {624, 411}, {0x5A, 0x00, 0x5A, 0xFF}}},
	{{{70, 0, 0}, 0, {752, 581}, {0x7F, 0x00, 0x00, 0xFF}}},
	{{{70, 26, 0}, 0, {752, 411}, {0x7F, 0x00, 0x00, 0xFF}}},
	{{{50, 0, -50}, 0, {880, 581}, {0x5A, 0x00, 0xA6, 0xFF}}},
	{{{50, 26, -50}, 0, {880, 411}, {0x5A, 0x00, 0xA6, 0xFF}}},
	{{{0, 0, -70}, 0, {1008, 581}, {0x00, 0x00, 0x81, 0xFF}}},
	{{{0, 26, -70}, 0, {1008, 411}, {0x00, 0x00, 0x81, 0xFF}}},
	{{{0, 0, -70}, 0, {496, 28}, {0x00, 0x81, 0x00, 0xFF}}},
	{{{50, 0, -50}, 0, {827, 165}, {0x00, 0x81, 0x00, 0xFF}}},
	{{{-50, 0, -50}, 0, {165, 165}, {0x00, 0x81, 0x00, 0xFF}}},
	{{{-70, 0, 0}, 0, {28, 496}, {0x00, 0x81, 0x00, 0xFF}}},
	{{{70, 0, 0}, 0, {964, 496}, {0x00, 0x81, 0x00, 0xFF}}},
	{{{-50, 0, 50}, 0, {165, 827}, {0x00, 0x81, 0x00, 0xFF}}},
	{{{50, 0, 50}, 0, {827, 827}, {0x00, 0x81, 0x00, 0xFF}}},
	{{{0, 0, 70}, 0, {496, 964}, {0x00, 0x81, 0x00, 0xFF}}},
	{{{0, 26, -70}, 0, {496, 28}, {0x00, 0x7F, 0x00, 0xFF}}},
	{{{-50, 26, -50}, 0, {165, 165}, {0x00, 0x7F, 0x00, 0xFF}}},
	{{{50, 26, -50}, 0, {827, 165}, {0x00, 0x7F, 0x00, 0xFF}}},
	{{{70, 26, 0}, 0, {964, 496}, {0x00, 0x7F, 0x00, 0xFF}}},
	{{{-70, 26, 0}, 0, {28, 496}, {0x00, 0x7F, 0x00, 0xFF}}},
	{{{50, 26, 50}, 0, {827, 827}, {0x00, 0x7F, 0x00, 0xFF}}},
	{{{-50, 26, 50}, 0, {165, 827}, {0x00, 0x7F, 0x00, 0xFF}}},
	{{{0, 26, 70}, 0, {496, 964}, {0x00, 0x7F, 0x00, 0xFF}}},
};

Gfx mc_scarecrow_root_mesh_layer_1_tri_1[] = {
	gsSPVertex(mc_scarecrow_root_mesh_layer_1_vtx_1 + 0, 34, 0),
	gsSP2Triangles(0, 1, 2, 0, 0, 2, 3, 0),
	gsSP2Triangles(3, 2, 4, 0, 3, 4, 5, 0),
	gsSP2Triangles(5, 4, 6, 0, 5, 6, 7, 0),
	gsSP2Triangles(7, 6, 8, 0, 7, 8, 9, 0),
	gsSP2Triangles(9, 8, 10, 0, 9, 10, 11, 0),
	gsSP2Triangles(11, 10, 12, 0, 11, 12, 13, 0),
	gsSP2Triangles(13, 12, 14, 0, 13, 14, 15, 0),
	gsSP2Triangles(15, 14, 16, 0, 15, 16, 17, 0),
	gsSP2Triangles(18, 19, 20, 0, 19, 21, 20, 0),
	gsSP2Triangles(19, 22, 21, 0, 22, 23, 21, 0),
	gsSP2Triangles(22, 24, 23, 0, 23, 24, 25, 0),
	gsSP2Triangles(26, 27, 28, 0, 27, 29, 28, 0),
	gsSP2Triangles(27, 30, 29, 0, 30, 31, 29, 0),
	gsSP2Triangles(30, 32, 31, 0, 32, 33, 31, 0),
	gsSPEndDisplayList(),
};

Vtx mc_scarecrow_body_skinned_mesh_layer_4_vtx_0[6] = {
	{{{21, 55, 0}, 0, {368, 2288}, {0x7F, 0x00, 0x00, 0xFF}}},
	{{{21, 55, 0}, 0, {112, 2544}, {0x7F, 0x00, 0x00, 0xFF}}},
	{{{0, 55, 21}, 0, {240, 2288}, {0x00, 0x00, 0x7F, 0xFF}}},
	{{{-21, 55, 0}, 0, {112, 2288}, {0x81, 0x00, 0x00, 0xFF}}},
	{{{0, 55, -21}, 0, {240, 2544}, {0x00, 0x00, 0x81, 0xFF}}},
	{{{-21, 55, 0}, 0, {368, 2544}, {0x81, 0x00, 0x00, 0xFF}}},
};

Gfx mc_scarecrow_body_skinned_mesh_layer_4_tri_0[] = {
	gsSPVertex(mc_scarecrow_body_skinned_mesh_layer_4_vtx_0 + 0, 6, 0),
	gsSPEndDisplayList(),
};

Vtx mc_scarecrow_body_mesh_layer_4_vtx_0[6] = {
	{{{21, 35, 0}, 0, {368, -1808}, {0x7F, 0x00, 0x00, 0xFF}}},
	{{{0, 35, 21}, 0, {240, -1808}, {0x00, 0x00, 0x7F, 0xFF}}},
	{{{-21, 35, 0}, 0, {112, -1808}, {0x81, 0x00, 0x00, 0xFF}}},
	{{{0, 35, -21}, 0, {240, -1552}, {0x00, 0x00, 0x81, 0xFF}}},
	{{{21, 35, 0}, 0, {112, -1552}, {0x7F, 0x00, 0x00, 0xFF}}},
	{{{-21, 35, 0}, 0, {368, -1552}, {0x81, 0x00, 0x00, 0xFF}}},
};

Gfx mc_scarecrow_body_mesh_layer_4_tri_0[] = {
	gsSPVertex(mc_scarecrow_body_mesh_layer_4_vtx_0 + 0, 6, 6),
	gsSP2Triangles(0, 6, 7, 0, 0, 7, 2, 0),
	gsSP2Triangles(2, 7, 8, 0, 2, 8, 3, 0),
	gsSP2Triangles(1, 9, 10, 0, 1, 4, 9, 0),
	gsSP2Triangles(4, 11, 9, 0, 4, 5, 11, 0),
	gsSPEndDisplayList(),
};

Vtx mc_scarecrow_body_mesh_layer_1_vtx_0[23] = {
	{{{0, 96, -45}, 0, {240, -900}, {0x00, 0x33, 0x8C, 0xFF}}},
	{{{0, -49, -106}, 0, {240, 706}, {0x00, 0x33, 0x8C, 0xFF}}},
	{{{-78, -49, -75}, 0, {59, 706}, {0xAF, 0x2F, 0xAB, 0xFF}}},
	{{{78, -49, -75}, 0, {421, 706}, {0x51, 0x2F, 0xAB, 0xFF}}},
	{{{47, 96, -23}, 0, {348, -900}, {0x5F, 0x37, 0xC0, 0xFF}}},
	{{{111, -49, 0}, 0, {496, 706}, {0x77, 0x2D, 0x00, 0xFF}}},
	{{{47, 96, 23}, 0, {348, -900}, {0x5F, 0x37, 0x40, 0xFF}}},
	{{{78, -49, 75}, 0, {421, 706}, {0x51, 0x2F, 0x55, 0xFF}}},
	{{{0, 96, 45}, 0, {240, -900}, {0x00, 0x33, 0x74, 0xFF}}},
	{{{0, -49, 106}, 0, {240, 706}, {0x00, 0x33, 0x74, 0xFF}}},
	{{{-78, -49, 75}, 0, {59, 706}, {0xAF, 0x2F, 0x55, 0xFF}}},
	{{{-47, 96, 23}, 0, {132, -900}, {0xA1, 0x37, 0x40, 0xFF}}},
	{{{-111, -49, 0}, 0, {-16, 706}, {0x89, 0x2D, 0x00, 0xFF}}},
	{{{-47, 96, -23}, 0, {132, -900}, {0xA1, 0x37, 0xC0, 0xFF}}},
	{{{0, -49, -106}, 0, {240, 706}, {0x00, 0x9B, 0x4D, 0xFF}}},
	{{{78, -49, -75}, 0, {421, 706}, {0xCB, 0x9A, 0x36, 0xFF}}},
	{{{0, 31, 0}, 0, {240, 706}, {0x00, 0x81, 0x00, 0xFF}}},
	{{{111, -49, 0}, 0, {496, 706}, {0xB6, 0x99, 0x00, 0xFF}}},
	{{{78, -49, 75}, 0, {421, 706}, {0xCB, 0x9A, 0xCA, 0xFF}}},
	{{{0, -49, 106}, 0, {240, 706}, {0x00, 0x9B, 0xB3, 0xFF}}},
	{{{-78, -49, 75}, 0, {59, 706}, {0x35, 0x9A, 0xCA, 0xFF}}},
	{{{-111, -49, 0}, 0, {-16, 706}, {0x4A, 0x99, 0x00, 0xFF}}},
	{{{-78, -49, -75}, 0, {59, 706}, {0x35, 0x9A, 0x36, 0xFF}}},
};

Gfx mc_scarecrow_body_mesh_layer_1_tri_0[] = {
	gsSPVertex(mc_scarecrow_body_mesh_layer_1_vtx_0 + 0, 23, 0),
	gsSP2Triangles(0, 1, 2, 0, 0, 3, 1, 0),
	gsSP2Triangles(0, 4, 3, 0, 5, 3, 4, 0),
	gsSP2Triangles(5, 4, 6, 0, 6, 7, 5, 0),
	gsSP2Triangles(8, 7, 6, 0, 8, 9, 7, 0),
	gsSP2Triangles(8, 10, 9, 0, 8, 11, 10, 0),
	gsSP2Triangles(11, 12, 10, 0, 13, 12, 11, 0),
	gsSP2Triangles(13, 2, 12, 0, 0, 2, 13, 0),
	gsSP2Triangles(14, 15, 16, 0, 15, 17, 16, 0),
	gsSP2Triangles(17, 18, 16, 0, 18, 19, 16, 0),
	gsSP2Triangles(19, 20, 16, 0, 20, 21, 16, 0),
	gsSP2Triangles(21, 22, 16, 0, 22, 14, 16, 0),
	gsSPEndDisplayList(),
};

Vtx mc_scarecrow_body_mesh_layer_1_vtx_1[32] = {
	{{{0, 55, 5}, 0, {242, 104}, {0x00, 0x81, 0x01, 0xFF}}},
	{{{-69, 97, 35}, 0, {242, 104}, {0x97, 0xFD, 0x48, 0xFF}}},
	{{{-73, 108, -37}, 0, {242, 104}, {0x94, 0x0F, 0xC0, 0xFF}}},
	{{{0, 91, 55}, 0, {242, 104}, {0x00, 0xF3, 0x7E, 0xFF}}},
	{{{69, 97, 35}, 0, {242, 104}, {0x69, 0xFE, 0x47, 0xFF}}},
	{{{73, 108, -37}, 0, {242, 104}, {0x6D, 0x10, 0xC1, 0xFF}}},
	{{{0, 103, -66}, 0, {242, 104}, {0x00, 0x01, 0x81, 0xFF}}},
	{{{-21, 127, -20}, 0, {242, 104}, {0xEC, 0x7B, 0xEA, 0xFF}}},
	{{{-20, 124, 18}, 0, {242, 104}, {0xEA, 0x73, 0x31, 0xFF}}},
	{{{20, 124, 18}, 0, {242, 104}, {0x18, 0x73, 0x2F, 0xFF}}},
	{{{21, 127, -20}, 0, {242, 104}, {0x17, 0x7B, 0xEB, 0xFF}}},
	{{{-16, 81, 50}, 0, {242, 104}, {0x9E, 0xB1, 0x0F, 0xFF}}},
	{{{-16, 99, 52}, 0, {242, 104}, {0x99, 0x45, 0x1D, 0xFF}}},
	{{{0, 95, 12}, 0, {242, 104}, {0x00, 0x0D, 0x82, 0xFF}}},
	{{{0, 78, 61}, 0, {242, 104}, {0x00, 0x9F, 0x52, 0xFF}}},
	{{{16, 81, 50}, 0, {242, 104}, {0x62, 0xB1, 0x0F, 0xFF}}},
	{{{16, 99, 52}, 0, {242, 104}, {0x67, 0x45, 0x1D, 0xFF}}},
	{{{0, 103, 63}, 0, {242, 104}, {0x00, 0x53, 0x60, 0xFF}}},
	{{{-35, 70, 61}, 0, {242, 104}, {0x9C, 0x4A, 0x1A, 0xFF}}},
	{{{-6, 87, 43}, 0, {242, 104}, {0x15, 0x62, 0xB1, 0xFF}}},
	{{{-34, 59, 50}, 0, {242, 104}, {0xB3, 0xD2, 0xA6, 0xFF}}},
	{{{-5, 58, 78}, 0, {242, 104}, {0x38, 0x0C, 0x71, 0xFF}}},
	{{{-31, 49, 77}, 0, {242, 104}, {0xB8, 0xBE, 0x51, 0xFF}}},
	{{{-4, 47, 67}, 0, {242, 104}, {0x47, 0x97, 0xF9, 0xFF}}},
	{{{7, 82, 50}, 0, {242, 104}, {0x69, 0x40, 0xE1, 0xFF}}},
	{{{37, 69, 60}, 0, {242, 104}, {0x6B, 0x42, 0x13, 0xFF}}},
	{{{34, 58, 49}, 0, {242, 104}, {0x43, 0xCD, 0xA1, 0xFF}}},
	{{{7, 89, 44}, 0, {242, 104}, {0xEE, 0x63, 0xB3, 0xFF}}},
	{{{32, 48, 76}, 0, {242, 104}, {0x48, 0xB8, 0x4C, 0xFF}}},
	{{{7, 60, 79}, 0, {242, 104}, {0xD1, 0x10, 0x75, 0xFF}}},
	{{{-5, 85, 52}, 0, {242, 104}, {0x9A, 0x48, 0xE8, 0xFF}}},
	{{{4, 48, 68}, 0, {242, 104}, {0xB1, 0x9D, 0xFE, 0xFF}}},
};

Gfx mc_scarecrow_body_mesh_layer_1_tri_1[] = {
	gsSPVertex(mc_scarecrow_body_mesh_layer_1_vtx_1 + 0, 32, 0),
	gsSP2Triangles(0, 1, 2, 0, 0, 3, 1, 0),
	gsSP2Triangles(0, 4, 3, 0, 0, 5, 4, 0),
	gsSP2Triangles(0, 6, 5, 0, 0, 2, 6, 0),
	gsSP2Triangles(6, 2, 7, 0, 2, 8, 7, 0),
	gsSP2Triangles(2, 1, 8, 0, 1, 3, 8, 0),
	gsSP2Triangles(8, 3, 9, 0, 3, 4, 9, 0),
	gsSP2Triangles(4, 10, 9, 0, 4, 5, 10, 0),
	gsSP2Triangles(5, 6, 10, 0, 6, 7, 10, 0),
	gsSP2Triangles(8, 10, 7, 0, 8, 9, 10, 0),
	gsSP2Triangles(11, 12, 13, 0, 14, 12, 11, 0),
	gsSP2Triangles(13, 14, 11, 0, 13, 15, 14, 0),
	gsSP2Triangles(13, 16, 15, 0, 13, 17, 16, 0),
	gsSP2Triangles(13, 12, 17, 0, 14, 17, 12, 0),
	gsSP2Triangles(15, 17, 14, 0, 15, 16, 17, 0),
	gsSP2Triangles(18, 19, 20, 0, 21, 19, 18, 0),
	gsSP2Triangles(21, 18, 22, 0, 18, 20, 22, 0),
	gsSP2Triangles(20, 23, 22, 0, 20, 24, 23, 0),
	gsSP2Triangles(20, 19, 24, 0, 21, 24, 19, 0),
	gsSP2Triangles(23, 24, 21, 0, 23, 21, 22, 0),
	gsSP2Triangles(25, 26, 27, 0, 25, 28, 26, 0),
	gsSP2Triangles(29, 28, 25, 0, 29, 25, 27, 0),
	gsSP2Triangles(29, 27, 30, 0, 26, 30, 27, 0),
	gsSP2Triangles(26, 31, 30, 0, 26, 28, 31, 0),
	gsSP2Triangles(31, 28, 29, 0, 31, 29, 30, 0),
	gsSPEndDisplayList(),
};

Vtx mc_scarecrow_arm_l_mesh_layer_1_vtx_0[17] = {
	{{{3, 20, -7}, 0, {118, -251}, {0xD4, 0x77, 0x00, 0xFF}}},
	{{{80, -8, 38}, 0, {180, 734}, {0xE7, 0x2C, 0x74, 0xFF}}},
	{{{87, 24, -7}, 0, {-16, 734}, {0xF9, 0x7F, 0x00, 0xFF}}},
	{{{-1, 3, 17}, 0, {221, -251}, {0xC4, 0x2F, 0x66, 0xFF}}},
	{{{-17, -1, -7}, 0, {239, -260}, {0x84, 0x1B, 0x00, 0xFF}}},
	{{{-1, 3, -30}, 0, {221, -251}, {0xC4, 0x2F, 0x9A, 0xFF}}},
	{{{80, -8, -51}, 0, {180, 734}, {0xE7, 0x2C, 0x8C, 0xFF}}},
	{{{-7, -24, -21}, 0, {388, -251}, {0xAA, 0xBA, 0xC1, 0xFF}}},
	{{{68, -59, -34}, 0, {496, 734}, {0xCA, 0xA6, 0xB8, 0xFF}}},
	{{{-7, -24, 8}, 0, {388, -251}, {0xAA, 0xBA, 0x3F, 0xFF}}},
	{{{68, -59, 21}, 0, {496, 734}, {0xCA, 0xA6, 0x48, 0xFF}}},
	{{{52, 11, -7}, 0, {242, 734}, {0x6B, 0xBC, 0x00, 0xFF}}},
	{{{68, -59, 21}, 0, {496, 734}, {0x7B, 0x12, 0xE4, 0xFF}}},
	{{{68, -59, -34}, 0, {496, 734}, {0x7B, 0x12, 0x1C, 0xFF}}},
	{{{80, -8, 38}, 0, {180, 734}, {0x61, 0xDC, 0xB6, 0xFF}}},
	{{{87, 24, -7}, 0, {-16, 734}, {0x2E, 0x89, 0x00, 0xFF}}},
	{{{80, -8, -51}, 0, {180, 734}, {0x61, 0xDC, 0x4A, 0xFF}}},
};

Gfx mc_scarecrow_arm_l_mesh_layer_1_tri_0[] = {
	gsSPVertex(mc_scarecrow_arm_l_mesh_layer_1_vtx_0 + 0, 17, 0),
	gsSP2Triangles(0, 1, 2, 0, 0, 3, 1, 0),
	gsSP2Triangles(0, 4, 3, 0, 5, 4, 0, 0),
	gsSP2Triangles(5, 0, 2, 0, 5, 2, 6, 0),
	gsSP2Triangles(7, 5, 6, 0, 7, 6, 8, 0),
	gsSP2Triangles(9, 7, 8, 0, 9, 8, 10, 0),
	gsSP2Triangles(3, 9, 10, 0, 3, 10, 1, 0),
	gsSP2Triangles(3, 4, 9, 0, 9, 4, 7, 0),
	gsSP2Triangles(7, 4, 5, 0, 11, 12, 13, 0),
	gsSP2Triangles(11, 14, 12, 0, 11, 15, 14, 0),
	gsSP2Triangles(11, 16, 15, 0, 11, 13, 16, 0),
	gsSPEndDisplayList(),
};

Vtx mc_scarecrow_arm_l_mesh_layer_1_vtx_1[8] = {
	{{{66, -6, -26}, 0, {125, 267}, {0x00, 0xC1, 0x92, 0xFF}}},
	{{{125, 15, -14}, 0, {382, 1017}, {0x00, 0x7F, 0x00, 0xFF}}},
	{{{125, -6, -26}, 0, {125, 1017}, {0x00, 0xC1, 0x92, 0xFF}}},
	{{{66, 15, -14}, 0, {382, 267}, {0x00, 0x7F, 0x00, 0xFF}}},
	{{{125, -6, -1}, 0, {639, 1017}, {0x00, 0xC1, 0x6E, 0xFF}}},
	{{{66, -6, -1}, 0, {639, 267}, {0x00, 0xC1, 0x6E, 0xFF}}},
	{{{125, -6, -26}, 0, {897, 1017}, {0x00, 0xC1, 0x92, 0xFF}}},
	{{{66, -6, -26}, 0, {897, 267}, {0x00, 0xC1, 0x92, 0xFF}}},
};

Gfx mc_scarecrow_arm_l_mesh_layer_1_tri_1[] = {
	gsSPVertex(mc_scarecrow_arm_l_mesh_layer_1_vtx_1 + 0, 8, 0),
	gsSP2Triangles(0, 1, 2, 0, 0, 3, 1, 0),
	gsSP2Triangles(3, 4, 1, 0, 3, 5, 4, 0),
	gsSP2Triangles(5, 6, 4, 0, 5, 7, 6, 0),
	gsSPEndDisplayList(),
};

Vtx mc_scarecrow_arm_l_mesh_layer_1_vtx_2[7] = {
	{{{163, 5, -12}, 0, {-16, 1008}, {0x7F, 0x00, 0x00, 0xFF}}},
	{{{135, -10, -54}, 0, {-16, 1008}, {0x00, 0xD6, 0x88, 0xFF}}},
	{{{135, 40, -39}, 0, {-16, 1008}, {0x00, 0x65, 0xB3, 0xFF}}},
	{{{135, -40, -11}, 0, {-16, 1008}, {0x00, 0x81, 0x03, 0xFF}}},
	{{{135, -8, 31}, 0, {-16, 1008}, {0x00, 0xDC, 0x7A, 0xFF}}},
	{{{135, 41, 13}, 0, {-16, 1008}, {0x00, 0x68, 0x48, 0xFF}}},
	{{{108, 5, -12}, 0, {-16, 1008}, {0x81, 0x00, 0x00, 0xFF}}},
};

Gfx mc_scarecrow_arm_l_mesh_layer_1_tri_2[] = {
	gsSPVertex(mc_scarecrow_arm_l_mesh_layer_1_vtx_2 + 0, 7, 0),
	gsSP2Triangles(0, 1, 2, 0, 0, 3, 1, 0),
	gsSP2Triangles(0, 4, 3, 0, 0, 5, 4, 0),
	gsSP2Triangles(0, 2, 5, 0, 5, 2, 6, 0),
	gsSP2Triangles(2, 1, 6, 0, 1, 3, 6, 0),
	gsSP2Triangles(3, 4, 6, 0, 4, 5, 6, 0),
	gsSPEndDisplayList(),
};

Vtx mc_scarecrow_hand_l_mesh_layer_1_vtx_0[27] = {
	{{{-14, 9, 9}, 0, {438, 54}, {0xA6, 0x44, 0x3A, 0xFF}}},
	{{{0, -50, 28}, 0, {554, 54}, {0xCC, 0xDF, 0x6F, 0xFF}}},
	{{{23, 23, 14}, 0, {378, 269}, {0x19, 0x66, 0x47, 0xFF}}},
	{{{37, -50, 32}, 0, {554, 170}, {0x2D, 0xE2, 0x73, 0xFF}}},
	{{{40, -72, 7}, 0, {659, 240}, {0x39, 0x97, 0x2B, 0xFF}}},
	{{{5, -75, 7}, 0, {624, 54}, {0xD9, 0x90, 0x2F, 0xFF}}},
	{{{56, -48, 7}, 0, {554, 292}, {0x78, 0xED, 0x26, 0xFF}}},
	{{{40, -72, -39}, 0, {659, 496}, {0x3B, 0x97, 0xD8, 0xFF}}},
	{{{5, -75, 7}, 0, {810, 310}, {0xD9, 0x90, 0x2F, 0xFF}}},
	{{{5, -75, -39}, 0, {810, 426}, {0xD7, 0x90, 0xD5, 0xFF}}},
	{{{56, -48, -39}, 0, {554, 444}, {0x78, 0xED, 0xDA, 0xFF}}},
	{{{37, -50, -64}, 0, {554, 566}, {0x2F, 0xE5, 0x8D, 0xFF}}},
	{{{5, -75, -39}, 0, {624, 775}, {0xD7, 0x90, 0xD5, 0xFF}}},
	{{{0, -50, -60}, 0, {554, 700}, {0xCA, 0xE2, 0x91, 0xFF}}},
	{{{-17, -51, -37}, 0, {554, 822}, {0x8D, 0xD7, 0xDC, 0xFF}}},
	{{{5, -75, 7}, 0, {624, 938}, {0xD9, 0x90, 0x2F, 0xFF}}},
	{{{-17, -51, 5}, 0, {554, 938}, {0x8D, 0xD7, 0x24, 0xFF}}},
	{{{0, -50, 28}, 0, {554, 1008}, {0xCC, 0xDF, 0x6F, 0xFF}}},
	{{{-14, 9, 9}, 0, {438, 973}, {0xA6, 0x44, 0x3A, 0xFF}}},
	{{{-14, 9, -40}, 0, {438, 752}, {0xA6, 0x44, 0xC6, 0xFF}}},
	{{{23, 23, -45}, 0, {384, 525}, {0x19, 0x66, 0xB9, 0xFF}}},
	{{{46, 0, -33}, 0, {420, 426}, {0x6C, 0x37, 0xDB, 0xFF}}},
	{{{46, 0, 2}, 0, {420, 310}, {0x6C, 0x37, 0x25, 0xFF}}},
	{{{23, 23, 14}, 0, {298, 310}, {0x19, 0x66, 0x47, 0xFF}}},
	{{{23, 23, -45}, 0, {298, 426}, {0x19, 0x66, 0xB9, 0xFF}}},
	{{{-14, 9, -40}, 0, {147, 461}, {0xA6, 0x44, 0xC6, 0xFF}}},
	{{{-14, 9, 9}, 0, {147, 275}, {0xA6, 0x44, 0x3A, 0xFF}}},
};

Gfx mc_scarecrow_hand_l_mesh_layer_1_tri_0[] = {
	gsSPVertex(mc_scarecrow_hand_l_mesh_layer_1_vtx_0 + 0, 27, 0),
	gsSP2Triangles(0, 1, 2, 0, 3, 2, 1, 0),
	gsSP2Triangles(4, 3, 1, 0, 4, 1, 5, 0),
	gsSP2Triangles(4, 6, 3, 0, 7, 6, 4, 0),
	gsSP2Triangles(7, 4, 8, 0, 7, 8, 9, 0),
	gsSP2Triangles(7, 10, 6, 0, 7, 11, 10, 0),
	gsSP2Triangles(12, 11, 7, 0, 12, 13, 11, 0),
	gsSP2Triangles(12, 14, 13, 0, 15, 14, 12, 0),
	gsSP2Triangles(15, 16, 14, 0, 17, 16, 15, 0),
	gsSP2Triangles(18, 16, 17, 0, 18, 14, 16, 0),
	gsSP2Triangles(18, 19, 14, 0, 13, 14, 19, 0),
	gsSP2Triangles(19, 20, 13, 0, 13, 20, 11, 0),
	gsSP2Triangles(11, 20, 21, 0, 10, 11, 21, 0),
	gsSP2Triangles(21, 6, 10, 0, 21, 22, 6, 0),
	gsSP2Triangles(23, 22, 21, 0, 23, 21, 24, 0),
	gsSP2Triangles(25, 23, 24, 0, 25, 26, 23, 0),
	gsSP2Triangles(3, 6, 22, 0, 22, 2, 3, 0),
	gsSPEndDisplayList(),
};

Vtx mc_scarecrow_arm_r_mesh_layer_1_vtx_0[17] = {
	{{{-3, 20, -7}, 0, {118, -251}, {0x2C, 0x77, 0x00, 0xFF}}},
	{{{-87, 24, -7}, 0, {-16, 734}, {0x07, 0x7F, 0x00, 0xFF}}},
	{{{-80, -8, 38}, 0, {180, 734}, {0x19, 0x2C, 0x74, 0xFF}}},
	{{{1, 3, -30}, 0, {221, -251}, {0x3C, 0x2F, 0x9A, 0xFF}}},
	{{{17, -1, -7}, 0, {239, -260}, {0x7C, 0x1B, 0x00, 0xFF}}},
	{{{1, 3, 17}, 0, {221, -251}, {0x3C, 0x2F, 0x66, 0xFF}}},
	{{{-68, -59, 21}, 0, {496, 734}, {0x36, 0xA6, 0x48, 0xFF}}},
	{{{7, -24, 8}, 0, {388, -251}, {0x56, 0xBA, 0x3F, 0xFF}}},
	{{{-68, -59, -34}, 0, {496, 734}, {0x36, 0xA6, 0xB8, 0xFF}}},
	{{{7, -24, -21}, 0, {388, -251}, {0x56, 0xBA, 0xC1, 0xFF}}},
	{{{-80, -8, -51}, 0, {180, 734}, {0x19, 0x2C, 0x8C, 0xFF}}},
	{{{-52, 11, -7}, 0, {242, 734}, {0x95, 0xBC, 0x00, 0xFF}}},
	{{{-87, 24, -7}, 0, {-16, 734}, {0xD2, 0x89, 0x00, 0xFF}}},
	{{{-80, -8, -51}, 0, {180, 734}, {0x9F, 0xDC, 0x4A, 0xFF}}},
	{{{-80, -8, 38}, 0, {180, 734}, {0x9F, 0xDC, 0xB6, 0xFF}}},
	{{{-68, -59, 21}, 0, {496, 734}, {0x85, 0x12, 0xE4, 0xFF}}},
	{{{-68, -59, -34}, 0, {496, 734}, {0x85, 0x12, 0x1C, 0xFF}}},
};

Gfx mc_scarecrow_arm_r_mesh_layer_1_tri_0[] = {
	gsSPVertex(mc_scarecrow_arm_r_mesh_layer_1_vtx_0 + 0, 17, 0),
	gsSP2Triangles(0, 1, 2, 0, 3, 1, 0, 0),
	gsSP2Triangles(3, 0, 4, 0, 0, 5, 4, 0),
	gsSP2Triangles(0, 2, 5, 0, 5, 2, 6, 0),
	gsSP2Triangles(5, 6, 7, 0, 7, 6, 8, 0),
	gsSP2Triangles(7, 8, 9, 0, 9, 8, 10, 0),
	gsSP2Triangles(9, 10, 3, 0, 3, 10, 1, 0),
	gsSP2Triangles(9, 3, 4, 0, 7, 9, 4, 0),
	gsSP2Triangles(5, 7, 4, 0, 11, 12, 13, 0),
	gsSP2Triangles(11, 14, 12, 0, 15, 14, 11, 0),
	gsSP2Triangles(15, 11, 16, 0, 11, 13, 16, 0),
	gsSPEndDisplayList(),
};

Vtx mc_scarecrow_arm_r_mesh_layer_1_vtx_1[8] = {
	{{{-66, -6, -26}, 0, {125, 267}, {0x00, 0xC1, 0x92, 0xFF}}},
	{{{-125, -6, -26}, 0, {125, 1017}, {0x00, 0xC1, 0x92, 0xFF}}},
	{{{-125, 15, -14}, 0, {382, 1017}, {0x00, 0x7F, 0x00, 0xFF}}},
	{{{-66, 15, -14}, 0, {382, 267}, {0x00, 0x7F, 0x00, 0xFF}}},
	{{{-125, -6, -1}, 0, {639, 1017}, {0x00, 0xC1, 0x6E, 0xFF}}},
	{{{-66, -6, -1}, 0, {639, 267}, {0x00, 0xC1, 0x6E, 0xFF}}},
	{{{-125, -6, -26}, 0, {897, 1017}, {0x00, 0xC1, 0x92, 0xFF}}},
	{{{-66, -6, -26}, 0, {897, 267}, {0x00, 0xC1, 0x92, 0xFF}}},
};

Gfx mc_scarecrow_arm_r_mesh_layer_1_tri_1[] = {
	gsSPVertex(mc_scarecrow_arm_r_mesh_layer_1_vtx_1 + 0, 8, 0),
	gsSP2Triangles(0, 1, 2, 0, 0, 2, 3, 0),
	gsSP2Triangles(3, 2, 4, 0, 3, 4, 5, 0),
	gsSP2Triangles(5, 4, 6, 0, 5, 6, 7, 0),
	gsSPEndDisplayList(),
};

Vtx mc_scarecrow_arm_r_mesh_layer_1_vtx_2[7] = {
	{{{-163, 5, -12}, 0, {-16, 1008}, {0x81, 0x00, 0x00, 0xFF}}},
	{{{-135, 40, -39}, 0, {-16, 1008}, {0x00, 0x65, 0xB3, 0xFF}}},
	{{{-135, -10, -54}, 0, {-16, 1008}, {0x00, 0xD6, 0x88, 0xFF}}},
	{{{-135, 41, 13}, 0, {-16, 1008}, {0x00, 0x68, 0x48, 0xFF}}},
	{{{-135, -8, 31}, 0, {-16, 1008}, {0x00, 0xDC, 0x7A, 0xFF}}},
	{{{-135, -40, -11}, 0, {-16, 1008}, {0x00, 0x81, 0x03, 0xFF}}},
	{{{-108, 5, -12}, 0, {-16, 1008}, {0x7F, 0x00, 0x00, 0xFF}}},
};

Gfx mc_scarecrow_arm_r_mesh_layer_1_tri_2[] = {
	gsSPVertex(mc_scarecrow_arm_r_mesh_layer_1_vtx_2 + 0, 7, 0),
	gsSP2Triangles(0, 1, 2, 0, 0, 3, 1, 0),
	gsSP2Triangles(0, 4, 3, 0, 0, 5, 4, 0),
	gsSP2Triangles(0, 2, 5, 0, 2, 6, 5, 0),
	gsSP2Triangles(1, 6, 2, 0, 3, 6, 1, 0),
	gsSP2Triangles(4, 6, 3, 0, 5, 6, 4, 0),
	gsSPEndDisplayList(),
};

Vtx mc_scarecrow_hand_r_mesh_layer_1_vtx_0[27] = {
	{{{14, 9, 9}, 0, {438, 54}, {0x5A, 0x44, 0x3A, 0xFF}}},
	{{{-23, 23, 14}, 0, {378, 269}, {0xE7, 0x66, 0x47, 0xFF}}},
	{{{0, -50, 28}, 0, {554, 54}, {0x34, 0xDF, 0x6F, 0xFF}}},
	{{{-37, -50, 32}, 0, {554, 170}, {0xD3, 0xE2, 0x73, 0xFF}}},
	{{{-46, 0, 2}, 0, {420, 310}, {0x94, 0x37, 0x25, 0xFF}}},
	{{{-56, -48, 7}, 0, {554, 292}, {0x88, 0xED, 0x26, 0xFF}}},
	{{{-46, 0, -33}, 0, {420, 426}, {0x94, 0x37, 0xDB, 0xFF}}},
	{{{-23, 23, 14}, 0, {298, 310}, {0xE7, 0x66, 0x47, 0xFF}}},
	{{{-23, 23, -45}, 0, {298, 426}, {0xE7, 0x66, 0xB9, 0xFF}}},
	{{{14, 9, -40}, 0, {147, 461}, {0x5A, 0x44, 0xC6, 0xFF}}},
	{{{14, 9, 9}, 0, {147, 275}, {0x5A, 0x44, 0x3A, 0xFF}}},
	{{{-56, -48, -39}, 0, {554, 444}, {0x88, 0xED, 0xDA, 0xFF}}},
	{{{-37, -50, -64}, 0, {554, 566}, {0xD1, 0xE5, 0x8D, 0xFF}}},
	{{{-23, 23, -45}, 0, {384, 525}, {0xE7, 0x66, 0xB9, 0xFF}}},
	{{{0, -50, -60}, 0, {554, 700}, {0x36, 0xE2, 0x91, 0xFF}}},
	{{{14, 9, -40}, 0, {438, 752}, {0x5A, 0x44, 0xC6, 0xFF}}},
	{{{17, -51, -37}, 0, {554, 822}, {0x73, 0xD7, 0xDC, 0xFF}}},
	{{{14, 9, 9}, 0, {438, 973}, {0x5A, 0x44, 0x3A, 0xFF}}},
	{{{17, -51, 5}, 0, {554, 938}, {0x73, 0xD7, 0x24, 0xFF}}},
	{{{0, -50, 28}, 0, {554, 1008}, {0x34, 0xDF, 0x6F, 0xFF}}},
	{{{-5, -75, 7}, 0, {624, 938}, {0x27, 0x90, 0x2F, 0xFF}}},
	{{{-5, -75, -39}, 0, {624, 775}, {0x29, 0x90, 0xD5, 0xFF}}},
	{{{-40, -72, -39}, 0, {659, 496}, {0xC5, 0x97, 0xD8, 0xFF}}},
	{{{-40, -72, 7}, 0, {659, 240}, {0xC7, 0x97, 0x2B, 0xFF}}},
	{{{-5, -75, 7}, 0, {810, 310}, {0x27, 0x90, 0x2F, 0xFF}}},
	{{{-5, -75, -39}, 0, {810, 426}, {0x29, 0x90, 0xD5, 0xFF}}},
	{{{-5, -75, 7}, 0, {624, 54}, {0x27, 0x90, 0x2F, 0xFF}}},
};

Gfx mc_scarecrow_hand_r_mesh_layer_1_tri_0[] = {
	gsSPVertex(mc_scarecrow_hand_r_mesh_layer_1_vtx_0 + 0, 27, 0),
	gsSP2Triangles(0, 1, 2, 0, 3, 2, 1, 0),
	gsSP2Triangles(4, 3, 1, 0, 3, 4, 5, 0),
	gsSP2Triangles(6, 5, 4, 0, 7, 6, 4, 0),
	gsSP2Triangles(7, 8, 6, 0, 9, 8, 7, 0),
	gsSP2Triangles(9, 7, 10, 0, 6, 11, 5, 0),
	gsSP2Triangles(11, 6, 12, 0, 12, 6, 13, 0),
	gsSP2Triangles(14, 12, 13, 0, 15, 14, 13, 0),
	gsSP2Triangles(14, 15, 16, 0, 17, 16, 15, 0),
	gsSP2Triangles(17, 18, 16, 0, 17, 19, 18, 0),
	gsSP2Triangles(19, 20, 18, 0, 20, 16, 18, 0),
	gsSP2Triangles(20, 21, 16, 0, 21, 14, 16, 0),
	gsSP2Triangles(21, 12, 14, 0, 21, 22, 12, 0),
	gsSP2Triangles(22, 11, 12, 0, 22, 5, 11, 0),
	gsSP2Triangles(22, 23, 5, 0, 22, 24, 23, 0),
	gsSP2Triangles(22, 25, 24, 0, 23, 3, 5, 0),
	gsSP2Triangles(23, 2, 3, 0, 23, 26, 2, 0),
	gsSPEndDisplayList(),
};

Vtx mc_scarecrow_cape1_skinned_mesh_layer_1_vtx_0[3] = {
	{{{-46, 101, -25}, 0, {242, 104}, {0xCD, 0x4B, 0xA7, 0xFF}}},
	{{{0, 101, -44}, 0, {242, 104}, {0x00, 0x4B, 0x9A, 0xFF}}},
	{{{46, 101, -25}, 0, {242, 104}, {0x33, 0x4B, 0xA7, 0xFF}}},
};

Gfx mc_scarecrow_cape1_skinned_mesh_layer_1_tri_0[] = {
	gsSPVertex(mc_scarecrow_cape1_skinned_mesh_layer_1_vtx_0 + 0, 3, 0),
	gsSPEndDisplayList(),
};

Vtx mc_scarecrow_cape1_mesh_layer_1_vtx_0[4] = {
	{{{-77, -136, -80}, 0, {242, 104}, {0xCF, 0x30, 0x95, 0xFF}}},
	{{{-137, -136, -8}, 0, {242, 104}, {0xA8, 0x36, 0xB6, 0xFF}}},
	{{{77, -136, -80}, 0, {242, 104}, {0x31, 0x30, 0x95, 0xFF}}},
	{{{137, -136, -8}, 0, {242, 104}, {0x58, 0x36, 0xB6, 0xFF}}},
};

Gfx mc_scarecrow_cape1_mesh_layer_1_tri_0[] = {
	gsSPVertex(mc_scarecrow_cape1_mesh_layer_1_vtx_0 + 0, 4, 3),
	gsSP2Triangles(3, 4, 0, 0, 1, 3, 0, 0),
	gsSP2Triangles(5, 3, 1, 0, 5, 1, 2, 0),
	gsSP1Triangle(6, 5, 2, 0),
	gsSPEndDisplayList(),
};

Vtx mc_scarecrow_cape1_mesh_layer_1_vtx_1[6] = {
	{{{-160, -241, -36}, 0, {242, 104}, {0xAC, 0x1D, 0xA5, 0xFF}}},
	{{{-137, -136, -8}, 0, {242, 104}, {0xA8, 0x36, 0xB6, 0xFF}}},
	{{{-77, -136, -80}, 0, {242, 104}, {0xCF, 0x30, 0x95, 0xFF}}},
	{{{77, -136, -80}, 0, {242, 104}, {0x31, 0x30, 0x95, 0xFF}}},
	{{{137, -136, -8}, 0, {242, 104}, {0x58, 0x36, 0xB6, 0xFF}}},
	{{{160, -241, -36}, 0, {242, 104}, {0x54, 0x1D, 0xA5, 0xFF}}},
};

Gfx mc_scarecrow_cape1_mesh_layer_1_tri_1[] = {
	gsSPVertex(mc_scarecrow_cape1_mesh_layer_1_vtx_1 + 0, 6, 0),
	gsSP2Triangles(0, 1, 2, 0, 3, 4, 5, 0),
	gsSPEndDisplayList(),
};

Vtx mc_scarecrow_cape2_skinned_mesh_layer_1_vtx_0[4] = {
	{{{77, -136, -80}, 0, {242, 104}, {0x31, 0x30, 0x95, 0xFF}}},
	{{{160, -241, -36}, 0, {242, 104}, {0x54, 0x1D, 0xA5, 0xFF}}},
	{{{-77, -136, -80}, 0, {242, 104}, {0xCF, 0x30, 0x95, 0xFF}}},
	{{{-160, -241, -36}, 0, {242, 104}, {0xAC, 0x1D, 0xA5, 0xFF}}},
};

Gfx mc_scarecrow_cape2_skinned_mesh_layer_1_tri_0[] = {
	gsSPVertex(mc_scarecrow_cape2_skinned_mesh_layer_1_vtx_0 + 0, 4, 0),
	gsSPEndDisplayList(),
};

Vtx mc_scarecrow_cape2_mesh_layer_1_vtx_0[3] = {
	{{{100, -106, -15}, 0, {242, 104}, {0x39, 0x0E, 0x8F, 0xFF}}},
	{{{0, -106, -40}, 0, {242, 104}, {0x00, 0x12, 0x82, 0xFF}}},
	{{{-100, -106, -15}, 0, {242, 104}, {0xC7, 0x0E, 0x8F, 0xFF}}},
};

Gfx mc_scarecrow_cape2_mesh_layer_1_tri_0[] = {
	gsSPVertex(mc_scarecrow_cape2_mesh_layer_1_vtx_0 + 0, 3, 4),
	gsSP2Triangles(4, 0, 1, 0, 5, 0, 4, 0),
	gsSP2Triangles(2, 0, 5, 0, 6, 2, 5, 0),
	gsSP1Triangle(6, 3, 2, 0),
	gsSPEndDisplayList(),
};

Vtx mc_scarecrow_head_mesh_layer_1_vtx_0[16] = {
	{{{0, 242, -99}, 0, {240, -374}, {0xFE, 0xD9, 0x87, 0xFF}}},
	{{{0, 157, -74}, 0, {240, 512}, {0xFB, 0xD8, 0x88, 0xFF}}},
	{{{-51, 159, -53}, 0, {56, 510}, {0xB1, 0xCE, 0xAA, 0xFF}}},
	{{{62, 196, -68}, 0, {466, 115}, {0x59, 0xCE, 0xB4, 0xFF}}},
	{{{51, 159, -53}, 0, {424, 510}, {0x59, 0xCF, 0xB4, 0xFF}}},
	{{{90, 248, -9}, 0, {569, -382}, {0x7B, 0xE2, 0x00, 0xFF}}},
	{{{72, 162, -3}, 0, {501, 506}, {0x7B, 0xE1, 0xFE, 0xFF}}},
	{{{62, 204, 56}, 0, {466, 104}, {0x50, 0xDC, 0x5C, 0xFF}}},
	{{{51, 165, 48}, 0, {424, 501}, {0x50, 0xDC, 0x5C, 0xFF}}},
	{{{0, 254, 81}, 0, {240, -390}, {0x02, 0xEB, 0x7D, 0xFF}}},
	{{{0, 166, 69}, 0, {240, 499}, {0x05, 0xEA, 0x7D, 0xFF}}},
	{{{-62, 204, 56}, 0, {14, 104}, {0xA6, 0xDB, 0x51, 0xFF}}},
	{{{-51, 165, 48}, 0, {56, 501}, {0xA7, 0xDB, 0x53, 0xFF}}},
	{{{-90, 248, -9}, 0, {-89, -382}, {0x85, 0xE2, 0x03, 0xFF}}},
	{{{-72, 162, -3}, 0, {-21, 506}, {0x85, 0xE1, 0x07, 0xFF}}},
	{{{-62, 196, -68}, 0, {14, 115}, {0xB2, 0xCD, 0xA9, 0xFF}}},
};

Gfx mc_scarecrow_head_mesh_layer_1_tri_0[] = {
	gsSPVertex(mc_scarecrow_head_mesh_layer_1_vtx_0 + 0, 16, 0),
	gsSP2Triangles(0, 1, 2, 0, 3, 1, 0, 0),
	gsSP2Triangles(3, 4, 1, 0, 5, 4, 3, 0),
	gsSP2Triangles(5, 6, 4, 0, 7, 6, 5, 0),
	gsSP2Triangles(7, 8, 6, 0, 9, 8, 7, 0),
	gsSP2Triangles(9, 10, 8, 0, 11, 10, 9, 0),
	gsSP2Triangles(11, 12, 10, 0, 13, 12, 11, 0),
	gsSP2Triangles(13, 14, 12, 0, 15, 14, 13, 0),
	gsSP2Triangles(15, 2, 14, 0, 0, 2, 15, 0),
	gsSPEndDisplayList(),
};

Vtx mc_scarecrow_head_mesh_layer_1_vtx_1[94] = {
	{{{64, 170, 0}, 0, {1620, -293}, {0x4E, 0x64, 0x00, 0xFF}}},
	{{{0, 190, 0}, 0, {1336, -649}, {0x00, 0x7F, 0x00, 0xFF}}},
	{{{52, 170, 38}, 0, {874, -293}, {0x3F, 0x64, 0x2E, 0xFF}}},
	{{{94, 130, 0}, 0, {1620, 9}, {0x75, 0x31, 0x00, 0xFF}}},
	{{{76, 130, 55}, 0, {874, 9}, {0x5F, 0x31, 0x45, 0xFF}}},
	{{{20, 170, 61}, 0, {482, -293}, {0x18, 0x64, 0x4A, 0xFF}}},
	{{{0, 190, 0}, 0, {516, -649}, {0x00, 0x7F, 0x00, 0xFF}}},
	{{{29, 130, 89}, 0, {482, 9}, {0x24, 0x31, 0x6F, 0xFF}}},
	{{{-20, 170, 61}, 0, {-461, -293}, {0xE8, 0x64, 0x4A, 0xFF}}},
	{{{0, 190, 0}, 0, {-47, -649}, {0x00, 0x7F, 0x00, 0xFF}}},
	{{{-29, 130, 89}, 0, {-461, 9}, {0xDC, 0x31, 0x6F, 0xFF}}},
	{{{-52, 170, 38}, 0, {-1055, -293}, {0xC1, 0x64, 0x2E, 0xFF}}},
	{{{0, 190, 0}, 0, {-680, -649}, {0x00, 0x7F, 0x00, 0xFF}}},
	{{{-76, 130, 55}, 0, {-1055, 9}, {0xA1, 0x31, 0x45, 0xFF}}},
	{{{-64, 170, 0}, 0, {-1307, -293}, {0xB2, 0x64, 0x00, 0xFF}}},
	{{{0, 190, 0}, 0, {-1053, -649}, {0x00, 0x7F, 0x00, 0xFF}}},
	{{{-94, 130, 0}, 0, {-1307, 9}, {0x8B, 0x31, 0x00, 0xFF}}},
	{{{-52, 170, -38}, 0, {-1671, -293}, {0xC1, 0x64, 0xD2, 0xFF}}},
	{{{0, 190, 0}, 0, {-1477, -649}, {0x00, 0x7F, 0x00, 0xFF}}},
	{{{-76, 130, -55}, 0, {-1671, 9}, {0xA1, 0x31, 0xBB, 0xFF}}},
	{{{-20, 170, -61}, 0, {-2189, -293}, {0xE8, 0x64, 0xB6, 0xFF}}},
	{{{0, 190, 0}, 0, {-1979, -649}, {0x00, 0x7F, 0x00, 0xFF}}},
	{{{-29, 130, -89}, 0, {-2189, 9}, {0xDC, 0x31, 0x91, 0xFF}}},
	{{{-84, 76, -61}, 0, {-1671, 347}, {0x99, 0xFB, 0xB5, 0xFF}}},
	{{{-32, 76, -99}, 0, {-2189, 347}, {0xD9, 0xFB, 0x87, 0xFF}}},
	{{{-74, 30, -54}, 0, {-1671, 595}, {0xA5, 0xC4, 0xBE, 0xFF}}},
	{{{-28, 30, -87}, 0, {-2189, 595}, {0xDD, 0xC4, 0x96, 0xFF}}},
	{{{-52, 1, -38}, 0, {-1671, 773}, {0xC6, 0x97, 0xD6, 0xFF}}},
	{{{-20, 1, -61}, 0, {-2189, 773}, {0xEA, 0x97, 0xBC, 0xFF}}},
	{{{0, -19, 0}, 0, {-2135, 1129}, {0x00, 0x81, 0x00, 0xFF}}},
	{{{-64, 1, 0}, 0, {-1307, 773}, {0xB9, 0x97, 0x00, 0xFF}}},
	{{{0, -19, 0}, 0, {-1477, 1129}, {0x00, 0x81, 0x00, 0xFF}}},
	{{{-91, 30, 0}, 0, {-1307, 595}, {0x90, 0xC4, 0x00, 0xFF}}},
	{{{-52, 1, 38}, 0, {-1055, 773}, {0xC6, 0x97, 0x2A, 0xFF}}},
	{{{0, -19, 0}, 0, {-1074, 1129}, {0x00, 0x81, 0x00, 0xFF}}},
	{{{-74, 30, 54}, 0, {-1055, 595}, {0xA5, 0xC4, 0x42, 0xFF}}},
	{{{-20, 1, 61}, 0, {-461, 773}, {0xEA, 0x97, 0x44, 0xFF}}},
	{{{0, -19, 0}, 0, {-680, 1129}, {0x00, 0x81, 0x00, 0xFF}}},
	{{{-28, 30, 87}, 0, {-461, 595}, {0xDD, 0xC4, 0x6A, 0xFF}}},
	{{{20, 1, 61}, 0, {482, 773}, {0x16, 0x97, 0x44, 0xFF}}},
	{{{0, -19, 0}, 0, {-98, 1129}, {0x00, 0x81, 0x00, 0xFF}}},
	{{{28, 30, 87}, 0, {482, 595}, {0x23, 0xC4, 0x6A, 0xFF}}},
	{{{52, 1, 38}, 0, {874, 773}, {0x3A, 0x97, 0x2A, 0xFF}}},
	{{{0, -19, 0}, 0, {712, 1129}, {0x00, 0x81, 0x00, 0xFF}}},
	{{{74, 30, 54}, 0, {874, 595}, {0x5B, 0xC4, 0x42, 0xFF}}},
	{{{64, 1, 0}, 0, {1620, 773}, {0x47, 0x97, 0x00, 0xFF}}},
	{{{0, -19, 0}, 0, {1326, 1129}, {0x00, 0x81, 0x00, 0xFF}}},
	{{{91, 30, 0}, 0, {1620, 595}, {0x70, 0xC4, 0x00, 0xFF}}},
	{{{52, 1, -38}, 0, {2158, 773}, {0x3A, 0x97, 0xD6, 0xFF}}},
	{{{0, -19, 0}, 0, {1986, 1129}, {0x00, 0x81, 0x00, 0xFF}}},
	{{{74, 30, -54}, 0, {2158, 595}, {0x5B, 0xC4, 0xBE, 0xFF}}},
	{{{20, 1, -61}, 0, {2511, 773}, {0x16, 0x97, 0xBC, 0xFF}}},
	{{{0, -19, 0}, 0, {2370, 1129}, {0x00, 0x81, 0x00, 0xFF}}},
	{{{28, 30, -87}, 0, {2511, 595}, {0x23, 0xC4, 0x96, 0xFF}}},
	{{{-20, 1, -61}, 0, {2792, 773}, {0xEA, 0x97, 0xBC, 0xFF}}},
	{{{0, -19, 0}, 0, {2634, 1129}, {0x00, 0x81, 0x00, 0xFF}}},
	{{{28, 30, -87}, 0, {2511, 595}, {0x23, 0xC4, 0x96, 0xFF}}},
	{{{-20, 1, -61}, 0, {2792, 773}, {0xEA, 0x97, 0xBC, 0xFF}}},
	{{{-28, 30, -87}, 0, {2792, 595}, {0xDD, 0xC4, 0x96, 0xFF}}},
	{{{32, 76, -99}, 0, {2511, 347}, {0x27, 0xFB, 0x87, 0xFF}}},
	{{{-32, 76, -99}, 0, {2792, 347}, {0xD9, 0xFB, 0x87, 0xFF}}},
	{{{29, 130, -89}, 0, {2511, 9}, {0x24, 0x31, 0x91, 0xFF}}},
	{{{-29, 130, -89}, 0, {2792, 9}, {0xDC, 0x31, 0x91, 0xFF}}},
	{{{20, 170, -61}, 0, {2511, -293}, {0x18, 0x64, 0xB6, 0xFF}}},
	{{{-20, 170, -61}, 0, {2792, -293}, {0xE8, 0x64, 0xB6, 0xFF}}},
	{{{0, 190, 0}, 0, {2634, -649}, {0x00, 0x7F, 0x00, 0xFF}}},
	{{{52, 170, -38}, 0, {2158, -293}, {0x3F, 0x64, 0xD2, 0xFF}}},
	{{{76, 130, -55}, 0, {2158, 9}, {0x5F, 0x31, 0xBB, 0xFF}}},
	{{{64, 170, 0}, 0, {1620, -293}, {0x4E, 0x64, 0x00, 0xFF}}},
	{{{0, 190, 0}, 0, {1970, -649}, {0x00, 0x7F, 0x00, 0xFF}}},
	{{{94, 130, 0}, 0, {1620, 9}, {0x75, 0x31, 0x00, 0xFF}}},
	{{{84, 76, -61}, 0, {2158, 347}, {0x67, 0xFB, 0xB5, 0xFF}}},
	{{{104, 76, 0}, 0, {1620, 347}, {0x7F, 0xFB, 0x00, 0xFF}}},
	{{{76, 130, 55}, 0, {874, 9}, {0x5F, 0x31, 0x45, 0xFF}}},
	{{{84, 76, 61}, 0, {874, 347}, {0x67, 0xFB, 0x4B, 0xFF}}},
	{{{29, 130, 89}, 0, {482, 9}, {0x24, 0x31, 0x6F, 0xFF}}},
	{{{32, 76, 99}, 0, {482, 347}, {0x27, 0xFB, 0x79, 0xFF}}},
	{{{-29, 130, 89}, 0, {-461, 9}, {0xDC, 0x31, 0x6F, 0xFF}}},
	{{{-32, 76, 99}, 0, {-461, 347}, {0xD9, 0xFB, 0x79, 0xFF}}},
	{{{-76, 130, 55}, 0, {-1055, 9}, {0xA1, 0x31, 0x45, 0xFF}}},
	{{{-84, 76, 61}, 0, {-1055, 347}, {0x99, 0xFB, 0x4B, 0xFF}}},
	{{{-94, 130, 0}, 0, {-1307, 9}, {0x8B, 0x31, 0x00, 0xFF}}},
	{{{-104, 76, 0}, 0, {-1307, 347}, {0x81, 0xFB, 0x00, 0xFF}}},
	{{{-76, 130, -55}, 0, {-1671, 9}, {0xA1, 0x31, 0xBB, 0xFF}}},
	{{{-84, 76, -61}, 0, {-1671, 347}, {0x99, 0xFB, 0xB5, 0xFF}}},
	{{{-91, 30, 0}, 0, {-1307, 595}, {0x90, 0xC4, 0x00, 0xFF}}},
	{{{-74, 30, -54}, 0, {-1671, 595}, {0xA5, 0xC4, 0xBE, 0xFF}}},
	{{{-74, 30, 54}, 0, {-1055, 595}, {0xA5, 0xC4, 0x42, 0xFF}}},
	{{{-28, 30, 87}, 0, {-461, 595}, {0xDD, 0xC4, 0x6A, 0xFF}}},
	{{{28, 30, 87}, 0, {482, 595}, {0x23, 0xC4, 0x6A, 0xFF}}},
	{{{74, 30, 54}, 0, {874, 595}, {0x5B, 0xC4, 0x42, 0xFF}}},
	{{{91, 30, 0}, 0, {1620, 595}, {0x70, 0xC4, 0x00, 0xFF}}},
	{{{74, 30, -54}, 0, {2158, 595}, {0x5B, 0xC4, 0xBE, 0xFF}}},
	{{{0, 190, 0}, 0, {2360, -649}, {0x00, 0x7F, 0x00, 0xFF}}},
};

Gfx mc_scarecrow_head_mesh_layer_1_tri_1[] = {
	gsSPVertex(mc_scarecrow_head_mesh_layer_1_vtx_1 + 0, 56, 0),
	gsSP2Triangles(0, 1, 2, 0, 2, 3, 0, 0),
	gsSP2Triangles(2, 4, 3, 0, 5, 4, 2, 0),
	gsSP2Triangles(2, 6, 5, 0, 5, 7, 4, 0),
	gsSP2Triangles(8, 7, 5, 0, 5, 9, 8, 0),
	gsSP2Triangles(8, 10, 7, 0, 11, 10, 8, 0),
	gsSP2Triangles(8, 12, 11, 0, 11, 13, 10, 0),
	gsSP2Triangles(14, 13, 11, 0, 11, 15, 14, 0),
	gsSP2Triangles(14, 16, 13, 0, 17, 16, 14, 0),
	gsSP2Triangles(14, 18, 17, 0, 17, 19, 16, 0),
	gsSP2Triangles(20, 19, 17, 0, 17, 21, 20, 0),
	gsSP2Triangles(20, 22, 19, 0, 22, 23, 19, 0),
	gsSP2Triangles(22, 24, 23, 0, 24, 25, 23, 0),
	gsSP2Triangles(24, 26, 25, 0, 26, 27, 25, 0),
	gsSP2Triangles(26, 28, 27, 0, 29, 27, 28, 0),
	gsSP2Triangles(25, 27, 30, 0, 31, 30, 27, 0),
	gsSP2Triangles(25, 30, 32, 0, 32, 30, 33, 0),
	gsSP2Triangles(34, 33, 30, 0, 32, 33, 35, 0),
	gsSP2Triangles(35, 33, 36, 0, 37, 36, 33, 0),
	gsSP2Triangles(35, 36, 38, 0, 38, 36, 39, 0),
	gsSP2Triangles(40, 39, 36, 0, 38, 39, 41, 0),
	gsSP2Triangles(41, 39, 42, 0, 43, 42, 39, 0),
	gsSP2Triangles(41, 42, 44, 0, 44, 42, 45, 0),
	gsSP2Triangles(46, 45, 42, 0, 44, 45, 47, 0),
	gsSP2Triangles(47, 45, 48, 0, 49, 48, 45, 0),
	gsSP2Triangles(47, 48, 50, 0, 50, 48, 51, 0),
	gsSP2Triangles(52, 51, 48, 0, 50, 51, 53, 0),
	gsSP2Triangles(53, 51, 54, 0, 55, 54, 51, 0),
	gsSPVertex(mc_scarecrow_head_mesh_layer_1_vtx_1 + 56, 38, 0),
	gsSP2Triangles(0, 1, 2, 0, 3, 0, 2, 0),
	gsSP2Triangles(3, 2, 4, 0, 5, 3, 4, 0),
	gsSP2Triangles(5, 4, 6, 0, 7, 5, 6, 0),
	gsSP2Triangles(7, 6, 8, 0, 8, 9, 7, 0),
	gsSP2Triangles(10, 5, 7, 0, 10, 11, 5, 0),
	gsSP2Triangles(12, 11, 10, 0, 10, 13, 12, 0),
	gsSP2Triangles(12, 14, 11, 0, 14, 15, 11, 0),
	gsSP2Triangles(14, 16, 15, 0, 17, 16, 14, 0),
	gsSP2Triangles(17, 18, 16, 0, 19, 18, 17, 0),
	gsSP2Triangles(19, 20, 18, 0, 21, 20, 19, 0),
	gsSP2Triangles(21, 22, 20, 0, 23, 22, 21, 0),
	gsSP2Triangles(23, 24, 22, 0, 25, 24, 23, 0),
	gsSP2Triangles(25, 26, 24, 0, 27, 26, 25, 0),
	gsSP2Triangles(27, 28, 26, 0, 28, 29, 26, 0),
	gsSP2Triangles(28, 30, 29, 0, 26, 29, 31, 0),
	gsSP2Triangles(26, 31, 24, 0, 24, 31, 32, 0),
	gsSP2Triangles(24, 32, 22, 0, 22, 32, 33, 0),
	gsSP2Triangles(22, 33, 20, 0, 20, 33, 34, 0),
	gsSP2Triangles(20, 34, 18, 0, 18, 34, 35, 0),
	gsSP2Triangles(18, 35, 16, 0, 16, 35, 36, 0),
	gsSP2Triangles(16, 36, 15, 0, 15, 36, 0, 0),
	gsSP2Triangles(15, 0, 3, 0, 11, 15, 3, 0),
	gsSP2Triangles(11, 3, 5, 0, 7, 37, 10, 0),
	gsSPEndDisplayList(),
};

Vtx mc_scarecrow_head_mesh_layer_4_vtx_0[12] = {
	{{{-43, 90, 100}, 0, {496, -16}, {0xE8, 0x0B, 0x7C, 0xFF}}},
	{{{-73, 102, 91}, 0, {-16, -16}, {0xE2, 0x0D, 0x7B, 0xFF}}},
	{{{-84, 77, 91}, 0, {-16, 496}, {0xE2, 0x0E, 0x7B, 0xFF}}},
	{{{-55, 65, 100}, 0, {496, 496}, {0xE8, 0x0B, 0x7C, 0xFF}}},
	{{{-15, 75, 105}, 0, {1008, -16}, {0xEE, 0x08, 0x7D, 0xFF}}},
	{{{-26, 51, 105}, 0, {1008, 496}, {0xEE, 0x09, 0x7D, 0xFF}}},
	{{{43, 90, 100}, 0, {496, -16}, {0x18, 0x0B, 0x7C, 0xFF}}},
	{{{84, 77, 91}, 0, {-16, 496}, {0x1E, 0x0D, 0x7B, 0xFF}}},
	{{{73, 102, 91}, 0, {-16, -16}, {0x1E, 0x0D, 0x7B, 0xFF}}},
	{{{55, 65, 100}, 0, {496, 496}, {0x18, 0x0B, 0x7C, 0xFF}}},
	{{{15, 75, 105}, 0, {1008, -16}, {0x12, 0x08, 0x7D, 0xFF}}},
	{{{26, 51, 105}, 0, {1008, 496}, {0x12, 0x09, 0x7D, 0xFF}}},
};

Gfx mc_scarecrow_head_mesh_layer_4_tri_0[] = {
	gsSPVertex(mc_scarecrow_head_mesh_layer_4_vtx_0 + 0, 12, 0),
	gsSP2Triangles(0, 1, 2, 0, 0, 2, 3, 0),
	gsSP2Triangles(4, 0, 3, 0, 4, 3, 5, 0),
	gsSP2Triangles(6, 7, 8, 0, 6, 9, 7, 0),
	gsSP2Triangles(10, 9, 6, 0, 10, 11, 9, 0),
	gsSPEndDisplayList(),
};

Vtx mc_scarecrow_head_mesh_layer_4_vtx_1[20] = {
	{{{0, 179, -40}, 0, {1264, 496}, {0x09, 0xD2, 0x8A, 0xFF}}},
	{{{0, 206, -53}, 0, {1264, -16}, {0x08, 0xD2, 0x8A, 0xFF}}},
	{{{53, 267, 0}, 0, {752, -16}, {0x7D, 0xEA, 0xFF, 0xFF}}},
	{{{40, 179, 0}, 0, {752, 496}, {0x7D, 0xE9, 0xFB, 0xFF}}},
	{{{0, 206, 53}, 0, {240, -16}, {0xF8, 0xD2, 0x76, 0xFF}}},
	{{{0, 179, 40}, 0, {240, 496}, {0xF7, 0xD2, 0x76, 0xFF}}},
	{{{-53, 267, 0}, 0, {-272, -16}, {0x83, 0xEA, 0x01, 0xFF}}},
	{{{-40, 179, 0}, 0, {-272, 496}, {0x83, 0xE9, 0x05, 0xFF}}},
	{{{0, 206, -53}, 0, {-784, -16}, {0x08, 0xD2, 0x8A, 0xFF}}},
	{{{0, 179, -40}, 0, {-784, 496}, {0x09, 0xD2, 0x8A, 0xFF}}},
	{{{-29, 179, 0}, 0, {1264, 496}, {0x86, 0xDF, 0xF9, 0xFF}}},
	{{{-38, 206, 0}, 0, {1264, -16}, {0x86, 0xDF, 0xF7, 0xFF}}},
	{{{0, 267, -38}, 0, {752, -16}, {0xFF, 0xF0, 0x82, 0xFF}}},
	{{{0, 179, -29}, 0, {752, 496}, {0xFC, 0xEE, 0x82, 0xFF}}},
	{{{38, 206, 0}, 0, {240, -16}, {0x7A, 0xDF, 0x09, 0xFF}}},
	{{{29, 179, 0}, 0, {240, 496}, {0x7A, 0xDF, 0x07, 0xFF}}},
	{{{0, 267, 38}, 0, {-272, -16}, {0x01, 0xF0, 0x7E, 0xFF}}},
	{{{0, 179, 29}, 0, {-272, 496}, {0x04, 0xEE, 0x7E, 0xFF}}},
	{{{-38, 206, 0}, 0, {-784, -16}, {0x86, 0xDF, 0xF7, 0xFF}}},
	{{{-29, 179, 0}, 0, {-784, 496}, {0x86, 0xDF, 0xF9, 0xFF}}},
};

Gfx mc_scarecrow_head_mesh_layer_4_tri_1[] = {
	gsSPVertex(mc_scarecrow_head_mesh_layer_4_vtx_1 + 0, 20, 0),
	gsSP2Triangles(0, 1, 2, 0, 0, 2, 3, 0),
	gsSP2Triangles(3, 2, 4, 0, 3, 4, 5, 0),
	gsSP2Triangles(5, 4, 6, 0, 5, 6, 7, 0),
	gsSP2Triangles(7, 6, 8, 0, 7, 8, 9, 0),
	gsSP2Triangles(10, 11, 12, 0, 10, 12, 13, 0),
	gsSP2Triangles(13, 12, 14, 0, 13, 14, 15, 0),
	gsSP2Triangles(15, 14, 16, 0, 15, 16, 17, 0),
	gsSP2Triangles(17, 16, 18, 0, 17, 18, 19, 0),
	gsSPEndDisplayList(),
};

Vtx mc_scarecrow_head_switch_option_head_switch_mesh_layer_4_vtx_0[16] = {
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

Gfx mc_scarecrow_head_switch_option_head_switch_mesh_layer_4_tri_0[] = {
	gsSPVertex(mc_scarecrow_head_switch_option_head_switch_mesh_layer_4_vtx_0 + 0, 16, 0),
	gsSP2Triangles(0, 1, 2, 0, 0, 2, 3, 0),
	gsSP2Triangles(3, 2, 4, 0, 3, 4, 5, 0),
	gsSP2Triangles(5, 4, 6, 0, 5, 6, 7, 0),
	gsSP2Triangles(7, 6, 8, 0, 7, 8, 9, 0),
	gsSP2Triangles(10, 11, 12, 0, 13, 11, 10, 0),
	gsSP2Triangles(13, 14, 11, 0, 15, 14, 13, 0),
	gsSP2Triangles(15, 12, 14, 0, 10, 12, 15, 0),
	gsSPEndDisplayList(),
};


Gfx mat_mc_scarecrow_wood2[] = {
	gsSPSetLights1(mc_scarecrow_wood2_lights),
	gsDPPipeSync(),
	gsDPSetCombineLERP(TEXEL0, 0, SHADE, 0, 0, 0, 0, ENVIRONMENT, TEXEL0, 0, SHADE, 0, 0, 0, 0, ENVIRONMENT),
	gsDPSetAlphaDither(G_AD_NOISE),
	gsDPSetTextureLUT(G_TT_RGBA16),
	gsSPTexture(65535, 65535, 0, 0, 1),
	gsDPSetTextureImage(G_IM_FMT_RGBA, G_IM_SIZ_16b, 1, mc_scarecrow_wood2_pal_rgba16),
	gsDPSetTile(0, 0, 0, 256, 5, 0, G_TX_WRAP | G_TX_NOMIRROR, 0, 0, G_TX_WRAP | G_TX_NOMIRROR, 0, 0),
	gsDPLoadTLUTCmd(5, 8),
	gsDPSetTextureImage(G_IM_FMT_CI, G_IM_SIZ_16b, 1, mc_scarecrow_wood2_ci4),
	gsDPSetTile(G_IM_FMT_CI, G_IM_SIZ_16b, 0, 0, 7, 0, G_TX_WRAP | G_TX_NOMIRROR, 0, 0, G_TX_WRAP | G_TX_NOMIRROR, 0, 0),
	gsDPLoadBlock(7, 0, 0, 255, 1024),
	gsDPSetTile(G_IM_FMT_CI, G_IM_SIZ_4b, 2, 0, 0, 0, G_TX_WRAP | G_TX_NOMIRROR, 5, 0, G_TX_WRAP | G_TX_NOMIRROR, 5, 0),
	gsDPSetTileSize(0, 0, 0, 124, 124),
	gsSPEndDisplayList(),
};

Gfx mat_revert_mc_scarecrow_wood2[] = {
	gsDPPipeSync(),
	gsDPSetAlphaDither(G_AD_DISABLE),
	gsDPSetTextureLUT(G_TT_NONE),
	gsSPEndDisplayList(),
};

Gfx mat_mc_scarecrow_wood1[] = {
	gsSPSetLights1(mc_scarecrow_wood1_lights),
	gsDPPipeSync(),
	gsDPSetCombineLERP(TEXEL0, 0, SHADE, 0, 0, 0, 0, ENVIRONMENT, TEXEL0, 0, SHADE, 0, 0, 0, 0, ENVIRONMENT),
	gsDPSetAlphaDither(G_AD_NOISE),
	gsDPSetTextureLUT(G_TT_RGBA16),
	gsSPTexture(65535, 65535, 0, 0, 1),
	gsDPSetTextureImage(G_IM_FMT_RGBA, G_IM_SIZ_16b, 1, mc_scarecrow_wood1_pal_rgba16),
	gsDPSetTile(0, 0, 0, 256, 5, 0, G_TX_WRAP | G_TX_NOMIRROR, 0, 0, G_TX_WRAP | G_TX_NOMIRROR, 0, 0),
	gsDPLoadTLUTCmd(5, 8),
	gsDPSetTextureImage(G_IM_FMT_CI, G_IM_SIZ_16b, 1, mc_scarecrow_wood1_ci4),
	gsDPSetTile(G_IM_FMT_CI, G_IM_SIZ_16b, 0, 0, 7, 0, G_TX_WRAP | G_TX_NOMIRROR, 0, 0, G_TX_WRAP | G_TX_NOMIRROR, 0, 0),
	gsDPLoadBlock(7, 0, 0, 255, 1024),
	gsDPSetTile(G_IM_FMT_CI, G_IM_SIZ_4b, 2, 0, 0, 0, G_TX_WRAP | G_TX_NOMIRROR, 5, 0, G_TX_WRAP | G_TX_NOMIRROR, 5, 0),
	gsDPSetTileSize(0, 0, 0, 124, 124),
	gsSPEndDisplayList(),
};

Gfx mat_revert_mc_scarecrow_wood1[] = {
	gsDPPipeSync(),
	gsDPSetAlphaDither(G_AD_DISABLE),
	gsDPSetTextureLUT(G_TT_NONE),
	gsSPEndDisplayList(),
};

Gfx mat_mc_scarecrow_spring[] = {
	gsSPClearGeometryMode(G_CULL_BACK),
	gsSPSetLights1(mc_scarecrow_spring_lights),
	gsDPPipeSync(),
	gsDPSetCombineLERP(TEXEL0, 0, SHADE, 0, TEXEL0, 0, ENVIRONMENT, 0, TEXEL0, 0, SHADE, 0, TEXEL0, 0, ENVIRONMENT, 0),
	gsDPSetAlphaDither(G_AD_NOISE),
	gsDPSetTextureLUT(G_TT_RGBA16),
	gsSPTexture(65535, 65535, 0, 0, 1),
	gsDPSetTextureImage(G_IM_FMT_RGBA, G_IM_SIZ_16b, 1, mc_scarecrow_spring_pal_rgba16),
	gsDPSetTile(0, 0, 0, 256, 5, 0, G_TX_WRAP | G_TX_NOMIRROR, 0, 0, G_TX_WRAP | G_TX_NOMIRROR, 0, 0),
	gsDPLoadTLUTCmd(5, 8),
	gsDPSetTextureImage(G_IM_FMT_CI, G_IM_SIZ_16b, 1, mc_scarecrow_spring_ci4),
	gsDPSetTile(G_IM_FMT_CI, G_IM_SIZ_16b, 0, 0, 7, 0, G_TX_WRAP | G_TX_NOMIRROR, 0, 0, G_TX_WRAP | G_TX_NOMIRROR, 0, 0),
	gsDPLoadBlock(7, 0, 0, 63, 2048),
	gsDPSetTile(G_IM_FMT_CI, G_IM_SIZ_4b, 1, 0, 0, 0, G_TX_WRAP | G_TX_NOMIRROR, 4, 0, G_TX_WRAP | G_TX_NOMIRROR, 4, 0),
	gsDPSetTileSize(0, 0, 0, 60, 60),
	gsSPEndDisplayList(),
};

Gfx mat_revert_mc_scarecrow_spring[] = {
	gsSPSetGeometryMode(G_CULL_BACK),
	gsDPPipeSync(),
	gsDPSetAlphaDither(G_AD_DISABLE),
	gsDPSetTextureLUT(G_TT_NONE),
	gsSPEndDisplayList(),
};

Gfx mat_mc_scarecrow_shirt[] = {
	gsSPSetLights1(mc_scarecrow_shirt_lights),
	gsDPPipeSync(),
	gsDPSetCombineLERP(TEXEL0, 0, SHADE, 0, 0, 0, 0, ENVIRONMENT, TEXEL0, 0, SHADE, 0, 0, 0, 0, ENVIRONMENT),
	gsDPSetAlphaDither(G_AD_NOISE),
	gsDPSetTextureLUT(G_TT_RGBA16),
	gsSPTexture(65535, 65535, 0, 0, 1),
	gsDPSetTextureImage(G_IM_FMT_RGBA, G_IM_SIZ_16b, 1, mc_scarecrow_cloth_pal_rgba16),
	gsDPSetTile(0, 0, 0, 256, 5, 0, G_TX_WRAP | G_TX_NOMIRROR, 0, 0, G_TX_WRAP | G_TX_NOMIRROR, 0, 0),
	gsDPLoadTLUTCmd(5, 1),
	gsDPSetTextureImage(G_IM_FMT_CI, G_IM_SIZ_16b, 1, mc_scarecrow_cloth_ci4),
	gsDPSetTile(G_IM_FMT_CI, G_IM_SIZ_16b, 0, 0, 7, 0, G_TX_WRAP | G_TX_NOMIRROR, 0, 0, G_TX_WRAP | G_TX_NOMIRROR, 0, 0),
	gsDPLoadBlock(7, 0, 0, 63, 2048),
	gsDPSetTile(G_IM_FMT_CI, G_IM_SIZ_4b, 1, 0, 0, 0, G_TX_CLAMP | G_TX_NOMIRROR, 4, 0, G_TX_CLAMP | G_TX_NOMIRROR, 4, 0),
	gsDPSetTileSize(0, 0, 0, 60, 60),
	gsSPEndDisplayList(),
};

Gfx mat_revert_mc_scarecrow_shirt[] = {
	gsDPPipeSync(),
	gsDPSetAlphaDither(G_AD_DISABLE),
	gsDPSetTextureLUT(G_TT_NONE),
	gsSPEndDisplayList(),
};

Gfx mat_mc_scarecrow_crown[] = {
	gsSPClearGeometryMode(G_CULL_BACK),
	gsSPSetLights1(mc_scarecrow_crown_lights),
	gsDPPipeSync(),
	gsDPSetCombineLERP(TEXEL0, SHADE, TEXEL0_ALPHA, SHADE, 0, 0, 0, ENVIRONMENT, TEXEL0, SHADE, TEXEL0_ALPHA, SHADE, 0, 0, 0, ENVIRONMENT),
	gsDPSetAlphaDither(G_AD_NOISE),
	gsDPSetTextureLUT(G_TT_RGBA16),
	gsSPTexture(65535, 65535, 0, 0, 1),
	gsDPSetTextureImage(G_IM_FMT_RGBA, G_IM_SIZ_16b, 1, mc_scarecrow_crown_pal_rgba16),
	gsDPSetTile(0, 0, 0, 256, 5, 0, G_TX_WRAP | G_TX_NOMIRROR, 0, 0, G_TX_WRAP | G_TX_NOMIRROR, 0, 0),
	gsDPLoadTLUTCmd(5, 2),
	gsDPSetTextureImage(G_IM_FMT_CI, G_IM_SIZ_16b, 1, mc_scarecrow_crown_ci4),
	gsDPSetTile(G_IM_FMT_CI, G_IM_SIZ_16b, 0, 0, 7, 0, G_TX_WRAP | G_TX_NOMIRROR, 0, 0, G_TX_WRAP | G_TX_NOMIRROR, 0, 0),
	gsDPLoadBlock(7, 0, 0, 63, 2048),
	gsDPSetTile(G_IM_FMT_CI, G_IM_SIZ_4b, 1, 0, 0, 0, G_TX_CLAMP | G_TX_NOMIRROR, 4, 0, G_TX_CLAMP | G_TX_NOMIRROR, 4, 0),
	gsDPSetTileSize(0, 0, 0, 60, 60),
	gsSPEndDisplayList(),
};

Gfx mat_revert_mc_scarecrow_crown[] = {
	gsSPSetGeometryMode(G_CULL_BACK),
	gsDPPipeSync(),
	gsDPSetAlphaDither(G_AD_DISABLE),
	gsDPSetTextureLUT(G_TT_NONE),
	gsSPEndDisplayList(),
};

Gfx mat_mc_scarecrow_gloves[] = {
	gsSPSetLights1(mc_scarecrow_gloves_lights),
	gsDPPipeSync(),
	gsDPSetCombineLERP(0, 0, 0, SHADE, 0, 0, 0, ENVIRONMENT, 0, 0, 0, SHADE, 0, 0, 0, ENVIRONMENT),
	gsDPSetAlphaDither(G_AD_NOISE),
	gsSPTexture(65535, 65535, 0, 0, 1),
	gsSPEndDisplayList(),
};

Gfx mat_revert_mc_scarecrow_gloves[] = {
	gsDPPipeSync(),
	gsDPSetAlphaDither(G_AD_DISABLE),
	gsSPEndDisplayList(),
};

Gfx mat_mc_scarecrow_head[] = {
	gsSPSetLights1(mc_scarecrow_head_lights),
	gsDPPipeSync(),
	gsDPSetCombineLERP(TEXEL0, 0, SHADE, 0, 0, 0, 0, ENVIRONMENT, TEXEL0, 0, SHADE, 0, 0, 0, 0, ENVIRONMENT),
	gsDPSetAlphaDither(G_AD_NOISE),
	gsDPSetTextureLUT(G_TT_RGBA16),
	gsSPTexture(65535, 65535, 0, 0, 1),
	gsDPSetTextureImage(G_IM_FMT_RGBA, G_IM_SIZ_16b, 1, mc_scarecrow_head_pal_rgba16),
	gsDPSetTile(0, 0, 0, 256, 5, 0, G_TX_WRAP | G_TX_NOMIRROR, 0, 0, G_TX_WRAP | G_TX_NOMIRROR, 0, 0),
	gsDPLoadTLUTCmd(5, 13),
	gsDPSetTextureImage(G_IM_FMT_CI, G_IM_SIZ_16b, 1, mc_scarecrow_head_ci4),
	gsDPSetTile(G_IM_FMT_CI, G_IM_SIZ_16b, 0, 0, 7, 0, G_TX_WRAP | G_TX_NOMIRROR, 0, 0, G_TX_WRAP | G_TX_NOMIRROR, 0, 0),
	gsDPLoadBlock(7, 0, 0, 127, 1024),
	gsDPSetTile(G_IM_FMT_CI, G_IM_SIZ_4b, 2, 0, 0, 0, G_TX_WRAP | G_TX_NOMIRROR, 4, 0, G_TX_WRAP | G_TX_NOMIRROR, 5, 0),
	gsDPSetTileSize(0, 0, 0, 124, 60),
	gsSPEndDisplayList(),
};

Gfx mat_revert_mc_scarecrow_head[] = {
	gsDPPipeSync(),
	gsDPSetAlphaDither(G_AD_DISABLE),
	gsDPSetTextureLUT(G_TT_NONE),
	gsSPEndDisplayList(),
};

Gfx mat_mc_scarecrow_eye[] = {
	gsSPClearGeometryMode(G_CULL_BACK),
	gsSPSetLights1(mc_scarecrow_eye_lights),
	gsDPPipeSync(),
	gsDPSetCombineLERP(TEXEL0, 0, SHADE, 0, TEXEL0, 0, ENVIRONMENT, 0, TEXEL0, 0, SHADE, 0, TEXEL0, 0, ENVIRONMENT, 0),
	gsDPSetAlphaDither(G_AD_NOISE),
	gsSPTexture(65535, 65535, 0, 0, 1),
	gsDPSetTextureImage(G_IM_FMT_IA, G_IM_SIZ_8b_LOAD_BLOCK, 1, mc_scarecrow_eye_ia8),
	gsDPSetTile(G_IM_FMT_IA, G_IM_SIZ_8b_LOAD_BLOCK, 0, 0, 7, 0, G_TX_WRAP | G_TX_NOMIRROR, 0, 0, G_TX_WRAP | G_TX_NOMIRROR, 0, 0),
	gsDPLoadBlock(7, 0, 0, 255, 512),
	gsDPSetTile(G_IM_FMT_IA, G_IM_SIZ_8b, 4, 0, 0, 0, G_TX_WRAP | G_TX_NOMIRROR, 4, 0, G_TX_WRAP | G_TX_NOMIRROR, 5, 0),
	gsDPSetTileSize(0, 0, 0, 124, 60),
	gsSPEndDisplayList(),
};

Gfx mat_revert_mc_scarecrow_eye[] = {
	gsSPSetGeometryMode(G_CULL_BACK),
	gsDPPipeSync(),
	gsDPSetAlphaDither(G_AD_DISABLE),
	gsSPEndDisplayList(),
};

Gfx mat_mc_scarecrow_head_tip[] = {
	gsSPClearGeometryMode(G_CULL_BACK),
	gsSPSetLights1(mc_scarecrow_head_tip_lights),
	gsDPPipeSync(),
	gsDPSetCombineLERP(TEXEL0, 0, SHADE, 0, TEXEL0, 0, ENVIRONMENT, 0, TEXEL0, 0, SHADE, 0, TEXEL0, 0, ENVIRONMENT, 0),
	gsDPSetAlphaDither(G_AD_NOISE),
	gsDPSetTextureLUT(G_TT_RGBA16),
	gsSPTexture(65535, 65535, 0, 0, 1),
	gsDPSetTextureImage(G_IM_FMT_RGBA, G_IM_SIZ_16b, 1, mc_scarecrow_head_alpha_pal_rgba16),
	gsDPSetTile(0, 0, 0, 256, 5, 0, G_TX_WRAP | G_TX_NOMIRROR, 0, 0, G_TX_WRAP | G_TX_NOMIRROR, 0, 0),
	gsDPLoadTLUTCmd(5, 18),
	gsDPSetTextureImage(G_IM_FMT_CI, G_IM_SIZ_8b_LOAD_BLOCK, 1, mc_scarecrow_head_alpha_ci8),
	gsDPSetTile(G_IM_FMT_CI, G_IM_SIZ_8b_LOAD_BLOCK, 0, 0, 7, 0, G_TX_WRAP | G_TX_NOMIRROR, 0, 0, G_TX_WRAP | G_TX_NOMIRROR, 0, 0),
	gsDPLoadBlock(7, 0, 0, 127, 1024),
	gsDPSetTile(G_IM_FMT_CI, G_IM_SIZ_8b, 2, 0, 0, 0, G_TX_CLAMP | G_TX_NOMIRROR, 4, 0, G_TX_WRAP | G_TX_NOMIRROR, 4, 0),
	gsDPSetTileSize(0, 0, 0, 60, 60),
	gsSPEndDisplayList(),
};

Gfx mat_revert_mc_scarecrow_head_tip[] = {
	gsSPSetGeometryMode(G_CULL_BACK),
	gsDPPipeSync(),
	gsDPSetAlphaDither(G_AD_DISABLE),
	gsDPSetTextureLUT(G_TT_NONE),
	gsSPEndDisplayList(),
};

Gfx mc_scarecrow_root_mesh_layer_1[] = {
	gsSPDisplayList(mat_mc_scarecrow_wood2),
	gsSPDisplayList(mc_scarecrow_root_mesh_layer_1_tri_0),
	gsSPDisplayList(mat_revert_mc_scarecrow_wood2),
	gsSPDisplayList(mat_mc_scarecrow_wood1),
	gsSPDisplayList(mc_scarecrow_root_mesh_layer_1_tri_1),
	gsSPDisplayList(mat_revert_mc_scarecrow_wood1),
	gsSPEndDisplayList(),
};

Gfx mc_scarecrow_body_skinned_mesh_layer_4[] = {
	gsSPDisplayList(mat_mc_scarecrow_spring),
	gsSPDisplayList(mc_scarecrow_body_skinned_mesh_layer_4_tri_0),
	gsSPDisplayList(mat_revert_mc_scarecrow_spring),
	gsSPEndDisplayList(),
};

Gfx mc_scarecrow_body_mesh_layer_4[] = {
	gsSPDisplayList(mat_mc_scarecrow_spring),
	gsSPDisplayList(mc_scarecrow_body_mesh_layer_4_tri_0),
	gsSPDisplayList(mat_revert_mc_scarecrow_spring),
	gsSPEndDisplayList(),
};

Gfx mc_scarecrow_body_mesh_layer_1[] = {
	gsSPDisplayList(mat_mc_scarecrow_shirt),
	gsSPDisplayList(mc_scarecrow_body_mesh_layer_1_tri_0),
	gsSPDisplayList(mat_revert_mc_scarecrow_shirt),
	gsSPDisplayList(mat_mc_scarecrow_crown),
	gsSPDisplayList(mc_scarecrow_body_mesh_layer_1_tri_1),
	gsSPDisplayList(mat_revert_mc_scarecrow_crown),
	gsSPEndDisplayList(),
};

Gfx mc_scarecrow_arm_l_mesh_layer_1[] = {
	gsSPDisplayList(mat_mc_scarecrow_shirt),
	gsSPDisplayList(mc_scarecrow_arm_l_mesh_layer_1_tri_0),
	gsSPDisplayList(mat_revert_mc_scarecrow_shirt),
	gsSPDisplayList(mat_mc_scarecrow_wood1),
	gsSPDisplayList(mc_scarecrow_arm_l_mesh_layer_1_tri_1),
	gsSPDisplayList(mat_revert_mc_scarecrow_wood1),
	gsSPDisplayList(mat_mc_scarecrow_gloves),
	gsSPDisplayList(mc_scarecrow_arm_l_mesh_layer_1_tri_2),
	gsSPDisplayList(mat_revert_mc_scarecrow_gloves),
	gsSPEndDisplayList(),
};

Gfx mc_scarecrow_hand_l_mesh_layer_1[] = {
	gsSPDisplayList(mat_mc_scarecrow_gloves),
	gsSPDisplayList(mc_scarecrow_hand_l_mesh_layer_1_tri_0),
	gsSPDisplayList(mat_revert_mc_scarecrow_gloves),
	gsSPEndDisplayList(),
};

Gfx mc_scarecrow_arm_r_mesh_layer_1[] = {
	gsSPDisplayList(mat_mc_scarecrow_shirt),
	gsSPDisplayList(mc_scarecrow_arm_r_mesh_layer_1_tri_0),
	gsSPDisplayList(mat_revert_mc_scarecrow_shirt),
	gsSPDisplayList(mat_mc_scarecrow_wood1),
	gsSPDisplayList(mc_scarecrow_arm_r_mesh_layer_1_tri_1),
	gsSPDisplayList(mat_revert_mc_scarecrow_wood1),
	gsSPDisplayList(mat_mc_scarecrow_gloves),
	gsSPDisplayList(mc_scarecrow_arm_r_mesh_layer_1_tri_2),
	gsSPDisplayList(mat_revert_mc_scarecrow_gloves),
	gsSPEndDisplayList(),
};

Gfx mc_scarecrow_hand_r_mesh_layer_1[] = {
	gsSPDisplayList(mat_mc_scarecrow_gloves),
	gsSPDisplayList(mc_scarecrow_hand_r_mesh_layer_1_tri_0),
	gsSPDisplayList(mat_revert_mc_scarecrow_gloves),
	gsSPEndDisplayList(),
};

Gfx mc_scarecrow_cape1_skinned_mesh_layer_1[] = {
	gsSPDisplayList(mat_mc_scarecrow_crown),
	gsSPDisplayList(mc_scarecrow_cape1_skinned_mesh_layer_1_tri_0),
	gsSPDisplayList(mat_revert_mc_scarecrow_crown),
	gsSPEndDisplayList(),
};

Gfx mc_scarecrow_cape1_mesh_layer_1[] = {
	gsSPDisplayList(mat_mc_scarecrow_crown),
	gsSPDisplayList(mc_scarecrow_cape1_mesh_layer_1_tri_0),
	gsSPDisplayList(mc_scarecrow_cape1_mesh_layer_1_tri_1),
	gsSPDisplayList(mat_revert_mc_scarecrow_crown),
	gsSPEndDisplayList(),
};

Gfx mc_scarecrow_cape2_skinned_mesh_layer_1[] = {
	gsSPDisplayList(mat_mc_scarecrow_crown),
	gsSPDisplayList(mc_scarecrow_cape2_skinned_mesh_layer_1_tri_0),
	gsSPDisplayList(mat_revert_mc_scarecrow_crown),
	gsSPEndDisplayList(),
};

Gfx mc_scarecrow_cape2_mesh_layer_1[] = {
	gsSPDisplayList(mat_mc_scarecrow_crown),
	gsSPDisplayList(mc_scarecrow_cape2_mesh_layer_1_tri_0),
	gsSPDisplayList(mat_revert_mc_scarecrow_crown),
	gsDPPipeSync(),
	gsSPSetGeometryMode(G_LIGHTING),
	gsSPClearGeometryMode(G_TEXTURE_GEN),
	gsDPSetCombineLERP(0, 0, 0, SHADE, 0, 0, 0, ENVIRONMENT, 0, 0, 0, SHADE, 0, 0, 0, ENVIRONMENT),
	gsSPTexture(65535, 65535, 0, 0, 0),
	gsDPSetEnvColor(255, 255, 255, 255),
	gsDPSetAlphaCompare(G_AC_NONE),
	gsSPEndDisplayList(),
};

Gfx mc_scarecrow_head_mesh_layer_1[] = {
	gsSPDisplayList(mat_mc_scarecrow_crown),
	gsSPDisplayList(mc_scarecrow_head_mesh_layer_1_tri_0),
	gsSPDisplayList(mat_revert_mc_scarecrow_crown),
	gsSPDisplayList(mat_mc_scarecrow_head),
	gsSPDisplayList(mc_scarecrow_head_mesh_layer_1_tri_1),
	gsSPDisplayList(mat_revert_mc_scarecrow_head),
	gsDPPipeSync(),
	gsSPSetGeometryMode(G_LIGHTING),
	gsSPClearGeometryMode(G_TEXTURE_GEN),
	gsDPSetCombineLERP(0, 0, 0, SHADE, 0, 0, 0, ENVIRONMENT, 0, 0, 0, SHADE, 0, 0, 0, ENVIRONMENT),
	gsSPTexture(65535, 65535, 0, 0, 0),
	gsDPSetEnvColor(255, 255, 255, 255),
	gsDPSetAlphaCompare(G_AC_NONE),
	gsSPEndDisplayList(),
};

Gfx mc_scarecrow_head_mesh_layer_4[] = {
	gsSPDisplayList(mat_mc_scarecrow_eye),
	gsSPDisplayList(mc_scarecrow_head_mesh_layer_4_tri_0),
	gsSPDisplayList(mat_revert_mc_scarecrow_eye),
	gsSPDisplayList(mat_mc_scarecrow_head_tip),
	gsSPDisplayList(mc_scarecrow_head_mesh_layer_4_tri_1),
	gsSPDisplayList(mat_revert_mc_scarecrow_head_tip),
	gsDPPipeSync(),
	gsSPSetGeometryMode(G_LIGHTING),
	gsSPClearGeometryMode(G_TEXTURE_GEN),
	gsDPSetCombineLERP(0, 0, 0, SHADE, 0, 0, 0, ENVIRONMENT, 0, 0, 0, SHADE, 0, 0, 0, ENVIRONMENT),
	gsSPTexture(65535, 65535, 0, 0, 0),
	gsDPSetEnvColor(255, 255, 255, 255),
	gsDPSetAlphaCompare(G_AC_NONE),
	gsSPEndDisplayList(),
};

Gfx mc_scarecrow_head_switch_option_head_switch_mesh_layer_4[] = {
	gsSPDisplayList(mat_mc_scarecrow_head_tip),
	gsSPDisplayList(mc_scarecrow_head_switch_option_head_switch_mesh_layer_4_tri_0),
	gsSPDisplayList(mat_revert_mc_scarecrow_head_tip),
	gsDPPipeSync(),
	gsSPSetGeometryMode(G_LIGHTING),
	gsSPClearGeometryMode(G_TEXTURE_GEN),
	gsDPSetCombineLERP(0, 0, 0, SHADE, 0, 0, 0, ENVIRONMENT, 0, 0, 0, SHADE, 0, 0, 0, ENVIRONMENT),
	gsSPTexture(65535, 65535, 0, 0, 0),
	gsDPSetEnvColor(255, 255, 255, 255),
	gsDPSetAlphaCompare(G_AC_NONE),
	gsSPEndDisplayList(),
};

