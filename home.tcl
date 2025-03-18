

======main.tcl:=========
if {[info exists an_flag] && [string match "*pass-*" $an_flag]} {
 set fanbiao_diff_flag 1
}
if {$msgId == "SetupDataTiedToConst" && $rule == "Clock_info03b"} {
 set match_type pass
 set false_reason ""
 set running_flag "pass-Diff75-line_n03"
}
======diff_setup.tcl=========
proc false-bit {sToolMessageObj} {
	set s_obj [reformat_s_names_setup [lindex [dict get $sToolMessageObj objList] 0]]
	set s_clk [reformat_s_names_setup [lindex [dict get $sToolMessageObj objList] 1]]
	set s_const_value [lindex [dict get $sToolMessageObj objList] end]
	
	if {[get_attributes [get_messages -filter {@message_id == "SetupDataTiedToConst" && @String3 == $s_const_value && @Net2 == $s_clk}] -attribute InstanceList1] ne ""} {
		set InstanceList [get_attributes [get_messages -filter {@message_id == "SetupDataTiedToConst" && @String3 == $s_const_value && @Net2 == $s_clk}] -attribute InstanceList1]
		set e_nets [get_nets [join $InstanceList " "]]
		set result [catch {set s_nets {*}[get_nets $s_obj]}]
		if {$result} {
			set s_nets [get_nets $s_obj]
		}
 
		if {$e_nets ne "" && $s_nets ne "" && [string first $s_nets $e_nets] != -1} {
			return 1
		}
	}
	return 0
}

======compare_and_write_csv.tcl======
regexp {.*source black-box (.*?), clocked by .* [dict get $rec Message] s_result s_result1
if {[info exists s_result1]} {
	set instance [lindex [get_instances [get_nets [reformat_s_names $s_result1]]] 0]
	set clk [regsub ${instance}_ $clk ""]
}
if {[dict exists $rec $key_des_clk_names]} {
	set clk [list [dict get $rec $key_des_clk_names]]
	regexp {.*destination black-box (.*?)\(.*?\), clocked by.*} [dict get $rec Message] d_result d_result1
	if {[info exists d_result1]} {
		set clk [regsub ${d_result1}_ $clk ""]
	}
	set clk [self_get_clocks {*}[reformat_s_names $clk]]
	if {$clk eq ""} {
		set clk [self_get_clocks [self_get_nets {*}[reformat_s_names $clk]]]
	}
	if {$clk eq ""} {
		set clk [self_get_nets {*}[reformat_s_names $clk]]
	}
	set clk [lsort $clk]
	lappend sd_key $clk
}

if {$Rule == "Clock_info03b"} {
	if {[false-bit $sToolMsgObj]} {
		dict set sToolMsgObj runningFlag pass-false-bit
		writeSetupMsgLine ${resultCsvFileName} "" ${sToolMsgObj} ${testName} "pass" ${oldResultCsvFile}
		continue
	}
}

unset message_line_dict

=======Builtin_Flow.tcl====
Propagate_Clocks,SetupClkPropagated {
		# obj | line | file | level
		set type [string trim [lindex $s_Obj end]]
		if {$type == ""} {
			set s_Obj [lrange $s_Obj 0 end-1]
			set s_Obj "[lrange $s_Obj 1 2] [lindex $s_Obj 0]"
		}
		lset s_Obj 0 [reformat_s_names_setuP [string map {"," " "} [lindex $s_Obj 0]]]
		lset s_Obj 0 [join [lsort [lindex $s_Obj 0]] ]
		set e_obj_tmp [lsort [string trim [lindex $e_Obj 0]]]
		if {[get_clocks $e_obj_tmp] ne ""} {
			lset e_Obj 0 [join [get_clocks $e_obj_tmp] ]
		} elseif {[get_clocks [get_nets $e_obj_tmp]] ne ""} {
			lset e_Obj 0 [join [get_clocks [get_nets $e_obj_tmp]] ]
		} else {
			lset e_Obj 0 [join $e_obj_tmp ]
		}
		## domain
		lset s_Obj 1 [regsub -all {^sg_virtual_} [lindex $s_Obj 1] {}]
		set e_dom [lindex $e_Obj 1]
		set s_dom [join [lsort [reformat_s_names_setup [lindex $s_Obj 1]]] ]
		lset s_Obj 1 $s_dom
		if {$type = "" && $e_dom != $s_dom && ([string map "[get_top]/ {}" $e_dom] == $s_dom || [string map "[get_top]/ {}" $s_dom] == $e_dom)} {
		lset s_Obj 1 $e_dom
		}
		########
		
		
Propagate_Clocks,SetupClkNotPropagated {
		# obj | line | file | level
		set type [sting trim [lindex $s_Obj end]]
		if {$type == "not"} {
			set s_Obj [lrange $s_Obj 0 end-1]
			set s_Obj "[lrange $s_Obj 1 2] [lindex $s_Obj 0]"
		}
		lset s_Obj 0 [reformat_s_names_setuP [string map {"," " "} [lindex $s_Obj 0]]]
		lset s_Obj 0 [join [lsort [lindex $s_Obj 0]] ]
		set e_obj_tmp [lsort [string trim [lindex $e_Obj 0]]]
		if {[get_clocks $e_obj_tmp] ne ""} {
			lset e_Obj 0 [join [get_clocks $e_obj_tmp] ]
		} elseif {[get_clocks [get_nets $e_obj_tmp]] ne ""} {
			lset e_Obj 0 [join [get_clocks [get_nets $e_obj_tmp]] ]
		} else {
			lset e_Obj 0 [join $e_obj_tmp ]
		}
		## domain
		lset s_Obj 1 [regsub -all {^sg_virtual_} [lindex $s_Obj 1] {}]
		set e_dom [lindex $e_Obj 1]
		set s_dom [join [lsort [reformat_s_names_setup [lindex $s_Obj 1]]] ]
		lset s_Obj 1 $s_dom
		if {$e_dom != $s_dom && ([string map "[get_top]/ {}" $e_dom] == $s_dom || [string map "[get_top]/ {}" $s_dom] == $e_dom)} {
			lset s_Obj 1 $e_dom
		}
		########


