`timescale 1ns/1ps


module tb_module_7_2
(
);


wire CE = 1;
reg CLK = 0;

always
begin
    #1 CLK = ~CLK;    
end

reg signed [17:0]A;          //z9c8u
reg signed [7:0]B;           //z4c3u
reg signed [11:0]C;          //z4c7u
reg signed [7:0]D;           //z5c2u
reg signed [13:0]E;          //z8c5u
reg signed [18:0]F;          //z9c9u
wire signed [36:0]Y;          //z21c15u

module_7_2 module_i
(
    .A(A),
    .B(B),
    .C(C),
    .D(D),
    .E(E),
    .F(F),
    .CE(CE),
    .CLK(CLK),
    .Y(Y)
);

initial begin
    
    A = 18'h00000;
    B = 8'h00;
    C = 12'h000;
    D = 8'h00;
    E = 14'h0000;
    F = 19'h00000;
    
    #10;

    // A = -100.34, B = 7.367, C = -4.92, D = 9.111, E = -99.99, F = 134.56
    @(negedge CLK);
    A = 18'h39BA9;
    B = 8'h3B;
    C = 12'hD8A;
    D = 8'h24;
    E = 14'h3380;
    F = 19'h10D1F;

    // A = 10.0, B = 2.0, C = 3.0, D = 4.0, E = 5.0, F = 6.0
    @(negedge CLK);
    A = 18'h00A00;
    B = 8'h10;
    C = 12'h0180;
    D = 8'h10;
    E = 14'h000A0;
    F = 19'h00C00;

    // A = 1.5, B = 0.25, C = -2.0, D = 3.0, E = -1.0, F = 0.5
    @(negedge CLK);
    A = 18'h00180;
    B = 8'h02;
    C = 12'h0F00;
    D = 8'h0C;
    E = 14'h03FE0;
    F = 19'h00100;

    // A = 0.0, B = 0.0, C = 0.0, D = 15.5, E = -15.5, F = 10.0
    @(negedge CLK);
    A = 18'h00000;
    B = 8'h00;
    C = 12'h000;
    D = 8'h3E;
    E = 14'h3E10;
    F = 19'h01400;

    @(negedge CLK);
    A = 18'h39BA9;
    B = 8'h3B;
    C = 12'hD8A;
    D = 8'h24;
    E = 14'h3380;
    F = 19'h10D1F;
    #20;
    $finish;
end


endmodule