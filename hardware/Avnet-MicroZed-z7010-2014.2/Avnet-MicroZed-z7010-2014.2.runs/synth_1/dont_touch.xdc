# This file is automatically generated.
# It contains project source information necessary for synthesis and implementation.

# Block Designs: bd/zed/zed.bd
set_property DONT_TOUCH TRUE [get_cells -hier -filter {REF_NAME==zed || ORIG_REF_NAME==zed}]

# IP: bd/zed/ip/zed_processing_system7_0_0/zed_processing_system7_0_0.xci
set_property DONT_TOUCH TRUE [get_cells -hier -filter {REF_NAME==zed_processing_system7_0_0 || ORIG_REF_NAME==zed_processing_system7_0_0}]

# IP: bd/zed/ip/zed_processing_system7_0_axi_periph_0/zed_processing_system7_0_axi_periph_0.xci
set_property DONT_TOUCH TRUE [get_cells -hier -filter {REF_NAME==zed_processing_system7_0_axi_periph_0 || ORIG_REF_NAME==zed_processing_system7_0_axi_periph_0}]

# IP: bd/zed/ip/zed_rst_processing_system7_0_100M_0/zed_rst_processing_system7_0_100M_0.xci
set_property DONT_TOUCH TRUE [get_cells -hier -filter {REF_NAME==zed_rst_processing_system7_0_100M_0 || ORIG_REF_NAME==zed_rst_processing_system7_0_100M_0}]

# IP: bd/zed/ip/zed_jtag_axi_0_0/zed_jtag_axi_0_0.xci
set_property DONT_TOUCH TRUE [get_cells -hier -filter {REF_NAME==zed_jtag_axi_0_0 || ORIG_REF_NAME==zed_jtag_axi_0_0}]

# IP: bd/zed/ip/zed_xbar_0/zed_xbar_0.xci
set_property DONT_TOUCH TRUE [get_cells -hier -filter {REF_NAME==zed_xbar_0 || ORIG_REF_NAME==zed_xbar_0}]

# IP: bd/zed/ip/zed_ila_0_0/zed_ila_0_0.xci
set_property DONT_TOUCH TRUE [get_cells -hier -filter {REF_NAME==zed_ila_0_0 || ORIG_REF_NAME==zed_ila_0_0}]

# IP: bd/zed/ip/zed_EdXel_0_1/zed_EdXel_0_1.xci
set_property DONT_TOUCH TRUE [get_cells -hier -filter {REF_NAME==zed_EdXel_0_1 || ORIG_REF_NAME==zed_EdXel_0_1}]

# IP: bd/zed/ip/zed_ila_1_0/zed_ila_1_0.xci
set_property DONT_TOUCH TRUE [get_cells -hier -filter {REF_NAME==zed_ila_1_0 || ORIG_REF_NAME==zed_ila_1_0}]

# IP: bd/zed/ip/zed_auto_pc_0/zed_auto_pc_0.xci
set_property DONT_TOUCH TRUE [get_cells -hier -filter {REF_NAME==zed_auto_pc_0 || ORIG_REF_NAME==zed_auto_pc_0}]

# IP: bd/zed/ip/zed_auto_pc_1/zed_auto_pc_1.xci
set_property DONT_TOUCH TRUE [get_cells -hier -filter {REF_NAME==zed_auto_pc_1 || ORIG_REF_NAME==zed_auto_pc_1}]

# XDC: bd/zed/ip/zed_processing_system7_0_0/zed_processing_system7_0_0.xdc
set_property DONT_TOUCH TRUE [get_cells [split [join [get_cells -hier -filter {REF_NAME==zed_processing_system7_0_0 || ORIG_REF_NAME==zed_processing_system7_0_0}] {/inst }]/inst ]]

# XDC: bd/zed/ip/zed_rst_processing_system7_0_100M_0/zed_rst_processing_system7_0_100M_0_board.xdc
#dup# set_property DONT_TOUCH TRUE [get_cells -hier -filter {REF_NAME==zed_rst_processing_system7_0_100M_0 || ORIG_REF_NAME==zed_rst_processing_system7_0_100M_0}]

# XDC: bd/zed/ip/zed_rst_processing_system7_0_100M_0/zed_rst_processing_system7_0_100M_0.xdc
#dup# set_property DONT_TOUCH TRUE [get_cells -hier -filter {REF_NAME==zed_rst_processing_system7_0_100M_0 || ORIG_REF_NAME==zed_rst_processing_system7_0_100M_0}]

# XDC: bd/zed/ip/zed_rst_processing_system7_0_100M_0/zed_rst_processing_system7_0_100M_0_ooc.xdc

# XDC: ipshared/xilinx.com/jtag_axi_v1_0/b7a1cace/constraints/jtag_axi.xdc
#dup# set_property DONT_TOUCH TRUE [get_cells -hier -filter {REF_NAME==zed_jtag_axi_0_0 || ORIG_REF_NAME==zed_jtag_axi_0_0}]

# XDC: bd/zed/ip/zed_jtag_axi_0_0/zed_jtag_axi_0_0_ooc.xdc

# XDC: bd/zed/ip/zed_xbar_0/zed_xbar_0_ooc.xdc

# XDC: ipshared/xilinx.com/ila_v5_0/ce9baedf/constraints/ila.xdc
#dup# set_property DONT_TOUCH TRUE [get_cells -hier -filter {REF_NAME==zed_ila_0_0 || ORIG_REF_NAME==zed_ila_0_0}]

# XDC: bd/zed/ip/zed_ila_0_0/zed_ila_0_0_ooc.xdc

# XDC: ipshared/xilinx.com/ila_v5_0/ce9baedf/constraints/ila.xdc
#dup# set_property DONT_TOUCH TRUE [get_cells -hier -filter {REF_NAME==zed_ila_1_0 || ORIG_REF_NAME==zed_ila_1_0}]

# XDC: bd/zed/ip/zed_ila_1_0/zed_ila_1_0_ooc.xdc

# XDC: bd/zed/ip/zed_auto_pc_0/zed_auto_pc_0_ooc.xdc

# XDC: bd/zed/ip/zed_auto_pc_1/zed_auto_pc_1_ooc.xdc

# XDC: bd/zed/zed_ooc.xdc
