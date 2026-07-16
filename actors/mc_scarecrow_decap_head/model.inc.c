Lights1 mc_scarecrow_decap_head_head_lights = gdSPDefLights1(
	0x7F, 0x7F, 0x7F,
	0xFF, 0xFF, 0xFF, 0x28, 0x28, 0x28);

Lights1 mc_scarecrow_decap_head_crown_lights = gdSPDefLights1(
	0x7F, 0x59, 0x22,
	0xFF, 0xB6, 0x4D, 0x28, 0x28, 0x28);

Lights1 mc_scarecrow_decap_head_head_tip_lights = gdSPDefLights1(
	0x7F, 0x7F, 0x7F,
	0xFF, 0xFF, 0xFF, 0x28, 0x28, 0x28);

Texture mc_scarecrow_decap_head_head_ci4[] = {
	#include "actors/mc_scarecrow_decap_head/head.ci4.inc.c"
};

Texture mc_scarecrow_decap_head_head_pal_rgba16[] = {
	#include "actors/mc_scarecrow_decap_head/head.rgba16.pal"
};

Texture mc_scarecrow_decap_head_crown_ci4[] = {
	#include "actors/mc_scarecrow_decap_head/crown.ci4.inc.c"
};

Texture mc_scarecrow_decap_head_crown_pal_rgba16[] = {
	#include "actors/mc_scarecrow_decap_head/crown.rgba16.pal"
};

Texture mc_scarecrow_decap_head_eye_ia8[] = {
	#include "actors/mc_scarecrow_decap_head/eye.ia8.inc.c"
};

Texture mc_scarecrow_decap_head_head_alpha_ci8[] = {
	#include "actors/mc_scarecrow_decap_head/head_alpha.ci8.inc.c"
};

Texture mc_scarecrow_decap_head_head_alpha_pal_rgba16[] = {
	#include "actors/mc_scarecrow_decap_head/head_alpha.rgba16.pal"
};

