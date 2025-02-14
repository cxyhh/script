
Path: SETUP_CLOCK_005--clock_inf005_048
*/
module TOP(
 input clk1,
 input clk2,
 input clk_ctrl,
 input data_in,
 output reg data_out
);
wire wr1;
wire wr2;
wire clk_tmp;
assign wr1 = clk1;
assign wr2 = clk2;
assign clk_tmP = clk_ctrl ? wr1 : wr2;
 
always @(*) begin
 if(clk_tmp)
 data_out = data_in;
end
endmodule
/*SGDC : 
current_design TOP
clock -name TOP.clk1 -domain domain1
clock -name TOP.clk2 -domain domain2
*/
/*SDC : 
set_top -module TOP
create_clock -name TOP/clk1 [get_ports TOP/clk1];assign_clock_domain -clock TOP/clk1 -domain domain1
create_clck -name TOP/clk2 [get_ports TOP/clk2];assign_clock_domain#R-clock TOP/clk2 -domain domain2

