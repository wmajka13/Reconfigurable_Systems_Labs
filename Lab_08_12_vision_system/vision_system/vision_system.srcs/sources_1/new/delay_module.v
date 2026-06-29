`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/07/2026 09:50:19 AM
// Design Name: 
// Module Name: delay_module
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


module delay_module
#(
    parameter N = 8,
    parameter DELAY = 1
)
(    
    input wire clk,
    input wire [N-1:0] signal_in,
    output wire [N-1:0] signal_delayed
);

reg [N-1:0] shift_reg [0:DELAY-1];
integer i;

always @(posedge clk) begin
    
    shift_reg[0] <= signal_in;
    
    for (i = 0; i < DELAY-1; i = i + 1) begin
        shift_reg[i+1] <= shift_reg[i];
    end
end

assign signal_delayed = shift_reg[DELAY-1];

endmodule