`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/16/2026 08:24:06 AM
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


module preprocess(
    input [23:0] video_in,
    output [23:0] video_out
    );

//BRG
// B[23:16]
// R[15:8]
// G[7:0]

assign video_out = {video_in[15:8], video_in[7:0], video_in[23:16]};

endmodule



