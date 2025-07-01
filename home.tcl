需要删除/注释的proc
注释mapdict中的diff59 diff157 diff91
注释main.tcl中的getAcMsgLineNumDict
mian.tcl write_ac_flag fanbiao_proc_flag
diff.tcl中的find_diff_s_split_bus
find_Diff9，find_Diff17
Diff237
find_match_split_bus


覆盖的proc 
is_analysis
setupUnmatchMsgLine
Ac-affected-by-data_const
merge_one_sd_bus
detailed_match

增加的proc
parse_oldCsv
acReasonMap
Diff178-report1*missing

relace
+++utils
# if the msg_line marked as analyzed sign in the oldResultCsvFile or not
proc is_analyzed {oldResultCsvFile msg_line} {
	set proc_name [lindex [info level 0] 0]
	puts_debug_message start $proc_name
	global arr_result header_list mark_switch
	set mark_switch 0
	#set msg_line [escape_special_chars $msg_line]
	#catch {exec grep "$msg_line" $oldResultCsvFile} result
	if {[info exists arr_result($msg_line)]} {
		set result $arr_result($msg_line)
	} else {
		set result ""
	}
	#set header_list [split [exec head -n 1 $oldResultCsvFile] ","]
	if {![info exists header_list]} {
		set header_list [split [exec head -n 1 $oldResultCsvFile] ","]
	}
	set diff_basis_col [lsearch $header_list "diff_basis"]
	set diff_basis [string trim [lindex [split $result ","] $diff_basis_col] "\""]
	set running_flag_col [lsearch $header_list "running_flag"]
	set running_flag [string trim [lindex [split $result ","] $running_flag_col] "\""]
	
	###in order to replace proc with mark label
	set markFlag [join [list $running_flag $diff_basis] ";"]
	if {$result eq "" || [regexp "child process exited abnormally" $result]} {
		return new
	}
	
	if {[regexp ".*?,(False|Missing) report,(yes)?,1,.*" $result]} {
		return "1,$diff_basis"
	} elseif {[regexp ".*?,Unmatch,(yes)?,1,.*" $result]} {
		return "1,$diff_basis"
	} elseif {[regexp ".*?,(False|Missing) report,(yes)?,2,*" $result]} {
		return "2,$diff_basis"
	} elseif {[regexp ".*?,(False|Missing) report,(yes)?,3,.*" $result]} {
		return "3,"
	} elseif {[regexp ".*?,(False|Missing) report,(yes)?,4,.*" $result]} {
		return "4,"
	} elseif {[regexp ".*?,(False|Missing) report,(yes)?,5,.*" $result]} {
		return "5,$diff_basis"
	} elseif {[regexp ".*?,(False|Missing) report,(yes)?,6,.*" $result]} {
		return "6,"
	} elseif {$mark_switch && [regexp "*?,Unmatch,,7,.*,pass*" $result]} {
		###in order to deal scenarios like Unmatch,7,Diff1,pass-Diff2
		return "7,$markFlag"
	} elseif {[regexp ".*?,(False|Missing) report,(yes)?,7,.*" $result]} {
		return "7,$diff_basis"
	} elseif {[regexp ".*?,Unmatch,(yes)?,7,.*" $result]} {
		return "7,$diff_basis"
	} elseif {[regexp ".*?,(False|Missing) report,(yes)?,8,.*" $result]} {
		return "8,"
	} elseif {[regexp ".*?,(False|Missing) report,(yes)?,9,.*" $result]} {
		return "9,$diff_basis"
	} elseif {$mark_switch && [regexp ".*?,pass,,,,.*" $result]} {
		###in order to replace proc with mark label
		return "7,$markFlag"
	}
	return 0
}
++++++main.tcl
# set message line of unmatched messages
proc setUnmatchMsgLine {msgLine falseType tail {oldResultCsvFile ""}} {
	set proc_name [lindex [info level 0] 0]
	global current_time an_flag
	puts_debug_message start $proc_name
	set time1 $current_time
	if {$oldResultCsvFile != "" && [file exist $oldResultCsvFile]} {
		#set an_flag [is_analyzed $oldResultCsvFile $msgLine]
		set result [catch {set an_flag [is_analyzed $oldResultCsvFile $msgLine]}]
		if {$result} {
			set an_flag ""
		}
		if {$an_flag eq "new"} {
			set msgLine "$msgLine,$falseType,yes,,"
		} elseif {$an_flag ne 0} {
			set msgLine "$msgLine,$falseType,,$an_flag"
		} else {
			set msgLine "$msgLine,$falseType,,,"
		}
	} else {
		set msgLine "$msgLine,$falseType,,,"
	}
	if {$falseType eq "Missing report"} {
		set msgLine "$msgLine,$tail"
	} elseif {$falseType eq "False report"} {
		set msgLine "$msgLine,$tail"
	} elseif {$falseType eq "Unmatch"} {
		set msgLine "$msgLine,$tail"
	}
	puts_debug_message end $proc_name
	set time2 $current_time
	get_proc_time $proc_name $time1 $time2
	return $msgLine
}
if {$eToolMsgObj eq "" && $sToolMsgObj ne ""} {
	if {[dict exists ${sToolMsgObj} diff18]} {
		set runningFlag [join [concat $runningFlag "pass-Diff18-irregular2-vclk"] ";"]
		set match_type "pass"
	}
	
	####unmatch里面
if {[dict exists ${sToolMsgObj} diff237] || [dict exists ${eToolMsgObj} diff237]} {
	set runningFlag [join [concat $runningFlag "pass-Diff237-Diff48-UDP"] ";"]
	set match_type "pass"
}

#####
截图
#####

####setup里
if {([string match "*_info01" $rule]|| [string match "Setup*Inferred" $msgId]) && $match_type ne "match"} {
	if {![info exist an_flag]} {
		set msgLine "${msgId},${rule},${eFileName},${sFileName},${eFileNum},${sFileNum},\"${objList}\""
		set msgLine "${msgLine},$match_type,,7,pass_clock_reset_info,,,${testName},,$sSeverity,,\"$sMessage\""
	} elseif {$an_flag eq "new" || $an_flag eq "0"} {
		set msgLine "${msgId},${rule},${eFileName},${sFileName},${eFileNum},${sFileNum},\"${objList}\""
		set msgLine "${msgLine},$match_type,,7,pass_clock_reset_info,,,${testName},,$sSeverity,,\"$sMessage\""
	}
}


#####diff.tcl还未处理
#####diff_setup还未处理
++++++compare_and_write_csv
# merge the bus bits of source obj and destination obj in e_list_dict
proc merge_one_sd_bus_bits {rec} {
	set proc_name [lindex [info level 0] 0]
	global current_time
	puts_debug_message start $proc_name
	set time1 $current_time
	upvar $rec l_new_rec
	global key_src_obj key_des_obj key_src_clk key_des_clk
	set changed 0
	set i 1
	foreach {k v} $l_new_rec {
		if {$k eq $key_src_obj || $k eq $key_des_obj} {
			set nets [get_nets_of_pins_or_ports $v]
			set bus_name [fold_bus_bits $nets]
			#set bus_name [reverse_lsb_msb $bus_name $nets]
			if {$bus_name != {}} {
				if {$bus_name != $v} {
					dict set l_new_rec $k $bus_name
					set changed 1
				}
			} elseif {$nets != {}} {
				if {$nets != $v} {
					dict set l_new_rec $k $nets
					set changed 1
				}
			}
			if {[llength [get_instances $v]] == 1 } {
				####for diff237. this diff needs to retain the original report of ecdc tool
				if {[get_instances $v -filter {@is_udp}] ne "" && [get_instances $v -filter {@is_black_box}] ne ""} {
					set changed 0
				}
			}
		}
		incr i
	}
	puts_debug_message end $proc_name
	set time2 $current_time
	get_proc_time $proc_name $time1 $time2
	return $changed
}

# create source and destination key with the src and dst objs and clocks
proc create_sd_key {l_rec} {
	set proc_name [lindex [info level 0] 0]
	global current_time
	puts_debug_message start $proc_name
	set time1 $current_time
	global key_src_obj key_des_obj key_src_clk key_des_clk key_src_clk_names key_des_clk_names
	upvar $l_rec rec
	set dbg_cnt [dict get $rec DebugCount]
	set sd_key {}
	if {[dict exists $rec $key_src_obj]} {
		set src [get_nets [dict get $rec $key_src_obj]]
		if {$src eq ""} {
			set src [get_nets [get_pins [dict get $rec $key_src_obj]]]
		}
		if {$src ne ""} {
			set src [fold_bus_bits $src]
		} else {
			set src [dict get $rec $key_src_obj]
		}
		lappend sd_key $src
	}
	if {[dict exists $rec $key_des_obj]} {
		set dest [dict get $rec $key_des_obj]
		set dest_pin [get_pins $dest]
		if {[get_attributes [get_instances [get_nets $dest]] -attributes {is_black_box is_udp}] == "1 0"} {
			set tmp [join [get_nets $dest] " "]
			set dest [join [fold_bus_bits [get_nets $dest -canonical]] " "]
			if {$dest != $tmp} {
				dict set rec diff71 1
			}
		} elseif {[get_attributes [get_instances $dest_pin] -attributes {is_black_box is_udp}] == "1 1"} {
			set dest [get_instances [get_pins $dest]]
			dict set rec diff237 1
		}
		lappend sd_key $dest
	}
proc create_s_sd_key {rec} {
	set proc_name [lindex [info level 0] 0]
	global current_time
	# Diff71-report6-black_box
	upvar l_se_list se_list
	upvar up_var_j l_j
	puts_debug_message start $proc_name
	set time1 $current_time
	global key_src_obj key_des_obj key_src_clk_names key_des_clk_names
	set dbg_cnt [dict get $rec DebugCount]
	set sd_key {}
	if {[dict exists $rec $key_src_obj]} {
		set src [self_get_nets [lindex [reformat_s_names [list [dict get $rec $key_src_obj]]] 0]]
		set src_drivers [get_attributes $src -attributes dbg_drivers]
		if {[get_attributes [get_instances $src_drivers] -attributes {is_black_box is_udp}] == "1 1"} {
			set tmp [lindex $se_list $l_j]
			dict lappend tmp diff237 1
			lset se_list $l_j $tmp
		}
		if {$src eq ""} {
			set src [lindex [reformat_s_names [list [dict get $rec $key_src_obj]]] 0]
		} else {
			set src [fold_bus_bits $src]
			if {$src eq ""} {
				set src [reformat_s_names [list [dict get $rec $key_src_obj]]]
			}
		}
		#if {![regexp {\]|\[} $src]} {
		#	set src [self_get_nets [reformat_s_names [list [dict get $rec $key_src_obj]]]]
		#}
		lappend sd_key $src
	}
	.......
		#set dest [self_get_nets [lindex [reformat_s_names [list [dict get $rec $key_des_obj]]] 0]]
		set dest [self_get_nets [lindex [reformat_s_names [list [dict get $rec $key_des_obj]]] 0]]
		set dest_black [get_instances [get_attributes $dest -attributes dbg_drivers]]
		if {[get_attributes $dest_black -attributes {is_black_box is_udp}] == "1 1"} {
			set dest $dest_black
			set tmp [lindex $se_list $l_j]
			dict lappend tmp diff237 1
			lset se_list $l_j $tmp
		}
		if {$dest eq ""} {
			set dest [lindex [reformat_s_names [list [dict get $rec $key_des_obj]]] 0]
		} else {
				......
				
		if {[get_instances [get_nets $src]] ne "" && [get_instances [get_nets $src] -filter {@is_black_box ==1}] ne ""} {
			set instance [lindex [get_instances [get_nets $src]] 0]
			set clk [regsub ${instance}_ $clk ""]
		}
		####for diff18 vclk
		if {[string match {SG_VCLK_*} $clk] && [get_clocks $clk] eq ""} {
			set clk [get_attributes [get_nets $src] -attributes data_clock]
			set tmp [lindex $se_list $l_j]
			dict lappend tmp diff18 1
			lset se_list $l_j $tmp
		}
		set tmp_clk ""
		
proc detailed_match {sv ev s_list e_list s_match_list e_match_list e_indexes_list verbose} {
	set proc_name [lindex [info level 0] 0]
	global current_time e_origin_list s_origin_list e_line_dict
	puts_debug_message start $proc_name
	set time1 $current_time
	upvar $s_list l_s_list
	upvar $e_list l_e_list
	upvar $s_match_list l_s_match_list
	upvar $e_match_list l_e_match_list
	upvar $e_indexes_list l_e_indexes_list
	upvar $verbose l_verbose
	
	set l_verbose {}
	global key_debug_count resultCsvFileName oldResultCsvFile
	global key_src_obj key_des_obj ruleMapAc
	set diff63_flag 0
	set e_origin_list $l_e_list
	set s_origin_list $l_s_list
	# set sv [lsort -command sort_s_by_line $sv]
	# set ev [lsort -command sort_e_by_line $ev]
	set sv_len [llength $sv]
	set sv_origin_len $sv_len
	get_e_line_dict $ev
	set i 0
	while { ${i} < ${sv_len} } {
	set s [lindex $sv $i]
	incr i
	if {[expr ${i} - 1] < ${sv_origin_len}} {
		if {![dict exists $e_line_dict [dict get [lindex $s_origin_list $s] Line]]} {
			lappend sv $s
			set sv_len [llength $sv]
			continue
		}
	}
	set sToolMessageObj [lindex $l_s_list $s]
	if {[dict exists $sToolMessageObj markFlag]} {
		if {[dict get $sToolMessageObj markFlag]} {
			continue
		}
	}
	if {[dict exists $sToolMessageObj matchFlag]} {
		continue
	}
	set s_debug [dict get $sToolMessageObj $key_debug_count]
	set matched 0
	if { [llength $ev] > 1} {
		set multiRelated 1
	} else {
		set multiRelated 0
	}
	foreach e $ev {
		set eToolMessageObj [lindex $l_e_list $e]
		if {[dict exists $eToolMessageObj markFlag]} {
			if {[dict get $eToolMessageObj markFlag]} {
				continue
			}
		}
		set diff_result 0
		if {[expr ${i} - 1] < ${sv_origin_len}} {
			if {[dict get [lindex $s_origin_list $s] Line] != [dict get [lindex $e_origin_list $e] Line]} {
				continue
			}
		}
		if {[dict exists $eToolMessageObj matchFlag]} {
			continue
		}
		set e_debug [dict get $eToolMessageObj $key_debug_count]
		set runningFlag ""
		set msgId [dict get $eToolMessageObj msgId]
		set rulename [dict get $sToolMessageObj rulename]
		#modify_severity sToolMessageObj
		set match_result [isMatchAcNew eToolMessageObj sToolMessageObj l_verbose $s_debug $e_debug]
		if {$match_result && $diff63_flag != "1"} {
			set matched 1
		} elseif {[isMatchAcWithoutReason eToolMessageObj sToolMessageObj runningFlag l_verbose]} {
			set running_flag $runningFlag
			set matched 1
		} else {
			# puts "---- Not matched $l_verbose"
			set matched 0
			if {![dict exists $eToolMessageObj matchFlag] || [dict get $eToolMessageObj matchFlag] ne 1} {
				dict set eToolMessageObj unmatchReason $l_verbose
				lset l_e_list $e $eToolMessageObj
			}
			if {![dict exists $sToolMessageObj matchFlag]} {
				dict set sToolMessageObj unmatchReason $l_verbose
				lset l_s_list $s $sToolMessageObj
			}
		}
		if {$matched} {
			if {[info exists running_flag]} {
				set eToolMessageObj [modify_value_of_dict_key $eToolMessageObj runningFlag $running_flag " "]
				set sToolMessageObj [modify_value_of_dict_key $sToolMessageObj runningFlag $running_flag " "]
			}
			set eToolMessageObj [dict remove $eToolMessageObj unmatchReason]
			set sToolMessageObj [dict remove $sToolMessageObj unmatchReason]
			set idx [lsearch $l_e_indexes_list $e]
			set l_e_indexes_list [lreplace $l_e_indexes_list $idx $idx]
			dict set eToolMessageObj matchFlag 1
			dict set sToolMessageObj matchFlag 1
			if { ${multiRelated} == 1 } {
				dict set eToolMessageObj multiRelated 1
			}
			lset l_e_list $e $eToolMessageObj
			lset l_s_list $s $sToolMessageObj
			set match_type ""
			if {[info exists running_flag]} {
				set match_type "pass"
			}
			writeAcMsgLine $resultCsvFileName $eToolMessageObj $sToolMessageObj $match_type $oldResultCsvFile
			lappend l_s_match_list $s
			lappend l_e_match_list $e
			break
			}
		}
	}
	puts_debug_message end $proc_name
	set time2 $current_time
	get_proc_time $proc_name $time1 $time2
}

# find the match messages
proc find_match {k sv s_list e_sd_map e_list s_match_list e_match_list} {
	set proc_name [lindex [info level 0] 0]
	global current_time
	puts_debug_message start $proc_name
	set time1 $current_time
	upvar $s_list l_s_list
	upvar $e_list l_e_list
	upvar $s_match_list l_s_match_list
	upvar $e_match_list l_e_match_list
	global key_debug_count resultCsvFileName oldResultCsvFile
	set e_indexes_list [get_indexes_list_of_a_list $l_e_list]
	set verbose {}
	set ev [dict get $e_sd_map $k]
	detailed_match $sv $ev l_s_list l_e_list l_s_match_list l_e_match_list e_indexes_list verbose
	foreach idx $e_indexes_list {
		set eToolMessageObj [lindex $l_e_list $idx]
		# dict set eToolMessageObj unmatchReason "(e_keys of ecdc (both 4 tuples and 2 tuples) are not in s_map)"
		lset l_e_list $idx $eToolMessageObj
	}
	puts_debug_message end $proc_name
	set time2 $current_time
	get_proc_time $proc_name $time1 $time2
	return [expr [expr [llength $l_s_match_list] + [llength $l_e_match_list]] > 0]
}

# eliminate the match ones of sg and ecdc messages from s_list and e_list with the src and dst objs and clocks keys
proc eliminate_match {s_sd_map s_list e_sd_map e_list match_pass_map} {
	set proc_name [lindex [info level 0] 0]
	global current_time resultCsvFileName oldResultCsvFile
	puts_debug_message start $proc_name
	set time1 $current_time
	upvar $s_list l_s_list
	upvar $e_list l_e_list
	upvar $match_pass_map l_match_pass_map
	#upvar $matched_msg_map_dict matched_msg_map_dict_eliminate_match
	set s_match_list {}
	set e_match_list {}
	# for remaining messages, check if multiple clocks converge and ignore them all
	set sm_list {}
	set em_list {}
	if {[llength $l_s_list] ne 0 && [llength $l_e_list] ne 0} {
		#puts "find_match Start [exec date "+%Y-%m-%d %H:%M:%S"]"
		foreach {k v} $s_sd_map {
			set sm_list {}
			set em_list {}
			if {[dict exists $e_sd_map $k]} {
				if {[find_match $k $v l_s_list $e_sd_map l_e_list sm_list em_list]} {
					foreach i $sm_list {
						lappend s_match_list $i
					}
					foreach i $em_list {
						if {[string match "AcSync*" [dict get [lindex $l_e_list $i] msgId]]} {
							dict set l_match_pass_map $k diff9_1
						} else {
							dict set l_match_pass_map $k diff9_2
						}
						lappend e_match_list $i 
					}
				}
			}
		}
		foreach s [lsort -decreasing -integer -unique $s_match_list] {
		set l_s_list [lreplace $l_s_list $s $s]
		}
		foreach e [lsort -decreasing -integer -unique $e_match_list] {
		set l_e_list [lreplace $l_e_list $e $e]
		}
	}
	puts_debug_message end $proc_name
	set time2 $current_time
	get_proc_time $proc_name $time1 $time2
}

# create s_map and s_map, and eliminate match
proc create_map_eliminate_match {s_list e_list match_pass_map} {
	set proc_name [lindex [info level 0] 0]
	global current_time oldResultCsvFile resultCsvFileName 
	puts_debug_message start $proc_name
	set time1 $current_time
	upvar $s_list l_s_list
	upvar $e_list l_e_list
	upvar $match_pass_map l_match_pass_map
	#Diff71-report6-black_box
	#puts "create_map_eliminate_match Start: [exec date "+%Y-%m-%d %H:%M:%S"]"
	#set T0 [clock seconds]
	set s_map [create_s_sd_map l_s_list]
	set e_map [create_e_sd_map l_e_list]
	#set T1 [clock seconds]
	#puts "create_map time: [expr $T1 -$T0]"
	puts_debug_message messageR"=======e redults ac========="
	puts_debug_message message "e_list(size)=[llength $l_e_list]"
	puts_debug_message message "==============s results ac========="
	puts_debug_message message "s_list(size)=[llength $l_s_list]"
	puts_debug_message message "smap_ac:$s_map"
	puts_debug_message message "emap_ac:$e_map"
	set e_list_base $l_e_list
	set s_list_base $l_s_list
	set e_sd_map_base $s_map
	set s_sd_map_base $e_map
	#puts "eliminate_match Start: [exec date "+%Y-%m-%d %H:%M:%S"]"
	#set T2 [clock seconds]
	eliminate_match $s_map l_s_list $e_map l_e_list l_match_pass_map
	#set T3 [clock seconds]
	#puts "find match time: [expr $T3 - $T2]"
	puts_debug_message end $proc_name
	set time2 $current_time
	get_proc_time $proc_name $time1 $time2
}

# handle the remaining messages of s_list and e_list, list_type: sg|ecdc
proc handle_remaining_msg {a_list a_list_bk list_type} {
	set proc_name [lindex [info level 0] 0]
	global current_time aided_proc
	puts_debug_message start $proc_name
	set time1 $current_time
	global resultCsvFileName oldResultCsvFile
	if {[llength $a_list] eq 0} {
		return
	}
	set index_unmatch_key_map {}
	foreach a_msg $a_list {
		if {[dict exists $a_msg origin_index]} {
			set origin_index [dict get $a_msg origin_index]
			#set sd_key [create_sd_key $a_msg]
			#if {$list_type eq "sg"} {
			#	set sd_key [reformat_s_names $sd_key]
			#}
			#set sd_key ([join $sd_key {-}])
			#dict lappend index_unmatch_key_map $origin_index $sd_key
			lappend index_unmatch_key_map $origin_index
		} else {
			if {$list_type eq "sg"} {
				set sRule [dict get $a_msg rulename]
				if {!([dict exists $a_msg markFlag] || [dict exists $a_msg matchFlag])} {
					if {[Diff34-synth7_shift_register "" ${a_list} {} 0 0]} {
						dict set a_msg runningFlag "pass-Diff34-synth7_shift_register"
						writeAcMsgLine $resultCsvFileName "" $a_msg "pass" $oldResultCsvFile
						continue
					}
					if {[dict exists $a_msg SyncScheme] && [dict get $a_msg SyncScheme] == "Enable Based Synchronizer"} {
						if {[Diff108-synth21-data_const $a_msg]} {
							dict set a_msg runningFlag "pass-Diff108-synth21-data_const"
							writeAcMsgLine $resultCsvFileName "" $a_msg "pass" $oldResultCsvFile
							continue
						} 
					}
					if {$aided_proc && [Ac-affected-by-data_const $a_msg running_Flag]} {
						dict set a_msg runningFlag $running_Flag
						writeAcMsgLine $resultCsvFileName "" $a_msg "const" $oldResultCsvFile
						continue
					}
					writeAcMsgLine $resultCsvFileName "" $a_msg "" $oldResultCsvFile
			}
		} elseif {$list_type eq "ecdc"} {
			if {[string first "\n" ${a_msg}] != -1} {
				set a_msg [string map {"\n" " "} ${a_msg}]
			}
			if {!([dict exists $a_msg markFlag] || [dict exists $a_msg matchFlag])} {
				writeAcMsgLine $resultCsvFileName $a_msg "" "" $oldResultCsvFile
			}
		}
		continue
	}
}


	merge_sd_bus_bits e_list
	collect_obj_list e_list
	#sort_inner_values s_list
	#sort_inner_values e_list
	set s_map {}
	set e_map {}
	
	#set matched_msg_map_dict [dict create]
	set match_pass_map ""
	set match_pass_map [dict create]
	#exact match and key-rule match
	create_map_eliminate_match s_list e_list match_pass_map
	
	set s_diff_map {}
	set e_diff_map {}
	create_map_eliminate_pass s_list e_list match_pass_map
	set s_list_bk $s_list
	set e_list_bk $e_list
	#if {[llength $s_list] ne 0 || [llength $e_list] ne 0} {
	# create_map_eliminate_match_diff s_list e_list
	#}
	# find and eliminate sg invalid path messages
	# create_map_eliminate_sg_invalid_path s_list
	
if {[lsearch $rule_list "setup"] ne -1} {
	set oldResultCsvFile ""
	set resultCsvFileName [dict get $resultCsvFileDict setup]
	if {[dict exist $oldResultCsvFileDict setup]} {
		global arr_result
		set oldResultCsvFile [dict get $oldResultCsvFileDict setup]
		parse_oldCsv $oldResultCsvFile
	}
	puts "---------- Start to compare Setup and Converge ---------"
	compare_setup_messages $sg_rpt_file e_list s_list $csv_title
	if {[info exists header_list]} {
		unset header_list
	}
	array unset arr_result
	puts "----------- End to compare Setup and Converge ----------"
}
## BuiltIn
if {"builtin" in $rule_list} {
	puts "---------- Start to compare BuiltInR---------"
	set oldResultCsvFile ""
	set resultCsvFileName [dict get $resultCsvFileDict builtin]
	if {[dict exist $oldResultCsvFileDict builtin]} {
		global arr_result
		set oldResultCsvFile [dict get $oldResultCsvFileDict builtin]
		parse_oldCsv $oldResultCsvFile
	}
} else {
	compare_BuiltIn_messages $sg_rpt_file e_list s_list $csv_title
}
if {[info exists header_list]} {
 unset header_list
}
array unset arr_result
		puts "----------- End to compare BuiltIn -----------"
		}


if {[lsearch $rule_list "ac"] ne -1} {
	set oldResultCsvFile ""
	set resultCsvFileName [dict get $resultCsvFileDict ac]
	if {[dict exist $oldResultCsvFileDict ac]} {
		global arr_result
		set oldResultCsvFile [dict get $oldResultCsvFileDict ac]
		parse_oldCsv $oldResultCsvFile
	}
	puts "----------- Start to compare Ac ---------"
	compare_ac_messages $sg_rpt_file e_list s_list $csv_title
	if {[info exists header_list]} {
		unset header_list
	}
	array unset arr_result
	puts "----------- End to compare Ac ---------"