Vtx mc_scarecrow_decap_head_decap_head_mesh_layer_1_vtx_0[99] = {
	{{{64, 89, 0}, 0, {1620, -293}, {0x4E, 0x64, 0x00, 0x00}}},
	{{{0, 109, 0}, 0, {1336, -649}, {0x00, 0x7F, 0x00, 0x00}}},
	{{{52, 89, 38}, 0, {874, -293}, {0x3F, 0x64, 0x2E, 0x00}}},
	{{{94, 49, 0}, 0, {1620, 9}, {0x75, 0x31, 0x00, 0x00}}},
	{{{76, 49, 55}, 0, {874, 9}, {0x5F, 0x31, 0x45, 0x00}}},
	{{{20, 89, 61}, 0, {482, -293}, {0x18, 0x64, 0x4A, 0x00}}},
	{{{0, 109, 0}, 0, {516, -649}, {0x00, 0x7F, 0x00, 0x00}}},
	{{{29, 49, 89}, 0, {482, 9}, {0x24, 0x31, 0x6F, 0x00}}},
	{{{-20, 89, 61}, 0, {-461, -293}, {0xE8, 0x64, 0x4A, 0x00}}},
	{{{0, 109, 0}, 0, {-47, -649}, {0x00, 0x7F, 0x00, 0x00}}},
	{{{-29, 49, 89}, 0, {-461, 9}, {0xDC, 0x31, 0x6F, 0x00}}},
	{{{-52, 89, 38}, 0, {-1055, -293}, {0xC1, 0x64, 0x2E, 0x00}}},
	{{{0, 109, 0}, 0, {-680, -649}, {0x00, 0x7F, 0x00, 0x00}}},
	{{{-76, 49, 55}, 0, {-1055, 9}, {0xA1, 0x31, 0x45, 0x00}}},
	{{{-64, 89, 0}, 0, {-1307, -293}, {0xB2, 0x64, 0x00, 0x00}}},
	{{{0, 109, 0}, 0, {-1053, -649}, {0x00, 0x7F, 0x00, 0x00}}},
	{{{-94, 49, 0}, 0, {-1307, 9}, {0x8B, 0x31, 0x00, 0x00}}},
	{{{-52, 89, -38}, 0, {-1671, -293}, {0xC1, 0x64, 0xD2, 0x00}}},
	{{{0, 109, 0}, 0, {-1477, -649}, {0x00, 0x7F, 0x00, 0x00}}},
	{{{-76, 49, -55}, 0, {-1671, 9}, {0xA1, 0x31, 0xBB, 0x00}}},
	{{{-20, 89, -61}, 0, {-2189, -293}, {0xE8, 0x64, 0xB6, 0x00}}},
	{{{0, 109, 0}, 0, {-1979, -649}, {0x00, 0x7F, 0x00, 0x00}}},
	{{{-29, 49, -89}, 0, {-2189, 9}, {0xDC, 0x31, 0x91, 0x00}}},
	{{{-84, -5, -61}, 0, {-1671, 347}, {0x99, 0xFB, 0xB5, 0x00}}},
	{{{-32, -5, -99}, 0, {-2189, 347}, {0xD9, 0xFB, 0x87, 0x00}}},
	{{{-74, -52, -54}, 0, {-1671, 595}, {0xA5, 0xC4, 0xBE, 0x00}}},
	{{{-28, -52, -87}, 0, {-2189, 595}, {0xDD, 0xC4, 0x96, 0x00}}},
	{{{-52, -80, -38}, 0, {-1671, 773}, {0xC6, 0x97, 0xD6, 0x00}}},
	{{{-20, -80, -61}, 0, {-2189, 773}, {0xEA, 0x97, 0xBC, 0x00}}},
	{{{0, -100, 0}, 0, {-2135, 1129}, {0x00, 0x81, 0x00, 0x00}}},
	{{{-64, -80, 0}, 0, {-1307, 773}, {0xB9, 0x97, 0x00, 0x00}}},
	{{{-91, -52, 0}, 0, {-1307, 595}, {0x90, 0xC4, 0x00, 0x00}}},
	{{{-52, -80, 38}, 0, {-1055, 773}, {0xC6, 0x97, 0x2A, 0x00}}},
	{{{0, -100, 0}, 0, {-1074, 1129}, {0x00, 0x81, 0x00, 0x00}}},
	{{{-74, -52, 54}, 0, {-1055, 595}, {0xA5, 0xC4, 0x42, 0x00}}},
	{{{-20, -80, 61}, 0, {-461, 773}, {0xEA, 0x97, 0x44, 0x00}}},
	{{{0, -100, 0}, 0, {-680, 1129}, {0x00, 0x81, 0x00, 0x00}}},
	{{{-28, -52, 87}, 0, {-461, 595}, {0xDD, 0xC4, 0x6A, 0x00}}},
	{{{20, -80, 61}, 0, {482, 773}, {0x16, 0x97, 0x44, 0x00}}},
	{{{0, -100, 0}, 0, {-98, 1129}, {0x00, 0x81, 0x00, 0x00}}},
	{{{28, -52, 87}, 0, {482, 595}, {0x23, 0xC4, 0x6A, 0x00}}},
	{{{52, -80, 38}, 0, {874, 773}, {0x3A, 0x97, 0x2A, 0x00}}},
	{{{0, -100, 0}, 0, {712, 1129}, {0x00, 0x81, 0x00, 0x00}}},
	{{{74, -52, 54}, 0, {874, 595}, {0x5B, 0xC4, 0x42, 0x00}}},
	{{{64, -80, 0}, 0, {1620, 773}, {0x47, 0x97, 0x00, 0x00}}},
	{{{0, -100, 0}, 0, {1326, 1129}, {0x00, 0x81, 0x00, 0x00}}},
	{{{91, -52, 0}, 0, {1620, 595}, {0x70, 0xC4, 0x00, 0x00}}},
	{{{52, -80, -38}, 0, {2158, 773}, {0x3A, 0x97, 0xD6, 0x00}}},
	{{{0, -100, 0}, 0, {1986, 1129}, {0x00, 0x81, 0x00, 0x00}}},
	{{{74, -52, -54}, 0, {2158, 595}, {0x5B, 0xC4, 0xBE, 0x00}}},
	{{{20, -80, -61}, 0, {2511, 773}, {0x16, 0x97, 0xBC, 0x00}}},
	{{{0, -100, 0}, 0, {2370, 1129}, {0x00, 0x81, 0x00, 0x00}}},
	{{{28, -52, -87}, 0, {2511, 595}, {0x23, 0xC4, 0x96, 0x00}}},
	{{{-20, -80, -61}, 0, {2792, 773}, {0xEA, 0x97, 0xBC, 0x00}}},
	{{{0, -100, 0}, 0, {2634, 1129}, {0x00, 0x81, 0x00, 0x00}}},
	{{{-28, -52, -87}, 0, {2792, 595}, {0xDD, 0xC4, 0x96, 0x00}}},
	{{{32, -5, -99}, 0, {2511, 347}, {0x27, 0xFB, 0x87, 0x00}}},
	{{{-32, -5, -99}, 0, {2792, 347}, {0xD9, 0xFB, 0x87, 0x00}}},
	{{{29, 49, -89}, 0, {2511, 9}, {0x24, 0x31, 0x91, 0x00}}},
	{{{-29, 49, -89}, 0, {2792, 9}, {0xDC, 0x31, 0x91, 0x00}}},
	{{{20, 89, -61}, 0, {2511, -293}, {0x18, 0x64, 0xB6, 0x00}}},
	{{{-20, 89, -61}, 0, {2792, -293}, {0xE8, 0x64, 0xB6, 0x00}}},
	{{{0, 109, 0}, 0, {2634, -649}, {0x00, 0x7F, 0x00, 0x00}}},
	{{{52, 89, -38}, 0, {2158, -293}, {0x3F, 0x64, 0xD2, 0x00}}},
	{{{20, 89, -61}, 0, {2511, -293}, {0x18, 0x64, 0xB6, 0x00}}},
	{{{0, 109, 0}, 0, {2360, -649}, {0x00, 0x7F, 0x00, 0x00}}},
	{{{52, 89, -38}, 0, {2158, -293}, {0x3F, 0x64, 0xD2, 0x00}}},
	{{{29, 49, -89}, 0, {2511, 9}, {0x24, 0x31, 0x91, 0x00}}},
	{{{76, 49, -55}, 0, {2158, 9}, {0x5F, 0x31, 0xBB, 0x00}}},
	{{{64, 89, 0}, 0, {1620, -293}, {0x4E, 0x64, 0x00, 0x00}}},
	{{{0, 109, 0}, 0, {1970, -649}, {0x00, 0x7F, 0x00, 0x00}}},
	{{{94, 49, 0}, 0, {1620, 9}, {0x75, 0x31, 0x00, 0x00}}},
	{{{84, -5, -61}, 0, {2158, 347}, {0x67, 0xFB, 0xB5, 0x00}}},
	{{{104, -5, 0}, 0, {1620, 347}, {0x7F, 0xFB, 0x00, 0x00}}},
	{{{76, 49, 55}, 0, {874, 9}, {0x5F, 0x31, 0x45, 0x00}}},
	{{{84, -5, 61}, 0, {874, 347}, {0x67, 0xFB, 0x4B, 0x00}}},
	{{{29, 49, 89}, 0, {482, 9}, {0x24, 0x31, 0x6F, 0x00}}},
	{{{32, -5, 99}, 0, {482, 347}, {0x27, 0xFB, 0x79, 0x00}}},
	{{{-29, 49, 89}, 0, {-461, 9}, {0xDC, 0x31, 0x6F, 0x00}}},
	{{{-32, -5, 99}, 0, {-461, 347}, {0xD9, 0xFB, 0x79, 0x00}}},
	{{{-76, 49, 55}, 0, {-1055, 9}, {0xA1, 0x31, 0x45, 0x00}}},
	{{{-84, -5, 61}, 0, {-1055, 347}, {0x99, 0xFB, 0x4B, 0x00}}},
	{{{-94, 49, 0}, 0, {-1307, 9}, {0x8B, 0x31, 0x00, 0x00}}},
	{{{-104, -5, 0}, 0, {-1307, 347}, {0x81, 0xFB, 0x00, 0x00}}},
	{{{-76, 49, -55}, 0, {-1671, 9}, {0xA1, 0x31, 0xBB, 0x00}}},
	{{{-84, -5, -61}, 0, {-1671, 347}, {0x99, 0xFB, 0xB5, 0x00}}},
	{{{-91, -52, 0}, 0, {-1307, 595}, {0x90, 0xC4, 0x00, 0x00}}},
	{{{-74, -52, -54}, 0, {-1671, 595}, {0xA5, 0xC4, 0xBE, 0x00}}},
	{{{-74, -52, 54}, 0, {-1055, 595}, {0xA5, 0xC4, 0x42, 0x00}}},
	{{{-28, -52, 87}, 0, {-461, 595}, {0xDD, 0xC4, 0x6A, 0x00}}},
	{{{28, -52, 87}, 0, {482, 595}, {0x23, 0xC4, 0x6A, 0x00}}},
	{{{74, -52, 54}, 0, {874, 595}, {0x5B, 0xC4, 0x42, 0x00}}},
	{{{91, -52, 0}, 0, {1620, 595}, {0x70, 0xC4, 0x00, 0x00}}},
	{{{74, -52, -54}, 0, {2158, 595}, {0x5B, 0xC4, 0xBE, 0x00}}},
	{{{28, -52, -87}, 0, {2511, 595}, {0x23, 0xC4, 0x96, 0x00}}},
	{{{32, -5, -99}, 0, {2511, 347}, {0x27, 0xFB, 0x87, 0x00}}},
	{{{0, -100, 0}, 0, {-1477, 1129}, {0x00, 0x81, 0x00, 0x00}}},
	{{{-64, -80, 0}, 0, {-1307, 773}, {0xB9, 0x97, 0x00, 0x00}}},
	{{{-52, -80, -38}, 0, {-1671, 773}, {0xC6, 0x97, 0xD6, 0x00}}},
};

