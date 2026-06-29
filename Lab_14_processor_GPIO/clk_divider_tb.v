`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/17/2026 07:20:57 PM
// Design Name: 
// Module Name: clk_divider_tb
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


module clk_divider_tb
(
);

reg clk_in = 0;

always
begin
    #10 clk_in = ~clk_in;    
end


clk_divider DUT
(
    .clk_in  (clk_in  ),
    .clk_out (clk_out )
);

wire clock_out;
assign clock_out = clk_out;


endmodule
