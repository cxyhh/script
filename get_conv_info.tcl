#######get_match_conv01.tcl#######
proc get_match_msgs_by_conv_path { sg_msg_id sg_qualifiers sg_conv_net } {

 ## get sg driver of conv net
 set sg_driver [get_pins -flat [get_nets $sg_conv_net] -filter {[get_attributes -attributes dir @@] == "out"}]
 if {$sg_driver == {}} {
	set sg_driver [get_pins [get_nets $sg_conv_net] -filter {[get_attributes -attributes dir @@] == "out"}]
 }
 
 set match_msgs {}
 foreach msg [get_messages -message_id ChySameSrcConvIncSeq] {
	set my_conv_net [get_nets [get_attributes -attributes Net4 $msg]]
	set my_driver [get_pins -flat [get_nets $my_conv_net] -filter {[get_attributes -attributes dir @@] == "out"}]
	if {$my_driver == {}} {
		set my_driver [get_pins [get_nets $my_conv_net] -filter {[get_attributes -attributes dir @@] == "out"}]
	}
	set fanin_list1 [get_fanin -tcl_list -to $my_driver -through {[get_pins @@] == $sg_driver}]
	set fanin_list2 [get_fanin -tcl_list -to $sg_driver -through {[get_pins @@] == $my_driver}]
	if {[llength $fanin_list1] > 0} {
		lappend match_msgs $msg
	} elseif {[llength $fanin_list2] > 0} {
		lappend match_msgs $msg
	}
 }
 return $match_msgs
}

proc get_best_match_msg_by_comm_qual_cnt { sg_msg_id sg_qualifiers sg_conv_net } {

 ## create dict-in-dict for ecdc(my) messages
	set my_msg_dict [dict create]
	foreac msg [get_messages -message_id ChySameSrcConvIncSeq] {
	set my_per_msg_dict [dict create]
	
## collect all qualifiers: canonical - actual
	set my_qualifiers [get_pins [get_attributes -attributes PinList1 $msg -tcl_dict]]
	foreach act_qual $my_qualifiers {
		set can_qual [get_nets -canonical $act_qual]
		dict lappend my_per_msg_dict act_qual $act_qual
		dict lappend my_per_msg_dict can_qual $can_qual
	}
## sort all can_qual
	dict set my_per_msg_dict can_qual [
		lsort -uniq [dict get $my_per_msg_dict can_qual]
	]
	
## collect conv net: canonical -> actual
	set act_conv_net [get_nets [get_attributes -attributes Net4 $msg]]
	set can_conv_net [get_nets -canonical $act_conv_net]
	dict set my_per_msg_dict act_conv_net $act_conv_net
	dict set my_per_msg_dict can_conv_net $can_conv_net
	
	dict set my_msg_dict $msg $my_per_msg_dict
 }
 
 ## create one dict for the sg message
	if {1} {
		set sg_per_msg_dict [dict create]
	
	## collect all #ualifiers: canonical > actual
		set sg_qualifiers [get_nets $sg_qualifiers]
		foreach act_qual $sg_qualifiers {
			set can_qual [get_nets -canonical $act_qual]
			dict lappend sg_per_msg_dict act_qual $act_qual
			dict lappend sg_per_msg_dict can_qual $can_qual
		}	
## sort all can_qual
		dict set sg_per_msg_dict can_qual [
			lsort -uniq [dict get $sg_per_msg_dict can_qual]
		]
		
## collect conv net: canonical -> actual
		set act_conv_net [get_nets $sg_conv_net]
		set can_conv_net [get_nets -canonical $act_conv_net]
		dict set sg_per_msg_dict act_conv_net $act_conv_net
		dict set sg_per_msg_dict can_conv_net $can_conv_net
	}
	
	
 ## now find the best match
	set best_match_msg_by_comm_qual_cnt {}
	set comm_qual_cnt 0
	foreach msg [dict keys $my_msg_dict] {
		set my_per_msg_dict [dict get $my_msg_dict $msg]
		set my_can_qual [dict get $my_per_msg_dict can_qual]
		set sg_can_qual [dict get $sg_Per_msg_dict can_qual]
		
		set likeliness [get_common_cnt $msg $sg_can_qual $my_can_qual]
		if {$comm_qual_cnt < $likeliness} {
			set comm_qual_cnt $likeliness
			set best_matc_msg_by_comm_qual_cnt $msg
		}
	}
	return $best_match_msg_by_comm_qual_cnt
}

proc get_common_cnt { msg sg_can_qual my_can_qual } {

 ## set them into a dict
	set dd [dict create]
	foreach can_qual $sg_can_qual {
		dict lappend dd $can_qual sg
	}
	foreach can_qual $my_can_qual {
		dict lappend dd $can_qual my
	}
	
 ## count the sum from dict
	set comm_cnt 0
	foreach k [dict keys $dd] {
		set cnt [llength [dict get $dd $k]]
		if {$cnt >= 2} {
			incr comm_cnt
		}
	}
	return $comm_cnt
}

#####get_conv_info.tcl#####
set current_dir [file dirname [info script]]
source [file join $current_dir mapdict.tcl]
source [file join $current_dir utils.tcl]
source [file join $current_dir setup.tcl]
#source [file join $current_dir compare_and_write_csv.tcl]

set Chy_type ""
set debug_key 0
# read a file to a var
proc read_file {file_name} {
	if {![file exists ${file_name}]} {
		puts "<<main.tcl:read_file>> File is not existed: ${file_name}#
		return
	}
	set fp [open "${file_name}" r]
	set content [read $fp]
	close $fp
	return ${content}
}
proc get_conv_info {s_rule_id rule moresimple qualifier conv_net} {
	upvar $qualifier l_qualifier
	upvar $conv_net l_conv_net
	
	global message_line_dict Chy_type
	set s_rule_id [string toupper $s_rule_id]
	set s_list {}
	set s_setup_map {}
	set $message_line_dict [dict create]
	get_report_content $moresimple
	
	if {[dict size $message_line_dict] == 0} {
		puts "$moresimple not report some rules"
	}
	set s_list [conv_rpt_to_list ${moresimple} ${rule} ${s_rule_id}]
	set s_setup_map [create_s_setup_map $s_list]
	set l_qualifier [lindex [lindex $s_setup_map 0] 1]
	set l_conv_net [lindex [lindex $s_setup_map 0] 2]
	#if {$rule == "Ac_conv04"} {
	#	switc ${Chy_tyPe} {
	# 	ChyCtrlBusNoConv {
	# 		set l_quailifer [lindex [lindex $s_setup_maP 0] 1]
	# 		set l_conv_net "there is no conv net"
	# 	}
	# 	ChyDataBusDiffSyncScheme {
	# 		set l_quailifer [lindex [linde $s_setup_map 0] 1]
	# 		set l_conv_net [lindex [#index $s_setup_map 0] 2]
	# 	}
	# 	ChyDataBusDiffEnable {
	#		set l_quailifer [lindex [lindex $s_setup_map 0] 1]
	# 		set l_conv_net [lindex [#index $s_setup_map 0] 2]
	# 	}
	# 	}
	#}
puts "quailifer is $l_qualifier"
puts "conv_net is $l_conv_net"
}



