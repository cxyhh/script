需要删除/注释的proc
注释mapdict中的diff59 diff157 diff91
注释main.tcl中的getAcMsgLineNumDict
write_ac_flag fanbiao_proc_flag
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


+++++utils+++++++
proc parse_oldCsv {oldResultCsvFile} {
		set proc_name [lindex [info level 0] 0]
		puts_debug_message start $proc_name
		global arr_result current_time
		set time1 $current_time
		
		set old_csv $oldResultCsvFile
		set fh [open $old_csv r]
		set content [split [read $fh] "\n"]
		set title_line [lindex $content 0]
		set result_index [lsearch [split $title_line ","] "result"]
		set content [lrange $content 1 end]
		array set arr_result {}
		foreach item $content {
			set k [join [lrange [split $item ","] 0 $result_index-1] ","]
			set arr_result($k) $item 
		}
		puts_debug_message end $proc_name
		set time2 $current_time
		get_proc_time $proc_name $time1 $time2
		return 1
		#return [array get arr_result]
}


++++++++++++mapdict
################################### NEW #############################
dict set acReasonMap {Conventional multi-flop for metastability technique} "MultiFlop"
dict set acReasonMap {Conventional multi-flop (library-cell) for metastability technique} "MultiFlop"
dict set acReasonMap {Conventional multi-flop synchronizer is hanging} "MultiFlop"
#dict set acReasonMap {synchronizing cell\(cell name : .*\)} "UserDefinedCell"
dict set acReasonMap {synchronizing cell} "UserDefinedCell"
dict set acReasonMap {does not require synchronization (long-delay/quasi-static)} "LongDelaySignal"
#dict  set acReasonMap {qualifier .* defined on destination} "UserDefinedQual"
dict set acReasonMap {qualifier defined on destination} "UserDefinedQual"
#dict set acReasonMap {Synchronization at And gate.*} "ValidGate"
dict set acReasonMap {Synchronization at And gate} "ValidGate"
#dict  set acReasonMap {Merges with valid .* qualifier} "ValidGate"
dict set acReasonMap {Merges with valid qualifier} "ValidGate"
#dict  set acReasonMap {Mux-select sync.*} "MuxSelect"
#dict  set acReasonMap {Recirculation flop.*} "RecirculationMux"
dict set acReasonMap {Mux-select sync} "MuxSelect"
dict set acReasonMap {Recirculation flop} "RecirculationMux"
dict set acReasonMap {Clock Gate Synchronization (auto-detected clock gating)} "CGICAutoInferred"
dict set acReasonMap {Clock Gate Synchronization (user-defined clock gating cell)} "CGICUserDefinedCell"
dict set acReasonMap {Enable Based User-Defined Qualifier} "RecirculationMux"
dict set acReasonMap {Enable Based Synchronizer} "RecirculationMux"
dict set acReasonMap {Clock Based User-Defined Qualifier} "CGICUserDefinedQual"

dict set acReasonMap {Clock domains of destination instance and synchronizer flop do not match} "CtrlClkDomainMismatch"
dict set acReasonMap {Combinational logic used between crossing} "NonstaticComboInCrossing"
dict set acReasonMap {Unsynchronized synchronous reset} "UnsyncSyncRst"
dict set acReasonMap {Destination instance is driving multiple paths} "MultiFanout"
#dict  set acReasonMap {Invalid synchronizer .*} "InvalidSyncCell"
dict set acReasonMap {Invalid synchronizer} "InvalidSyncCell"
dict set acReasonMap {Sync reset used in multi-flop synchronizer} "CtrlPotentialSynRstUndefined"
dict set acReasonMap {Gating logic not accepted: gate-type invalid} "InvalidGate"
dict set acReasonMap {Gating logic not accepted: source drives MUX select input} "SrcMuxSelPin"
dict set acReasonMap {Gating logic not accepted: source and qualifier drive MUX data inputs} "QualMuxDataPin"
dict set acReasonMap {Gating logic not accepted: source and user-defined qualifier drive MUX data inputs} "QualMuxDataPin"
dict set acReasonMap {Gating logic not accepted: only sources drive MUX data inputs; atleast one destination domain signal should drive a MUX data input} "NoDestMuxDataPin"
dict set acReasonMap {User-defined qualifier merges with another source with non-deterministic enable condition before gating logic} "QualMergesOtherSrc"
dict set acReasonMap {Qualifier merges with another source with non-deterministic enable condition before gating logic} "QualMergesOtherSrc"
dict set acReasonMap {Qualifier not accepted: crossing source is the same as source of qualifier} "SrcSameAsQualSrc"
dict set acReasonMap {User-defined qualifier merges with the same source before gating logic} "QualMergesSameSrc"
dict set acReasonMap {Qualifier merges with the same source before gating logic} "QualMergesSameSrc"

