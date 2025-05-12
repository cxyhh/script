
+++++++utils.tcl+++++
 if {[string match "Ac_sync*" $rulename] || [string match "Ac_unsync*" $rulename]} {
++++++msgobjmap.txt+++++
ChySameSrcConvIncSeq {Port1 PinPort1 PortList1 PinPort1 Pin1 PinPort1 PinList1 PinPort1 Net4 Net4 ClockList2 ClockList2 ClockList3 ClockList3} 
ChySameSrcConvExcSeq {Port1 PinPort1 PortList1 PinPort1 Pin1 PinPort1 PinList1 PinPort1 Net4 Net4 ClockList2 ClockList2 ClockList3 ClockList3}
++++++setup.tcl++++++++
set clocklist2 {*}[lsort [dict get $eToolMessageObj ClockList2]]
set clocklist3 {*}[lsort [dict get $eToolMessageObj ClockList3]]
set dst_clk {*}[lindex $csv_objs 1]
set src_clk {*}[lindex $csv_objs 2]
+++++main.tcl++i
if {[regexp "\\s+" $first_item && [regexp "\\." $first_item]} {
		set tmpList [split $first_item]
		set objTmp [join [lrange $tmpList 1 end] ""]
		set destName [concat $objTmp [lindex [dict get $msg objList] 1]]
		lappend mBody ${destName}_[lindex [dict get $msg objList] 1]
		set mBody_patch "${destName}_${rulename}"
} else {
		set mBody "[lindex [dict get $msg objList] 1]_[lindex [ dict get $msg objList] 4]"
		set destName [lindex [lrange [dict get $msg objList] 1 1] 0]
		set mBody_patch "${destName}_${rulename}"
}
#in order to deal with dest/src like TOP.a .\b.c [3:0]
set mBody ${mBody}_${rulename}
if {![dict exists $lineNumDict $mBody]} {
 ·...
}


	set objs "[dict get $sToolMsgObj DestName]_[dict get $sToolMsgObj SourceName]_${rulename}"
	#set objs [string map {" " ""} $objs]
++++++diff_setup.tcl++++++
 } elseif {[string first "incorrectly constrained" ${status}] != -1} { 
		set msg_id "SetupPort_incorrectly"
}
++++++compare_and#write_csv++++
set clk [self_get_clocks $clk]
if {$clk eq ""} {
set clk [self_get_clocks [self_get_nets $clk]]
}
if {$clk eq ""} {
set clk [self_get_nets $clk]
}
set clk [lsort $clk]
lappend sd_key $clk

