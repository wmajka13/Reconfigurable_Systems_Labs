module add_mult_7_1 
(
    input CLK,
    input CE,
    input [9:0]A,
    input [9:0]B,
    input [9:0]C,
    output [20:0]out
);

wire signed [10:0]AB;
wire signed [20:0]ABC;
wire signed [9:0]C_delayed;

//latency = 1
c_addsub_0 addsub_i
(
    .A(A),
    .B(B),
    .CLK(CLK),
    .CE(CE),
    .S(AB)
);

delay_line2
#(
    .N(10),
    .DELAY(1)
) delay_line_i
(
    .clk(CLK),
    .idata(C),
    .odata(C_delayed)
);

mult_gen_0 mult_gen_i
(
    .A(AB),
    .B(C_delayed),
    .CLK(CLK),
    .CE(CE),
    .P(ABC)
);

assign out = ABC;

endmodule