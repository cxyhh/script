
set clkList [concat $clkList [lindex $value_list 1]]
set clkList [regsub -all {\\} $clkList {#}]
set clkList [regsub -all { \.} $clkList {=}]
set clkList [regsub -all {=} $clkList { .}]
set clkList [regsub -all {#} $clkList {\\}]

