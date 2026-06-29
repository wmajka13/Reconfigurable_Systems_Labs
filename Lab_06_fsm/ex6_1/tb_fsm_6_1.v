`timescale 1ns/1ps

module tb_fsm_6_1
(
);

wire rst = 1'b0;
wire txd;

reg clk = 0;
reg send = 0;
reg [7:0]data;


always
begin
    #1 clk = ~clk;
end

fsm_6_1 fsm_i
(
    .clk(clk),
    .rst(rst),
    .send(send),
    .data(data),
    .txd(txd)
);

initial
begin
    #5;
    data = 8'h33;
    #3;
    send = 1;
    #20;
    send = 0;
    #10
    $finish;

end


endmodule