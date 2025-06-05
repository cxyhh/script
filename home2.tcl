++++++main.tcl++++
++(proc writeAcMsgLine add in line 786 796 835)
if {[info exists an_flag] && [string match "*pass-*" $an_flag]} {
		set fanbiao_proc_flag 1
}
+++(add in line 854)
if {$fanbiao_proc_flag || $write_ac_flag} {
		record_msgLine $resultCsvFileName $msgLine
}
return $fanbiao_proc_flag


+++++diff.tcl++
+++(proc find_diff line 699)
if {[dict exists $sToolMessageObj markFlag]} {
		if {[dict get $sToolMessageObj markFlag]} {
			continue
		}
}
######check if mark in oldResultCsvFile, if false do diff
if {[file exists $oldResultCsvFile] && $mark_switch} {
	set write_ac_flag 0
	if {[dict exists $eToolMessageObj markFlag]} {
			if {[dict get $eToolMessageObj markFlag]} {
					continue
			} 
	} else {
		if {[writeAcMsgLine $resultCsvFileName $eToolMessageObj $sToolMessageObj "Unmatch" $oldResultCsvFile]} {
				set write_ac_flag 1
				dict set eToolMessageObj markFlag 1
				dict set sToolMessageObj markFlag 1
				set l_e_list [lreplace $l_e_list $e $e $eToolMessageObj]
				set l_s_list [lreplace $l_s_list $s $s $sToolMessageObj]
				lappend l_s_match_list $s
				lappend l_e_match_list $e
				break
		} else {
				set write_ac_flag 1
		}
	}
} else {
		set write_ac_flag 1
}
####check if mark in oldResultCsvFile, if false do diff


+++++++compare_and_write_csv++
++(proc detailed_match)
if {[dict exists $sToolMessageObj markFlag]} {
		if {[dict get $sToolMessageObj markFlag]} {
				continue
		}
}

foreach e $ev {
		set eToolMessageObj [lindex $l_e_list $e]
		if {[dict exists $eToolMessageObj markFlag]} {
				if {[dict get $eToolMessageObj markFlag]} {
						continue
				}
		}
		######check if mark in oldResultCsvFile, if false do diff
		if {[file exists $oldResultCsvFile] && $mark_switch} {
				set write_ac_flag 0
				if {[dict exists $eToolMessageObj markFlag]} {
						if {[dict get $eToolMessageObj markFlag]} {
								continue
						}
				} else {
						if {[writeAcMsgLine $resultCsvFileName $eToolMessageObj $sToolMessageObj "Unmatch" $oldResultCsvFile]} {
								set write_ac_flag 1
								dict set eToolMessageObj markFlag 1
								dict set sToolMessageObj markFlag 1
								set l_e_list [lreplace $l_e_list $e $e $eToolMessageObj]
								set l_s_list [lreplace $l_s_list $s $s $sToolMessageObj]
								lappend l_s_match_list $s
								lappend l_e_match_list $e
								continue
					} elseif {[writeAcMsgLine $resultCsvFileName $eToolMessageObj "" "" $oldResultCsvFile]} {
								set write_ac_flag 1
								dict set eToolMessageObj markFlag 1
								set l_e_list [lreplace $l_e_list $e $e $eToolMessageObj]
								lappend l_e_match_list $e
								continue
					} elseif {[writeAcMsgLine $resultCsvFileName "" $sToolMessageObj "" $oldResultCsvFile]} {
							set write_ac_flag 1
							dict set sToolMessageObj markFlag 1
							set l_s_list [lreplace $l_s_list $s $s $sToolMessageObj]
							lappend l_s_match_list $s
							break
					} else {
							set write_ac_flag 1
					}
			}
		} else {
				set write_ac_flag 1
		}
		######check if mark in oldResultCsvFile, if false do diff
		
++++(proc create_map_eliminate_match)
######check if mark in oldResultCsvFile, if false do diff
if {[file exists $oldResultCsvFile] && $mark_switch} {
		set s_length [llength $l_s_list]
		set e_length [llength $l_e_list]
		set write_ac_flag 0
		for {set s 0} {$s < $s_length} {incr s} {
				set write_ac_flag 0
				set sToolMessageObj [lindex $l_s_list $s]
				if {!([dict exists $sToolMessageObj markFlag] || [dict exists $sToolMessageObj matchFlag])} {
						if {[writeAcMsgLine $resultCsvFileName "" $sToolMessageObj "" $oldResultCsvFile]} {
								set l_s_list [lreplace $l_s_list $s $s]
						}
				}
				unset sToolMessageObj
		}
		for {set e 0} {$e < $e_length} {incr e} {
				set write_ac_flag 0
				set eToolMessageObj [lindex $l_e_list $e]
				if {!([dict exists $eToolMessageObj markFlag] || [dict exists $eToolMessageObj matchFlag])} {
						if {[writeAcMsgLine $resultCsvFileName $eToolMessageObj "" "" $oldResultCsvFile]} {
								###for Diff9.change l_e_list instead of delete
								dict set eToolMessageObj markFlag 1
								set l_e_list [lreplace $l_e_list $e $e $eToolMessageObj]
						}
				}
				unset eToolMessageObj
		}
		###for Diff9.change l_e_list instead of delete
		set e_list_base $l_e_list
		unset write_ac_flag
		unset s_length
		unset e_length
}
######check if mark in oldResultCsvFile, if false do diff


+++(proc compare_and_write_csv)
##To control whether to reverse the mark and then do find_diff
 mark_switch 1 means: reverse the mark and then do find_diff
if {![info exists mark_switch]} {
		set mark_switch 1
}

