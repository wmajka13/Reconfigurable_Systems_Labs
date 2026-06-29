`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/16/2026 08:39:06 AM
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

module vision_system (
    input clk,
    input de_in,
    input hsync_in,
    input vsync_in,
    input [23:0] pixel_in,

    input [3:0] sw,
    
    output de_out,
    output hsync_out,
    output vsync_out,
    output [23:0] pixel_out
);


// WYMIARY OBRAZU!!!
// DLA 64x64
// localparam IMG_H = 64;
// localparam IMG_W = 64;
// localparam H_SIZE = 83;

// DLA 1920x1089
localparam IMG_H = 1080;
localparam IMG_W = 1920;
localparam H_SIZE = 2200;


wire [23:0]rgb_mux[15:0];
wire de_mux[15:0];
wire hsync_mux[15:0];
wire vsync_mux[15:0];


// MULTIPLEKSER[0] - CZYSTY OBRAZ -                                 BRAK SW     ODDANE 
// MULTIPLEKSER[1] - YCbCr -                                        SW1         ODDANE
// MULTIPLEKSER[2] - ZBINARYZOWANY OBRAZ -                          SW2         ODDANE
// MULTIPLEKSER[3] - FILTRACJA KONTEKSTOWA - MASKA MEDIANOWA -      SW1 SW2     ODDANE
// MULTIPLEKSER[4] - WYRYSOWYWANIE ŚRODKA CIĘŻKOŚCI - KRZYŻYK -     SW3         
// MULTIPLEKSER[5] - WYRYSOWYWANIE ŚRODKA CIĘŻKOŚCI - OKRĄG         SW1 SW3
// MULTIPLEKSER[6] - OTWARCIE -                                     SW2 SW3


// PRZYPISANIE WYJŚĆ DO WYBORU KANAŁU MULTIPLEKSERA SWITCH'ami
assign pixel_out = rgb_mux[sw];
assign de_out = de_mux[sw];
assign hsync_out = hsync_mux[sw];
assign vsync_out = vsync_mux[sw];


// MULTIPLEKSER[0] - CZYSTY OBRAZ - BRAK SW
assign rgb_mux[0]   = pixel_in;
assign de_mux[0]    = de_in;
assign hsync_mux[0] = hsync_in;
assign vsync_mux[0] = vsync_in;

// MULTIPLEKSER[1] - YCbCr - SW1
rgb2ycbcr_0 RGB_to_YCbCr (
    .clk(clk),                          // input wire clk

    .vsync_in(vsync_mux[0]),            // input wire vsync_in
    .hsync_in(hsync_mux[0]),            // input wire hsync_in
    .de_in(de_mux[0]),                  // input wire de_in
    .rgb_pixel_in(rgb_mux[0]),          // input wire [23 : 0] rgb_pixel_in

    .ycbcr_pixel_out(rgb_mux[1]),       // output wire [23 : 0] ycbcr_pixel_out
    .vsync_out(vsync_mux[1]),           // output wire vsync_out
    .hsync_out(hsync_mux[1]),           // output wire hsync_out
    .de_out(de_mux[1])                  // output wire de_out
);


// MULTIPLEKSER[2] - ZBINARYZOWANY OBRAZ - SW2
//BINARYZACJA
//ycbcr_pixel_out = {Y[7:0], Cb[7:0], Cr[7:0]};

localparam Ta = 8'd77;
localparam Tb = 8'd127;
localparam Tc = 8'd133;
localparam Td = 8'd173;

wire [7:0] Cb;
wire [7:0] Cr;
wire [7:0] bin;

assign Cb = rgb_mux[1][15:8];
assign Cr = rgb_mux[1][7:0];
assign bin = (Cb > Ta && Cb < Tb && Cr > Tc && Cr < Td) ? 8'd255 : 0;


assign rgb_mux[2]   = {bin, bin, bin};
assign de_mux[2]    = de_mux[1];
assign hsync_mux[2] = hsync_mux[1];
assign vsync_mux[2] = vsync_mux[1];


// MULTIPLEKSER[3] - FILTRACJA KONTEKSTOWA - MASKA MEDIANOWA - SW1 SW2
wire [7:0] median5x5_byte_out;

median5x5 
#(
    .H_SIZE(H_SIZE)

) u_median5x5
(
    .clk           (clk           ),
    .hsync_in      (hsync_mux[2]  ),
    .vsync_in      (vsync_mux[2]  ),
    .de_in         (de_mux[2]     ),
    .bit_pixel_in  (rgb_mux[2][0] ),

    .hsync_out     (hsync_mux[3]  ),
    .vsync_out     (vsync_mux[3]  ),
    .de_out        (de_mux[3]     ),
    .byte_pixel_out (median5x5_byte_out)
);

assign rgb_mux[3] = {median5x5_byte_out, median5x5_byte_out, median5x5_byte_out};

// WYLICZANIE ŚRODKA CIĘŻKOŚCI
wire [10:0] x_out_centroid;
wire [10:0] y_out_centroid;


centroid 
#(
    .IMG_H(IMG_H),
    .IMG_W(IMG_W)

) u_centroid
(
    .clk   (clk   ),
    .hsync (hsync_mux[3] ),
    .vsync (vsync_mux[3] ),
    .de    (de_mux[3]    ),
    .mask  (rgb_mux[3][0]),
    .x     (x_out_centroid),
    .y     (y_out_centroid)
);

// MULTIPLEKSER[4] - WYRYSOWYWANIE ŚRODKA CIĘŻKOŚCI - KRZYŻYK - SW3
vis_centroid 
#(
    .IMG_H(IMG_H),
    .IMG_W(IMG_W)

) u_vis_centroid
(
    .clk           (clk           ),
    .hsync_in      (hsync_mux[3]  ),
    .vsync_in      (vsync_mux[3]  ),
    .de_in         (de_mux[3]     ),
    .pixel_in      (rgb_mux[3]    ),

    .x             (x_out_centroid),
    .y             (y_out_centroid),

    .hsync_out     (hsync_mux[4]  ),
    .vsync_out     (vsync_mux[4]  ),
    .de_out        (de_mux[4]     ),
    .red_pixel_out (rgb_mux[4]    )
);

// MULTIPLEKSER[5] - WYRYSOWYWANIE ŚRODKA CIĘŻKOŚCI - OKRĄG SW1 SW3
vis_circ_centroid 
#(
    .IMG_H(IMG_H),
    .IMG_W(IMG_W)

) u_vis_circ_centroid
(
    .clk           (clk           ),
    .hsync_in      (hsync_mux[3]  ),
    .vsync_in      (vsync_mux[3]  ),
    .de_in         (de_mux[3]     ),
    .pixel_in      (rgb_mux[3]    ),

    .x             (x_out_centroid),
    .y             (y_out_centroid),

    .hsync_out     (hsync_mux[5]  ),
    .vsync_out     (vsync_mux[5]  ),
    .de_out        (de_mux[5]     ),
    .red_pixel_out (rgb_mux[5]    )
);




// OBLICZANIE OTWARCIA
wire erosion_hsync_out;
wire erosion_vsync_out;
wire erosion_de_out;
wire [7:0] erosion_byte_out;

erosion 
#(
    .H_SIZE(H_SIZE)

) u_erosion
(
    .clk           (clk           ),

    .hsync_in      (hsync_mux[2]  ),
    .vsync_in      (vsync_mux[2]  ),
    .de_in         (de_mux[2]     ),
    .bit_pixel_in  (rgb_mux[2][0] ),
    
    .hsync_out      (erosion_hsync_out),
    .vsync_out      (erosion_vsync_out),
    .de_out         (erosion_de_out   ),
    .byte_pixel_out (erosion_byte_out )
);

// MULTIPLEKSER[6] - OTWARCIE - SW2 SW3
wire [7:0] dilation_byte_out;

dilation 
#(
    .H_SIZE(H_SIZE)

) u_dilation
(
    .clk                (clk                 ),
    
    .hsync_in          (erosion_hsync_out   ),
    .vsync_in          (erosion_vsync_out   ),
    .de_in             (erosion_de_out      ),
    .bit_pixel_in      (erosion_byte_out[0] ),

    .hsync_out          (hsync_mux[6]        ),
    .vsync_out          (vsync_mux[6]        ),
    .de_out             (de_mux[6]           ),
    .byte_pixel_out     (dilation_byte_out   )
);

assign rgb_mux[6] = {dilation_byte_out, dilation_byte_out, dilation_byte_out};


endmodule