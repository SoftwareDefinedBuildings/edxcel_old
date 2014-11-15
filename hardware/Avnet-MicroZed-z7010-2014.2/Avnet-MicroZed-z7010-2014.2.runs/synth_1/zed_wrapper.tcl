# 
# Synthesis run script generated by Vivado
# 

set_param gui.test TreeTableDev
debug::add_scope template.lib 1
set_msg_config -id {HDL 9-1061} -limit 100000
set_msg_config -id {HDL 9-1654} -limit 100000

create_project -in_memory -part xc7z010clg400-1
set_param project.compositeFile.enableAutoGeneration 0
set_param synth.vivado.isSynthRun true
set_msg_config -id {IP_Flow 19-2162} -severity warning -new_severity info
set_property webtalk.parent_dir /home/immesys/w/FPGA/project/hardware/Avnet-MicroZed-z7010-2014.2/Avnet-MicroZed-z7010-2014.2.cache/wt [current_project]
set_property parent.project_path /home/immesys/w/FPGA/project/hardware/Avnet-MicroZed-z7010-2014.2/Avnet-MicroZed-z7010-2014.2.xpr [current_project]
set_property default_lib xil_defaultlib [current_project]
set_property target_language Verilog [current_project]
set_property ip_repo_paths /home/immesys/w/FPGA/project/hardware/ip_repo/EdXel_1.1 [current_project]
add_files /home/immesys/w/FPGA/project/hardware/Avnet-MicroZed-z7010-2014.2/Avnet-MicroZed-z7010-2014.2.srcs/sources_1/bd/zed/zed.bd
set_property used_in_implementation false [get_files -all /home/immesys/w/FPGA/project/hardware/Avnet-MicroZed-z7010-2014.2/Avnet-MicroZed-z7010-2014.2.srcs/sources_1/bd/zed/ip/zed_processing_system7_0_0/zed_processing_system7_0_0.xdc]
set_property used_in_implementation false [get_files -all /home/immesys/w/FPGA/project/hardware/Avnet-MicroZed-z7010-2014.2/Avnet-MicroZed-z7010-2014.2.srcs/sources_1/bd/zed/ip/zed_rst_processing_system7_0_100M_0/zed_rst_processing_system7_0_100M_0_board.xdc]
set_property used_in_implementation false [get_files -all /home/immesys/w/FPGA/project/hardware/Avnet-MicroZed-z7010-2014.2/Avnet-MicroZed-z7010-2014.2.srcs/sources_1/bd/zed/ip/zed_rst_processing_system7_0_100M_0/zed_rst_processing_system7_0_100M_0.xdc]
set_property used_in_implementation false [get_files -all /home/immesys/w/FPGA/project/hardware/Avnet-MicroZed-z7010-2014.2/Avnet-MicroZed-z7010-2014.2.srcs/sources_1/bd/zed/ip/zed_rst_processing_system7_0_100M_0/zed_rst_processing_system7_0_100M_0_ooc.xdc]
set_property used_in_implementation false [get_files -all /home/immesys/w/FPGA/project/hardware/Avnet-MicroZed-z7010-2014.2/Avnet-MicroZed-z7010-2014.2.srcs/sources_1/ipshared/xilinx.com/jtag_axi_v1_0/b7a1cace/constraints/jtag_axi.xdc]
set_property used_in_implementation false [get_files -all /home/immesys/w/FPGA/project/hardware/Avnet-MicroZed-z7010-2014.2/Avnet-MicroZed-z7010-2014.2.srcs/sources_1/bd/zed/ip/zed_jtag_axi_0_0/zed_jtag_axi_0_0_ooc.xdc]
set_property used_in_implementation false [get_files -all /home/immesys/w/FPGA/project/hardware/Avnet-MicroZed-z7010-2014.2/Avnet-MicroZed-z7010-2014.2.srcs/sources_1/bd/zed/ip/zed_xbar_0/zed_xbar_0_ooc.xdc]
set_property used_in_implementation false [get_files -all /home/immesys/w/FPGA/project/hardware/Avnet-MicroZed-z7010-2014.2/Avnet-MicroZed-z7010-2014.2.srcs/sources_1/ipshared/xilinx.com/ila_v5_0/ce9baedf/constraints/ila.xdc]
set_property used_in_implementation false [get_files -all /home/immesys/w/FPGA/project/hardware/Avnet-MicroZed-z7010-2014.2/Avnet-MicroZed-z7010-2014.2.srcs/sources_1/bd/zed/ip/zed_ila_0_0/zed_ila_0_0_ooc.xdc]
set_property used_in_implementation false [get_files -all /home/immesys/w/FPGA/project/hardware/Avnet-MicroZed-z7010-2014.2/Avnet-MicroZed-z7010-2014.2.srcs/sources_1/bd/zed/ip/zed_auto_pc_0/zed_auto_pc_0_ooc.xdc]
set_property used_in_implementation false [get_files -all /home/immesys/w/FPGA/project/hardware/Avnet-MicroZed-z7010-2014.2/Avnet-MicroZed-z7010-2014.2.srcs/sources_1/bd/zed/ip/zed_auto_pc_1/zed_auto_pc_1_ooc.xdc]
set_property used_in_implementation false [get_files -all /home/immesys/w/FPGA/project/hardware/Avnet-MicroZed-z7010-2014.2/Avnet-MicroZed-z7010-2014.2.srcs/sources_1/bd/zed/zed_ooc.xdc]
set_property is_locked true [get_files /home/immesys/w/FPGA/project/hardware/Avnet-MicroZed-z7010-2014.2/Avnet-MicroZed-z7010-2014.2.srcs/sources_1/bd/zed/zed.bd]

read_verilog -library xil_defaultlib /home/immesys/w/FPGA/project/hardware/Avnet-MicroZed-z7010-2014.2/Avnet-MicroZed-z7010-2014.2.srcs/sources_1/bd/zed/hdl/zed_wrapper.v
read_xdc dont_touch.xdc
set_property used_in_implementation false [get_files dont_touch.xdc]
catch { write_hwdef -file zed_wrapper.hwdef }
synth_design -top zed_wrapper -part xc7z010clg400-1
write_checkpoint zed_wrapper.dcp
catch { report_utilization -file zed_wrapper_utilization_synth.rpt -pb zed_wrapper_utilization_synth.pb }
