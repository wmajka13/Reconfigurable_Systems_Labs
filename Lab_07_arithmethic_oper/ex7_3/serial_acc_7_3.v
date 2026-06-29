`timescale 1ns/1ps


module serial_acc_7_3 
(
    input CLK,
    input CE,
    input RST,
    input [12:0]A,        //z8c4u
    output [21:0]Y
);

//You can add 2^13-1 * 256 times
// log2((2^13 -1) * 256) == 20.99 = 21
// add sign bit: 21 + 1 = 22 bits - register width

reg signed [21:0] rejestr = 0;
wire signed [21:0] adder_to_reg;

always @(posedge CLK) 
begin
    if (RST == 1'b1)
    begin
        rejestr <= 0;
    end 
    else if (CE == 1'b1)
    begin
        rejestr <= adder_to_reg;
    end
end

c_addsub_0 adder
(
    // .CLK(CLK),
    // .CE(CE),
    .A(A),
    .B(rejestr),
    .S(adder_to_reg)
);

assign Y = rejestr;

endmodule