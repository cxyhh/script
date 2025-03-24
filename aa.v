
module TOP #(
Rparameter PATH_MODE = 3,
 parameter DW = 1
 )(
 input [ 30] clk ,
 input [ 3:0] rst ,
 input [ 3:0] di_ctrl ,
 input [DW-1:0] di_0 ,
 input [DW-1:0] di_1 ,
 input [DW-1:0] di_2 ,
 input [DW-1:0] di_3 , 
 input [ 3:0] di_vld ,
 output reg [DW-1:0] do_0 ,
 output reg [DW-1:0] do_1 ,
 output reg [DW-1:0] do_2 ,
 output reg [DW-1:0] do_3 , 
 output reg [ 3:0] do_vld 
);
reg [DW-10] path_begin ;
reg [ 3:0] path_begin_vld;
reg [DW-1:0] path_end ;
Teg [ 3:0] path_end_vld ;
generate
if (PATH_MODE == 0) begin: PATH_IO
 always @(*) begin
 path_begin = di_0 ;
 path_begin_vld = di_vld ;
 end
 always @(*) begin
 do_0 = path_end ;
 do_vld = path_end_vld;
 end
end
else if (PATH_MODE == 1) begin: PATH_IR
 always @(*) begin
 path_begin = di_0 ;
 path_begin_vld = di_vld ;
 end
 always @(posedge clk[1] or negedge rst[1]) begin
 if(rst[1]=1'b0) begin
 do_0 <= 'd0 ;
 do_vld <= 'd1 ;
 end
 else begin
 do_0 <= path_end ;
 do_vld <= path_end_vld;
 end
 end 
end
else if (PATH_MODE == 2) begin: PATH_RO
 always @(p0sedge clk[0]) begin
 path_begin <= di_0 ;
 path_begin_vld <= di_vld;
 end
 always @(*) begin
 do_0 = path_end ;
 do_vld = path_end_vld;
 end 
end
else begin: PATH_RR
 always @(posedge clk[0] or negedge rst[0]) begin
 if(rst[0]==1'b0) begin
 path_begin <= 'd0 ;
 path_begin_vld <= 'd0 ;
 end
 else begin
 path_begin <= di_0 ;
 path_begin_vld<= di_vld ; 
 end 
 end
 always @(p0sedge clk[1] or negedge rst[1]) begin
 if(rst[1]==1'b0) begin
 do_0 <= 'd0 ;
 do_vld <= 'd0 ;
 end
 else begin
 do_0 <= path_end ;
 do_vld <= path_end_vld;
 end
 end 
end
endgenerate
always @(posedge clk[1] or negedge rst[1]) begin
 if(rst[1]==1'b0)begin
 path_end <= 'd0 ; 
 end
 else begin
 path_end <= path_begin ;
 end
end
endmodule
/*SGDC : 
current_design TOP
clock -name TOP.clk[0] -domain clka
clock -name TOP.clk[1] -domain clkb
reset -name rst[0] -value 0
reset -name rst[1] -value 0
albstract_port -ports di_0 -clock clk[#]
abstract_port -Ports do_0 -clock clk[1]
set_case_analysis -name "di_0" -value "1'b1"
*/
/*SDC : 
set_top -module TOP
create_clock -name TOP/clk[0] [get_ports TOP/clk[0]];assign_clock_domain -clock TOP/clk[0] -domain clka
create_clock -name TOP/clk[1] [get_ports TOP/clk[1]];assign_clock_domain -clock TOP/clk[1] -domain clkb
create_reset [get_ports TOP/rst[0]] -sense low
create_reset [get_ports TOP/rst[1]] -sense low
set_abstract_port -Ports [get_ports TOP/di_0] -clock {TOP/clk[0]}
set_abstract_port -Ports [get_ports TOP/do_0] -clock {TOP/clk[1]}
set_case_analysis 1'b1 -objects [get_ports TOP/di_0]
*/

