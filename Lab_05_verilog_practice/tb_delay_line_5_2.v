`timescale 1ns/1ps


module tb_delay_line2
(
);

reg clk = 1'b0;

always 
begin
    #1 clk = ~clk;
end

localparam N1 = 2;
localparam N2 = 2;
localparam N3 = 2;

localparam DELAY1 = 0;
localparam DELAY2 = 1;
localparam DELAY3 = 3;

reg [N1-1:0]idata1 = 2'b0;
reg [N2-1:0]idata2 = 2'b0;
reg [N3-1:0]idata3 = 2'b0;

wire [N1-1:0]odata1;
wire [N2-1:0]odata2;
wire [N3-1:0]odata3;
reg [1:0] counter = 0;




initial     
begin
    idata1 = 0;
    idata2 = 0;
    idata3 = 0;

    #2;
end

always @(posedge clk) 
begin
    counter = counter + 1;
    idata1 = counter;
    idata2 = counter;
    idata3 = counter; 
end

delay_line2
#(
    .N(N1),
    .DELAY(DELAY1)
)
delay_line2_inst1
(
    .clk(clk),
    .idata(idata1),
    .odata(odata1)
);

delay_line2
#(
    .N(N2),
    .DELAY(DELAY2)
)
delay_line2_inst2
(
    .clk(clk),
    .idata(idata2),
    .odata(odata2)
);


delay_line2
#(
    .N(N3),
    .DELAY(DELAY3)
)
delay_line2_inst3
(
    .clk(clk),
    .idata(idata3),
    .odata(odata3)
);


endmodule
