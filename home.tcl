
proc Diff178-report1-clocktietoconst-missing {sToolMessageObj} {
set proc_name [lindex [info level 0] 0]
global current_time 
puts_debug_message start $proc_name
set ret 0
 set s_clk [reformat_s_names_setup [list [lindex [dict get $sToolMessageObj objList] 0]]]
 
 if {[get_attributes [get_nets $s_clk] -attributes is_const] eq "const"} {
	set ret 1
}
puts_debug_message end $proc_name
return $ret
}

if {$Rule == "Clock_info03c"} {
	if {[Diff178-report1-clocktietoconst-missing $sToolMsgObj]} {
		dict set sToolMsgObj runningFlag pass-Diff178-report1-clocktietoconst
		writeSetupMsgLine ${resultCsvFileName} "" ${sToolMsgObj} ${testName} "pass" ${oldResultCsvFile}
		continue
	}
}

