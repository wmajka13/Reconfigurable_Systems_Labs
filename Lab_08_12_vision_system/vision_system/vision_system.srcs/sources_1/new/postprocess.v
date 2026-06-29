`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/16/2026 08:34:06 AM
// Design Name: 
// Module Name: preprocess
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


module postprocess(
    input [23:0] video_in,
    output [35:0] video_out
);

//RGB
// R[23:16]
// G[15:8]
// B[7:0]

//BRG
assign video_out = {video_in[7:0], 4'b0000, video_in[23:16], 4'b0000, video_in[15:8], 4'b0000};

endmodule