module TOP (
input din,
input clk,
output dout_const,
output dout_din
);
SUB_1 SUB_ins ( .din(din), .clk(clk), .dout_const(dout_const), .dout_din(dout_din));
endmodule
module SUB_1 (
input din,
input clk,
output dout_const,
output dout_din
);
SUB_2 sub_2_ins ( .din(din), .clk(clk), .dout_const(dout_const), .dout_din(dout_din) );
endmodule
module SUB_2 (
input din,
input clk,
output dout_const,
output dout_din
);
din_dff din_DFF_hier_3 ( .din(din), .clk(clk), .dout(dout_din) );
const_dff const_DFF_hier3 ( .clk(clk), .dout(dout_const) );
endmodule

module din_dff (
input din,
input clk,
output dout
);
reg DFF;
always@(posedge clk)begin
DFF <= din;
end
assign dout = DFF;
endmodule
module const_dff (
input clk,
output dout
);
reg DFF;
always@(posedge clk)begin
DFF <= 1'b0;
end
assign dout = DFF;
endmodule
