`timescale 1ns/1ps

module tb_add_mult_7_1
(
);

reg CLK = 0;
wire signed CE = 1;
reg signed [9:0]A = 0;
reg signed [9:0]B = 0;
reg signed [9:0]C = 0;
wire signed [20:0]out;

always
begin
    #1 CLK = ~CLK;
end


add_mult_7_1 add_mult_7_1_i 
(
    .CLK(CLK),
    .CE(CE),
    .A(A),
    .B(B),
    .C(C),
    .out(out)
);

initial
begin
#10;

A = 83;
B = -202;
C = 145;

#10;
$finish;

end

endmodule