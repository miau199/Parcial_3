set DESIGN_NAME "alu_top"
set BASE_DIR    "$env(HOME)/parcial3_parte2/pdk/M31LLSC750GL150MS_00.01.000/M31LLSC750GL150MS_00.01.000"
set TECH_FILE   "$BASE_DIR/M31LLSC750GL150MS.0.01/milkyway_techfiles/tech/GL150M_5M1T_9K.tf"
set REF_NDM     "$env(HOME)/parcial3_parte2/M31LLSC750GL150MS.ndm"

if {[file exists "${DESIGN_NAME}_lib.ndm"]} {
    file delete -force "${DESIGN_NAME}_lib.ndm"
}

create_lib ${DESIGN_NAME}_lib.ndm -technology $TECH_FILE -ref_libs $REF_NDM

read_verilog -top $DESIGN_NAME outputs/${DESIGN_NAME}_mapped.v
current_block $DESIGN_NAME
link_block

set_app_options -name place.coarse.continue_on_missing_scandef -value true
set_app_options -name opt.common.user_instance_name_prefix -value "icc2_opt_"

set routing_layers [get_layers -quiet -filter "layer_type == interconnect"]
set dir "horizontal"
foreach_in_collection lyr $routing_layers {
    set lyr_name [get_object_name $lyr]
    if {[string match -nocase "M*" $lyr_name]} {
        catch {set_attribute $lyr routing_direction $dir}
        if {$dir eq "horizontal"} { set dir "vertical" } else { set dir "horizontal" }
    }
}

remove_corners -all; remove_modes -all; remove_scenarios -all
create_corner typical
create_mode func
create_scenario -mode func -corner typical -name func_typical
current_scenario func_typical
read_sdc outputs/${DESIGN_NAME}_mapped.sdc
set_scenario_status func_typical -active true -setup true -hold true

proc conectar_pg {} {
    if {[sizeof_collection [get_nets -quiet VDD]] == 0} { create_net -power VDD }
    if {[sizeof_collection [get_nets -quiet VSS]] == 0} { create_net -ground VSS }

    set pwr_pins [get_pins -quiet -physical_context -filter "port_type == power"]
    set gnd_pins [get_pins -quiet -physical_context -filter "port_type == ground"]

    if {[sizeof_collection $pwr_pins] > 0} { catch {connect_pg_net -net VDD $pwr_pins} }
    if {[sizeof_collection $gnd_pins] > 0} { catch {connect_pg_net -net VSS $gnd_pins} }
    catch {connect_pg_net -automatic}
}

initialize_floorplan -core_utilization 0.65 -core_offset {5.0 5.0 5.0 5.0}
catch {create_track}
place_pins -self
conectar_pg
save_block -as ${DESIGN_NAME}/01_floorplan

if {[catch {place_opt} err_place]} {
    create_placement -effort high
    legalize_placement
}
conectar_pg
report_qor    > reports/icc2_1_place_opt_qor.rpt
report_timing > reports/icc2_1_place_opt_timing.rpt
save_block -as ${DESIGN_NAME}/02_place_opt

if {[catch {clock_opt} err_cts]} {
    catch {synthesize_clock_trees}
    catch {legalize_placement}
}
conectar_pg
report_qor        > reports/icc2_2_clock_opt_qor.rpt
report_timing     > reports/icc2_2_clock_opt_timing.rpt
report_clock_qor  > reports/icc2_2_clock_tree_qor.rpt
save_block -as ${DESIGN_NAME}/03_clock_opt

if {[catch {route_auto} err_route]} {
    catch {route_global}
    catch {route_track}
    catch {route_detail}
}
report_qor    > reports/icc2_3_route_auto_qor.rpt
report_timing > reports/icc2_3_route_auto_timing.rpt
save_block -as ${DESIGN_NAME}/04_route_auto

catch {route_opt}
catch {route_eco -utilize_dangling_wires true -reroute modified_nets_first_then_others}
catch {route_detail -incremental true -initial_drc_from_input true}
conectar_pg

report_qor                  > reports/icc2_4_route_opt_qor.rpt
report_timing -max_paths 5  > reports/icc2_4_route_opt_timing.rpt
report_design               > reports/icc2_4_route_opt_design_area.rpt
report_power                > reports/icc2_4_route_opt_power.rpt

check_legality -verbose > reports/icc2_check_legality.rpt
check_routes            > reports/icc2_check_routes.rpt
check_lvs -max_error 50 > reports/icc2_check_lvs.rpt

save_block -as ${DESIGN_NAME}/05_route_opt
save_block

write_gds outputs/${DESIGN_NAME}.gds
write_verilog outputs/${DESIGN_NAME}_post_route.v
save_lib

exit
