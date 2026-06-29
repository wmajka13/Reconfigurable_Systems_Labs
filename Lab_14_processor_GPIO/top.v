`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/17/2026 07:05:35 PM
// Design Name: 
// Module Name: top
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


module top
(
    input clk50,
    input [3:0] sw,
    output [3:0] led
);

wire clk_out_1;

clk_divider clk_divider
(
    .clk_in  (clk50   ),
    .clk_out (clk_out_1)
);


wire [7:0] sw_ext = {4'b0000, sw};
wire [7:0] led_proc_out;

processor procesor
(
    .clk (clk_out_1 ),
    .gpi (sw_ext ),
    .gpo (led_proc_out )
);

assign led = led_proc_out[3:0];

endmodule
