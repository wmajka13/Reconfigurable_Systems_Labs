`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/04/2026 06:54:00 PM
// Design Name: 
// Module Name: processor_tb
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


module processor_tb
(
);

// ZEGAR
reg clk=1'b0;

always 
begin
    #1 clk = ~clk;
end

// mov R2, R1 - maszynowo: 0x0011_6200
// mov Rd, Rx – odpowiedni kod maszynowy bedzie przyjmował wartosc 0x{001,Rx,6,Rd,00}.

// movi R0, 0x34 - maszynowo: 0x0016_8034
// movi Rd, imm – odpowiedni kod maszynowy bedzie przyjmował wartosc 0x{00168,Rd,imm}

// U nas wpisać coś do R0 i przepisać do R1

// movi R0, 0x34 - maszynowo: 0x0016_8034
// moc R1, R0 - maszynowo: 0x0010_6100

processor DUT
(
    .clk (clk )
);






endmodule