dict set acReasonMap {Qualifier not found} "MissingSynchronizer"
dict set acReasonMap {Synchronizer flop is the destination flop for another crossing} "MissingSynchronizer"
dict set acReasonMap {Sources from different domains converge before being synchronized} "SrcConverge"
################################### NEW #############################


dict set reasonSync {^Clock Based User-Defined Qualifier} "CGICUserDefinedQual"




####ac 4 key pass by find_diff
proc eliminate_pass_4_key {s_sd_map s_list e_sd_map e_list match_pass_map} {
		set proc_name [lindex [info level 0] 0]
		global current_time resultCsvFileName oldResultCsvFile
		puts_debug_message start $proc_name
		set time1 $current_time
		upvar $s_list l_s_list
		upvar $e_list l_e_list
		
		upvar $match_pass_map l_match_pass_map
		####find_diff deal
		set s_pass_list {}
		set e_pass_list {}
		if {[llength $l_s_list] ne 0 && [llength $l_e_list] ne 0} {
				set sp_list {}
				set ep_list {}
				foreach {k v} $s_sd_map {
						if {[dict exists $e_sd_map $k]} {
								dict set s_diff_map $k $v
								dict set e_diff_map $k [dict get $e_sd_map $k]
								if {[find_diff $k $s_diff_map l_s_list $e_diff_map l_e_list sp_list ep_list]} {
										foreach i $sp_list {
												lappend s_pass_list $i
										}
										foreach i $ep_list {
												if {[string match "AcSync*" [dict get [lindex $l_e_list $i] msgId]]} {
														dict set l_match_pass_map $k diff9_1
												} else {
														dict set l_match_pass_map $k diff9_2
												}
												lappend e_pass_list $i 
										}
								}
						}
				}
				
				foreach s [lsort -decreasing -integer -unique $s_pass_list] {
						set l_s_list [lreplace $l_s_list $s $s]
				}
				foreach e [lsort -decreasing -integer -unique $e_pass_list] {
						set l_e_list [lreplace $l_e_list $e $e]
				}
		}
		puts_debug_message end $proc_name
		set time2 $current_time
		get_proc_time $proc_name $time1 $time2
}

