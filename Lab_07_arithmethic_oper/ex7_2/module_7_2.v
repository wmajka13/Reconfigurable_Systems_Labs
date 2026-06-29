`timescale 1ns/1ps


module module_7_2
(
    input CLK,
    input CE,
    input [17:0]A,          //z9c8u
    input [7:0]B,           //z4c3u
    input [11:0]C,          //z4c7u
    input [7:0]D,           //z5c2u
    input [13:0]E,          //z8c5u
    input [18:0]F,          //z9c9u
    output [36:0]Y          //z21c15u
);

wire signed [12:0]B_ext = {B, 5'b00000 };
wire signed [10:0]D_ext = {D, 3'b000 };
wire signed [17:0]E_ext = {E, 4'b0000 };


wire signed [18:0]addAB;
wire signed [11:0]delC;
wire signed [14:0]addDE;
wire signed [19:0]addEF;
wire signed [30:0]multABC;
wire signed [34:0]multDEEF;

wire signed [35:0]multDEEF_ext = {multDEEF, 1'b0 };

wire signed [36:0]out;

c_addsub_AB0 add0_AB
(
    .CLK(CLK),
    .CE(CE),
    .A(A),
    .B(B_ext),
    .S(addAB)
);

delay_line2
#(
    .N(12),
    .DELAY(1)
) delay_line_i
(
    .clk(CLK),
    .idata(C),
    .odata(delC)
);

c_addsub_DE1 add1_DE
(
    .CLK(CLK),
    .CE(CE),
    .A(D_ext),
    .B(E),
    .S(addDE)
);

c_addsub_EF2 add2_EF
(
    .CLK(CLK),
    .CE(CE),
    .A(E_ext),
    .B(F),
    .S(addEF)
);

mult_gen_AB_C mult0_AB_C
(
    .CLK(CLK),
    .CE(CE),
    .A(addAB),
    .B(delC),
    .P(multABC)
);


mult_gen_DE_EF mult1_DE_EF
(
    .CLK(CLK),
    .CE(CE),
    .A(addDE),
    .B(addEF),
    .P(multDEEF)
);



c_addsub_Y3 add3_Y
(
    .CLK(CLK),
    .CE(CE),
    .A(multABC),
    .B(multDEEF_ext),
    .S(out)
);

assign Y = out;


endmodule