
#####mapdict.tcl#####
dict set diff_dict [list [list Ac_unsync02 {Gating logic not accepted: source drives MUX select input}] [list AcSyncDataPath {ValidGate}]] Diff25-synth5_mux_and
#####main.tcl####
if {${runningFlag} ni "pass-Diff45-bug7 pass-Diff7-bug2_src_same_as_qual_src pass-Diff25-synth5_mux_and"} {
	set severity_cmp [cmp_2_values "Severity" [string range $eSeverity 0 3] [string range $sSeverity 0 3] verbose]
}
####diff.tcl#####
proc Ac-affected-by-data_const {sTo0lMessageObj} {
 ....
	set dest_instance [get_instances [get_pins [lindex [get_nets $dest_obj] 0] -filter {@name=="q"}]]
	if {[get_pins $dest_instance -filter {@name = "d"}] ne ""} {
		if {[get_attributes [get_pins $dest_instance -filter {@name = "d"}] -attribute inferred_constant] ne ""} {
			return 1
		}
	}
	return 0
}

proc Diff25-synth5_mux_and {eToolMessageObj sToolMessageObj verbose runningFlag {s_debug 0} {e_debug 0}} {
 set e_sourname [dict get ${eToolMessageObj} SourceName]
 set result [catch {set s_sourname {*}[reformat_s_names [dict get ${sToolMessageObj} SourceName]]}]
 if {$result} {
	set s_sourname [reformat_s_names [dict get ${sToolMessageObj} SourceName]]
 }
 
 set e_destname [dict get ${eToolMessageObj} DestName]
 set result [catch {set s_destname {*}[reformat_s_names [dict get ${sToolMessageObj} DestName]]}]
 if {$result} {
	set s_destname [reformat_s_names [dict get ${sToolMessageObj} DestName]]
}
 
 set e_source_clk [dict get $eTo0lMessageObj SourceClock]
 set s_source_clk [reformat_s_names [dict get $sToolMessageObj SourceClockNames]]
 
 set e_dest_clk [dict get $eToolMessageObj DestClock]
 set s_dest_clk [reformat_s_names [dict get $sToolMessageObj DestClockNames]]
	if {${e_source_clk} == ${s_source_clk} && ${e_dest_clk} == ${s_dest_clk} && ${e_sourname} == ${s_sourname} && ${e_destname} == ${s_destname}} {
		set src_linked_mux_c [get_pins [get_nets $e_sourname] -filter {@name == "c"}]
		if {$src_linked_mux_c ne ""} {
			set mux_instance [get_instances $src_linked_mux_c -filter {@view == "VERIFIC_MUX"}]
			if {$mux_instance ne ""} {
				set mux_a0_value [get_attributes [get_pins $mux_instance -filter {@name == "a0"}] -attribute inferred_constant]
				set mux_a1_clock_domian [get_attributes [get_pins $mux_instance -filter {@name == "a0"}] -attribute data_clock_domain]
				set e_dest_clock_domain [get_attributes [get_instances $e_destname] -attribute data_clock_domain]
				if {$mux_a0_value == "0" && $mux_a1_clock_domian == $e_dest_clock_domain} {
					return 1
				}
			}
		}
		return 0
	} 
	return 0
}
#######diff_setuP.cl######
proc false-bit {eToolMessageOb sTolMessageOb} {
 set e_obj [lindex [dict get $eToolMessageObj objList] 0]
 set e_const_value [lindex [dict get $eToolMessageObj objList] end]
 set s_obj [lindex [dict get $sToolMessageObj objList] 0]
 set s_const_value [lindex [dict get $sTolMessageObj objList] end
 if {$e_const_value == $s_const_value} {
	if {[regexp { .} $s_obj]} {
		set s_obj \{$s_obj\}
	}
	if {[get_pins [get_nets [reformat_s_names_setup $s_obj]] -filter {@name == "q"}] ne ""} {
		set s_obj [get_instances [get_pins [get_nets [reformat_s_names_setup $s_obj]] -filter {@name == "q"}]]
	}
	if {[string first $s_obj $e_obj] != -1 && $s_obj != $e_obj} {
		return 1
	}
 }
 return 0
}

