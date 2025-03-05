对应新泛化block修改
	见welink截图
考训case新的cfg
	见welink截图

增加泛化对比脚本速度，将dataTiedToConst的反标放到diff proc之前
---utils.tcl/Proc is_analysis------
set running_flag_col [lsearch $header_list "running_flag"]
set running_flag [string trim [lindex [split $result ","] $running_flag_col] "\""]

elseif {[regexp "SetupDataTiedToConst,.*?,pass,,,,.*" $result]} {
return "7,$running_flag"
}
---main.tcl/proc writeSetupMsgLine-*..--
global current_time e_pass_list IntegrityRstConvOnComb_pass_dict an_flag write_flag
set fanbiao_diff_flag 0
} elseif {${eToolMsgObj} ne "" && ${sToolMsgObj} eq ""} {
		if {$matc_type == "pass"} {
			set msgLine "${msgLine},${match_type},,,,$running_flag,,${testName},$eSeverity,,\"$eMessage\""
		} else {
			set msgLine "[setUnmatchMsgLine ${msgLine} "False report" "$running_flag,${unmatchReason},${testName},$eSeverity,,\"$eMessage\"" ${oldResultCsvFile}]"
			if {[string match "*pass-*" $an_flag]} {
				set fanbiao_diff_flag 1
			}
		}
		
		
if {$fanbiao_diff_flag || $write_flag} {
 record_msgLine ${resultCsvFileName} ${msgLine}
}
return $fanbiao_diff_flag


--compare_and_write_csv/proc compare_setup_messages---
global e_running_flag_map s_running_flag_map e_split_cnt_map s_split_cnt_map s_setup_map write_flag
set write_flag 1


if {$msgId == "SetupDataTiedToConst"} {
	set write_flag 0
	if {[writeSetupMsgLine ${resultCsvFileName} ${eToolMsgObj} "" ${testName} "" ${oldResultCsvFile}]} {
			set write_flag 1
			continue
	} else {
		set write_flag 1
		if {[Diff87-synth17-data_const $eToolMsgObj]} {
			dict set eTo0lMsgObj runningFlag pass-Diff87-synth17-data_const
			.......
		}
	}
}