#####ac 2 key pass by ac_clk_diff
proc eliminate_pass_2_key {s_sd_map s_list e_no_clk_map e_list match_pass_map} {
		set proc_name [lindex [info level 0] 0]
		global current_time resultCsvFileName oldResultCsvFile
		puts_debug_message start $proc_name
		set time1 $current_time
		upvar $s_list l_s_list
		upvar $e_list l_e_list
		
		upvar $match_pass_map l_match_pass_map
		####deal clk diff
		set s_pass_2tuple {}
		set e_pass_2tuple {}
		if {[llength $l_s_list] ne 0 && [llength $l_e_list] ne 0} {
				foreach {k v} $s_sd_map {
						set e_no_clk_key [join [lrange [split $k " "] 0 1] " "]
						if {[dict exists $e_no_clk_map $e_no_clk_key]} {
						foreach sv $v {
							set matched 0
							set sToolMessageObj [lindex $l_s_list $sv]
							set rulename [dict get $sToolMessageObj rulename]
							foreach ev [dict get $e_no_clk_map $e_no_clk_key] {
									set eToolMessageObj [lindex $l_e_list $ev]
									set msgId [dict get $eToolMessageObj msgId]
									if {[isMatchAcNew eToolMessageObj sToolMessageObj verbose]} {
											if {[diff91-report13-clock_clocklist $eToolMessageObj $sToolMessageObj verbose]} {
													set matched 1
													set runningFlag "pass-diff91-report13-clock_clocklist"
											} elseif {[diff157-report23-clocklist $eToolMessageObj $sToolMessageObj runningFlag verbose]} {
													set runningFlag "pass-diff157-report23-clocklist"
													set matched 1
											}
									} elseif {[isMatchAcWithoutReason eToolMessageObj sToolMessageObj runningFlag l_verbose]} {
											if {[diff91-report13-clock_clocklist $eToolMessageObj $sToolMessageObj verbose]} {
													set matched 1
													set runningFlag "pass-diff91-report13-clock_clocklist;pass-diff63-synth14-vague_match"
											} elseif {[diff157-report23-clocklist $eToolMessageObj $sToolMessageObj runningFlag verbose]} {
													set matched 1
													set runningFlag "pass-diff157-report23-clocklist;pass-diff63-synth14-vague_match"
											}
									}
									if {$matched} {
											dict set eToolMessageObj runningFlag $runningFlag
											dict set sToolMessageObj runningFlag $runningFlag
											dict set eToolMessageObj matched 1
											dict set sToolMessageObj matched 1
											set l_e_list [lreplace $l_e_list $ev $ev $eToolMessageObj]
											set l_s_list [lreplace $l_s_list $sv $sv $sToolMessageObj]
											writeAcMsgLine $resultCsvFileName $eToolMessageObj $sToolMessageObj "pass" $oldResultCsvFile
											if {[string match "AcSync*" [dict get $eToolMessageObj msgId]]} {
													set rec [list $eToolMessageObj]
													set e_sd_map [create_e_sd_map rec]
													dict set l_match_pass_map [lindex $e_sd_map 0] diff9_1
											} else {
													set rec [list $eToolMessageObj]
													set e_sd_map [create_e_sd_map rec]
													dict set l_match_pass_map [lindex $e_sd_map 0] diff9_2
											}
											lappend s_pass_2tuple $sv
											lappend e_pass_2tuple $ev
											break
									}
								}
							}
						}
				}
				foreach s [lsort -decreasing -integer -unique $s_pass_2tuple] {
						set l_s_list [lreplace $l_s_list $s $s]
				}
				foreach e [lsort -decreasing -integer -unique $e_pass_2tuple] {
						set l_e_list [lreplace $l_e_list $e $e]
				}
		}
		puts_debug_message end $proc_name
		set time2 $current_time
		get_proc_time $proc_name $time1 $time2
}

