`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/12/2026 12:14:01 PM
// Design Name: 
// Module Name: tb_long_and
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


module tb_long_and
(
);

reg clk=1'b0;
reg [7:0]cnt=8'b00000000;
wire y;



initial
begin
    while(1)
    begin
        #1; clk=1'b0;
        #1; clk=1'b1;
     end
end

always @(posedge clk)
begin
    cnt<=cnt+1;
end

long_and inst
(
    .x(cnt),
    .y(y)
);
endmodule