proc find_fanout_quailfier {pin_list} {
	set quailifers [get_instances $pin_list]
	set ret 1
	foreach ff $quailifers {
		set ac_sync_flop_number [get_param cdc.ac_sync_flop_number]
		for {set i 1} {$i < $ac_sync_flop_number} {incr i} {
			if {$ret} {
				set quai_dest [get_instances [get_fanout -from [get_instances $#ef] -tcl_list -endpoints_only] -filter {@view = "VERIFIC_DFFRS"}]
				regsub "$ff" $quai_dest "" quai_dest
				if {$quai_dest ne "" && [llength $quai_dest] ne 1} {
					red "$ff is not considered as quailifer"
					set ret 0
					continue
				} else {
					set ff $quai_dest
				}
			}
		}
		if {$quai_dest ne "" && $ret} {
			set quai_dest_qpin {*}[get_pins [get_instances $quai_dest] -filter {@name == "q"}]
				if {[get_messages -filter {@message_id = "AcUnsyncCtrlPath" && @Port1 == $quai_dest_qpin || @Pin1 == $quai_dest_qpin || @PortList1 == $quai_dest_qpin || @PinList1 == $quai_dest_qpin}] ne ""} {
					blue "$ff is what we are looking for"
				} elseif {[get_messages -filter {@message_id == "AcNoSyncScheme" && @Port1 == $quai_dest_qpin || @Pin1 == $quai_dest_qpin || @PortList1 == $quai_dest_qpin || @PinList1 == $quai_dest_qpin}] ne ""} {
					blue "$ff is what we are looking for"
				} elseif {[get_messages -filter {@message_id == "AcUnsyncDataPath" && @Port1 == $quai_dest_qpin || @Pin1 == $quai_dest_qpin || @PortList1 == $quai_dest_qpin || @PinList1 == $quai_dest_qpin}] ne ""} {
					blue "$ff is what we are looking for"
				} elseif {[get_messages -filter {@message_id == "AcSyncDataPath" && @Port1 == $quai_dest_qpin || @Pin1 == $quai_dest_qpin || @PortList1 == $quai_dest_qpin || @PinList1 == $quai_dest_qpin}] ne ""} {
					blue "$ff is what we are looking for"
				} elseif {[get_messages -filter {@message_id == "AcSyncCtrlPath" && @Port1 == $quai_dest_qpin || @Pin1 == $quai_dest_qpin || @PortList1 == $quai_dest_qpin || @PinList1 == $quai_dest_qpin}] ne ""} {
					blue "$ff is what we are looking for"
				} else {
					puts "$ff is not diff122"
					continue 
				}
		} else {
				puts "$ff is not diff122"
				continue
		}
	}
	puts "proc done"
} 

