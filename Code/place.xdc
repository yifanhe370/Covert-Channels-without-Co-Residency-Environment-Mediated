create_pblock pblock_CL_SLR0
create_pblock pblock_CL_SLR1
create_pblock pblock_CL_SLR2
create_pblock pblock_CL_SLR3
create_pblock pblock_CL_SLR4
create_pblock pblock_CL_SLR5
# Complete CRs
resize_pblock pblock_CL_SLR0 -add {CLOCKREGION_X0Y0:CLOCKREGION_X0Y0}
resize_pblock pblock_CL_SLR1 -add {CLOCKREGION_X0Y3:CLOCKREGION_X0Y3}
resize_pblock pblock_CL_SLR2 -add {CLOCKREGION_X1Y3:CLOCKREGION_X1Y3}
resize_pblock pblock_CL_SLR3 -add {CLOCKREGION_X1Y0:CLOCKREGION_X1Y0}
resize_pblock pblock_CL_SLR4 -add {CLOCKREGION_X0Y0:CLOCKREGION_X0Y0}
add_cells_to_pblock pblock_CL_SLR0 [get_cells -hierarchical -regexp {loop_antenna_use/lines1_inst}]
add_cells_to_pblock pblock_CL_SLR0 [get_cells -hierarchical -regexp {loop_antenna_use/lines1_inst__([0-9])}]
add_cells_to_pblock pblock_CL_SLR0 [get_cells -hierarchical -regexp {loop_antenna_use/lines1_inst__([1-9][0-9])}]
add_cells_to_pblock pblock_CL_SLR0 [get_cells -hierarchical -regexp {loop_antenna_use/lines1_inst__([1-8][0-9][0-9])}]
add_cells_to_pblock pblock_CL_SLR0 [get_cells -hierarchical -regexp {loop_antenna_use/lines1_inst__(9[0-8][0-9])}]
add_cells_to_pblock pblock_CL_SLR0 [get_cells -hierarchical -regexp {loop_antenna_use/lines1_inst__(99[0-7])}]
add_cells_to_pblock pblock_CL_SLR1 [get_cells -hierarchical -regexp {loop_antenna_use/lines1_inst__(998)}]
add_cells_to_pblock pblock_CL_SLR1 [get_cells -hierarchical -regexp {loop_antenna_use/lines1_inst__(999)}]
add_cells_to_pblock pblock_CL_SLR1 [get_cells -hierarchical -regexp {loop_antenna_use/lines1_inst__(1[0-8][0-9][0-9])}]
add_cells_to_pblock pblock_CL_SLR1 [get_cells -hierarchical -regexp {loop_antenna_use/lines1_inst__(19[0-8][0-9])}]
add_cells_to_pblock pblock_CL_SLR1 [get_cells -hierarchical -regexp {loop_antenna_use/lines1_inst__(199[0-7])}]
add_cells_to_pblock pblock_CL_SLR0 [get_cells   loop_antenna_use/stem_start*]
add_cells_to_pblock pblock_CL_SLR2 [get_cells   loop_antenna_use/lines2*]
add_cells_to_pblock pblock_CL_SLR3 [get_cells   loop_antenna_use/lines3*]
add_cells_to_pblock pblock_CL_SLR4 [get_cells   loop_antenna_use/stem_end*]
#add_cells_to_pblock pblock_CL_SLR5 [get_cells   *noise*]//use for noise
set_property IS_SOFT 0 [get_pblocks pblock_CL_SLR0]
set_property IS_SOFT 0 [get_pblocks pblock_CL_SLR1]
set_property IS_SOFT 0 [get_pblocks pblock_CL_SLR2]
set_property IS_SOFT 0 [get_pblocks pblock_CL_SLR3]
set_property IS_SOFT 0 [get_pblocks pblock_CL_SLR4]
#set_property IS_SOFT 0 [get_pblocks pblock_CL_SLR5]