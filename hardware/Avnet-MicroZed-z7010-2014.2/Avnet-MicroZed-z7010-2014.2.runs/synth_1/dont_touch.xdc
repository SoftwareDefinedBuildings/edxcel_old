# This file is automatically generated.
# It contains project source information necessary for synthesis and implementation.

# Block Designs: bd/zed/zed.bd
set_property DONT_TOUCH TRUE [get_cells -hier -filter {REF_NAME==zed || ORIG_REF_NAME==zed}]

# IP: bd/zed/ip/zed_processing_system7_0_0/zed_processing_system7_0_0.xci
set_property DONT_TOUCH TRUE [get_cells -hier -filter {REF_NAME==zed_processing_system7_0_0 || ORIG_REF_NAME==zed_processing_system7_0_0}]

# XDC: bd/zed/ip/zed_processing_system7_0_0/zed_processing_system7_0_0.xdc
set_property DONT_TOUCH TRUE [get_cells [split [join [get_cells -hier -filter {REF_NAME==zed_processing_system7_0_0 || ORIG_REF_NAME==zed_processing_system7_0_0}] {/inst }]/inst ]]

# XDC: bd/zed/zed_ooc.xdc