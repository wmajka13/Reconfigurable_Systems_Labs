`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/12/2026 12:02:02 PM
// Design Name: 
// Module Name: zad51
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


module long_and #
(
    parameter LENGTH=8
)
(
input [LENGTH-1:0]x,
output y
);

wire [LENGTH:0]chain;
assign chain[0]=1'b1;

genvar i;
generate
    for(i=0;i<LENGTH;i=i+1)
    begin
    
    assign chain[i+1] = x[i] & chain[i];
    
    end
endgenerate
assign y=chain[LENGTH];
endmodule

