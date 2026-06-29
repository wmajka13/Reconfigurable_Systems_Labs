`timescale 1ns / 1ps

module tb_rgb2ycbcr;

    reg clk;
    reg vsync_in;
    reg hsync_in;
    reg de_in;
    
    reg [7:0] r_in;
    reg [7:0] g_in;
    reg [7:0] b_in;
    
    wire [23:0] rgb_pixel_in;
    wire [23:0] ycbcr_pixel_out;
    
    wire vsync_out;
    wire hsync_out;
    wire de_out;
    
    wire [7:0] cr_out;
    wire [7:0] cb_out;
    wire [7:0] y_out;

    assign rgb_pixel_in = {r_in, g_in, b_in};
    
    assign cr_out = ycbcr_pixel_out[23:16];
    assign cb_out = ycbcr_pixel_out[15:8];
    assign y_out  = ycbcr_pixel_out[7:0];

    rgb2ycbcr DUT (
        .clk(clk),
        .vsync_in(vsync_in),
        .hsync_in(hsync_in),
        .de_in(de_in),
        .rgb_pixel_in(rgb_pixel_in),
        .ycbcr_pixel_out(ycbcr_pixel_out),
        .vsync_out(vsync_out),
        .hsync_out(hsync_out),
        .de_out(de_out)
    );

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin
        vsync_in = 0;
        hsync_in = 0;
        de_in = 0;
        r_in = 8'd0;
        g_in = 8'd0;
        b_in = 8'd0;
        
        #20; 

        @(posedge clk);
        de_in = 1;
        vsync_in = 1;
        r_in = 8'd100;
        g_in = 8'd150;
        b_in = 8'd200;
        

        #100;
        
        $finish;
    end

endmodule