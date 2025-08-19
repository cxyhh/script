module TOP (
	input clk,rst,clkb,
	input [2：0]d,
	input [2:0]d1,
	output reg [2:0]out,
	output reg [2:0]out1,
	output reg [2:0]out2
	);
	wire core_clk;
	wire [2:0] U_BB_cfg_rst;
	wire U_EPE_RST;
	always @(posedge clk or negedeg rst) begin
		if (!rst) begin
			out <= 1'b0;
		end
		else begin
			out <= d;
		end
	end
	
BB U_BB (.clk(clkb),.A(1'b0),.core_clk(core_clk));
BB_cfg U_BB_cfg (.clk(clkb),.A(1'b0),.rst(U_BB_cfg_rst));

always @(posedge core_clk) begin
	out1 <= d1;
end
assign U_EPE_RST =U_BB_cfg_rst[0];
RBB U_RBB(.rst(U_EPE_RST), .in (1'b0), .out(out2));
endmodule
module BB_cfg(
input clk,A,
output [2:0]rst
);
endmodule

current design TOP
clock -name clk
clock -name clkb
reset -name TOP.U_BB_cfg.rst-value 0 -async
input -name d[0] -clock clk
input -name d[1] -clock clk
output -name out[1] -clock clk

set top -module TOP
create_clock -name clk [get_ports TOP/clk]
create_clock -name clkb [get_ports TOP/clkb]
create_reset -name TOP/U_BB_cfg/rst [get pins TOP/U_BB_cfg/rst] -async -sense low
set abstract port -ports [get_ports TOP/d[0] -clock clk 
set abstract port -ports [get ports TOP/d[1] -clock clk
set abstract port -ports [get ports TOP/out[1]]-clock clk
