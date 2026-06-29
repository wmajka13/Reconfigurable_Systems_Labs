`timescale 1ns/1ps

module module_7_4
(
    input CLK,
    input CE,
    input [12:0]A,
    input [12:0]B,
    output [26:0]Y,
    output [26:0]Z
);

wire signed [25:0] mult0_to_add0;
wire signed [25:0] mult1_to_add0;

wire signed [25:0] mult2_to_add1;
wire signed [25:0] mult3_to_add1;

wire signed [26:0] out_add0;
wire signed [26:0] out_add1;

localparam [12:0]a00 = 13'h1FFE;      //  -0.11       z8c4u
localparam [12:0]a01 = 13'h0025;      //  2.3         z8c4u
localparam [12:0]a10 = 13'h0032;      //  3.14        z8c4u
localparam [12:0]a11 = 13'h1F4C;      //  -11.25      z8c4u

//Calculating Y
mult_gen_0 mult0
(
    .CLK(CLK),
    .CE(CE),
    .A(A),
    .B(a00),
    .P(mult0_to_add0)
);

mult_gen_0 mult1
(
    .CLK(CLK),
    .CE(CE),
    .A(B),
    .B(a01),
    .P(mult1_to_add0)
);

c_addsub_0 add0
(
    .CLK(CLK),
    .CE(CE),
    .A(mult0_to_add0),
    .B(mult1_to_add0),
    .S(out_add0)
);


//Calculating Z
mult_gen_0 mult2
(
    .CLK(CLK),
    .CE(CE),
    .A(A),
    .B(a10),
    .P(mult2_to_add1)
);

mult_gen_0 mult3
(
    .CLK(CLK),
    .CE(CE),
    .A(B),
    .B(a11),
    .P(mult3_to_add1)
);

c_addsub_0 add1
(
    .CLK(CLK),
    .CE(CE),
    .A(mult2_to_add1),
    .B(mult3_to_add1),
    .S(out_add1)
);

assign Y = out_add0;
assign Z = out_add1;

endmodule