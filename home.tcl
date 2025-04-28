+++++++utils.c#++++
###write the runningFlag that does not compare the line number and file
proc get_no_compare_proc {} {
	return {pass-Diff123-diff19-clock_inf0-03 pass-Diff112-irregular7-clock_coverge-Ac_conv03 
		pass-Diff112-irregular7-clock_coverge-Clock_cOnverge01 pass-Diff150-report22_conv
	}
}

+++++main.tcl++
 if {[dict exists ${sToolMsgObj} diff71] || [dict exists ${eToolMsgObj} diff71]} {
	# Diff71-report6-black_box
	set runningFlag [join [concat $runningFlag "pass-Diff71-report6-black_box"] ";"]
}

###对应第4张图，整理了一下不比行号的proc的逻辑
} elseif {${eToolMsgObj} ne "" && ${sToolMsgObj} ne ""} {
		set false_reason {}
		set ignoreMsg [get_no_compare_msgId]
		set ignoreProc [get_no_compare_proc]
		if {[lsearch -exact $ignoreMsg $rule] == -1} {
			set line_cmp [cmp_2_values "line number" $eFileNum $sFileNum verbose]
			if {[lsearch -exact $ignoreProc $running_flag] == -1} {
				set line_cmp "true"
				set verbose ""
			}
			if {${line_cmp} == "false"} {
				if {${msgId} = "SetupRstNetUndefined" && ${rule} == "Reset_info09a"} {
					set match_type "pass"
					set false_reason ""
					set running_flag "pass-diff160-line_n07"
				}
				if {$msgId == "SetupDataTiedToConst" && $rule == "Clock_info03b"} {
					set matc_type pass
					set false_reason ""
					set running_flag "pass-Diff75-line_no3"
				}
				if {$msgId == "SetupClkNetUndefined" && $rule == "Clock_info03a" } {
					set matc_type pass
					set false_reason ""
					set running_flag "pass-Diff226-line8-clk"
				}
			} else {
				if {$verbose ne ""} {
					lappend false_reason $verbose
				}
			}
			set severity_cmp [cmp_2_values "Severity" [string range $eSeverity 0 3] [string range $sSeverity 0 3] verbose]
			
if {([string match "*_info01" $rule]|| [string match "Setup*Inferred" $msgId]) && $matc_type ne "match" && [info exists an_flag] && $an_flag eq 0} {
		set msgLine "${msgId},${rule},${eFileName},${sFileName},${eFileNum},${sFileNum},\"${objList}\""
		set msgLine "${msgLine},$match_type,,7,pass_clock_reset_inf0,,,${testName},,$sSeverity,,\"$sMessage\""
}


++++++diff_setup.tcl++++++
proc loop_mux_cnt {mux_1_inst ff_q_pin sg_input_value} {
		upvar $sg_input_value l_sg_input_value
		set mux_1_a0_pin [get_pins $mux_1_inst -filter {@name == "a0"}]
		set i 1
		set rec_mux_num 0
		##check whether the loop is mux+ff,and cont the num of loop_mux
		for {set i 1} {$i <= 2} {incr i} {
			if {$i == 1} {
				if {[get_nets $mux_1_a0_pin] eq [get_nets $ff_q_pin]} {
				##if 1 mux+ff loop
					set rec_mux_num 1
					set mux_1_a1_pin [get_pins $mux_1_inst -filter {@name == "a1"}]
					set l_sg_input_value [get_attributes [get_nets $mux_1_a1_pin] -attributes inferred_constant]
					break
				}
				set mux_2_out_pin [get_pins [get_nets $mux_1_a0_pin] -filter {@dir == "out"}]
				set mux_2_a0_pin [get_pins [get_instances $mux_2_out_pin -filter {@view == "VERIFIC_MUX"}] -filter {@name == "a0"}]
				set mux_2_a1_Pin [get_pins [get_instances $mux_2_out_pin -filter {@view == "VERIFIC_MUX"}] -filter {@name == "a1"}]
			} else {
				if {[get_nets $mux_2_a0_pin] eq [get_nets $ff_q_pin]} {
				####if 2 mus+ff loop
					set rec_mux_num 2
					set l_sg_input_value [get_attributes [get_nets $mux_2_a1_pin] -attributes inferred_constant]
					break
				}
			} 
		}
		return $rec_mux_num
}

###用这个新的proc data_const_logic_optimization替换原来库上proc
proc data_const_logic_optimization {sToolMessageObj runningFlag} {
		upvar $runningFlag l_runningFlag
		#return 0
		
		set s_obj [reformat_s_names_setup [lindex [dict get $sToolMessageObj objList] 0]]
		set s_clk [reformat_s_names_setup [lindex [dict get $sToolMessageObj objList] 1]]
		set s_const_value [linde [dict get $sToolMessageObj objList] end]
		
		set ff [get_instances [lindex $s_obj 0]]
		set e_const_value [lsort -uniq [get_attributes [get_pins $ff -filter {@name == "d"}] -attributes inferred_constant]]
		
		set ff_d_pin [lindex [get_pins $ff -filter {[is_ff_d_pin @@]}] 0]
		set ff_q_pin [lindex [get_pins $ff -filter {[is_ff_q_pin @@]}] 0]
		
		set mux_1_inst [get_instances [get_pins [get_nets $ff_d_pin]] -filter {@view == "VERIFIC_MUX"}]
		###get enable pin value
		set enable_pin_value [get_attributes [get_pins $mux_1_inst -filter {@name == "c"}] -attributes inferred_constant]
		
		if {$enable_pin_value == 0} {
		###check whether the loop is mux+ff,and cont the num of loo_mux
			set rec_mu_num [looP_mux_cnt $mux_1_inst $ff_q_pin sg_input_value]
			if {$rec_mux_num != 0} {
				set ff_set_const [lsort -uniq [get_attributes [get_pins $ff -filter {@name == "s"}] -attributes inferred_constant]]
				set ff_rst_const [lsort -uniq [get_attributes [get_pins $ff -filter {@name == "r"}] -attributes inferred_constant]]
				if {$ff_set_const == 0 && $ff_rst_const == 0 && $s_const_value == 0 && $e_const_value = ""} {
					set l_runningFlag pass-Diff213-diff45-logic_optimization
					return 1
				} elseif {[expr {$ff_set_const == 0}] + [expr {$ff_rst_const == 0}] == 1 && $s_const_value == !$e_const_value && $s_const_value == $sg_input_value} {
				####one of set and rst is 0,while the other is not 0
				###inferred_constant value of sg is related to sg_input_value
				set l_runningFlag pass-Diff212-diff44-logic_optimization
				return 1
				}
			}
		}
		return 0
}


proc Diff190-syn39-udp-black_box {eToolMessageObj} {
	set instance [dict get $eToolMessageObj Instance3]
	if {[get_attributes [get_instances $instance] -attributes is_udp]} {
		return 1
	}
	return 0
}


+++++compare_and_write_csv+++
if {[dict exists $rec $key_des_clk_names]} {
	set clk [list [dict get $rec $key_des_clk_names]]
	set result [catch {set clk {*}[reformat_s_names $clk]}]
	if {${result}} {
		set clk [reformat_s_names $clk]
	}
	if {[get_instances [get_nets $dest]] ne "" && [get_instances [get_nets $dest] -filter {@is_black_box ==1}] ne ""} {
		set dest_instance [lindex [get_instances [get_nets $dest] -filter {@is_black_box ==1}] 0]
		set clk [regsub ${dest_instance}_ $clk ""]
	}
	...
	
	
if {[string match "SetupBBox*" $msgId]} {
		if {$msgId == "SetupBBoxPinFullyConstrained"} {
			set PinList1 [get_ports [dict get $eToolMsgObj PinList1]]
			dict set SetupBBoxPinFullyConstrained_d0t $PinList1 $eToolMsgObj
			if {[Diff190-syn39-udp-black_box $eToolMsgObj]} {
				dict set eToolMsgObj runningFlag pass-Diff190-syn39-udp
				writeSetupMsgLine ${resultCsvFileName} ${eToolMsgObj} "" ${testName} "pass" ${oldResultCsvFile}
			}
			continue
		}
		if {[Diff190-syn39-udp-black_b0x $eToolMsgObj]} {
			dict set eToolMsgObj runningFlag pass-Diff190-syn39-udp
			writeSetupMsgLine ${resultCsvFileName} ${eToolMsgObj} "" ${testName} "pass" ${oldResultCsvFile}
			continue
		}
}


