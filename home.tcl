

if {${eToolMsgObj} eq "" && ${sToolMsgObj} ne ""} {
	if {$match_type == "pass"} {
		set msgLine "${msgLine},${match_type},,,,$running_flag,,${testName},,$sSeverity,,\"$sMessage\""
	} else {
		if {$rule == "Clock_info03b"} {
			set msgLine "[setUnmatchMsgLine ${msgLine} "Missing report" "$running_flag,${unmatchReason},${testName},,$sSeverity,,\"$sMessage\"" ${oldResultCsvFile}]"
			set match_type "Missing report"
			if {[info exists an_flag] && $an_flag ne 0} {
					set fanbiao_diff_flag 1
			} elseif {$write_flag == 1} {
				set msgLine "${msgId},${rule},${eFileName},${sFileName},${eFileNum},${sFileNum},\"${objList}\",Missing report,,2,const,,,${testName},,$sSeverity,,\"$sMessage\""
			}
		} else {
				set msgLine "[setUnmatchMsgLine ${msgLine} "Missing report" "$running_flag,${unmatchReason},${testName},,$sSeverity,,\"$sMessage\"" ${oldResultCsvFile}]"
				set match_type "Missing report"
		}
	}
} elseif {${eToolMsgObj} ne "" && ${sToolMsgObj} eq ""} {
	if {$match_type == "pass"} {
		set msgLine "${msgLine},${match_type},,,,$running_flag,,${testName},$eSeverity,,\"$eMessage\""
	} else {
		if {$msgId == "SetupDataTiedToConst"} {
			set msgLine "[setUnmatchMsgLine ${msgLine} "False report" "$running_flag,${unmatchReason},${testName},$eSeverity,,\"$eMessage\"" ${oldResultCsvFile}]"
			set match_type "False report"
			if {[info exists an_flag] && [string match "*enno_const*" $an_flag] && ![string match "*pass-new-diff_const*" $an_flag]} {
				set fanbiao_diff_flag 2
			} elseif {[info exists an_flag] && [string match "7,pass*" $an_flag]} {
				set fanbiao_diff_flag 1
			} elseif {$write_flag == 1} {
				set msgLine "${msgId},${rule},${eFileName},${sFileName},${eFileNum},${sFileNum},\"${objList}\",False report,,2,const,,,${testName},$eSeverity,,\"$eMessage\""
			}
		} else {
			set msgLine "[setUnmatchMsgLine ${msgLine} "False report" "$running_flag,${unmatchReason},${testName},$eSeverity,,\"$eMessage\"" ${oldResultCsvFile}]"
			set match_type "False report"
		}
	}
} elseif {${eToolMsgObj} ne "" && ${sToolMsgObj} ne ""} {


if {[string match "*_info01" $rule] && $match_type eq "Missing report"} {
	if {![info exist an_flag]} {
		set msgLine "${msgId},${rule},${eFileName},${sFileName},${eFileNum},${sFileNum},\"${objList}\""
		set msgLine "${msgLine},$match_type,,7,pass_clock_reset_info,,,${testName},,$sSeverity,,\"$sMessage\""
	} elseif {$an_flag eq "new" || $an_flag eq "0"} {
		set msgLine "${msgId},${rule},${eFileName},${sFileName},${eFileNum},${sFileNum},\"${objList}\""
		set msgLine "${msgLine},$match_type,,7,pass_clock_reset_info,,,${testName},,$sSeverity,,\"$sMessage\""
	}
} elseif {[string match "Setup*Inferred" $msgId] && $match_type eq "False report"} {
	if {![info eist an_flag]} {
		set msgLine "${msgId},${rule},${eFileName},${sFileName},${eFileNum},${sFileNum},\"${objList}\",$match_type,,7,pass_clock_reset_info,,,${testName},$eSeverity,,\"$eMessage\""
	} elseif {$an_flag eq "new" || $an_flag eq "0"} {
		set msgLine "${msgId},${rule},${eFileName},${sFileName},${eFileNum},${sFileNum},\"${objList}\",$match_type,,7,pass_clock_reset_info,,,${testName},$eSeverity,,\"$eMessage\""
	}
}
 if {$msgId == "SetupAsyncClkConvOnComb" && ($match_type == "pass" || $match_type == "match")} {
 
 
 
if {$msgId == "SetupDataTiedToConst"} {
	set write_flag 0
	set fanbiao_diff_flag [writeSetupMsgLine ${resultCsvFileName} ${eToolMsgObj} "" ${testName} "" ${oldResultCsvFile}]
	if {$fanbiao_diff_flag == 1} {
		set write_flag 1
		continue
	} elseif {$fanbiao_diff_flag == 2} {
		set write_flag 1
		if {[diff_const $eToolMsgObj]} {
			global an_flag
			set diff_flag [join [concat "pass-new-diff_const" [lindex [split $an_flag ","] 1]] ";"]
			regsub {;$} $diff_flag {} diff_flag
			dict set eToolMsgObj runningFlag $diff_flag
			writeSetupMsgLine ${resultCsvFileName} ${eToolMsgObj} "" ${testName} "pass" ${oldResultCsvFile}
			continue
		}
	} else {
		set write_flag 1
		#if {[Diff171-diff28-logic_optimization-data_const $eToolMsgObj]} {
		# dict set eToolMsgObj runningFlag pass-Diff171-diff28-lgic_optimization-data_const
		# writeSetupMsgLine ${resultCsvFileName} ${eToolMsgObj} "" ${testName} "pass" ${oldResultCsvFile}
		# continue
		#}
		#if {[Diff170-diff27-logic_optimization-data_const $eToolMsgObj]} {
		# dict set eTo0|#gObj runningFlag pass-D#ff170-diff27-log0_optimization-data_const
		# writeSetupMsgLine ${resultCsvFileName} ${eToolMsgObj} "" ${testName} "pass" ${oldResultCsvFile}
		# continue
		#}
		if {[Diff87-synth17-data_const $eToolMsgObj]} {
		# dict set eTolMsgObj runningFlag pass-Diff87-synth17-data_const
		# writeSetupMsgLine ${resultCsvFileName} ${eToolMsgObj} "" ${testName} "pass" ${oldResultCsvFile}
		# continue
		#}
	}
}


if {$Rule == "Clock_info03c"} {
	if {[Diff178-report1-clocktietoconst-missing $sToolMsgObj]} {
		dict set sToolMsgObj runningFlag pass-Diff178-report1-clocktietoconst
		writeSetupMsgLine ${resultCsvFileName} "" ${sToolMsgObj} ${testName} "pass" ${oldResultCsvFile}
		continue
	}
}

if {[file exists $oldResultCsvFile]} {
	if {$add_quo} {
		set a [catch {exec /tmpdata/ranwu_staff_3/xycai/script/add_quo .sh $oldResultCsvFile}]
		if {$a} {
			red "you don't have the permission to quote $oldResultCsvFile, which may affect the reverse mark"
		} else {
			green "quote $oldResultCsvFile Success!"
		}
	}
	parse_oldCsv $oldResultCsvFile
}



} else {
	# 防止环路死循��?
	if {[dict exists $tmp_dict $tmp_const]} {
		if {[get_pins $tmp_const -filter {[is_ff_d_pin @@]}] ne ""} {
			#lappend const_data::tmp_no_const_origin $obj
		} else {
			set pin_port_objs [concat $pin_port_objs $tmp_const]
		}
	+++++++++
	} else {
			set pin_port_objs [concat $pin_port_objs $tmp_const]
	}
 }
	dict set tmp_dict $tmp_const 1
 }
	set pin_port_objs [lreplace $pin_port_objs 0 0]
 }
 # set const_data::all_no_const_origin [concat $const_data::all_no_const_origin $const_data::tmp_no_const_origin]
 ## 去重,不同的路线源头可能一��?
 +++++++++
	set const_origin [get_pins $const_origin -filter {!([is_ff_clear_pin @@] && @inferred_constant != 1) && !([is_ff_set_pin @@] && @inferred_constant != 1)}]
++++++
	return [lsort -unique $const_origin]
}
 proc diff_const {eMessage} {
	if {[dict exists $eMessage Instance1]} {
		set Instance_name "Instance1"
	} else {
		set Instance_name "InstanceList1"
	}
	set const_var [get_pins [get_instances [dict get $eMessage $Instance_name]] -filter {[is_ff_d_Pin @@]}]
	set const_origin [get_const_origin $const_var]
	if {[llength $const_data::tmp_no_const_origin] > 0} {
		# puts "is not diff"
		return 0
	} else {
		# puts "is diff"
		return 1
	}
}