#####ac bus pass by ac_bus_diff
proc eliminate_pass_bus {s_bus_map s_list e_no_bus_map e_list match_pass_map} {
		set proc_name [lindex [info level 0] 0]
		global current_time resultCsvFileName oldResultCsvFile aided_proc
		puts_debug_message start $proc_name
		set time1 $current_time
		upvar $s_list l_s_list
		upvar $e_list l_e_list
		
		upvar $match_pass_map l_match_pass_map
		####deal bus diff
		set e_bus_pass_list {}
		set s_bus_pass_list {}
		if {[llength $l_s_list] ne 0 && [llength $l_e_list] ne 0} {
				foreach {k v} $s_bus_map {
						set e_no_bus_key [deal_s_sd_no_bus ${k}]
						if {[dict exists ${e_no_bus_map} ${e_no_bus_key}] } {
						foreach sv $v {
								set sToolMessageObj [lindex $l_s_list $sv]
								set rulename [dict get $sToolMessageObj rulename]
								foreach ev [dict get $e_no_bus_map $e_no_bus_key] {
										set matched 0
										set eToolMessageObj [lindex $l_e_list $ev]
										set msgId [dict get $eToolMessageObj msgId]
										set e_debug {}
										set s_debug {}
										set rulename [modify_severity sToolMessageObj]
										if {[is_rule_match $::ruleMapAc $msgId $rulename]} {
												if {[isMatchAcNew eToolMessageObj sToolMessageObj verbose]} {
														if {[diff147-report21-multi_bits_merge $eToolMessageObj $sToolMessageObj l_verbose runningFlag $sv l_s_list s_bus_pass_list $s_debug $e_debug]} {
																set matched 1
														}
												}
												if {$matched != 1} {
														if {[diff63-synth14 $eToolMessageObj $sToolMessageObj l_verbose runningFlag $ev l_e_list e_bus_pass_list $s_debug $e_debug]} {
																set matched 1
														} elseif {[dict exists $sToolMessageObj FailureReason]} {
																set e_reason [dict get $eToolMessageObj "reasonList"]
																set s_reason [dict get $sToolMessageObj "FailureReason"]
																if {$s_reason eq "Gating logic not accepted: gate-type invalid" && ${e_reason} eq "InvalidGate"} {
																	if {[Diff72-report7-multi_bits_merge $eToolMessageObj $sToolMessageObj l_verbose runningFlag $s_debug $e_debug]} {
																			set matched 1
																	}	 
																}
														}
												}
										}
										if {$matched} {
												dict set eToolMessageObj runningFlag $runningFlag
												dict set sToolMessageObj runningFlag $runningFlag
												set l_e_list [lreplace $l_e_list $ev $ev $eToolMessageObj]
												set l_s_list [lreplace $l_s_list $sv $sv $sToolMessageObj]
												writeAcMsgLine $resultCsvFileName $eToolMessageObj $sToolMessageObj "pass" $oldResultCsvFile
												if {[string match "AcSync*" [dict get $eToolMessageObj msgId]]} {
														set rec [list $eToolMessageObj]
														set e_sd_map [create_e_sd_map rec]
														dict set l_match_pass_map [lindex $e_sd_map 0] diff9_1
												} else {
														set rec [list $eToolMessageObj]
														set e_sd_map [create_e_sd_map rec]
														dict set l_match_pass_map [lindex $e_sd_map 0] diff9_2
												}
												lappend s_bus_pass_list $sv
												lappend e_bus_pass_list $ev
												continue
										} else {
												if {$aided_proc} {
														set diff59_flag [Diff59-report4-multi_bits_merge $eToolMessageObj $sToolMessageObj l_verbose runningFlag "" ""] 
														if {$diff59_flag ne 0} {
																set e_unmatchReason [lindex $l_verbose 0]
																set s_unmatchReason [lindex $l_verbose 1]
																if {[dict exists ${eToolMessageObj} diff237]} {
																		set e_unmatchReason "$e_unmatchReason Diff237"
																}
																if {[dict exists ${sToolMessageObj} diff237]} {
																			set s_unmatchReason "$s_unmatchReason Diff237"
																}
																dict set eToolMessageObj unmatchReason $e_unmatchReason
																lset l_e_list $ev $eToolMessageObj
																dict set sToolMessageObj unmatchReason $s_unmatchReason
																lset l_s_list $sv $sToolMessageObj
																if {$diff59_flag == 1} {
																		continue
																} else {
																		break
																}
														}
													}
												}
										}
								}
						}
				}
				foreach s [lsort -decreasing -integer -unique $s_bus_pass_list] {
						set l_s_list [lreplace $l_s_list $s $s]
				}
				foreach e [lsort -decreasing -integer -unique $e_bus_pass_list] {
						set l_e_list [lreplace $l_e_list $e $e]
				}
		}
		puts_debug_message end $proc_name
		set time2 $current_time
		get_proc_time $proc_name $time1 $time2
}
####deal ac diff
proc create_map_eliminate_pass {s_list e_list match_pass_map} {
		set proc_name [lindex [info level 0] 0]
		global current_time 
		global resultCsvFileName oldResultCsvFile
		puts_debug_message start $proc_name
		set time1 $current_time
		upvar $s_list l_s_list
		upvar $e_list l_e_list
		
		upvar $match_pass_map l_match_pass_map
		#####4 key pass by find_diff
		set e_diff_map [create_e_sd_map l_e_list]
		set s_diff_map [create_s_sd_map l_s_list]
		#puts "find_diff Start [exec date "+%Y-%m-%d %H:%M:%S"]"
		#set T0 [clock seconds]
		eliminate_pass_4_key $s_diff_map l_s_list $e_diff_map l_e_list l_match_pass_map
		#set T1 [clock seconds]
		#puts "eliminate_pass_4_key time: [expr $T1 - $T0]"
		
		#####$ key pass by ac_clk_diff
		#puts "eliminate_pass_2_key [exec date "+%Y-%m-%d %H:%M:%S"]"
		#set T0 [clock seconds]
		if {[llength $l_s_list] ne 0 && [llength $l_e_list] ne 0} {
				set e_no_clk_map [create_e_sd_no_clk_map $l_e_list]
				set s_sd_map [create_s_sd_map l_s_list]
				eliminate_pass_2_key $s_sd_map l_s_list $e_no_clk_map l_e_list l_match_pass_map
		}
		#set T1 [clock seconds]
		#puts "eliminate_pass_2_key time: [expr $T1 - $T0]"
		
		#####bus pass by ac_bus_diff
		#puts "eliminate_pass_bus [exec date "+%Y-%m-%d %H:%M:%S"]"
		#set T0 [clock seconds]
		if {[llength $l_s_list] ne 0 && [llength $l_e_list] ne 0} {
				set e_no_bus_map [create_e_sd_no_bus_map $l_e_list]
				set s_bus_map [create_s_sd_map l_s_list]
				eliminate_pass_bus $s_bus_map l_s_list $e_no_bus_map l_e_list l_match_pass_map
		}
		#set T1 [clock seconds]
		#puts "eliminate_pass_bus time: [expr $T1 - $T0]"
		
		######deal diff9
		#puts "diff9 [exec date "+%Y-%m-%d %H:%M:%S"]"
		#set T0 [clock seconds]
		if {[llength $l_e_list] > 0} {
				set e_diff9_list {}
				set e_remained_map [create_e_sd_map l_e_list]
				foreach {k v} $e_remained_map {
						if {[dict exists $l_match_pass_map $k]} {
								set eToolMessageObj [lindex $l_e_list $v]
								if {[string match "AcSync*" [dict get $eToolMessageObj msgId]]} {
										set expect_flag "diff9_1"
								} else {
										set expect_flag "diff9_2"
								}
								
								if {$expect_flag eq [dict get $l_match_pass_map $k]} {
										dict set eToolMessageObj runningFlag "pass-Diff9-Multi_reasons1"
										dict set eToolMessageObj matched 1
										set l_e_list [lreplace $l_e_list $v $v $eToolMessageObj]
										writeAcMsgLine $resultCsvFileName $eToolMessageObj "" "pass" $oldResultCsvFile
										lappend e_diff9_list $v
										continue
								}
						}
				}
				foreach e [lsort -decreasing -integer -unique $e_diff9_list] {
						set l_e_list [lreplace $l_e_list $e $e]
				}
				#puts "Diff9 End: [exec date "+%Y-%m-%d %H:%M:%S"]"
		}
		#set T1 [clock seconds]
		#puts "diff9 time: [expr $T1 - $T0]"
		puts_debug_message end $proc_name
		set time2 $current_time
		get_proc_time $proc_name $time1 $time2
}
proc modify_reason {s_reason} {
		if {[string match "synchronizing cell(cell name : *)" $s_reason]} {
				set s_reason "synchronizing cell"
		} elseif {[string match "qualifier * defined on destination" $s_reason]} {
				set s_reason "qualifier defined on destination"
		} elseif {[string match "Synchronization at And gate*" $s_reason]} {
				set s_reason "Synchronization at And gate"
		} elseif {[string match "Merges with valid * qualifier" $s_reason]} {
				set s_reason "Merges with valid qualifier"
		} elseif {[string match "Mux-select sync.*" $s_reason]} {
				set s_reason "Mux-select sync"
		} elseif {[string match "Recirculation flop*" $s_reason]} {
				set s_reason "Recirculation flop"
		} elseif {[string match "Invalid synchronizer *" $s_reason]} {
				set s_reason "Invalid synchronizer"
		} else {
				set s_reason $s_reason
		}
		return $s_reason
}
#####$024/5/10:sg Ac_unsync has some syc scheme
proc modify_severity {sToolMessageObj} {
		upvar $sToolMessageObj l_sToolMessageObj
		set rulename [dict get $l_sToolMessageObj "rulename"]
		#024/5/10:Ac_unsync02 has some syc scheme
		if {[regexp {^Ac_unsync02} $rulename]} {
				if {[dict get $l_sToolMessageObj "FailureReason"] eq "N.A."} {
						if {[dict get $l_sToolMessageObj "SyncScheme"] ne "N.A."} {
								set rulename "Ac_sync02"
								dict set l_sToolMessageObj Severity info
						}
				}
		} elseif {[regexp {^Ac_unsync01} $rulename]} {
				if {[dict get $l_sToolMessageObj "FailureReason"] eq "N.A."} {
						if {[dict get $l_sToolMessageObj "SyncScheme"] ne "N.A."} {
								set rulename "Ac_sync01"
								dict set l_sToolMessageObj Severity info
						}
				}
		}
		return $rulename
}

