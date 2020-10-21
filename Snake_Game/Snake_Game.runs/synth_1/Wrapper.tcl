# 
# Synthesis run script generated by Vivado
# 

set_param xicom.use_bs_reader 1
debug::add_scope template.lib 1
set_msg_config -id {HDL 9-1061} -limit 100000
set_msg_config -id {HDL 9-1654} -limit 100000
create_project -in_memory -part xc7a35tcpg236-1

set_param project.compositeFile.enableAutoGeneration 0
set_param synth.vivado.isSynthRun true
set_property webtalk.parent_dir /home/s1808875/Snake_Game/Snake_Game.cache/wt [current_project]
set_property parent.project_path /home/s1808875/Snake_Game/Snake_Game.xpr [current_project]
set_property default_lib xil_defaultlib [current_project]
set_property target_language Verilog [current_project]
read_verilog -library xil_defaultlib {
  /home/s1808875/Snake_Game/Snake_Game.srcs/sources_1/imports/new/Seg7Display.v
  /home/s1808875/Snake_Game/Snake_Game.srcs/sources_1/imports/new/Multiplixer4.v
  /home/s1808875/Snake_Game/Snake_Game.srcs/sources_1/imports/new/Generic_counter.v
  /home/s1808875/Snake_Game/Snake_Game.srcs/sources_1/new/LED_Display.v
  /home/s1808875/Snake_Game/Snake_Game.srcs/sources_1/imports/new/VGA_interface.v
  /home/s1808875/Snake_Game/Snake_Game.srcs/sources_1/imports/new/Target_generator.v
  /home/s1808875/Snake_Game/Snake_Game.srcs/sources_1/imports/new/Snake_ctrl.v
  /home/s1808875/Snake_Game/Snake_Game.srcs/sources_1/imports/new/NavigationSM.v
  /home/s1808875/Snake_Game/Snake_Game.srcs/sources_1/imports/new/MasterSM.v
  /home/s1808875/Snake_Game/Snake_Game.srcs/sources_1/imports/new/Score_counter.v
  /home/s1808875/Snake_Game/Snake_Game.srcs/sources_1/imports/new/Wrapper.v
}
read_xdc /home/s1808875/Snake_Game/Snake_Game.srcs/constrs_1/imports/Downloads/snakeGame_constraints.xdc
set_property used_in_implementation false [get_files /home/s1808875/Snake_Game/Snake_Game.srcs/constrs_1/imports/Downloads/snakeGame_constraints.xdc]

synth_design -top Wrapper -part xc7a35tcpg236-1
write_checkpoint -noxdef Wrapper.dcp
catch { report_utilization -file Wrapper_utilization_synth.rpt -pb Wrapper_utilization_synth.pb }
