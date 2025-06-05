++++utils.tcl++++
+++(line 533)
if {[string match {*ynchronized Crossing: destination primary output*} $msg_body]} {
++++(prc is_analyzed)
####in order to replace proc with mark label
set markFlag [join [concat $running_flag $diff_basis] ";"]
......
 } elseif {[regexp ".*?,(False|Missing) report,(yes)?,6,.*" $result]} {
		return "6,"
} elseif {[regexp ".*?,Unmatch,,7,.*,pass*" $result]} {
		###in order to deal scenarios like Unmatch,7,Diff1,pass-Diff2
		return "7,$markFlag"
} elseif {[regexp ".*?,(False|Missing) report,(yes)?,7,.*" $result]} {
		return "7,$diff_basis"
}...
} elseif {[regexp ".*?,pass,,,,.*" $result]} {
		###in order to replace proc with mark label
		return "7,$markFlag"
}
proc get_no_compare_proc {} {
	return {pass-Diff123-diff19-clock_info-03 pass-Diff112-irregular7-clock_coverge 
	pass-Diff150-report22-conv pass-Diff178-report1-clocktietoconst
}
}
+++++++++setuptcl+++++++~
 set clocklist2 [string trim [lsort [dict get $eToolMessageObj ClockList2]] "{}"]
 set clocklist3 [string trim [lsort [dict get $eToolMessageObj ClockList3]] "{}"]
...
 ######in order to deal the clock of bbox will add the black-box instance in sg
