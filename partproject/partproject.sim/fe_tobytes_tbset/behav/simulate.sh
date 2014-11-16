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
ExecStep $xv_path/bin/xsim fe_tobytes_tb_behav -key {Behavioral:fe_tobytes_tbset:Functional:fe_tobytes_tb} -tclbatch fe_tobytes_tb.tcl -log simulate.log
