

 if {[dict get $eToolMessageObj msgId] == "ChyDataBusDiffEnable" && $rule == "Ac_conv04"} {
		if {[Diff133-synth28-conv $eToolMessageObj $sToolMessageObj]} {
			dict set eToolMessageObj runningFlag Diff133-synth28-conv
			dict set sToolMessageObj runningFlag Diff133-synth28-conv
			writeSetupMsgLine ${resultCsvFileName} ${eToolMessageObj} ${sToolMessageObj} ${testName} "pass" ${oldResultCsvFile}
			lappend l_s_match_list $s
			lappend l_e_match_list $e
			continue
		}
}

proc Diff133-synth28-conv {eToolMessageObj sToolMessageObj} {
	set proc_name [lindex [info level 0] 0]
	global current_time 
	puts_debug_message start $proc_name
	set s_reason [lindex [dict get $sToolMessageObj objList] end]
	if {$s_reason == "different synchronization scheme used"} {
		set s_key {*}[create_s_setup_key_list $sToolMessageObj {}]
		set e_key {*}[create_e_setup_key_list $eToolMessageObj {}]
		
		set e_obj [lrange $e_key 1 end]
		set s_obj [lrange $s_key 1 end]
		
		if {$e_obj == $s_obj} {
			set e_PinList1 [dict get $eToolMessageObj PinPort1]
			set e_PinList3 [dict get $eToolMessageObj PinPort2]
			
			if {$e_PinList1 ne "" && $e_PinList3 ne ""} {
				set e_PinList1 [fold_bus_bits $e_PinList1]
				set e_PinList3 [fold_bus_bits $e_PinList3]
					if {[get_messages -filter {@message_id == "AcSyncDataPath" && @PinList1 == "$e_PinList1" && @PinList3 == "$e_PinList3" && @ReasonInfOList5 == "ValidGate"}] != ""} {
						return 1
					} 
			}
		}
	}
	return 0
}

proc Diff119-multi_reasons13-and_gate {eToolMsgObj} {
	set ret 0
	set setup_source [lsort [get_nets [dict get ${eToolMsgObj} PinPort1] -canonical]]
	set setup_dest [lsort [get_nets [dict get ${eToolMsgObj} PinPort2] -canonical]]
 
	if {[get_pins $setup_source -filter {@name == "q"}] != "" && [get_pins $setup_dest -filter {@name == "q"}] !=""} {
		set setup_source_pins [fold_bus_bits [get_pins $setup_source -filter {@name == "q"}]]
		set setup_dest_pins [fold_bus_bits [get_pins $setup_dest -filter {@name == "q"}]]
		if {[get_messages -filter {@message_id == "AcSyncDataPath" && @pinList1 == "$setup_source_pins" && @PinList3 == $setup_dest_pins && @ReasonInfoList5 == "ValidGate CGICAutoInferred"}] != ""} {
			set ret 1
		}
	}
	return $ret
}


