#!/bin/sh -f
xv_path="/opt/Xilinx/Vivado/2014.3.1"
ExecStep()
{
"$@"
RETVAL=$?
if [ $RETVAL -ne 0 ]
then
exit $RETVAL
fi
}
ExecStep $xv_path/bin/xelab -wto b7bc99eee01d443e8e9af3480e63465e -m64 --debug typical --relax --include "../../../../verilog/src/fe2" -L xbip_utils_v3_0 -L xbip_pipe_v3_0 -L xbip_bram18k_v3_0 -L mult_gen_v12_0 -L xil_defaultlib -L c_reg_fd_v12_0 -L xbip_dsp48_wrapper_v3_0 -L xbip_dsp48_addsub_v3_0 -L xbip_addsub_v3_0 -L c_addsub_v12_0 -L unisims_ver -L unimacro_ver -L secureip --snapshot femulx_tb_behav xil_defaultlib.femulx_tb xil_defaultlib.glbl -log elaborate.log