proc isMatchAcNew {leToolMessageObj lsToolMessageObj verbose {s_debug 0} {e_debug 0}} {
		upvar $verbose l_verbose
		upvar $leToolMessageObj eToolMessageObj
		upvar $lsToolMessageObj sToolMessageObj
		set l_verbose {}
		if {${eToolMessageObj} ne "" && ${sToolMessageObj} ne ""} {
				set msgId [dict get $eToolMessageObj "msgId"]
				set rulename [dict get $sToolMessageObj "rulename"]
				#024/5/10:Ac_unsync02 has some syc scheme
				set rulename [modify_severity sToolMessageObj]
				if {[is_rule_match $::ruleMapAc $msgId $rulename]} {
						set e_reason [dict get $eToolMessageObj "reasonList"]
						if {[dict exists $sToolMessageObj SyncScheme] && [dict get $sToolMessageObj SyncScheme] ne "N.A."} {
								set s_reason [dict get $sToolMessageObj "SyncScheme"]
						} elseif {[dict exists $sToolMessageObj FailureReason] && [dict get $sToolMessageObj FailureReason] ne "N.A."} {
								set s_reason [dict get $sToolMessageObj "FailureReason"]
						}
						set s_reason [modify_reason $s_reason]
						if {[dict exists $::acReasonMap $s_reason]} {
								if {[dict get $::acReasonMap $s_reason] == $e_reason} {
										return 1
								} else {
										lappend l_verbose "(key and rule matched, $s_reason is not match $e_reason)"
								}
						} else {
								lappend l_verbose "(message of sg: {$s_reason} not in acReasonMap"
						}
				} else {
						if {[dict exists $eToolMessageObj diff237] || [dict exists $sToolMessageObj diff237]} {
								return 1
						} else {
								lappend l_verbose "($msgId does not match $rulename)"
						}
				}
		} else {
				lappend l_verbose "(Empty Msgobj)"
		}
		return 0 
}

proc isMatchAcWithoutReason {leToolMessageObj lsToolMessageObj running_flag verbose {s_debug 0} {e_debug 0}} {
		upvar $verbose l_verbose
		upvar $running_flag l_running_flag
		upvar $leToolMessageObj eToolMessageObj
		upvar $lsToolMessageObj sToolMessageObj
		set l_verbose {}
		if {${eToolMessageObj} ne "" && ${sToolMessageObj} ne ""} {
				set eFile [file tail [dict get $eToolMessageObj "fileName"]]
				set sFile [file tail [dict get $sToolMessageObj "File"]]
				if {$eFile eq $sFile} {
						set msgId [dict get $eToolMessageObj "msgId"]
						set rulename [dict get $sToolMessageObj "rulename"]
						set rulename [modify_severity sToolMessageObj]
						if {[is_rule_match $::ruleMapAc $msgId $rulename]} {

