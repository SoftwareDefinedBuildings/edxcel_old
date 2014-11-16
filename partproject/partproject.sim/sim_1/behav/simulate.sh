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
ExecStep $xv_path/bin/xsim fe_add_tb_behav -key {Behavioral:sim_1:Functional:fe_add_tb} -tclbatch fe_add_tb.tcl -log simulate.log
