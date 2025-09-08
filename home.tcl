proc Diff_report13_clock_clocklist {eToolMessageObj sToolMessageObj runningFlag verbose} {
    upvar $verbose l_verbose
    upvar $runningFlag l_runningFlag
    set enno_src [dict get $eToolMessageObj SourceName]
    set enno_dest [dict get $sToolMessageObj DestName]
    set enno_src_clk [dict get $eToolMessageObj SourceClock]
    set enno_dst_clk [dict get $eToolMessageObj DestClock]
	
    set result [catch {set sg_src [reformat_s_names [list [dict get $sToolMessageObj SourceName]]]}]
	if {$result} {
			set sg_src [reformat_s_names [list [dict get $sToolMessageObj SourceName]]]
	}
    set result [catch {set sg_dest [reformat_s_names [list [dict get $sToolMessageObj DestName]]]}]
	if {$result} {
			set sg_dest [reformat_s_names [list [dict get $sToolMessageObj DestName]]]
	}
    set sg_src_clk [dict get $sToolMessageObj SourceClockNames]
    set sg_dest_clk [dict get $sToolMessageObj DestClockNames]
	
    set ret 0
    set clk_domain ""
    set result [catch {set sg_src_clk {*}[reformat_s_names $sg_src_clk]}
    if {$result} {
        set sg_src_clk [reformat_s_names $sg_src_clk]
    }
    set result [catch {set sg_dest_clk {*}[reformat_s_names $sg_dest_clk]}
    if {$result} {
        set sg_dest_clk [reformat_s_names $sg_dest_clk]
    }
    if {$sg_src_clk ne $enno_src_clk} {
        if {[get_ports $sg_src] ne ""} {
            set data_clock [remove_curly_brace [lsort -u [get_attributes [get_ports $sg_src] -attributes data_clock]]]
            set clk_domain [lsort -u [get_attributes [get_ports $sg_src] -attributes data_clock_domain]]
            set all_sg_clk [lsort -u [concat $data_clock $sg_dest_clk]]
            set all_enno_clk [lsort -u [concat $eno_src_clk $eno_dst_clk]]
            if {$all_enno_clk eq $all_sg_clk} {
                set ret 1
            }
        }
    } elseif {$sg_dest_clk ne $enno_dst_clk} {
        if {[get_ports $sg_dest] ne ""} {
            set data_clock {*}[lsort -u [get_attributes [get_ports $sg_dest] -attributes data_clock]]
            set clk_domain [lsort -u [get_attributes [get_ports $sg_dest] -attributes data_clock_domain]]
            set all_sg_clk [lsort -u [concat $sg_src_clk $data_clock]]
            set all_enno_clk [lsort -u [concat $enno_src_clk $enno_dst_clk]]
            if {$all_enno_clk eq $all_sg_clk} {
                set ret 1
            }
        }
    }
    if {$ret == 1} {
        if {[llength $clk_domain] ==1} {
            set clk_domain [lindex $clk_domain 0]
        }
		if {[llength $clk_domain] ==1|| [llength $data_clock] > [llength $clk_domain]} {
            set l_runningFlag "pass-Diff91-report13-clock_clocklist"
        } else {
			set l_runningFlag "pass-Diff247-report13-clock_clocklist"
		}
    }
    return $ret
}

foreach s_dex $s_lindex {
    set sToolMessageObj [lindex $l_s_list $s_dex]
    set sToolMessageObj [dict remove $sToolMessageObj unmatchReason]
    if {[dict exists $sToolMessageObj runningFlag]} {
        set runningFlag [concat "pass-diff147-report21-multi_bits_merge" [dict get $sToolMessageObj runningFlag]]
        #set runningFlag [regsub " " [lsort -u $runningFlag] ";"]
    } else {
        set runningFlag "pass-diff147-report21-multi_bits_merge"
    }
}
proc Diff251-bug70-clocktiedtoconst {eToolMessageObj} {
    set proc_name [lindex [info level 0] 0]
    global current_time
    puts_debug_message start $proc_name
	
    set ret 0
    set e_clk [lindex [dict get $eToolMessageObj objList] 0]
    set e_clk_driver [get_attributes [get_nets $e_clk] -attributes dbg_drivers]
    if {[llength [get_nets [get_pins $e_clk_driver]]] == 1} {
        if {[get_attributes [get_instances $e_clk_driver] -attributes view] == "VERIFIC_BUF"} {
            set ret 1
        }
    }
    puts_debug_message end $proc_name
	return $ret
}

foreach ev [dict get $e_no_clk_map $e_no_clk_key] {
    set eToolMessageObj [lindex $l_e_list $ev]
    set msgId [dict get $eToolMessageObj msgId]
    set reasonFlag ""
    set rulename [modify_severity sToolMessageObj]
    if {[is_rule_match $::ruleMapAc $msgId $rulename]} {
        if {[isMatchAcNew eToolMessageObj sToolMessageObj verbose]} {
            set reasonFlag ""
        } elseif {[isMatchAcWithoutReason eToolMessageObj sToolMessageObj runningFlag l_verbose]} {
            set reasonFlag "pass-diff63-synth14-vague_match"
        }
        if {[diff157-report23-clocklist $eToolMessageObj $sToolMessageObj runningFlag verbose]} {
            set runningFlag [join [concat "pass-diff157-report23-clocklist" $reasonFlag] ";"]
            set matched 1
        } elseif {[Diff-report13-clock_clocklist $eToolMessageObj $sToolMessageObj runningFlag verbose]} {
            set runningFlag [join [concat $runningFlag $reasonFlag] ";"]
            set matched 1
        } elseif {[diff91-report13-clock_clocklist $eToolMessageObj $$sToolMessageObj verbose]} {
            set matched 1
            set runningFlag [join [concat "pass-Diff91-report13-clock_clocklist" $reasonFlag] ";"]
        }
    }
	
	 if {[is_rule_match $::ruleMapAc $msgId $rulename]} {
        if {[isMatchAcNew eToolMessageObj sToolMessageObj verbose]} {
            set reasonFlag ""
        } elseif {[isMatchAcWithoutReason eToolMessageObj sToolMessageObj runningFlag verbose]} {
            set reasonFlag "pass-diff63-synth14-vague_match"
        }
        if {[diff147-report21-multi_bits_merge $eToolMessageObj $sToolMessageObj l_verbose $sv l_s_list s_bus_pass_list $s_debug $e_debug]} {
            set runningFlag [join [concat "pass-Diff147-report21-multi_bits_merge" $reasonFlag] ";"]
            set matched 1
		}
    if {$msgId == "SetupClkTiedToConst"} {
        if {[Diff251-bug70-clocktiedtoconst $eToolMsgObj]} {
            dict set eToolMsgObj runningFlag pass-Diff251-bug70-clocktiedtoconst
            writeSetupMsgLine ${resultCsvFileName} ${eToolMsgObj} "" ${testName} "pass" ${oldResultCsvFile}
            continue
        }
    }
}