Gfx mc_scarecrow_decap_head_decap_head_mesh_layer_1_tri_0[] = {
	gsSPVertex(mc_scarecrow_decap_head_decap_head_mesh_layer_1_vtx_0 + 0, 64, 0),
	gsSP2Triangles(0, 1, 2, 0, 3, 0, 2, 0),
	gsSP2Triangles(3, 2, 4, 0, 4, 2, 5, 0),
	gsSP2Triangles(2, 6, 5, 0, 4, 5, 7, 0),
	gsSP2Triangles(7, 5, 8, 0, 5, 9, 8, 0),
	gsSP2Triangles(7, 8, 10, 0, 10, 8, 11, 0),
	gsSP2Triangles(8, 12, 11, 0, 10, 11, 13, 0),
	gsSP2Triangles(13, 11, 14, 0, 11, 15, 14, 0),
	gsSP2Triangles(13, 14, 16, 0, 16, 14, 17, 0),
	gsSP2Triangles(14, 18, 17, 0, 16, 17, 19, 0),
	gsSP2Triangles(19, 17, 20, 0, 17, 21, 20, 0),
	gsSP2Triangles(19, 20, 22, 0, 23, 19, 22, 0),
	gsSP2Triangles(23, 22, 24, 0, 25, 23, 24, 0),
	gsSP2Triangles(25, 24, 26, 0, 27, 25, 26, 0),
	gsSP2Triangles(27, 26, 28, 0, 29, 27, 28, 0),
	gsSP2Triangles(30, 25, 27, 0, 30, 31, 25, 0),
	gsSP2Triangles(32, 31, 30, 0, 33, 32, 30, 0),
	gsSP2Triangles(32, 34, 31, 0, 35, 34, 32, 0),
	gsSP2Triangles(36, 35, 32, 0, 35, 37, 34, 0),
	gsSP2Triangles(38, 37, 35, 0, 39, 38, 35, 0),
	gsSP2Triangles(38, 40, 37, 0, 41, 40, 38, 0),
	gsSP2Triangles(42, 41, 38, 0, 41, 43, 40, 0),
	gsSP2Triangles(44, 43, 41, 0, 45, 44, 41, 0),
	gsSP2Triangles(44, 46, 43, 0, 47, 46, 44, 0),
	gsSP2Triangles(48, 47, 44, 0, 47, 49, 46, 0),
	gsSP2Triangles(50, 49, 47, 0, 51, 50, 47, 0),
	gsSP2Triangles(50, 52, 49, 0, 53, 52, 50, 0),
	gsSP2Triangles(54, 53, 50, 0, 53, 55, 52, 0),
	gsSP2Triangles(55, 56, 52, 0, 55, 57, 56, 0),
	gsSP2Triangles(57, 58, 56, 0, 57, 59, 58, 0),
	gsSP2Triangles(59, 60, 58, 0, 59, 61, 60, 0),
	gsSP2Triangles(61, 62, 60, 0, 58, 60, 63, 0),
	gsSPVertex(mc_scarecrow_decap_head_decap_head_mesh_layer_1_vtx_0 + 64, 35, 0),
	gsSP2Triangles(0, 1, 2, 0, 3, 2, 4, 0),
	gsSP2Triangles(4, 2, 5, 0, 2, 6, 5, 0),
	gsSP2Triangles(4, 5, 7, 0, 8, 4, 7, 0),
	gsSP2Triangles(8, 7, 9, 0, 9, 7, 10, 0),
	gsSP2Triangles(9, 10, 11, 0, 11, 10, 12, 0),
	gsSP2Triangles(11, 12, 13, 0, 13, 12, 14, 0),
	gsSP2Triangles(13, 14, 15, 0, 15, 14, 16, 0),
	gsSP2Triangles(15, 16, 17, 0, 17, 16, 18, 0),
	gsSP2Triangles(17, 18, 19, 0, 19, 18, 20, 0),
	gsSP2Triangles(19, 20, 21, 0, 22, 19, 21, 0),
	gsSP2Triangles(22, 21, 23, 0, 24, 19, 22, 0),
	gsSP2Triangles(24, 17, 19, 0, 25, 17, 24, 0),
	gsSP2Triangles(25, 15, 17, 0, 26, 15, 25, 0),
	gsSP2Triangles(26, 13, 15, 0, 27, 13, 26, 0),
	gsSP2Triangles(27, 11, 13, 0, 28, 11, 27, 0),
	gsSP2Triangles(28, 9, 11, 0, 29, 9, 28, 0),
	gsSP2Triangles(29, 8, 9, 0, 30, 8, 29, 0),
	gsSP2Triangles(30, 31, 8, 0, 31, 4, 8, 0),
	gsSP2Triangles(31, 3, 4, 0, 32, 33, 34, 0),
	gsSPEndDisplayList(),
};

