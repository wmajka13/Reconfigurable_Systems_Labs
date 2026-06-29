`timescale 1ns/1ps

module tb_serial_acc_7_3
(
);


reg ce = 0;
reg rst = 0;
reg clk = 0;
wire [21:0]y;
reg [12:0]A = 13'h0000;

always
begin
    #1 clk = ~clk;
end

serial_acc_7_3 acc_0
(
    .CLK(clk),
    .CE(ce),
    .RST(rst),
    .A(A),
    .Y(y)
);

initial
begin
    ce = 1;

    #10;
    @(posedge clk);
    A = 13'h0018;
    
    @(posedge clk);
    A = 13'h0024;

    @(posedge clk);
    A = 13'h1FCE;
    
    @(posedge clk);
    A = 13'h0040;
    
    @(posedge clk);
    A = 13'h1FF0;

    @(posedge clk);
    A = 13'h0008;
    
    @(posedge clk);
    A = 13'h1FF8;
    
    @(posedge clk);
    A = 13'h0020;
    
    @(posedge clk);
    A = 13'h0014;
    
    @(posedge clk);
    A = 13'h1FD0;

    #3;
    @(posedge clk);
    rst = 1;
    #3
    @(posedge clk);
    rst = 0;

    @(posedge clk);
    ce = 0;
    
    @(posedge clk);
    ce = 1;
    
    #3;
    $finish;

end

endmodule