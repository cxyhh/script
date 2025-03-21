
*/
module TOP(
 input clk,
 input din,
 input data_in,
 output reg data_out
);
wire clk_tmp;
always @(posedge clk_tmp) begin
 data_out <= data_in;
end
TOP_FI U_TOP_FI(
 .clk(clk),
 .din(din),
 .dout(clk_tmp)
);
endmodule
module TOP_FI(
 input clk,
 input din,
 output reg dout
);
assign dout = clk & din;
endmodule
/*SGDC : 
current_design TOP
clock -name TOP.clk -domain domain1
clock -name TOP.U_TOP_FI.din -domain domain2
*/
/*SDC : 
set_top -module TOP
create_clock -name TOP/clk [get_ports TOP/clk];assign_clock_domain -clock TOP/clk -domain domain1
create_clock -name TOP/U_TOP_FI/din [get_pins TOP/U_TOP_FI/din];assign_clock_domain -clock TOP/U_TOP_FI/din -domain domain2
*/

