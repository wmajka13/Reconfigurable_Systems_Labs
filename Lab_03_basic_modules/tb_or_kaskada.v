`timescale 1ns/1ps


module tb_or_kaskada
(
);


reg clk=1'b0;
reg [7:0]x = 8'b0;
wire y;

always
begin
    #5 clk = ~clk;
end

always @(posedge clk)
begin
    x <= x + 1;
end


or_kaskada
#(
    .N(8)
) 

or_kaskada_i
(
    .x(x),
    .y(y)
);



endmodule