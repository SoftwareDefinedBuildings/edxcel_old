proc start_step { step } {
  set stopFile ".stop.rst"
  if {[file isfile .stop.rst]} {
    puts ""
    puts "*** Halting run - EA reset detected ***"
    puts ""
    puts ""
    return -code error
  }
  set beginFile ".$step.begin.rst"
  set platform "$::tcl_platform(platform)"
  set user "$::tcl_platform(user)"
  set pid [pid]
  set host ""
  if { [string equal $platform unix] } {
    if { [info exist ::env(HOSTNAME)] } {
      set host $::env(HOSTNAME)
    }
  } else {
    if { [info exist ::env(COMPUTERNAME)] } {
      set host $::env(COMPUTERNAME)
    }
  }
  set ch [open $beginFile w]
  puts $ch "<?xml version=\"1.0\"?>"
  puts $ch "<ProcessHandle Version=\"1\" Minor=\"0\">"
  puts $ch "    <Process Command=\".planAhead.\" Owner=\"$user\" Host=\"$host\" Pid=\"$pid\">"
  puts $ch "    </Process>"
  puts $ch "</ProcessHandle>"
  close $ch
}

proc end_step { step } {
  set endFile ".$step.end.rst"
  set ch [open $endFile w]
  close $ch
}

proc step_failed { step } {
  set endFile ".$step.error.rst"
  set ch [open $endFile w]
  close $ch
}

set_msg_config -id {HDL 9-1061} -limit 100000
set_msg_config -id {HDL 9-1654} -limit 100000

start_step init_design
set rc [catch {
  create_msg_db init_design.pb
  set_param gui.test TreeTableDev
  debug::add_scope template.lib 1
  set_property design_mode GateLvl [current_fileset]
  set_property webtalk.parent_dir /home/immesys/w/FPGA/project/hardware/Avnet-MicroZed-z7010-2014.2/Avnet-MicroZed-z7010-2014.2.cache/wt [current_project]
  set_property parent.project_path /home/immesys/w/FPGA/project/hardware/Avnet-MicroZed-z7010-2014.2/Avnet-MicroZed-z7010-2014.2.xpr [current_project]
  set_property ip_repo_paths {
  /home/immesys/w/FPGA/project/hardware/Avnet-MicroZed-z7010-2014.2/Avnet-MicroZed-z7010-2014.2.cache/ip
  /home/immesys/w/FPGA/project/hardware/ip_repo/EdXel_1.1
} [current_project]
  set_property ip_output_repo /home/immesys/w/FPGA/project/hardware/Avnet-MicroZed-z7010-2014.2/Avnet-MicroZed-z7010-2014.2.cache/ip [current_project]
  add_files -quiet /home/immesys/w/FPGA/project/hardware/Avnet-MicroZed-z7010-2014.2/Avnet-MicroZed-z7010-2014.2.runs/synth_1/zed_wrapper.dcp
  read_xdc -ref zed_processing_system7_0_0 -cells inst /home/immesys/w/FPGA/project/hardware/Avnet-MicroZed-z7010-2014.2/Avnet-MicroZed-z7010-2014.2.srcs/sources_1/bd/zed/ip/zed_processing_system7_0_0/zed_processing_system7_0_0.xdc
  set_property processing_order EARLY [get_files /home/immesys/w/FPGA/project/hardware/Avnet-MicroZed-z7010-2014.2/Avnet-MicroZed-z7010-2014.2.srcs/sources_1/bd/zed/ip/zed_processing_system7_0_0/zed_processing_system7_0_0.xdc]
  read_xdc -prop_thru_buffers -ref zed_rst_processing_system7_0_100M_0 /home/immesys/w/FPGA/project/hardware/Avnet-MicroZed-z7010-2014.2/Avnet-MicroZed-z7010-2014.2.srcs/sources_1/bd/zed/ip/zed_rst_processing_system7_0_100M_0/zed_rst_processing_system7_0_100M_0_board.xdc
  set_property processing_order EARLY [get_files /home/immesys/w/FPGA/project/hardware/Avnet-MicroZed-z7010-2014.2/Avnet-MicroZed-z7010-2014.2.srcs/sources_1/bd/zed/ip/zed_rst_processing_system7_0_100M_0/zed_rst_processing_system7_0_100M_0_board.xdc]
  read_xdc -ref zed_rst_processing_system7_0_100M_0 /home/immesys/w/FPGA/project/hardware/Avnet-MicroZed-z7010-2014.2/Avnet-MicroZed-z7010-2014.2.srcs/sources_1/bd/zed/ip/zed_rst_processing_system7_0_100M_0/zed_rst_processing_system7_0_100M_0.xdc
  set_property processing_order EARLY [get_files /home/immesys/w/FPGA/project/hardware/Avnet-MicroZed-z7010-2014.2/Avnet-MicroZed-z7010-2014.2.srcs/sources_1/bd/zed/ip/zed_rst_processing_system7_0_100M_0/zed_rst_processing_system7_0_100M_0.xdc]
  read_xdc -ref zed_jtag_axi_0_0 /home/immesys/w/FPGA/project/hardware/Avnet-MicroZed-z7010-2014.2/Avnet-MicroZed-z7010-2014.2.srcs/sources_1/ipshared/xilinx.com/jtag_axi_v1_0/b7a1cace/constraints/jtag_axi.xdc
  set_property processing_order EARLY [get_files /home/immesys/w/FPGA/project/hardware/Avnet-MicroZed-z7010-2014.2/Avnet-MicroZed-z7010-2014.2.srcs/sources_1/ipshared/xilinx.com/jtag_axi_v1_0/b7a1cace/constraints/jtag_axi.xdc]
  read_xdc -ref zed_ila_0_0 /home/immesys/w/FPGA/project/hardware/Avnet-MicroZed-z7010-2014.2/Avnet-MicroZed-z7010-2014.2.srcs/sources_1/ipshared/xilinx.com/ila_v5_0/ce9baedf/constraints/ila.xdc
  set_property processing_order EARLY [get_files /home/immesys/w/FPGA/project/hardware/Avnet-MicroZed-z7010-2014.2/Avnet-MicroZed-z7010-2014.2.srcs/sources_1/ipshared/xilinx.com/ila_v5_0/ce9baedf/constraints/ila.xdc]
  read_xdc -ref zed_ila_1_0 /home/immesys/w/FPGA/project/hardware/Avnet-MicroZed-z7010-2014.2/Avnet-MicroZed-z7010-2014.2.srcs/sources_1/ipshared/xilinx.com/ila_v5_0/ce9baedf/constraints/ila.xdc
  set_property processing_order EARLY [get_files /home/immesys/w/FPGA/project/hardware/Avnet-MicroZed-z7010-2014.2/Avnet-MicroZed-z7010-2014.2.srcs/sources_1/ipshared/xilinx.com/ila_v5_0/ce9baedf/constraints/ila.xdc]
  link_design -top zed_wrapper -part xc7z010clg400-1
  close_msg_db -file init_design.pb
} RESULT]
if {$rc} {
  step_failed init_design
  return -code error $RESULT
} else {
  end_step init_design
}

