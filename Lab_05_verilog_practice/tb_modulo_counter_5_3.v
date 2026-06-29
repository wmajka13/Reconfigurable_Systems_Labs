`timescale 1ns/1ps

module tb_modulo_counter
(
);

localparam N1 = 9;
localparam N2 = 24;

reg clk = 1'b0;

reg rst;
reg ce;
wire [$clog2(N1)-1:0]y1;
wire [$clog2(N2)-1:0]y2;


always
begin
    #1 clk = ~clk;
end

initial
begin
    rst = 0;
    ce = 1;
    #100;
    $finish;
end

modulo_counter
#(
    .N(N1)
)
moudlo_counter1
(
    .clk(clk),
    .rst(rst),
    .ce(ce),
    .y(y1)
);

modulo_counter
#(
    .N(N2)  
)
moudlo_counter2
(
    .clk(clk),
    .rst(rst),
    .ce(ce),
    .y(y2)
);


endmodule