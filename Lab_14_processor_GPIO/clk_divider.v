`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/17/2026 07:07:28 PM
// Design Name: 
// Module Name: clk_divider
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


module clk_divider
#(
    parameter N = 500000
)
(
    input clk_in,
    output clk_out
);


//CLK wchodzący to 50mhz, my checmy 1hz, trzeba doliczyć do 50 000 000
// 20^26 - 1 = 67 108 865
reg [25:0] counter = 0;
reg clk_out_val = 0;

always @(posedge clk_in) 
begin
    if (counter == N - 1) 
    begin
        counter <= 0;
        clk_out_val <= ~clk_out_val; // Zmienia stan z 0 na 1 i z 1 na 0 co pół okresu
    end 
    else 
    begin
        counter <= counter + 1;
    end
end
assign clk_out = clk_out_val;

endmodule