start_step opt_design
set rc [catch {
  create_msg_db opt_design.pb
  catch {write_debug_probes -quiet -force debug_nets}
  opt_design 
  write_checkpoint -force zed_wrapper_opt.dcp
  catch {report_drc -file zed_wrapper_drc_opted.rpt}
  close_msg_db -file opt_design.pb
} RESULT]
if {$rc} {
  step_failed opt_design
  return -code error $RESULT
} else {
  end_step opt_design
}

start_step place_design
set rc [catch {
  create_msg_db place_design.pb
  place_design 
  write_checkpoint -force zed_wrapper_placed.dcp
  catch { report_io -file zed_wrapper_io_placed.rpt }
  catch { report_clock_utilization -file zed_wrapper_clock_utilization_placed.rpt }
  catch { report_utilization -file zed_wrapper_utilization_placed.rpt -pb zed_wrapper_utilization_placed.pb }
  catch { report_control_sets -verbose -file zed_wrapper_control_sets_placed.rpt }
  close_msg_db -file place_design.pb
} RESULT]
if {$rc} {
  step_failed place_design
  return -code error $RESULT
} else {
  end_step place_design
}

start_step route_design
set rc [catch {
  create_msg_db route_design.pb
  route_design 
  write_checkpoint -force zed_wrapper_routed.dcp
  catch { report_drc -file zed_wrapper_drc_routed.rpt -pb zed_wrapper_drc_routed.pb }
  catch { report_timing_summary -warn_on_violation -max_paths 10 -file zed_wrapper_timing_summary_routed.rpt -rpx zed_wrapper_timing_summary_routed.rpx }
  catch { report_power -file zed_wrapper_power_routed.rpt -pb zed_wrapper_power_summary_routed.pb }
  catch { report_route_status -file zed_wrapper_route_status.rpt -pb zed_wrapper_route_status.pb }
  close_msg_db -file route_design.pb
} RESULT]
if {$rc} {
  step_failed route_design
  return -code error $RESULT
} else {
  end_step route_design
}

start_step write_bitstream
set rc [catch {
  create_msg_db write_bitstream.pb
  write_bitstream -force zed_wrapper.bit 
  if { [file exists /home/immesys/w/FPGA/project/hardware/Avnet-MicroZed-z7010-2014.2/Avnet-MicroZed-z7010-2014.2.runs/synth_1/zed_wrapper.hwdef] } {
    catch { write_sysdef -hwdef /home/immesys/w/FPGA/project/hardware/Avnet-MicroZed-z7010-2014.2/Avnet-MicroZed-z7010-2014.2.runs/synth_1/zed_wrapper.hwdef -bitfile zed_wrapper.bit -meminfo zed_wrapper.mmi -file zed_wrapper.sysdef }
  }
  close_msg_db -file write_bitstream.pb
} RESULT]
if {$rc} {
  step_failed write_bitstream
  return -code error $RESULT
} else {
  end_step write_bitstream
}

