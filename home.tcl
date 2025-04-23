####mapdict.tcl
dict set diff_dict [list [list Ac_conv03 {}] [list ChyDiffSrcConv {}]] Diff150-report22_conv

###main.tcl
 if {$msgId == "SetupClkNetUndefined" && $rule == "Clock_info03a" } {
	set match_type pass
	set false_reason ""
	set running_flag "pass-Diff226-line8-clk"
}
####diff_setup.tcl
proc Diff150-report22_conv {eToolMessageObj sToolMessageObj verbose {s_debug 0} {e_debug 0}} {
	set proc_name [lindex [info level 0] 0]
	global current_time 
	puts_debug_message start $proc_name
		
	set ret 0
	set e_objs [lsort [string map {"{" "" "}" ""} [process_objs [dict get ${eToolMessageObj} objList] 0 2]]]
	set s_objs [lsort [string map {"{" "" "}" ""} [process_objs [reformat_s_names_setup [dict get ${sToolMessageObj} objList]] 1 1]]]
	set e_key {*}[create_e_setup_key_list ${eToolMessageObj} {}]
	set s_key {*}[create_s_setup_key_list ${sToolMessageObj} {}]
	set e_conv_net [lindex ${e_key} 2]
	set s_conv_net [lindex ${s_key} 2]
	
	if {${s_conv_net} != {} && ${e_objs} == ${s_obj#}} {
		set e_inst [lsort [get_instances [get_fanin -to [get_nets ${e_conv_net}] -tcl_list -Pin_list] -filter @view=="VERIFIC_DFFRS"]]
		set s_inst [lsort [get_instances [get_fanin -to [get_nets ${s_conv_net}] -tcl_list -pin_list] -filter @view=="VERIFIC_DFFRS"]]
		if {${e_inst} == ${s_inst}} {
			set ret 1
		} else {
			set e_inst [lsort [get_instances [get_fanin -to [get_nets ${e_conv_net}] -tcl_list ] -filter @view=="VERIFIC_DFFRS"]]
			set s_inst [lsort [get_instances [get_fanin -to [get_nets ${s_conv_net}] -tcl_list ] -filter @view=="VERIFIC_DFFRS"]]
			if {${e_inst} == ${s_inst}} {
				set ret 1
			}
		}
	}
...
}
proc Diff122-bug30-conv {eToolMsgObj} {
 ....
 set e_nets [lsort $e_nets]
 set dest_nets [lsort $dest_nets]
 ...
}
#builtin_init.tcl
{{FalsePathSetup} 		{WireMultiAssign}}
{{checkSGDC_together02} {WireMultiAssign}}
#######utils
		###in order to deal with destination obj like "TOP.PIPE_S.U_RS .\FWD_TMO_PROC.r_pld_fd [33:0]"
		##the first return value of regular expression is "flop TOP.PIPE_S.U_RS .FWD_TMO_PROC.r_pld_fd" in the way "regsub -all "%" $patt "(.*)" patt" 
		##the first return value of regular expression is "flop/black-box/primary output" in the new way
		if {$rulename == "Ac_unsync02"} {
		if {[string match {Unsynchronized Crossing: destination primary output*} $msg_body]} {
			"regsub "%" $patt "(primary output)" patt
		} else {
			regsub "%" $patt "(\\S+)" patt
		}
}


