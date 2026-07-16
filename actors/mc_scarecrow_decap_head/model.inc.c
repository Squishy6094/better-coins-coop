Lights1 mc_scarecrow_decap_head_crown_lights = gdSPDefLights1(
	0x7F, 0x59, 0x22,
	0xFF, 0xB6, 0x4D, 0x28, 0x28, 0x28);

Lights1 mc_scarecrow_decap_head_head_lights = gdSPDefLights1(
	0x7F, 0x7F, 0x7F,
	0xFF, 0xFF, 0xFF, 0x28, 0x28, 0x28);

Lights1 mc_scarecrow_decap_head_eye_lights = gdSPDefLights1(
	0x7F, 0x7F, 0x7F,
	0xFF, 0xFF, 0xFF, 0x28, 0x28, 0x28);

Lights1 mc_scarecrow_decap_head_head_tip_lights = gdSPDefLights1(
	0x7F, 0x7F, 0x7F,
	0xFF, 0xFF, 0xFF, 0x28, 0x28, 0x28);

Gfx mc_scarecrow_decap_head_crown_ci4_aligner[] = {gsSPEndDisplayList()};
u8 mc_scarecrow_decap_head_crown_ci4[] = {
	#include "actors/mc_scarecrow_decap_head/crown.ci4.inc.c"
};

Gfx mc_scarecrow_decap_head_crown_pal_rgba16_aligner[] = {gsSPEndDisplayList()};
u8 mc_scarecrow_decap_head_crown_pal_rgba16[] = {
	#include "actors/mc_scarecrow_decap_head/crown.rgba16.pal"
};

Gfx mc_scarecrow_decap_head_head_ci4_aligner[] = {gsSPEndDisplayList()};
u8 mc_scarecrow_decap_head_head_ci4[] = {
	#include "actors/mc_scarecrow_decap_head/head.ci4.inc.c"
};

Gfx mc_scarecrow_decap_head_head_pal_rgba16_aligner[] = {gsSPEndDisplayList()};
u8 mc_scarecrow_decap_head_head_pal_rgba16[] = {
	#include "actors/mc_scarecrow_decap_head/head.rgba16.pal"
};

Gfx mc_scarecrow_decap_head_eye_ia8_aligner[] = {gsSPEndDisplayList()};
u8 mc_scarecrow_decap_head_eye_ia8[] = {
	#include "actors/mc_scarecrow_decap_head/eye.ia8.inc.c"
};

Gfx mc_scarecrow_decap_head_head_alpha_ci8_aligner[] = {gsSPEndDisplayList()};
u8 mc_scarecrow_decap_head_head_alpha_ci8[] = {
	#include "actors/mc_scarecrow_decap_head/head_alpha.ci8.inc.c"
};

Gfx mc_scarecrow_decap_head_head_alpha_pal_rgba16_aligner[] = {gsSPEndDisplayList()};
u8 mc_scarecrow_decap_head_head_alpha_pal_rgba16[] = {
	#include "actors/mc_scarecrow_decap_head/head_alpha.rgba16.pal"
};

Vtx mc_scarecrow_decap_head_decap_head_mesh_layer_1_vtx_0[16] = {
	{{{0, 161, -99}, 0, {240, -374}, {0x00, 0xD5, 0x88, 0xFF}}},
	{{{0, 76, -74}, 0, {240, 512}, {0x00, 0xD5, 0x88, 0xFF}}},
	{{{-51, 77, -53}, 0, {56, 510}, {0xAA, 0xD6, 0xAD, 0xFF}}},
	{{{62, 115, -68}, 0, {466, 115}, {0x56, 0xD6, 0xAC, 0xFF}}},
	{{{51, 77, -53}, 0, {424, 510}, {0x56, 0xD6, 0xAD, 0xFF}}},
	{{{90, 167, -9}, 0, {569, -382}, {0x7B, 0xDF, 0x02, 0xFF}}},
	{{{72, 81, -3}, 0, {501, 506}, {0x7B, 0xDF, 0x03, 0xFF}}},
	{{{62, 123, 56}, 0, {466, 104}, {0x57, 0xE3, 0x58, 0xFF}}},
	{{{51, 84, 48}, 0, {424, 501}, {0x56, 0xE3, 0x59, 0xFF}}},
	{{{0, 173, 81}, 0, {240, -390}, {0x00, 0xE8, 0x7D, 0xFF}}},
	{{{0, 85, 69}, 0, {240, 499}, {0x00, 0xE8, 0x7D, 0xFF}}},
	{{{-62, 123, 56}, 0, {14, 104}, {0xA9, 0xE3, 0x58, 0xFF}}},
	{{{-51, 84, 48}, 0, {56, 501}, {0xAA, 0xE3, 0x59, 0xFF}}},
	{{{-90, 167, -9}, 0, {-89, -382}, {0x85, 0xDF, 0x02, 0xFF}}},
	{{{-72, 81, -3}, 0, {-21, 506}, {0x85, 0xDF, 0x03, 0xFF}}},
	{{{-62, 115, -68}, 0, {14, 115}, {0xAA, 0xD6, 0xAC, 0xFF}}},
};

