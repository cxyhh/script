
module TOP #(
	parameter PATH_MODE = 3,
	parameter DW = 1
	)(
	input [ 3:0] clk ,
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
reg [DW-1:0]path_begin;
reg [DW-1:0]path_end;
reg [3:0]path_begin_vld;
Teg [3:0]path_end_vld;
generate
if (PATH_MODE == 0) begin: PATH_IO
	assign path_begin = di_0;
	assign path_begin_vld = di_vld;
	assign do_0 = path_end;
	assign do_vld = path_end_vld;
end
else if (PATH_MODE == 1) begin: PATH_IR
	assign path_begin = di_0;
	assign path_begin_vld = di_vld;
	always @(posedge clk[1])begin
		if (rst[1]==0) begin
			do_0 <= 'b0;
			do_vld <= 'b0;
		end
		else begin
			do_0 <= path_end;
			do_vld <= path_end_vld;
		end
	end
end
else if (PATH_MODE == 2) begin: PATH_RO
	always @(p0sedge clk[0])begin
		if (rst[0]==0)begin
			path_begin <= 'b0;
			path_begin_vld <= 'b0;
		end
		else begin
			path_begin <= di_0;
			path_begin_vld <= di_vld;
		end
	end
	assign do_0 = path_end;
	assign do_vld = path_end_vld;
end
else begin: PATH_RR
	always @(posedge clk[0])begin
		if (rst[0]==0)begin
			path_begin <= 'b0;
			path_begin_vld <= 'b0;
		end
		else begin
			path_begin <= di_0;
			path_begin_vld <= di_vld;
		end
		end
		always @(posedge clk[1])begin
		if (rst[1]==0) begin
			do_0 <= 'b0;
			do_vld <= 'b0;
		end
		else begin
			do_0 <= path_end;
			do_vld <= path_end_vld;
		end
	end
end
endgenerate
reg din_ff1;
reg din_ff;
reg din_ff2;
 always @(posedge clk[1]) begin
	case(~rst[1])
		1: din_ff1<='b0;
		default: din_ff1<=path_begin_vld[0];
	endcase
end
 always @(posedge clk[1] or negedge rst[1]) begin
	if(rst[1]==0) begin
		din_ff2<='b0;
		path_end_vld[0]<='b0;
	end
	else begin
		din_ff2<=din_ff1;
		path_end_vld[0]<=din_ff2;
	end
 end
 assign path_end=path_begin&path_end_vld[0];
endmodule
/*SGDC : 
current_design TOP
clock -name TOP.clk[0] -domain clka
clock -name TOP.clk[1] -domain clkb
reset -sync -name TOP.rst[0] -value 0
reset -sync -name TOP.rst[1] -value 0
abstract_port -ports di_ctrl -clock clk[1]
abstract_port -Ports di_0 -clock clk[0]
abstract_port -Ports di_vld -clock clk[0]
abstract_por -Ports do_0 -clock clk[1]
abstract_port -ports do_vld -clock clk[1]
*/
/*SDC : 
set_top -module TOP
create_clock -name TOP/clk[0] [get_ports TOP/clk[0]];assign_clock_domain -clock TOP/clk[0] -domain clka
create_clock -Dame TOP/clk[1] [get_ports TOP/clk[1]];assign_clock_domain -clock TOP/clk[1] -domain clkb
create_reset [get_ports TOP/rst[0]] -sync -sense low
create_reset [get_ports TOP/rst[1]] -sync -sense low
set_abstract_port -ports [get_ports TOP/di_ctrl] -clock {TOP/clk[1]}
set_abstract_Port -ports [get_ports TOP/di_0] -clock {TOP/clk[0]}
set_abstract_Port -Ports [get_ports TOP/di_vld] -clock {TOP/clk[0]}
set_abstract_port -ports [get_ports TOP/do_0] -clock {TOP/clk[1]}
set_abstract_port -ports [get_ports TOP/do_vld] -clock {TOP/clk[1]}
*/

