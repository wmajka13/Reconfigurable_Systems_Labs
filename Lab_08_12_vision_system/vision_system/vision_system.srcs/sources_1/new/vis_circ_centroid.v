`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/18/2026 02:49:31 PM
// Design Name: 
// Module Name: vis_circ_centroid
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


module vis_circ_centroid
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

// ZAKRES PROMIENIA OKRĘGU PODNIESIONY DO KWADRATU
// R = 5
localparam R2_MIN = 50;      // 16
localparam R2_MAX = 75;      // 25

// OBLICZANIE WZGLĘDNEO ŚRODKA OKRĘGU
reg signed [11:0] dx; 
reg signed [11:0] dy;

always @(posedge clk)
begin
    dx <= $signed({1'b0, x_pos}) - $signed({1'b0, x});
    dy <= $signed({1'b0, y_pos}) - $signed({1'b0, y});   
end

// MNOŻARKI DO X^2 i Y^2 - LATENCJA #1
wire signed [23:0] x_2_out;
wire signed [23:0] y_2_out;

vis_circ_mult x_2 (
  .CLK(clk),            // input wire CLK
  .A(dx),               // input wire [11 : 0] A
  .B(dx),               // input wire [11 : 0] B
  .P(x_2_out)           // output wire [23 : 0] P
);

vis_circ_mult y_2 (
  .CLK(clk),            // input wire CLK
  .A(dy),               // input wire [11 : 0] A
  .B(dy),               // input wire [11 : 0] B
  .P(y_2_out)           // output wire [23 : 0] P
);

// OBLICZENIE x^2+y^2
reg signed [23:0] x2_y2;

always @(posedge clk)
begin
    x2_y2 <= x_2_out + y_2_out;
end


// OPÓŹNIENIE PIXEL_IN
wire [23:0] pixel_in_delayed;

delay_module 
#(
    .N(24),
    .DELAY(3)
) vis_circ_centroid_delay_pixel_in
(
    .clk            (clk              ),
    .signal_in      (pixel_in         ),
    .signal_delayed (pixel_in_delayed )
);

// PRZYPISANIE PIKSELA NA WYJŚCIU
reg [23:0] pixel_out;

always @(posedge clk) 
begin
    if (x2_y2 >= R2_MIN && x2_y2 <= R2_MAX)
        pixel_out <= 24'hFF0000;
    else
        pixel_out <= pixel_in_delayed;
end

assign red_pixel_out = pixel_out;

// OPÓŹNIENIE vsync, hsync, de
wire [2:0] vsync_hsync_de_delayed;

delay_module 
#(
    .N(3),
    .DELAY(4)
) vis_circ_centroid_delay_vsync_hsync_de
(
    .clk            (clk                         ),
    .signal_in      ({vsync_in, hsync_in, de_in} ),
    .signal_delayed (vsync_hsync_de_delayed      )
);

assign {vsync_out, hsync_out, de_out} = vsync_hsync_de_delayed;
 
endmodule