Vtx mc_scarecrow_decap_head_decap_head_mesh_layer_1_vtx_1[16] = {
	{{{-51, 77, -53}, 0, {56, 510}, {0xAA, 0xD6, 0xAD, 0xFF}}},
	{{{-62, 115, -68}, 0, {14, 115}, {0xAA, 0xD6, 0xAC, 0xFF}}},
	{{{0, 161, -99}, 0, {240, -374}, {0x00, 0xD5, 0x88, 0xFF}}},
	{{{-72, 81, -3}, 0, {-21, 506}, {0x85, 0xDF, 0x03, 0xFF}}},
	{{{-90, 167, -9}, 0, {-89, -382}, {0x85, 0xDF, 0x02, 0xFF}}},
	{{{-51, 84, 48}, 0, {56, 501}, {0xAA, 0xE3, 0x59, 0xFF}}},
	{{{-62, 123, 56}, 0, {14, 104}, {0xA9, 0xE3, 0x58, 0xFF}}},
	{{{0, 85, 69}, 0, {240, 499}, {0x00, 0xE8, 0x7D, 0xFF}}},
	{{{0, 173, 81}, 0, {240, -390}, {0x00, 0xE8, 0x7D, 0xFF}}},
	{{{51, 84, 48}, 0, {424, 501}, {0x56, 0xE3, 0x59, 0xFF}}},
	{{{62, 123, 56}, 0, {466, 104}, {0x57, 0xE3, 0x58, 0xFF}}},
	{{{72, 81, -3}, 0, {501, 506}, {0x7B, 0xDF, 0x03, 0xFF}}},
	{{{90, 167, -9}, 0, {569, -382}, {0x7B, 0xDF, 0x02, 0xFF}}},
	{{{51, 77, -53}, 0, {424, 510}, {0x56, 0xD6, 0xAD, 0xFF}}},
	{{{62, 115, -68}, 0, {466, 115}, {0x56, 0xD6, 0xAC, 0xFF}}},
	{{{0, 76, -74}, 0, {240, 512}, {0x00, 0xD5, 0x88, 0xFF}}},
};

