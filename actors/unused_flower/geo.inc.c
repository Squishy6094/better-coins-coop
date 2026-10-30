const GeoLayout unused_flower_geo_opt_1[] = {
	GEO_NODE_START(),
	GEO_OPEN_NODE(),
		GEO_DISPLAY_LIST(LAYER_ALPHA, unused_flower_dl_mesh_layer_4_opt_1_with_revert),
	GEO_CLOSE_NODE(),
	GEO_RETURN(),
};
const GeoLayout unused_flower_geo_opt_2[] = {
	GEO_NODE_START(),
	GEO_OPEN_NODE(),
		GEO_DISPLAY_LIST(LAYER_ALPHA, unused_flower_dl_mesh_layer_4_opt_2_with_revert),
	GEO_CLOSE_NODE(),
	GEO_RETURN(),
};
const GeoLayout unused_flower_geo_opt_3[] = {
	GEO_NODE_START(),
	GEO_OPEN_NODE(),
		GEO_DISPLAY_LIST(LAYER_ALPHA, unused_flower_dl_mesh_layer_4_opt_3_with_revert),
	GEO_CLOSE_NODE(),
	GEO_RETURN(),
};
const GeoLayout unused_flower_geo_opt_4[] = {
	GEO_NODE_START(),
	GEO_OPEN_NODE(),
		GEO_DISPLAY_LIST(LAYER_ALPHA, unused_flower_dl_mesh_layer_4_opt_2_with_revert),
	GEO_CLOSE_NODE(),
	GEO_RETURN(),
};
const GeoLayout unused_flower_geo_opt_5[] = {
	GEO_NODE_START(),
	GEO_OPEN_NODE(),
		GEO_DISPLAY_LIST(LAYER_ALPHA, unused_flower_dl_mesh_layer_4_opt_1_with_revert),
	GEO_CLOSE_NODE(),
	GEO_RETURN(),
};
const GeoLayout unused_flower_geo[] = {
	GEO_NODE_START(),
	GEO_OPEN_NODE(),
		GEO_NODE_START(),
		GEO_OPEN_NODE(),
			GEO_SWITCH_CASE(8, geo_switch_anim_state),
			GEO_OPEN_NODE(),
				GEO_NODE_START(),
				GEO_OPEN_NODE(),
					GEO_DISPLAY_LIST(LAYER_ALPHA, unused_flower_dl_mesh_layer_4_with_revert),
				GEO_CLOSE_NODE(),
				GEO_BRANCH(1, unused_flower_geo_opt_1),
				GEO_BRANCH(1, unused_flower_geo_opt_2),
				GEO_BRANCH(1, unused_flower_geo_opt_3),
				GEO_BRANCH(1, unused_flower_geo_opt_4),
				GEO_BRANCH(1, unused_flower_geo_opt_5),
			GEO_CLOSE_NODE(),
		GEO_CLOSE_NODE(),
	GEO_CLOSE_NODE(),
	GEO_END(),
};
