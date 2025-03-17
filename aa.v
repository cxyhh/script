
module TOP #(
 parameter PARA = 2
)(
 input clk,
 input rst,
 input [PARA-1 : 0] proc_rel_time [1:0],
 input [PARA-1 : 0] proc_ext_time[1:0],
 
 input [4:0] cmd_type_M,
 input [PARA-1 : 0] a_time ,
 input [PARA-1 : 0] ckg_in_tmp,
 input [PARA-1 : 0] event_proc [1:0],
 input rst_n,
 input ckg_ind,
 output reg ckg_ind_1d
);
reg [PARA-1 : 0] event_proc_reftime [1:0];
wire [PARA-1 : 0] proc_wait_time [1:0];
genvar j;
generate 
 for(j = 0;j<2;j= j+ 1)begin
 always @(posedge clk or negedge rst)begin
	if(!rst)begin
		event_proc_reftime[j] <= 'd0;
 end
 else begin
	event_proc_reftime[j] <= event_proc[j];
 end
 end
 assign proc_wait_time[j] = (cmd_type_M == 5'd1) ? proc_rel_time[j]
	 : (cmd_type_M == 5'd2) ? proc_ext_time[j]
		: event_proc_reftime[j];
 end
endgenerate
wire [PARA-1 : 0] dif;
wire clk_out;
assign dif = proc_wait_time[0];
assign clk_out = (~dif) || ckg_in_tmp;
always @(posedge clk_out or negedge rst_n)begin
 if(!rst_n)begin
	ckg_ind_1d <= 1'b0;
 end
 else begin
	ckg_ind_1d <= ckg_ind;
 end
end
endmodule
/*SGDC : 
current_design TOP
clock -name clk
clock -name TOP.proc_ext_time -domain domain1
reset -name rst -value 0
reset -name rst_n -value 0
*/


/*SDC : 
set_top -module TOP
create_clock -name TOP/clk [get_ports TOP/clk];assign_clock_domain -clock TOP/clk -domain clk
create_clock -name TOP/proc_ext_time[1][1] [get_ports TOP/proc_ext_time[1][1]];assign_clock_domain -clock TOP/proc_ext_time[1][1] -domain domain1;create_clock -name TOP/proc_ext_time[1][0] [get_ports TOP/proc_ext_time[1][0]];assign_clock_domain -clock TOP/proc_ext_time[1][0] -domain domain1;create_clock -name TOP/proc_ext_time[0][1] [get_ports TOP/proc_ext_time[0][1]];assign_clock_domain -clock TOP/proc_ext_time[0][1] -domain domain1;create_clock -name TOP/proc_ext_time[0][0] [get_ports TOP/proc_ext_time[0][0]];assign_clock_domain -clock TOP/proc_ext_time[0][0] -domain domain1
create_reset [get_ports TOP/rst] -sense low
create_reset [get_ports TOP/rst_n] -sense low