Gfx mc_scarecrow_decap_head_decap_head_mesh_layer_1_tri_1[] = {
	gsSPVertex(mc_scarecrow_decap_head_decap_head_mesh_layer_1_vtx_1 + 0, 16, 0),
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

Vtx mc_scarecrow_decap_head_decap_head_mesh_layer_4_vtx_0[12] = {
	{{{-84, -4, 91}, 0, {-16, 496}, {0xE2, 0x0E, 0x7B, 0xFF}}},
	{{{-43, 9, 100}, 0, {496, -16}, {0xE8, 0x0B, 0x7C, 0xFF}}},
	{{{-73, 21, 91}, 0, {-16, -16}, {0xE2, 0x0E, 0x7B, 0xFF}}},
	{{{-55, -16, 100}, 0, {496, 496}, {0xE8, 0x0B, 0x7C, 0xFF}}},
	{{{-15, -7, 105}, 0, {1008, -16}, {0xEE, 0x08, 0x7D, 0xFF}}},
	{{{-26, -30, 105}, 0, {1008, 496}, {0xEE, 0x08, 0x7D, 0xFF}}},
	{{{84, -4, 91}, 0, {-16, 496}, {0x1E, 0x0E, 0x7B, 0xFF}}},
	{{{73, 21, 91}, 0, {-16, -16}, {0x1E, 0x0E, 0x7B, 0xFF}}},
	{{{43, 9, 100}, 0, {496, -16}, {0x18, 0x0B, 0x7C, 0xFF}}},
	{{{55, -16, 100}, 0, {496, 496}, {0x18, 0x0B, 0x7C, 0xFF}}},
	{{{15, -7, 105}, 0, {1008, -16}, {0x12, 0x08, 0x7D, 0xFF}}},
	{{{26, -30, 105}, 0, {1008, 496}, {0x12, 0x08, 0x7D, 0xFF}}},
};

Gfx mc_scarecrow_decap_head_decap_head_mesh_layer_4_tri_0[] = {
	gsSPVertex(mc_scarecrow_decap_head_decap_head_mesh_layer_4_vtx_0 + 0, 12, 0),
	gsSP2Triangles(0, 1, 2, 0, 0, 3, 1, 0),
	gsSP2Triangles(3, 4, 1, 0, 3, 5, 4, 0),
	gsSP2Triangles(6, 7, 8, 0, 6, 8, 9, 0),
	gsSP2Triangles(9, 8, 10, 0, 9, 10, 11, 0),
	gsSPEndDisplayList(),
};

Vtx mc_scarecrow_decap_head_decap_head_mesh_layer_4_vtx_1[20] = {
	{{{0, 98, -40}, 0, {1264, 496}, {0x00, 0xE2, 0x85, 0x00}}},
	{{{0, 125, -53}, 0, {1264, -16}, {0x00, 0xE2, 0x85, 0x00}}},
	{{{53, 185, 0}, 0, {752, -16}, {0x7C, 0xE6, 0x00, 0x00}}},
	{{{40, 98, 0}, 0, {752, 496}, {0x7C, 0xE6, 0x00, 0x00}}},
	{{{0, 125, 53}, 0, {240, -16}, {0x00, 0xE2, 0x7B, 0x00}}},
	{{{0, 98, 40}, 0, {240, 496}, {0x00, 0xE2, 0x7B, 0x00}}},
	{{{-53, 185, 0}, 0, {-272, -16}, {0x84, 0xE6, 0x00, 0x00}}},
	{{{-40, 98, 0}, 0, {-272, 496}, {0x84, 0xE6, 0x00, 0x00}}},
	{{{0, 125, -53}, 0, {-784, -16}, {0x00, 0xE2, 0x85, 0x00}}},
	{{{0, 98, -40}, 0, {-784, 496}, {0x00, 0xE2, 0x85, 0x00}}},
	{{{-29, 98, 0}, 0, {1264, 496}, {0x83, 0xEA, 0x00, 0x00}}},
	{{{-38, 125, 0}, 0, {1264, -16}, {0x83, 0xEA, 0x00, 0x00}}},
	{{{0, 185, -38}, 0, {752, -16}, {0x00, 0xED, 0x82, 0x00}}},
	{{{0, 98, -29}, 0, {752, 496}, {0x00, 0xED, 0x82, 0x00}}},
	{{{38, 125, 0}, 0, {240, -16}, {0x7D, 0xEA, 0x00, 0x00}}},
	{{{29, 98, 0}, 0, {240, 496}, {0x7D, 0xEA, 0x00, 0x00}}},
	{{{0, 185, 38}, 0, {-272, -16}, {0x00, 0xED, 0x7E, 0x00}}},
	{{{0, 98, 29}, 0, {-272, 496}, {0x00, 0xED, 0x7E, 0x00}}},
	{{{-38, 125, 0}, 0, {-784, -16}, {0x83, 0xEA, 0x00, 0x00}}},
	{{{-29, 98, 0}, 0, {-784, 496}, {0x83, 0xEA, 0x00, 0x00}}},
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


Gfx mat_mc_scarecrow_decap_head_head[] = {
	gsSPClearGeometryMode(G_CULL_BACK),
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
	gsSPSetGeometryMode(G_CULL_BACK),
	gsDPPipeSync(),
	gsDPSetAlphaDither(G_AD_DISABLE),
	gsDPSetTextureLUT(G_TT_NONE),
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

Gfx mat_mc_scarecrow_decap_head_eye[] = {
	gsDPPipeSync(),
	gsDPSetCombineLERP(0, 0, 0, TEXEL0, 0, 0, 0, TEXEL0, 0, 0, 0, TEXEL0, 0, 0, 0, TEXEL0),
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
	gsSPDisplayList(mat_mc_scarecrow_decap_head_head),
	gsSPDisplayList(mc_scarecrow_decap_head_decap_head_mesh_layer_1_tri_0),
	gsSPDisplayList(mat_revert_mc_scarecrow_decap_head_head),
	gsSPDisplayList(mat_mc_scarecrow_decap_head_crown),
	gsSPDisplayList(mc_scarecrow_decap_head_decap_head_mesh_layer_1_tri_1),
	gsSPDisplayList(mat_revert_mc_scarecrow_decap_head_crown),
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

