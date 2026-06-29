`timescale 1ns/1ps


module tb_and_or_cascade
(
);

reg [7:0] x;
reg [7:0] y;
wire z;


initial
begin
    #5;
    x = 8'b11100011;
    y = 8'b10101010;

    #10;
    x = 8'b00000000;
    y = 8'b00000000;

    #10;
    x = 8'b11111111;
    y = 8'b11111111;

    #10;
    x = 8'b10101010;
    y = 8'b01010101;

    #10;
    x = 8'b00000101;
    y = 8'b00000101;

    #10;
    x = 8'b11110000;
    y = 8'b11110000;

    #10;
    x = 8'b00000011;
    y = 8'b00000011;

    #10;
    x = 8'b01001000;
    y = 8'b01001000;

    #10;
    $finish;
end

and_or_cascade kaskada1
(
    .x(x),
    .y(y),
    .z(z)
);


endmodule