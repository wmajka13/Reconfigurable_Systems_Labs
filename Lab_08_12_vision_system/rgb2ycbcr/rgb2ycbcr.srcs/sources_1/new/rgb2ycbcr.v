`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/07/2026 08:29:05 AM
// Design Name: 
// Module Name: rgb2ycbcr
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


module rgb2ycbcr(
    input clk,
    input vsync_in,
    input hsync_in,
    input de_in,
    input [23:0] rgb_pixel_in,
    
    output [23:0] ycbcr_pixel_out,
    output vsync_out,
    output hsync_out,
    output de_out
    );


//    '09917   12c8b   03a5e'
//    '3a99b   35665   10000'
//    '10000   329a2   3d65e'


wire signed [17:0] Y_R_coef = 18'h09917;
wire signed [17:0] Y_G_coef = 18'h12c8b;
wire signed [17:0] Y_B_coef = 18'h03a5e;

wire signed [17:0] Cb_R_coef = 18'h3a99b;
wire signed [17:0] Cb_G_coef = 18'h35665;
wire signed [17:0] Cb_B_coef = 18'h10000;

wire signed [17:0] Cr_R_coef = 18'h10000;
wire signed [17:0] Cr_G_coef = 18'h329a2;
wire signed [17:0] Cr_B_coef = 18'h3d65e;

wire signed [8:0] Y_add_val = 9'd0;
wire signed [8:0] Cb_add_val = 9'd128;
wire signed [8:0] Cr_add_val = 9'd128;

wire signed [8:0] Y;
wire signed [8:0] Cb;
wire signed [8:0] Cr;

wire [2:0] sync_in_concat = {de_in, hsync_in, vsync_in};
wire [2:0] sync_out_concat;

localparam modules_delay = 4;

mult_and_add Y_calcs(
    .clk          (clk            ),
    .rgb_pixel_in (rgb_pixel_in   ),
    .R_coef       (Y_R_coef       ),
    .G_coef       (Y_G_coef       ),
    .B_coef       (Y_B_coef       ),
    .Add_val      (Y_add_val      ),
    .Out_val      (Y              )
);

mult_and_add Cb_calcs(
    .clk          (clk            ),
    .rgb_pixel_in (rgb_pixel_in   ),
    .R_coef       (Cb_R_coef      ),
    .G_coef       (Cb_G_coef      ),
    .B_coef       (Cb_B_coef      ),
    .Add_val      (Cb_add_val     ),
    .Out_val      (Cb             )
);

mult_and_add Cr_calcs(
    .clk          (clk            ),
    .rgb_pixel_in (rgb_pixel_in   ),
    .R_coef       (Cr_R_coef      ),
    .G_coef       (Cr_G_coef      ),
    .B_coef       (Cr_B_coef      ),
    .Add_val      (Cr_add_val     ),
    .Out_val      (Cr             )
);

delay_module 
#(
    .N(3),
    .DELAY(modules_delay)
) 
Syncs_delay_module
(
    .clk            (clk             ),
    .signal_in      (sync_in_concat  ),
    .signal_delayed (sync_out_concat )
);


assign ycbcr_pixel_out = {Cr[7:0], Cb[7:0], Y[7:0]};
assign {de_out, hsync_out, vsync_out} = sync_out_concat;


endmodule
