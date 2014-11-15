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
ExecStep $xv_path/bin/xsim DummyEPU_tb_behav -key {Behavioral:sim_1:Functional:DummyEPU_tb} -tclbatch DummyEPU_tb.tcl -log simulate.log
