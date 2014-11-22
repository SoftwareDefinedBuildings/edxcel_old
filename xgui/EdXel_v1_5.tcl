# Definitional proc to organize widgets for parameters.
proc init_gui { IPINST } {
  set Component_Name  [  ipgui::add_param $IPINST -name "Component_Name" -display_name {Component Name}]
  set_property tooltip {Component Name} ${Component_Name}
  #Adding Page
  set Page_0  [  ipgui::add_page $IPINST -name "Page 0" -display_name {Page 0}]
  set_property tooltip {Page 0} ${Page_0}
  set NUM_EPU  [  ipgui::add_param $IPINST -name "NUM_EPU" -parent ${Page_0} -display_name {Num Epu}]
  set_property tooltip {Num Epu} ${NUM_EPU}
  set C_S00_AXI_ADDR_WIDTH  [  ipgui::add_param $IPINST -name "C_S00_AXI_ADDR_WIDTH" -parent ${Page_0} -display_name {C S00 Axi Addr Width}]
  set_property tooltip {C S00 Axi Addr Width} ${C_S00_AXI_ADDR_WIDTH}
  set C_S00_AXI_DATA_WIDTH  [  ipgui::add_param $IPINST -name "C_S00_AXI_DATA_WIDTH" -parent ${Page_0} -display_name {C S00 Axi Data Width}]
  set_property tooltip {C S00 Axi Data Width} ${C_S00_AXI_DATA_WIDTH}


}

proc update_PARAM_VALUE.NUM_EPU { PARAM_VALUE.NUM_EPU } {
	# Procedure called to update NUM_EPU when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.NUM_EPU { PARAM_VALUE.NUM_EPU } {
	# Procedure called to validate NUM_EPU
	return true
}

proc update_PARAM_VALUE.C_S00_AXI_ADDR_WIDTH { PARAM_VALUE.C_S00_AXI_ADDR_WIDTH } {
	# Procedure called to update C_S00_AXI_ADDR_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_S00_AXI_ADDR_WIDTH { PARAM_VALUE.C_S00_AXI_ADDR_WIDTH } {
	# Procedure called to validate C_S00_AXI_ADDR_WIDTH
	return true
}

proc update_PARAM_VALUE.C_S00_AXI_DATA_WIDTH { PARAM_VALUE.C_S00_AXI_DATA_WIDTH } {
	# Procedure called to update C_S00_AXI_DATA_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_S00_AXI_DATA_WIDTH { PARAM_VALUE.C_S00_AXI_DATA_WIDTH } {
	# Procedure called to validate C_S00_AXI_DATA_WIDTH
	return true
}


proc update_MODELPARAM_VALUE.C_S00_AXI_DATA_WIDTH { MODELPARAM_VALUE.C_S00_AXI_DATA_WIDTH PARAM_VALUE.C_S00_AXI_DATA_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_S00_AXI_DATA_WIDTH}] ${MODELPARAM_VALUE.C_S00_AXI_DATA_WIDTH}
}

proc update_MODELPARAM_VALUE.C_S00_AXI_ADDR_WIDTH { MODELPARAM_VALUE.C_S00_AXI_ADDR_WIDTH PARAM_VALUE.C_S00_AXI_ADDR_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_S00_AXI_ADDR_WIDTH}] ${MODELPARAM_VALUE.C_S00_AXI_ADDR_WIDTH}
}

proc update_MODELPARAM_VALUE.NUM_EPU { MODELPARAM_VALUE.NUM_EPU PARAM_VALUE.NUM_EPU } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.NUM_EPU}] ${MODELPARAM_VALUE.NUM_EPU}
}

