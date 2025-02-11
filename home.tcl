################## maq.tc###################
if {$eToolMsgObj eq "" && $sToolMsgObj ne ""} {
	if {[info exists match_type] && $match_type eq "pass"} {
		if {$runningFlag ne ""} {
			set msgLine "$msgLine,$match_type,,,,$runningFlag,,$slineNum,,$sSeverity,,$testName,,\"$sMessage\""
		} else {
			set msgLine "$msgLine,$match_type,,,,,,$slineNum,,$sSeverity,,$testName,,\"$sMessage\""
		}
	} elseif {[info exists match_type] && $match_type eq "pass-const"} {
		if {$runningFlag ne ""} {
			set msgLine [setUnmatchMsgLine $msgLine "Missing report" "$runningFlag,,$slineNum,,,\"$sUnmatchReason\",$testName,,\"$sMessage\"" $oldResultCsvFile]
		} else {
			set msgLine "$msgLine,$match_type,,,,,,$slineNum,,$sSeverity,,$testName,,\"$sMessage\""
		}
	} else {
		set msgLine [setUnmatchMsgLine $msgLine "Missing report" ",,$slineNum,,,\"$sUnmatchReason\",$testName,,\"$sMessage\"" $oldResultCsvFile]
}
############# diff_setup##################
proc Diff170-diff27-logic_optimization-data_const {eToolMsgObj} {
.......
	if {$ret} {
		## get const value of pins
		set ff_set_const [get_attributes [get_pins $instance -filter {@name =="s"}] -attribute inferred_constant]
		set ff_rst_const [get_attributes [get_pins $instance -filter {@name =="r"}] -attribute inferred_constant]
		set mux_2_c_value [get_attributes [get_pins [get_instances $mux_2_out] -filter {@name =="c"}] -attribute inferred_constant]
		set mux_1_c_value [get_attributes [get_pins [get_instances $mux_1_out] -filter {@name =="c"}] -attribute inferred_constant]
		set mux_2_a1_value [get_attributes [get_pins [get_instances $mux_2_out] -filter {@name =="a1"}] -attribute inferred_constant]
		set mux_1_a1_value [get_attributes [get_pins [get_instances $mux_1_out] -filter {@name =="a1"}] -attribute inferred_constant]
		#### check the value of mux_1/a1 mux_1/c mux_2/a1 mux_2/c
		if {($constant_value == "0" && $ff_set_const == "0" && $ff_rst_const != "0") || ($constant_value == "1" && $ff_rst_const == "0" && $ff_set_const != "0")} {
			if {$mux_2_c_value != "0" && $mux_1_c_value == ""} {
				if {$mux_2_a1_value == $mux_1_a1_value == $constant_value} {
					return 1
				}
			} elseif {$mux_1_c_value == "1"} {
				if {$constant_value != "" && $constant_value == $mux_1_a1_value} {
					return 1
				}
			} elseif {$mux_1_c_value == "0"} {
				if {$mux_2_c_value != 0 && $constant_value == $mux_2_a1_value} {
					return 1
				} elseif {$mux_2_c_value == "0"} {
					return 1
				}
			} elseif {$mux_2_c_value == "0" && $mux_1_c_value == ""} {
				if {$mux_1_a1_value == "0" && $constant_value == "0"} {
					return 1
				}
			} else {
				return 0
			}
		} else {
			return 0
		}
	}
	return 0
}
if {[dict get $eToolMessageObj msgId] == "SetupDataTiedToConst" && [dict get $sToolMessageObj Rule] == "Clock_info03b"} {
	if {[false-bit $eToolMessageObj $sToolMessageObj]} {
		dict set sToolMessageObj runningFlag pass-false-bit
		writeSetupMsgLine ${resultCsvFileName} "" ${sToolMessageObj} ${testName} "pass" ${oldResultCsvFile}
		lappend l_s_match_list $s
		continue
	}
}
proc false-bit {eToolMessageObj sToolMessageObj} {
	set e_obj [lindex [dict get $eToolMessageObj objList] 0]
	set e_const_value [lindex [dict get $eToolMessageObj objList] end]
	set s_obj [lindex [dict get $sToolMessageObj objList] 0]
	set s_const_value [lindex [dict get $sToolMessageObj objList] end]
	if {$e_const_value == $s_const_value} {
		set s_obj [reformat_s_names_setup $s_obj]
		if {[string first $s_obj $e_obj] != -1 && $s_obj != $e_obj} {
			return 1
		}
	}
	return 0
}
####### compare_and_write_csv########
if {[Ac-affected-by-data_const $a_msg]} {
	dict set a_msg runningFlag "is affected-by-data-const"
	writeAcMsgLine $resultCsvFileName "" $a_msg "pass-const" $oldResultCsvFile
	continue
}
################ diff.tcl####################
proc Ac-affected-by-data_const {sToolMessageObj} {
	#### if d_pin of src or dest in missing_report is constant value in enno, give a mark
	set src_obj [reformat_s_names [dict get $sToolMessageObj "SourceName"]]
	set dest_obj [reformat_s_names [dict get $sToolMessageObj "DestName"]]
	set src_instance [get_instances [get_pins [lindex [get_nets $src_obj] 0] -filter {@name=="q"}]] ### get instance of source,if s_obj is bus just check one bit
	if {[get_pins $src_instance -filter {@name == "d"}] ne ""} {
		if {[get_attributes [get_pins $src_instance -filter {@name == "d"}] -attribute inferred_constant] ne ""} {
			return 1
		}
	}
	set dest_instance [get_instances [get_pins [lindex [get_nets $dest_obj] 0] -filter {@name=="q"}]] # get instance of dest,if dest_obj is bus just check one bit
	if {[get_pins $dest_instance -filter {@name == "d"}] ne ""} {
		if {[get_attributes [get_pins $dest_instance -filter {@name == "d"}] -attribute inferred_constant] ne ""} {
			return 1
		}
	}
	return 0
}


