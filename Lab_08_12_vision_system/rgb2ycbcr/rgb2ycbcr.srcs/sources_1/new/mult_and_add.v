`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/07/2026 09:34:32 AM
// Design Name: 
// Module Name: mult_and_add
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module mult_and_add(
    input clk,
    input [23:0] rgb_pixel_in,
    input [17:0] R_coef,
    input [17:0] G_coef,
    input [17:0] B_coef,
    input [8:0] Add_val,
    output [8:0] Out_val
    );
    
wire signed [17:0] R = {10'd0, rgb_pixel_in[23:16]};
wire signed [17:0] G = {10'd0, rgb_pixel_in[15:8]};
wire signed [17:0] B = {10'd0, rgb_pixel_in[7:0]};
    
wire signed [35:0] R_mult_out;
wire signed [35:0] G_mult_out;
wire signed [35:0] B_mult_out;


wire signed [8:0] RG_add_out;
wire signed [8:0] RGB_add_out;
wire signed [8:0] RGB_addval_add_out;    

wire signed [8:0] B_mult_out_delayed;


mult_gen_0 R_mult (
  .CLK(clk),  // input wire CLK
  .A(R),      // input wire [17 : 0] A
  .B(R_coef),      // input wire [17 : 0] B
  .P(R_mult_out)      // output wire [35 : 0] P
);

mult_gen_0 G_mult (
  .CLK(clk),  // input wire CLK
  .A(G),      // input wire [17 : 0] A
  .B(G_coef),      // input wire [17 : 0] B
  .P(G_mult_out)      // output wire [35 : 0] P
);

mult_gen_0 B_mult (
  .CLK(clk),  // input wire CLK
  .A(B),      // input wire [17 : 0] A
  .B(B_coef),      // input wire [17 : 0] B
  .P(B_mult_out)      // output wire [35 : 0] P
);

c_addsub_0 R_add_G (
  .A(R_mult_out[25:17]),      // input wire [8 : 0] A
  .B(G_mult_out[25:17]),      // input wire [8 : 0] B
  .CLK(clk),  // input wire CLK
  .S(RG_add_out)      // output wire [8 : 0] S
);

delay_module 
#(
    .N(9),
    .DELAY(1)
)
B_delay_module
(
    .clk            (clk                ),
    .signal_in      (B_mult_out[25:17]  ),
    .signal_delayed (B_mult_out_delayed )
);

c_addsub_0 RG_add_B (
  .A(B_mult_out_delayed),      // input wire [8 : 0] A
  .B(RG_add_out),      // input wire [8 : 0] B
  .CLK(clk),  // input wire CLK
  .S(RGB_add_out)      // output wire [8 : 0] S
);

c_addsub_0 RGB_add_adder (
  .A(RGB_add_out),      // input wire [8 : 0] A
  .B(Add_val),      // input wire [8 : 0] B
  .CLK(clk),  // input wire CLK
  .S(RGB_addval_add_out)      // output wire [8 : 0] S
);


assign Out_val = RGB_addval_add_out;

endmodule
