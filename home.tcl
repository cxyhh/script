++++utils.tcl++++

proc get_no_compare_proc {} {
	return {pass-Diff123-diff19-clock_info-03 pass-Diff112-irregular7-clock_coverge 
	pass-Diff150-report22-conv pass-Diff178-report1-clocktietoconst
}


++++mapdict.tcl++++++
dict set se_cmd_map qualifier set_qualifier
dict set diff_dict [list [list Ac_sync02 {Conventional multi-flop for metastability technique}] [list AcNoSyncScheme {MissingSynchronizer}]] Diff237-Diff48-UDP
dict set diff_dict [list [list Ac_sync02 {Synchronization at And gate}] [list AcNoSyncScheme {MissingSynchronizer}]] Diff237-Diff48-UDP

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
