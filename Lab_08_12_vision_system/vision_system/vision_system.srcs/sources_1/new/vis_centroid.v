`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/17/2026 03:09:19 PM
// Design Name: 
// Module Name: vis_centroid
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


module vis_centroid
#(
    parameter IMG_H = 64,
    parameter IMG_W = 64
)
(
    input clk,
    
    input hsync_in,
    input vsync_in,
    input de_in,
    input [23:0] pixel_in,

    input [10:0] x,
    input [10:0] y,

    output hsync_out,
    output vsync_out,
    output de_out,
    output [23:0] red_pixel_out
);

// POZYCJA AKTUALNIE PRZETWARZANEGO PIKSELA
reg [10:0] x_pos = 0;
reg [10:0] y_pos = 0;

//WYLICZANIE POZYCJI PIKSELA
always @(posedge clk)
begin
    if (vsync_in == 1)
    begin
        x_pos <= 0 ;   
        y_pos <= 0;
    end else if (de_in == 1)
        begin
            x_pos <= x_pos + 1;
            if (x_pos == IMG_W - 1) 
            begin
                x_pos <= 0;
                y_pos <= y_pos + 1;
                if (y_pos == IMG_H - 1) y_pos <= 0;
            end
        end
end


assign hsync_out = hsync_in;
assign vsync_out = vsync_in;
assign de_out = de_in;

  
assign red_pixel_out = ((x_pos == x || y_pos == y) ? 24'hFF0000 : pixel_in);


endmodule