Gfx mc_scarecrow_decap_head_decap_head_mesh_layer_1_tri_0[] = {
	gsSPVertex(mc_scarecrow_decap_head_decap_head_mesh_layer_1_vtx_0 + 0, 16, 0),
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

Vtx mc_scarecrow_decap_head_decap_head_mesh_layer_1_vtx_1[94] = {
	{{{52, 89, 38}, 0, {874, -293}, {0x3F, 0x64, 0x2E, 0xFF}}},
	{{{0, 109, 0}, 0, {516, -649}, {0x17, 0x79, 0x20, 0xFF}}},
	{{{20, 89, 61}, 0, {482, -293}, {0x18, 0x64, 0x4A, 0xFF}}},
	{{{76, 49, 55}, 0, {874, 9}, {0x5F, 0x31, 0x45, 0xFF}}},
	{{{29, 49, 89}, 0, {482, 9}, {0x24, 0x31, 0x6F, 0xFF}}},
	{{{-20, 89, 61}, 0, {-461, -293}, {0xE8, 0x64, 0x4A, 0xFF}}},
	{{{0, 109, 0}, 0, {-47, -649}, {0x00, 0x79, 0x27, 0xFF}}},
	{{{-29, 49, 89}, 0, {-461, 9}, {0xDC, 0x31, 0x6F, 0xFF}}},
	{{{-52, 89, 38}, 0, {-1055, -293}, {0xC1, 0x64, 0x2E, 0xFF}}},
	{{{0, 109, 0}, 0, {-680, -649}, {0xE9, 0x79, 0x20, 0xFF}}},
	{{{-76, 49, 55}, 0, {-1055, 9}, {0xA1, 0x31, 0x45, 0xFF}}},
	{{{-64, 89, 0}, 0, {-1307, -293}, {0xB2, 0x64, 0x00, 0xFF}}},
	{{{0, 109, 0}, 0, {-1053, -649}, {0xDB, 0x79, 0x0C, 0xFF}}},
	{{{-94, 49, 0}, 0, {-1307, 9}, {0x8B, 0x31, 0x00, 0xFF}}},
	{{{-52, 89, -38}, 0, {-1671, -293}, {0xC1, 0x64, 0xD2, 0xFF}}},
	{{{0, 109, 0}, 0, {-1477, -649}, {0xDB, 0x79, 0xF4, 0xFF}}},
	{{{-76, 49, -55}, 0, {-1671, 9}, {0xA1, 0x31, 0xBB, 0xFF}}},
	{{{-20, 89, -61}, 0, {-2189, -293}, {0xD1, 0x62, 0xBF, 0xFF}}},
	{{{0, 109, 0}, 0, {-1979, -649}, {0xE9, 0x79, 0xE0, 0xFF}}},
	{{{-29, 49, -89}, 0, {-2189, 9}, {0xBB, 0x2F, 0xA1, 0xFF}}},
	{{{-84, -5, -61}, 0, {-1671, 347}, {0x99, 0xFB, 0xB5, 0xFF}}},
	{{{-32, -5, -99}, 0, {-2189, 347}, {0xB5, 0xFB, 0x99, 0xFF}}},
	{{{-74, -52, -54}, 0, {-1671, 595}, {0xA5, 0xC4, 0xBE, 0xFF}}},
	{{{-28, -52, -87}, 0, {-2189, 595}, {0xBE, 0xC6, 0xA4, 0xFF}}},
	{{{-52, -80, -38}, 0, {-1671, 773}, {0xC6, 0x97, 0xD6, 0xFF}}},
	{{{-20, -80, -61}, 0, {-2189, 773}, {0xD5, 0x99, 0xC4, 0xFF}}},
	{{{0, -100, 0}, 0, {-2135, 1129}, {0xE9, 0x87, 0xE0, 0xFF}}},
	{{{-64, -80, 0}, 0, {-1307, 773}, {0xB9, 0x97, 0x00, 0xFF}}},
	{{{0, -100, 0}, 0, {-1477, 1129}, {0xDB, 0x87, 0xF4, 0xFF}}},
	{{{-91, -52, 0}, 0, {-1307, 595}, {0x90, 0xC4, 0x00, 0xFF}}},
	{{{-52, -80, 38}, 0, {-1055, 773}, {0xC6, 0x97, 0x2A, 0xFF}}},
	{{{0, -100, 0}, 0, {-1074, 1129}, {0xDB, 0x87, 0x0C, 0xFF}}},
	{{{-74, -52, 54}, 0, {-1055, 595}, {0xA5, 0xC4, 0x42, 0xFF}}},
	{{{-20, -80, 61}, 0, {-461, 773}, {0xEA, 0x97, 0x44, 0xFF}}},
	{{{0, -100, 0}, 0, {-680, 1129}, {0xE9, 0x87, 0x20, 0xFF}}},
	{{{-28, -52, 87}, 0, {-461, 595}, {0xDD, 0xC4, 0x6A, 0xFF}}},
	{{{20, -80, 61}, 0, {482, 773}, {0x16, 0x97, 0x44, 0xFF}}},
	{{{0, -100, 0}, 0, {-98, 1129}, {0x00, 0x87, 0x27, 0xFF}}},
	{{{28, -52, 87}, 0, {482, 595}, {0x23, 0xC4, 0x6A, 0xFF}}},
	{{{52, -80, 38}, 0, {874, 773}, {0x3A, 0x97, 0x2A, 0xFF}}},
	{{{0, -100, 0}, 0, {712, 1129}, {0x17, 0x87, 0x20, 0xFF}}},
	{{{74, -52, 54}, 0, {874, 595}, {0x5B, 0xC4, 0x42, 0xFF}}},
	{{{64, -80, 0}, 0, {1620, 773}, {0x47, 0x97, 0x00, 0xFF}}},
	{{{0, -100, 0}, 0, {1326, 1129}, {0x25, 0x87, 0x0C, 0xFF}}},
	{{{91, -52, 0}, 0, {1620, 595}, {0x70, 0xC4, 0x00, 0xFF}}},
	{{{52, -80, -38}, 0, {2158, 773}, {0x3A, 0x97, 0xD6, 0xFF}}},
	{{{0, -100, 0}, 0, {1986, 1129}, {0x25, 0x87, 0xF4, 0xFF}}},
	{{{74, -52, -54}, 0, {2158, 595}, {0x5B, 0xC4, 0xBE, 0xFF}}},
	{{{20, -80, -61}, 0, {2511, 773}, {0x16, 0x97, 0xBC, 0xFF}}},
	{{{0, -100, 0}, 0, {2370, 1129}, {0x17, 0x87, 0xE0, 0xFF}}},
	{{{28, -52, -87}, 0, {2511, 595}, {0x23, 0xC4, 0x96, 0xFF}}},
	{{{-20, -80, -61}, 0, {2792, 773}, {0x00, 0x99, 0xB6, 0xFF}}},
	{{{0, -100, 0}, 0, {2634, 1129}, {0x00, 0x87, 0xD9, 0xFF}}},
	{{{-28, -52, -87}, 0, {2792, 595}, {0x00, 0xC6, 0x8F, 0xFF}}},
	{{{32, -5, -99}, 0, {2511, 347}, {0x27, 0xFB, 0x87, 0xFF}}},
	{{{-32, -5, -99}, 0, {2792, 347}, {0x00, 0xFB, 0x81, 0xFF}}},
	{{{29, 49, -89}, 0, {2511, 9}, {0x24, 0x31, 0x91, 0xFF}}},
	{{{32, -5, -99}, 0, {2511, 347}, {0x27, 0xFB, 0x87, 0xFF}}},
	{{{-32, -5, -99}, 0, {2792, 347}, {0x00, 0xFB, 0x81, 0xFF}}},
	{{{-29, 49, -89}, 0, {2792, 9}, {0x00, 0x2F, 0x8A, 0xFF}}},
	{{{20, 89, -61}, 0, {2511, -293}, {0x18, 0x64, 0xB6, 0xFF}}},
	{{{-20, 89, -61}, 0, {2792, -293}, {0x00, 0x62, 0xAF, 0xFF}}},
	{{{0, 109, 0}, 0, {2634, -649}, {0x00, 0x79, 0xD9, 0xFF}}},
	{{{52, 89, -38}, 0, {2158, -293}, {0x3F, 0x64, 0xD2, 0xFF}}},
	{{{76, 49, -55}, 0, {2158, 9}, {0x5F, 0x31, 0xBB, 0xFF}}},
	{{{64, 89, 0}, 0, {1620, -293}, {0x4E, 0x64, 0x00, 0xFF}}},
	{{{0, 109, 0}, 0, {1970, -649}, {0x25, 0x79, 0xF4, 0xFF}}},
	{{{94, 49, 0}, 0, {1620, 9}, {0x75, 0x31, 0x00, 0xFF}}},
	{{{52, 89, 38}, 0, {874, -293}, {0x3F, 0x64, 0x2E, 0xFF}}},
	{{{0, 109, 0}, 0, {1336, -649}, {0x25, 0x79, 0x0C, 0xFF}}},
	{{{76, 49, 55}, 0, {874, 9}, {0x5F, 0x31, 0x45, 0xFF}}},
	{{{104, -5, 0}, 0, {1620, 347}, {0x7F, 0xFB, 0x00, 0xFF}}},
	{{{84, -5, 61}, 0, {874, 347}, {0x67, 0xFB, 0x4B, 0xFF}}},
	{{{29, 49, 89}, 0, {482, 9}, {0x24, 0x31, 0x6F, 0xFF}}},
	{{{32, -5, 99}, 0, {482, 347}, {0x27, 0xFB, 0x79, 0xFF}}},
	{{{-29, 49, 89}, 0, {-461, 9}, {0xDC, 0x31, 0x6F, 0xFF}}},
	{{{-32, -5, 99}, 0, {-461, 347}, {0xD9, 0xFB, 0x79, 0xFF}}},
	{{{-76, 49, 55}, 0, {-1055, 9}, {0xA1, 0x31, 0x45, 0xFF}}},
	{{{-84, -5, 61}, 0, {-1055, 347}, {0x99, 0xFB, 0x4B, 0xFF}}},
	{{{-94, 49, 0}, 0, {-1307, 9}, {0x8B, 0x31, 0x00, 0xFF}}},
	{{{-104, -5, 0}, 0, {-1307, 347}, {0x81, 0xFB, 0x00, 0xFF}}},
	{{{-76, 49, -55}, 0, {-1671, 9}, {0xA1, 0x31, 0xBB, 0xFF}}},
	{{{-84, -5, -61}, 0, {-1671, 347}, {0x99, 0xFB, 0xB5, 0xFF}}},
	{{{-91, -52, 0}, 0, {-1307, 595}, {0x90, 0xC4, 0x00, 0xFF}}},
	{{{-74, -52, -54}, 0, {-1671, 595}, {0xA5, 0xC4, 0xBE, 0xFF}}},
	{{{-74, -52, 54}, 0, {-1055, 595}, {0xA5, 0xC4, 0x42, 0xFF}}},
	{{{-28, -52, 87}, 0, {-461, 595}, {0xDD, 0xC4, 0x6A, 0xFF}}},
	{{{28, -52, 87}, 0, {482, 595}, {0x23, 0xC4, 0x6A, 0xFF}}},
	{{{74, -52, 54}, 0, {874, 595}, {0x5B, 0xC4, 0x42, 0xFF}}},
	{{{91, -52, 0}, 0, {1620, 595}, {0x70, 0xC4, 0x00, 0xFF}}},
	{{{74, -52, -54}, 0, {2158, 595}, {0x5B, 0xC4, 0xBE, 0xFF}}},
	{{{84, -5, -61}, 0, {2158, 347}, {0x67, 0xFB, 0xB5, 0xFF}}},
	{{{28, -52, -87}, 0, {2511, 595}, {0x23, 0xC4, 0x96, 0xFF}}},
	{{{0, 109, 0}, 0, {2360, -649}, {0x17, 0x79, 0xE0, 0xFF}}},
};

Gfx mc_scarecrow_decap_head_decap_head_mesh_layer_1_tri_1[] = {
	gsSPVertex(mc_scarecrow_decap_head_decap_head_mesh_layer_1_vtx_1 + 0, 56, 0),
	gsSP2Triangles(0, 1, 2, 0, 2, 3, 0, 0),
	gsSP2Triangles(2, 4, 3, 0, 5, 4, 2, 0),
	gsSP2Triangles(2, 6, 5, 0, 5, 7, 4, 0),
	gsSP2Triangles(8, 7, 5, 0, 5, 9, 8, 0),
	gsSP2Triangles(8, 10, 7, 0, 11, 10, 8, 0),
	gsSP2Triangles(8, 12, 11, 0, 11, 13, 10, 0),
	gsSP2Triangles(14, 13, 11, 0, 11, 15, 14, 0),
	gsSP2Triangles(14, 16, 13, 0, 17, 16, 14, 0),
	gsSP2Triangles(14, 18, 17, 0, 17, 19, 16, 0),
	gsSP2Triangles(19, 20, 16, 0, 19, 21, 20, 0),
	gsSP2Triangles(21, 22, 20, 0, 21, 23, 22, 0),
	gsSP2Triangles(23, 24, 22, 0, 23, 25, 24, 0),
	gsSP2Triangles(26, 24, 25, 0, 22, 24, 27, 0),
	gsSP2Triangles(28, 27, 24, 0, 22, 27, 29, 0),
	gsSP2Triangles(29, 27, 30, 0, 31, 30, 27, 0),
	gsSP2Triangles(29, 30, 32, 0, 32, 30, 33, 0),
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
	gsSP2Triangles(54, 50, 53, 0, 54, 53, 55, 0),
	gsSPVertex(mc_scarecrow_decap_head_decap_head_mesh_layer_1_vtx_1 + 56, 38, 0),
	gsSP2Triangles(0, 1, 2, 0, 0, 2, 3, 0),
	gsSP2Triangles(4, 0, 3, 0, 4, 3, 5, 0),
	gsSP2Triangles(5, 6, 4, 0, 7, 0, 4, 0),
	gsSP2Triangles(7, 8, 0, 0, 9, 8, 7, 0),
	gsSP2Triangles(7, 10, 9, 0, 9, 11, 8, 0),
	gsSP2Triangles(12, 11, 9, 0, 9, 13, 12, 0),
	gsSP2Triangles(12, 14, 11, 0, 14, 15, 11, 0),
	gsSP2Triangles(14, 16, 15, 0, 17, 16, 14, 0),
	gsSP2Triangles(17, 18, 16, 0, 19, 18, 17, 0),
	gsSP2Triangles(19, 20, 18, 0, 21, 20, 19, 0),
	gsSP2Triangles(21, 22, 20, 0, 23, 22, 21, 0),
	gsSP2Triangles(23, 24, 22, 0, 25, 24, 23, 0),
	gsSP2Triangles(25, 26, 24, 0, 26, 27, 24, 0),
	gsSP2Triangles(26, 28, 27, 0, 24, 27, 29, 0),
	gsSP2Triangles(24, 29, 22, 0, 22, 29, 30, 0),
	gsSP2Triangles(22, 30, 20, 0, 20, 30, 31, 0),
	gsSP2Triangles(20, 31, 18, 0, 18, 31, 32, 0),
	gsSP2Triangles(18, 32, 16, 0, 16, 32, 33, 0),
	gsSP2Triangles(16, 33, 15, 0, 15, 33, 34, 0),
	gsSP2Triangles(15, 34, 35, 0, 35, 34, 36, 0),
	gsSP2Triangles(35, 36, 1, 0, 8, 35, 1, 0),
	gsSP2Triangles(8, 1, 0, 0, 11, 35, 8, 0),
	gsSP2Triangles(11, 15, 35, 0, 4, 37, 7, 0),
	gsSPEndDisplayList(),
};

Vtx mc_scarecrow_decap_head_decap_head_mesh_layer_4_vtx_0[12] = {
	{{{-43, 9, 100}, 0, {496, -16}, {0xE8, 0x0B, 0x7C, 0xFF}}},
	{{{-73, 21, 91}, 0, {-16, -16}, {0xE2, 0x0E, 0x7B, 0xFF}}},
	{{{-84, -4, 91}, 0, {-16, 496}, {0xE2, 0x0E, 0x7B, 0xFF}}},
	{{{-55, -16, 100}, 0, {496, 496}, {0xE8, 0x0B, 0x7C, 0xFF}}},
	{{{-15, -7, 105}, 0, {1008, -16}, {0xEE, 0x08, 0x7D, 0xFF}}},
	{{{-26, -30, 105}, 0, {1008, 496}, {0xEE, 0x08, 0x7D, 0xFF}}},
	{{{43, 9, 100}, 0, {496, -16}, {0x18, 0x0B, 0x7C, 0xFF}}},
	{{{84, -4, 91}, 0, {-16, 496}, {0x1E, 0x0E, 0x7B, 0xFF}}},
	{{{73, 21, 91}, 0, {-16, -16}, {0x1E, 0x0E, 0x7B, 0xFF}}},
	{{{55, -16, 100}, 0, {496, 496}, {0x18, 0x0B, 0x7C, 0xFF}}},
	{{{15, -7, 105}, 0, {1008, -16}, {0x12, 0x08, 0x7D, 0xFF}}},
	{{{26, -30, 105}, 0, {1008, 496}, {0x12, 0x08, 0x7D, 0xFF}}},
};

Gfx mc_scarecrow_decap_head_decap_head_mesh_layer_4_tri_0[] = {
	gsSPVertex(mc_scarecrow_decap_head_decap_head_mesh_layer_4_vtx_0 + 0, 12, 0),
	gsSP2Triangles(0, 1, 2, 0, 0, 2, 3, 0),
	gsSP2Triangles(4, 0, 3, 0, 4, 3, 5, 0),
	gsSP2Triangles(6, 7, 8, 0, 6, 9, 7, 0),
	gsSP2Triangles(10, 9, 6, 0, 10, 11, 9, 0),
	gsSPEndDisplayList(),
};

Vtx mc_scarecrow_decap_head_decap_head_mesh_layer_4_vtx_1[20] = {
	{{{0, 98, -40}, 0, {1264, 496}, {0x61, 0xE9, 0xB2, 0xFF}}},
	{{{0, 125, -53}, 0, {1264, -16}, {0x67, 0xE0, 0xBD, 0xFF}}},
	{{{53, 185, 0}, 0, {752, -16}, {0x7D, 0xEA, 0xFF, 0xFF}}},
	{{{40, 98, 0}, 0, {752, 496}, {0x7D, 0xE9, 0xFB, 0xFF}}},
	{{{0, 125, 53}, 0, {240, -16}, {0xF8, 0xD2, 0x76, 0xFF}}},
	{{{0, 98, 40}, 0, {240, 496}, {0xF7, 0xD2, 0x76, 0xFF}}},
	{{{-53, 185, 0}, 0, {-272, -16}, {0x83, 0xEA, 0x01, 0xFF}}},
	{{{-40, 98, 0}, 0, {-272, 496}, {0x83, 0xE9, 0x05, 0xFF}}},
	{{{0, 125, -53}, 0, {-784, -16}, {0xA4, 0xE6, 0xAD, 0xFF}}},
	{{{0, 98, -40}, 0, {-784, 496}, {0xAB, 0xD7, 0xAB, 0xFF}}},
	{{{-29, 98, 0}, 0, {1264, 496}, {0xAF, 0xF1, 0xA0, 0xFF}}},
	{{{-38, 125, 0}, 0, {1264, -16}, {0xBC, 0xE9, 0x97, 0xFF}}},
	{{{0, 185, -38}, 0, {752, -16}, {0xFF, 0xF0, 0x82, 0xFF}}},
	{{{0, 98, -29}, 0, {752, 496}, {0xFC, 0xEE, 0x82, 0xFF}}},
	{{{38, 125, 0}, 0, {240, -16}, {0x7A, 0xDF, 0x09, 0xFF}}},
	{{{29, 98, 0}, 0, {240, 496}, {0x7A, 0xDF, 0x07, 0xFF}}},
	{{{0, 185, 38}, 0, {-272, -16}, {0x01, 0xF0, 0x7E, 0xFF}}},
	{{{0, 98, 29}, 0, {-272, 496}, {0x04, 0xEE, 0x7E, 0xFF}}},
	{{{-38, 125, 0}, 0, {-784, -16}, {0xAC, 0xEE, 0x5E, 0xFF}}},
	{{{-29, 98, 0}, 0, {-784, 496}, {0xA9, 0xE2, 0x57, 0xFF}}},
};

Gfx mc_scarecrow_decap_head_decap_head_mesh_layer_4_tri_1[] = {
	gsSPVertex(mc_scarecrow_decap_head_decap_head_mesh_layer_4_vtx_1 + 0, 20, 0),
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


Gfx mat_mc_scarecrow_decap_head_crown[] = {
	gsSPClearGeometryMode(G_CULL_BACK),
	gsSPSetLights1(mc_scarecrow_decap_head_crown_lights),
	gsDPPipeSync(),
	gsDPSetCombineLERP(TEXEL0, SHADE, TEXEL0_ALPHA, SHADE, 0, 0, 0, ENVIRONMENT, TEXEL0, SHADE, TEXEL0_ALPHA, SHADE, 0, 0, 0, ENVIRONMENT),
	gsDPSetAlphaDither(G_AD_NOISE),
	gsDPSetTextureLUT(G_TT_RGBA16),
	gsSPTexture(65535, 65535, 0, 0, 1),
	gsDPSetTextureImage(G_IM_FMT_RGBA, G_IM_SIZ_16b, 1, mc_scarecrow_decap_head_crown_pal_rgba16),
	gsDPSetTile(0, 0, 0, 256, 5, 0, G_TX_WRAP | G_TX_NOMIRROR, 0, 0, G_TX_WRAP | G_TX_NOMIRROR, 0, 0),
	gsDPLoadTLUTCmd(5, 2),
	gsDPSetTextureImage(G_IM_FMT_CI, G_IM_SIZ_16b, 1, mc_scarecrow_decap_head_crown_ci4),
	gsDPSetTile(G_IM_FMT_CI, G_IM_SIZ_16b, 0, 0, 7, 0, G_TX_WRAP | G_TX_NOMIRROR, 0, 0, G_TX_WRAP | G_TX_NOMIRROR, 0, 0),
	gsDPLoadBlock(7, 0, 0, 63, 2048),
	gsDPSetTile(G_IM_FMT_CI, G_IM_SIZ_4b, 1, 0, 0, 0, G_TX_CLAMP | G_TX_NOMIRROR, 4, 0, G_TX_CLAMP | G_TX_NOMIRROR, 4, 0),
	gsDPSetTileSize(0, 0, 0, 60, 60),
	gsSPEndDisplayList(),
};

Gfx mat_revert_mc_scarecrow_decap_head_crown[] = {
	gsSPSetGeometryMode(G_CULL_BACK),
	gsDPPipeSync(),
	gsDPSetAlphaDither(G_AD_DISABLE),
	gsDPSetTextureLUT(G_TT_NONE),
	gsSPEndDisplayList(),
};

Gfx mat_mc_scarecrow_decap_head_head[] = {
	gsSPSetLights1(mc_scarecrow_decap_head_head_lights),
	gsDPPipeSync(),
	gsDPSetCombineLERP(TEXEL0, 0, SHADE, 0, 0, 0, 0, ENVIRONMENT, TEXEL0, 0, SHADE, 0, 0, 0, 0, ENVIRONMENT),
	gsDPSetAlphaDither(G_AD_NOISE),
	gsDPSetTextureLUT(G_TT_RGBA16),
	gsSPTexture(65535, 65535, 0, 0, 1),
	gsDPSetTextureImage(G_IM_FMT_RGBA, G_IM_SIZ_16b, 1, mc_scarecrow_decap_head_head_pal_rgba16),
	gsDPSetTile(0, 0, 0, 256, 5, 0, G_TX_WRAP | G_TX_NOMIRROR, 0, 0, G_TX_WRAP | G_TX_NOMIRROR, 0, 0),
	gsDPLoadTLUTCmd(5, 13),
	gsDPSetTextureImage(G_IM_FMT_CI, G_IM_SIZ_16b, 1, mc_scarecrow_decap_head_head_ci4),
	gsDPSetTile(G_IM_FMT_CI, G_IM_SIZ_16b, 0, 0, 7, 0, G_TX_WRAP | G_TX_NOMIRROR, 0, 0, G_TX_WRAP | G_TX_NOMIRROR, 0, 0),
	gsDPLoadBlock(7, 0, 0, 127, 1024),
	gsDPSetTile(G_IM_FMT_CI, G_IM_SIZ_4b, 2, 0, 0, 0, G_TX_WRAP | G_TX_NOMIRROR, 4, 0, G_TX_WRAP | G_TX_NOMIRROR, 5, 0),
	gsDPSetTileSize(0, 0, 0, 124, 60),
	gsSPEndDisplayList(),
};

Gfx mat_revert_mc_scarecrow_decap_head_head[] = {
	gsDPPipeSync(),
	gsDPSetAlphaDither(G_AD_DISABLE),
	gsDPSetTextureLUT(G_TT_NONE),
	gsSPEndDisplayList(),
};

Gfx mat_mc_scarecrow_decap_head_eye[] = {
	gsSPClearGeometryMode(G_CULL_BACK),
	gsSPSetLights1(mc_scarecrow_decap_head_eye_lights),
	gsDPPipeSync(),
	gsDPSetCombineLERP(TEXEL0, 0, SHADE, 0, TEXEL0, 0, ENVIRONMENT, 0, TEXEL0, 0, SHADE, 0, TEXEL0, 0, ENVIRONMENT, 0),
	gsDPSetAlphaDither(G_AD_NOISE),
	gsSPTexture(65535, 65535, 0, 0, 1),
	gsDPSetTextureImage(G_IM_FMT_IA, G_IM_SIZ_8b_LOAD_BLOCK, 1, mc_scarecrow_decap_head_eye_ia8),
	gsDPSetTile(G_IM_FMT_IA, G_IM_SIZ_8b_LOAD_BLOCK, 0, 0, 7, 0, G_TX_WRAP | G_TX_NOMIRROR, 0, 0, G_TX_WRAP | G_TX_NOMIRROR, 0, 0),
	gsDPLoadBlock(7, 0, 0, 255, 512),
	gsDPSetTile(G_IM_FMT_IA, G_IM_SIZ_8b, 4, 0, 0, 0, G_TX_WRAP | G_TX_NOMIRROR, 4, 0, G_TX_WRAP | G_TX_NOMIRROR, 5, 0),
	gsDPSetTileSize(0, 0, 0, 124, 60),
	gsSPEndDisplayList(),
};

Gfx mat_revert_mc_scarecrow_decap_head_eye[] = {
	gsSPSetGeometryMode(G_CULL_BACK),
	gsDPPipeSync(),
	gsDPSetAlphaDither(G_AD_DISABLE),
	gsSPEndDisplayList(),
};

Gfx mat_mc_scarecrow_decap_head_head_tip[] = {
	gsSPClearGeometryMode(G_CULL_BACK),
	gsSPSetLights1(mc_scarecrow_decap_head_head_tip_lights),
	gsDPPipeSync(),
	gsDPSetCombineLERP(TEXEL0, 0, SHADE, 0, TEXEL0, 0, ENVIRONMENT, 0, TEXEL0, 0, SHADE, 0, TEXEL0, 0, ENVIRONMENT, 0),
	gsDPSetAlphaDither(G_AD_NOISE),
	gsDPSetTextureLUT(G_TT_RGBA16),
	gsSPTexture(65535, 65535, 0, 0, 1),
	gsDPSetTextureImage(G_IM_FMT_RGBA, G_IM_SIZ_16b, 1, mc_scarecrow_decap_head_head_alpha_pal_rgba16),
	gsDPSetTile(0, 0, 0, 256, 5, 0, G_TX_WRAP | G_TX_NOMIRROR, 0, 0, G_TX_WRAP | G_TX_NOMIRROR, 0, 0),
	gsDPLoadTLUTCmd(5, 18),
	gsDPSetTextureImage(G_IM_FMT_CI, G_IM_SIZ_8b_LOAD_BLOCK, 1, mc_scarecrow_decap_head_head_alpha_ci8),
	gsDPSetTile(G_IM_FMT_CI, G_IM_SIZ_8b_LOAD_BLOCK, 0, 0, 7, 0, G_TX_WRAP | G_TX_NOMIRROR, 0, 0, G_TX_WRAP | G_TX_NOMIRROR, 0, 0),
	gsDPLoadBlock(7, 0, 0, 127, 1024),
	gsDPSetTile(G_IM_FMT_CI, G_IM_SIZ_8b, 2, 0, 0, 0, G_TX_CLAMP | G_TX_NOMIRROR, 4, 0, G_TX_WRAP | G_TX_NOMIRROR, 4, 0),
	gsDPSetTileSize(0, 0, 0, 60, 60),
	gsSPEndDisplayList(),
};

Gfx mat_revert_mc_scarecrow_decap_head_head_tip[] = {
	gsSPSetGeometryMode(G_CULL_BACK),
	gsDPPipeSync(),
	gsDPSetAlphaDither(G_AD_DISABLE),
	gsDPSetTextureLUT(G_TT_NONE),
	gsSPEndDisplayList(),
};

Gfx mc_scarecrow_decap_head_decap_head_mesh_layer_1[] = {
	gsSPDisplayList(mat_mc_scarecrow_decap_head_crown),
	gsSPDisplayList(mc_scarecrow_decap_head_decap_head_mesh_layer_1_tri_0),
	gsSPDisplayList(mat_revert_mc_scarecrow_decap_head_crown),
	gsSPDisplayList(mat_mc_scarecrow_decap_head_head),
	gsSPDisplayList(mc_scarecrow_decap_head_decap_head_mesh_layer_1_tri_1),
	gsSPDisplayList(mat_revert_mc_scarecrow_decap_head_head),
	gsDPPipeSync(),
	gsSPSetGeometryMode(G_LIGHTING),
	gsSPClearGeometryMode(G_TEXTURE_GEN),
	gsDPSetCombineLERP(0, 0, 0, SHADE, 0, 0, 0, ENVIRONMENT, 0, 0, 0, SHADE, 0, 0, 0, ENVIRONMENT),
	gsSPTexture(65535, 65535, 0, 0, 0),
	gsDPSetEnvColor(255, 255, 255, 255),
	gsDPSetAlphaCompare(G_AC_NONE),
	gsSPEndDisplayList(),
};

Gfx mc_scarecrow_decap_head_decap_head_mesh_layer_4[] = {
	gsSPDisplayList(mat_mc_scarecrow_decap_head_eye),
	gsSPDisplayList(mc_scarecrow_decap_head_decap_head_mesh_layer_4_tri_0),
	gsSPDisplayList(mat_revert_mc_scarecrow_decap_head_eye),
	gsSPDisplayList(mat_mc_scarecrow_decap_head_head_tip),
	gsSPDisplayList(mc_scarecrow_decap_head_decap_head_mesh_layer_4_tri_1),
	gsSPDisplayList(mat_revert_mc_scarecrow_decap_head_head_tip),
	gsDPPipeSync(),
	gsSPSetGeometryMode(G_LIGHTING),
	gsSPClearGeometryMode(G_TEXTURE_GEN),
	gsDPSetCombineLERP(0, 0, 0, SHADE, 0, 0, 0, ENVIRONMENT, 0, 0, 0, SHADE, 0, 0, 0, ENVIRONMENT),
	gsSPTexture(65535, 65535, 0, 0, 0),
	gsDPSetEnvColor(255, 255, 255, 255),
	gsDPSetAlphaCompare(G_AC_NONE),
	gsSPEndDisplayList(),
};

