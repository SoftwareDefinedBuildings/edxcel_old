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
ExecStep $xv_path/bin/xsim femulx_tb_behav -key {Behavioral:sim_1:Functional:femulx_tb} -tclbatch femulx_tb.tcl -log simulate.log
