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
ExecStep $xv_path/bin/xelab -wto b7bc99eee01d443e8e9af3480e63465e -m64 --debug typical --relax --include "../../../../verilog/src/fe2" -L xil_defaultlib -L unisims_ver -L unimacro_ver -L secureip --snapshot fe_tobytes_tb_behav xil_defaultlib.fe_tobytes_tb xil_defaultlib.glbl -log elaborate.log
