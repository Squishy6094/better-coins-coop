#include <ultra64.h>
#include "sm64.h"
#include "behavior_data.h"
#include "model_ids.h"
#include "seq_ids.h"
#include "dialog_ids.h"
#include "segment_symbols.h"
#include "level_commands.h"

#include "game/level_update.h"

#include "levels/scripts.h"

#include "make_const_nonconst.h"
#include "levels/master_cap_stage/header.h"

/* Fast64 begin persistent block [scripts] */
/* Fast64 end persistent block [scripts] */

const LevelScript level_master_cap_stage_entry[] = {
	INIT_LEVEL(),
	LOAD_MIO0(0x07, _master_cap_stage_segment_7SegmentRomStart, _master_cap_stage_segment_7SegmentRomEnd), 
	ALLOC_LEVEL_POOL(),
	MARIO(MODEL_MARIO, 0x00000001, bhvMario), 
	/* Fast64 begin persistent block [level commands] */
	/* Fast64 end persistent block [level commands] */

	AREA(1, master_cap_stage_area_1),
		WARP_NODE(0x0A, LEVEL_CASTLE_GROUNDS, 0x01, 0x0A, WARP_NO_CHECKPOINT),
		WARP_NODE(0xF0, LEVEL_CASTLE_GROUNDS, 0x01, 0x0A, WARP_NO_CHECKPOINT),
		WARP_NODE(0xF1, LEVEL_CASTLE_GROUNDS, 0x01, 0x0A, WARP_NO_CHECKPOINT),
		OBJECT(MODEL_NONE, 2600, 700, -1000, 0, 0, 0, (0x02 << 24), bhvCoinFormation),
		OBJECT(MODEL_NONE, -6200, 2200, 1400, 0, 0, 0, (0x01 << 24), bhvCoinFormation),
		OBJECT(MODEL_NONE, -7100, 2200, 1400, 0, 0, 0, (0x01 << 24), bhvCoinFormation),
		MARIO_POS(0x01, 90, -7700, 200, -900),
		OBJECT(MODEL_NONE, -7700, 200, -900, 0, 90, 0, 0x000A0000, bhvSpinAirborneWarp),
		TERRAIN(master_cap_stage_area_1_collision),
		MACRO_OBJECTS(master_cap_stage_area_1_macro_objs),
		STOP_MUSIC(0),
		TERRAIN_TYPE(TERRAIN_STONE),
		/* Fast64 begin persistent block [area commands] */
		/* Fast64 end persistent block [area commands] */
	END_AREA(),
	FREE_LEVEL_POOL(),
	MARIO_POS(0x01, 90, -7700, 200, -900),
	CALL(0, lvl_init_or_update),
	CALL_LOOP(1, lvl_init_or_update),
	CLEAR_LEVEL(),
	SLEEP_BEFORE_EXIT(1),
	EXIT(),
};