if {[regexp {black-box} $var2]} {
		set port2 [lsort [self_get_instances [self_get_pins $port2]]]
		set clocks2 [regsub ${port2}_ $clocks2 ""]
} else {
		set port2 [lsort [self_get_nets $port2]]
		if {$port2 == {}} {
			set port2 [self_get_ports $port2]
		}
}
set clocks2 [lsort [self_get_clocks $clocks2]]
foreach portkey $port {
		lappend key_list [list $msgkey $portkey [lsort [list [list $clocks2 $port2] [list $clocks1 $inst1]]]]
}
.....
Ac_conv01 - Ac_conv02 {
		# Key: Ac_conv01/Ac_conv02
		puts_debug_message branch "rule: $rule start"
		set csv_objs [lindex $objList 1]
		set pinlist1 [lindex $csv_objs 0]
		set tmp_pinlist ""
		#foreach tmp_pin $pinlist1 {
			#set tmp_pinlist [concat $tmp_pinlist [add_top_name [expand_bits $tmp_pin]]]
			set tmp_pinlist [get_nets $pinlist1]
		#}
set net4 [lindex $objList 3]
set pin [get_nets $tmp_pinlist -canonical]
if {$pin == {}} {
	set pin [get_nets {*}$tmp_pinlist -canonical]
}
set pin [lsort $pin]
set net [self_get_nets $net4]
#set dst_clk [get_clocks [lindex $csv_objs 1]]
#set src_clk [get_clocks [lindex $csv_objs 2]]
set dst_clk [string trim [lindex $csv_objs 1] "{}"]
set src_clk [string trim [lindex $csv_objs 2] "{}"]
lappend key_list [list $msgkey $pin $net $dst_clk $src_clk]
puts_debug_message branch "rule: $rule end"
}
+++++++ms#$objmap+++++
IntegrityRstConvOnComb {Net1 NetList1 NetList1 NetList1 Net2 Net2 NetList2 Net2}
++++mapdict.tcl++++++
dict set se_cmd_map qualifier set_qualifier
dict set diff_dict [list [list Ac_sync01 {Conventional multi-flop for metastability technique}] [list AcNoSyncScheme {MissingSynchronizer}]] Diff237-Diff48-UDP
dict set diff_dict [list [list Ac_sync01 {Synchronization at And gate}] [list AcNoSyncScheme {MissingSynchronizer}]] Diff237-Diff48-UDP
++++++++main.tcl
++(line 811)
if {${runningFlag} ni "pass-Diff45-bug7-cgic pass-Diff7-bug2_src_same_as_qual_src pass-Diff25-synth5_mux_and pass-Diff237-Diff48-UDP"} {
+++(line 831)
if {$runningFlag != "pass-Diff237-Diff48-UDP" &&([dict exists ${sToolMsgObj} diff71] || [dict exists ${eToolMsgObj} diff71])} {
++++(line 1131)
if {${running_flag} == "pass-Diff150-report22-conv" || ${running_flag} == "pass-diff160-line_no7" || ${running_flag} == "pass-Diff226-line8-clk" || ${running_flag} == "pass-Diff178-report1-clocktietoconst"} {
++++++++++diff.tcl++++++
proc diff91-report13-clock_clocklist {eToolMessageObj sToolMessageObj verbose {s_debug 0} {e_debug 0}} {
		upvar $verbose l_verbose
		####add patch to aviod impact of Diff237
		set l_sToolMessageObj [list $sToolMessageObj]
		set l_eToolMessageObj [list $eToolMessageObj]
		set sg_key [create_s_sd_map l_sToolMessageObj] 
		set enno_key [create_e_sd_map l_eToolMessageObj]
		set enno_src [lindex [lindex $enno_key 0] 0]
		set enno_dst [lindex [lindex $enno_key 0] 1]
		set sg_src [lindex [lindex $sg_key 0] 0]
		set sg_dst [lindex [lindex $sg_key 0] 1]
		set enno_src_clk [dict get $eToolMessageObj SourceClock]
		set enno_dst_clk [dict get $eToolMessageObj DestClock]
		set sg_src_clk [dict get $sToolMessageObj SourceClockNames]
		set sg_dst_clk [dict get $sToolMessageObj DestClockNames]
		
		if {$enno_src == $sg_src && $enno_dst== $sg_dst} {
			if {[dict exists $sToolMessageObj is_2_tuple] && [dict exists $eToolMessageObj is_2_tuple]} {
				return [do_diff91-report13-clock_clocklist $enno_src_clk $enno_dst_clk $sg_src_clk $sg_dst_clk]
			} else {
				lappend l_verbose "(the keys of sg and enno messages are not 2-tuple, should not go diff proc [lindex [info level 0] 0])"
				return 0
			}
		} else {
			return 0
		}
}
		
proc do_diff59-report4-multi_bits_merge {sg_src_nets sg_dest_nets enno_src_net enno_dest_net verbose} {
		set proc_name [lindex [info level 0] 0]
		global current_time
		puts_debug_message start $proc_name 
		upvar $verbose l_verbose
		set ret 0
		set have_jiaoji 0
		set sg_src_bus [get_nets $sg_src_nets -bus]
		set sg_dest_bus [get_nets $sg_dest_nets -bus]
		set enno_src_bus [get_nets $enno_src_net -bus]
		set enno_dest_bus [get_nets $enno_dest_net -bus]
		if {$sg_src_bus == $enno_src_bus && $sg_dest_bus == $sg_dest_bus} {
			if {$sg_src_nets eq $enno_src_net} {
				if {$sg_dest_nets ne $enno_dest_net} {
					array set my_dict [concat {*}[lmap elem $enno_dest_net {list $elem 1}]]
					foreach sg_dest $sg_dest_nets {
						if {![info exists my_dict($sg_dest)]} {
							lappend result $sg_dest
						} else {
							set have_jiaoji 1
						}
					}
					if {$have_jiaoji && [info exists result]} {
						set ret 1
						set l_verbose [list "[fold_bus_bits $result] Diff59" "[fold_bus_bits $result] Diff59"]
					}
				}
			}
		}
		puts_debug_message end $proc_name 
		return $ret
}


proc Diff59-report4-multi_bits_merge {eToolMessageObj sToolMessageObj verbose runningFlag {s_debug 0} {e_debug 0}} {
		upvar $verbose l_verbose
		set l_verbose [list "" ""]
		upvar $runningFlag l_runningFlag
		set e_flag 0
		set s_flag 0
		if {[dict exists $eToolMessageObj unmatchReason]} {
				if {[regexp {Diff59} [dict get $eToolMessageObj unmatchReason]]} {
						set e_flag 1
				}
		} 
		if {[dict exists $sToolMessageObj unmatchReason]} {
				if {[regexp {Diff59} [dict get $sToolMessageObj unmatchReason]]} {
						set s_flag 1
				}
		}
		
		set sg_src_nets [self_get_nets [reformat_s_names [dict get $sToolMessageObj "SourceName"]]]
		if {$sg_src_nets == ""} {
				set sg_src_nets [self_get_nets [expand_bits [reformat_s_names [dict get $sToolMessageObj "SourceName"]]]]
		}
		set sg_dest_nets [self_get_nets [reformat_s_names [dict get $sToolMessageObj "DestName"]]]
		if {$sg_dest_nets == ""} {
				set sg_dest_nets [expand_bits [reformat_s_names [dict get $sToolMessageObj "DestName"]]]
		}
		set enno_src_nets [self_get_nets [dict get $eToolMessageObj "SourceName"]]
		if {$enno_src_nets == ""} {
				set enno_src_nets [expand_bits [dict get $eToolMessageObj "SourceName"]]
		}
		set enno_dest_nets [self_get_nets [dict get $eToolMessageObj "DestName"]]
		if {$enno_dest_nets == ""} {
				set enno_dest_nets [expand_bits [dict get $eToolMessageObj "DestName"]]
		}
		if {$e_flag && $s_flag} {
				set l_verbose [list [dict get $eToolMessageObj unmatchReason] [dict get $sToolMessageObj unmatchReason]]
				set ret 2
		} elseif {$e_flag == 0 && $s_flag == 1} {
				do_diff59-report4-multi_bits_merge $sg_src_nets $sg_dest_nets $enno_src_nets $enno_dest_nets l_verbose
				lset l_verbose 1 [dict get $sToolMessageObj unmatchReason]
				set ret 1
		} elseif {$e_flag == 1 && $s_flag == 0} {
				do_diff59-report4-multi_bits_merge $sg_src_nets $sg_dest_nets $enno_src_nets $enno_dest_nets l_verbose
				lset l_verbose 0 [dict get $eToolMessageObj unmatchReason]
				set ret 1
		} else {
				set ret [do_diff59-report4-multi_bits_merge $sg_src_nets $sg_dest_nets $enno_src_nets $enno_dest_nets l_verbose]
		}
		return $ret
}

proc diff157-report23-clocklist {eToolMessageObj sToolMessageObj runningFlag verbose} {
		upvar $verbose l_verbose
		upvar $runningFlag l_runningFlag
		set enno_src_clk [dict get $eToolMessageObj SourceClock]
		set enno_dst_clk [dict get $eToolMessageObj DestClock]
		set sg_src_clk [dict get $sToolMessageObj SourceClockNames]
		set sg_dst_clk [dict get $sToolMessageObj DestClockNames]
		########add patch to aviod impact of Diff237
		set l_sToolMessageObj [list $sToolMessageObj]
		set l_eToolMessageObj [list $eToolMessageObj]
		set sg_key [create_s_sd_map l_sToolMessageObj] 
		set enno_key [create_e_sd_map l_eToolMessageObj]
		set enno_src [lindex [lindex $enno_key 0] 0]
		set enno_dst [lindex [lindex $enno_key 0] 1]
		set sg_src [lindex [lindex $sg_key 0] 0]
		set sg_dst [lindex [lindex $sg_key 0] 1]
		if {$enno_src == $sg_src && $enno_dst == $sg_dst} {
				set match_result [isMatchAc eToolMessageObj sToolMessageObj l_verbose ]
				if {$match_result} {
						set l_runningFlag "pass-diff157-report23-clocklist"
				} else {
						set l_runningFlag "pass-diff157-report23-clocklist;pass-diff63-synth14-vague_match"
				}
				if {[dict exists $sToolMessageObj is_2_tuple] && [dict exists $eToolMessageObj is_2_tuple]} {
						return [do_diff157-report23-clocklist $enno_src_clk $enno_dst_clk $sg_src_clk $sg_dst_clk]
				} else {
						lappend l_verbose "(the keys of sg and enno messages are not 2-tuple, should not go diff proc [lindex [info level 0] 0])"
						return 0
				}
		} else {
				return 0
		}
}
proc Diff237-Diff48-UDP {eToolMessageObj sToolMessageObj verbose runningFlag {s_debug 0} {e_debug 0}} {
		upvar $sToolMessageObj l_sToolMessageObj
		set sg_src_nets [get_nets [reformat_s_names [dict get $sToolMessageObj "SourceName"]]]
		set sg_dest_nets [reformat_s_names [dict get $sToolMessageObj "DestName"]]
		set sg_dest_ins [get_instances [get_attributes [get_nets $sg_dest_nets] -attributes dbg_drivers]]
		set sg_src_clk [get_clocks [reformat_s_names [dict get $sToolMessageObj SourceClockNames]]]
		set sg_dest_clk [get_clocks [reformat_s_names [dict get $sToolMessageObj DestClockNames]]]
		
		set enno_src_nets [get_nets [dict get $eToolMessageObj "SourceName"]]
		set enno_dest_ins [get_instances [get_nets [dict get $eToolMessageObj "DestName"]]]
		set enno_src_clk [get_clocks [dict get $eToolMessageObj SourceClock]]
		set enno_dest_clk [get_clocks [dict get $eToolMessageObj DestClock]]
		
		if {$enno_src_clk == $sg_src_clk && $enno_dest_clk==$sg_dest_clk} {
				if {$enno_src_nets == $sg_src_nets && $sg_dest_ins ==$enno_dest_ins} {
					set src_type [get_instances $enno_src_nets -filter {@is_black_box==1 && @is_udp ==1}]
					set dest_type [get_instances [get_nets [dict get $eToolMessageObj "DestName"]] -filter {@is_black_box ==1 && @is_udp ==1}]
					if {$src_type ne "" || $dest_type ne ""} {
							dict set l_sToolMessageObj runningFlag "pass-Diff237-Diff48-UDP"
							return 1
					}
				}
		}
		return 0
}
+++diff_setup.tcl+++
} elseif {[dict get $eToolMessageObj msgId] in "ChySameSrcConvIncSeq ChySameSrcConvExcSeq ChyDiffSrcConv" && $rule in "Ac_conv01 Ac_conv02 Ac_conv03"} {
		if {[similar_conv $eToolMessageObj $sToolMessageObj reason]} {
				dict set eToolMessageObj unmatchReason $reason
				dict set sToolMessageObj unmatchReason $reason
				writeSetupMsgLine $resultCsvFileName {} $sToolMessageObj ${testName} {} $oldResultCsvFile
				writeSetupMsgLine $resultCsvFileName $eToolMessageObj {} ${testName} {} $oldResultCsvFile
				lappend l_s_match_list $s
				lappend l_e_match_list $e
				continue
}
proc Diff178-report1-clocktietoconst {eToolMessageObj sToolMessageObj verbose {s_debug 0} {e_debug 0}} {
		set proc_name [lindex [info level 0] 0]
		global current_time 
		puts_debug_message start $proc_name
		
		set ret 0
		set e_pin [lindex [dict get $eToolMessageObj objList] 0]
		set s_pin [reformat_s_names_setup [list [lindex [dict get $sToolMessageObj objList] 0]]]
		set e_net [get_nets $e_pin -canonical]
		set s_net [get_nets $s_pin -canonical]
		
		
		if {$e_net eq $s_net} {
				set e_flop [lindex [dict get $eToolMessageObj objList] 1]
				set s_flop [reformat_s_names_setup [list [lindex [dict get $sToolMessageObj objList] 1]]]
				
				set e_clk_pin [get_pins [get_instances $e_flop] -filter {@name == "clk"}]
				set s_clk_pin [get_pins [get_instances $s_flop] -filter {@name == "clk"}]
				
				set e_clk_net [get_nets $e_clk_pin -canonical]
				set s_clk_net [get_nets $s_clk_pin -canonical]
				if {$e_clk_net eq $s_clk_net} {
						set ret 1
				}
		}
		puts_debug_message end $proc_name
		return $ret
}
proc similar_conv {eToolMessageObj sToolMessageObj reason} {
		upvar $reason l_reason
		set e_objs [lsort [get_nets [lindex [dict get ${eToolMessageObj} objList] 0] -canonical]]
		set s_objs [lsort [get_nets [reformat_s_names_setup [lindex [lindex [dict get ${sToolMessageObj} objList] 1] 0]] -canonical]]
		
		set e_key {*}[create_e_setup_key_list ${eToolMessageObj} {}]
		set s_key {*}[create_s_setup_key_list ${sToolMessageObj} {}]
		set e_conv_net [lindex ${e_key} 2]
		set s_conv_net [lindex ${s_key} 2]
		
		if {$e_objs eq $s_objs} {
			if {$e_conv_net ne $s_conv_net} {
			set l_reason "unmatchReason is conv_net ($e_conv_net and $s_conv_net) not equal"
			return 1
			}
		}
		
		if {$e_conv_net eq $s_conv_net} {
			if {$s_objs ne $e_objs} {
				set more_quailfier $e_objs
				foreach s_obj $s_objs {
					set dex [lsearch -exact $more_quailfier $s_obj]
					if {$dex != -1} {
							set ret 1
							set more_quailfier [lreplace $more_quailfier $dex $dex]
					} else {
							set ret 0
							break
					}
				}
				if {$ret} {
						set l_reason "unmatchReason is that ecdc's quailfier is more than sg's quailifer ($more_quailfier)"
						return 1
				}
			}
		}
		return 0
}

++++compare_and_write_csv+++
+++(line 867)
set BB_n [regexp -all -inline {([\w/]+)/[^/]+\((.*)\)} $_item]

+++(line 949 proc create_s_sd_key )
if {[dict exists $rec $key_des_clk_names]} {
		set clk [list [dict get $rec $key_des_clk_names]]
		set result [catch {set clk {*}[reformat_s_names $clk]}]
		if {${result}} {
				set clk [reformat_s_names $clk]
		}
		regexp {.*destination black-box (.*?)(\(.*?\))?, clocked by.*} [regsub {\.\\} [dict get $rec Message] {.}] d_result d_result1
		if {[info exists d_result1] && [regexp {vclk} $clk]} {
				set dest_inst [lindex [get_instances [reformat_s_names $d_result1] -filter {@is_black_box ==1}] 0]
				if {$dest_inst == ""} {
						set dest_inst [lindex [get_instances [get_nets [reformat_s_names $d_result1]] -filter {@is_black_box ==1}] 0]
				}
				set clk [regsub ${dest_inst}_ $clk ""]
		}
#if {[get_instances [get_nets $dest]] ne "" && [get_instances [get_nets $dest] -filter {@is_black_box ==1}] ne ""} {
# set dest_instance [lindex [get_instances [get_nets $dest] -filter {@is_black_box ==1}] 0]
# set clk [regsub ${dest_instance}_ $clk ""]
# }
 ......
set diff_result 0
set diff59_flag [Diff59-report4-multi_bits_merge $eToolMessageObj $sToolMessageObj l_verbose runningFlag "" ""] 
if {$diff59_flag ne 0} {
	dict set eToolMessageObj unmatchReason [lindex $l_verbose 0]
	lset l_e_list $e $eToolMessageObj
	dict set sToolMessageObj unmatchReason [lindex $l_verbose 1]
	lset l_s_list $s $sToolMessageObj
	if {$diff59_flag == 1} {
			continue
	} else {
			break
	}
}
 .....
 
 
# create source key with the src objs
proc create_sd_src_key {rec} {
		set proc_name [lindex [info level 0] 0]
		global current_time
		puts_debug_message start $proc_name
		set time1 $current_time
		global key_src_obj
		set dbg_cnt [dict get $rec DebugCount]
		set sd_key {}
		if {[dict exists $rec $key_src_obj]} {
				lappend sd_key [dict get $rec $key_src_obj]
		}
		puts_debug_message end $proc_name
		set time2 $current_time
		get_proc_time $proc_name $time1 $time2
		return $sd_key
}

# create enno message map with src obj
		proc create_e_src_map {se_list} {
		set proc_name [lindex [info level 0] 0]
		global current_time
		puts_debug_message start $proc_name
		set time1 $current_time
		set sd_map [dict create]
		for {set i 0} {$i < [llength $se_list]} {incr i} {
			set rec [lindex $se_list $i]
			set sd_key [create_sd_src_key $rec]
			dict lappend sd_map $sd_key $i
		}
		puts_debug_message end $proc_name
		set time2 $current_time
		get_proc_time $proc_name $time1 $time2
		return $sd_map
}
+++++(proc eliminate_match)
set e_src_map [create_e_src_map $l_e_list]
		####for diff237
		set e_src_key [join [lindex [split $k " "] 0] " "]
		if {[dict exists $e_src_map $e_src_key]} {
			dict set s_src_map $e_src_key $v
			if {[find_diff $e_src_key $s_src_map l_s_list $e_src_map l_e_list sm_list em_list 1]} {
					foreach i $sm_list {
							lappend s_match_list $i
					}
					foreach i $em_list {
							lappend e_match_list $i
					}
			}
			continue
		}

