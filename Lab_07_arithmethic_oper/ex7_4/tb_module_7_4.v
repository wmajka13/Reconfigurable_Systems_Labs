`timescale 1ns/1ps

module tb_module_7_4
(
);

reg clk = 0;
reg ce = 1;

always
begin
    #1 clk = ~clk;    
end

reg signed [12:0]A = 0;
reg signed [12:0]B = 0;

wire signed [26:0] out_y;
wire signed [26:0] out_z;

module_7_4 module_i
(
    .CLK(clk),
    .CE(ce),
    .A(A),
    .B(B),
    .Y(out_y),
    .Z(out_z)
);

initial
begin
    //1
    #5;
    A = 13'h0fff;
    B = 13'h0fff;
    #5;

    //2
    A = 13'h1000;
    B = 13'h1000;
    #5;

    //3
    A = 13'h0000;
    B = 13'h0000;
    #5;

    //4
    A = 13'h0001;
    B = 13'h1fff;
    #5;

    //5
    A = 13'h00A8;
    B = 13'h0140;
    #5;

    //6
    A = 13'h1F0C;
    B = 13'h0052;
    #5;

    //7
    A = 13'h0640;
    B = 13'h1CE0;
    #5;

    //8
    A = 13'h19C0;
    B = 13'h0320;
    #5;

    $finish;
end



endmodule