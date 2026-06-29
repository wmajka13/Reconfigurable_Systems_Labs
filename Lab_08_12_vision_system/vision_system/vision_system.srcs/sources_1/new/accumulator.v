module accumulator 
(
    input clk,
    input ce,
    input rst,
    input [10:0] in, 
    output [30:0] out
);

// register width 31bits dla 1920x1080

reg [30:0] rejestr = 0;
wire [30:0] adder_to_reg;

always @(posedge clk) 
begin
    if (rst == 1'b1)
    begin
        rejestr <= 0;
    end 
    else if (ce == 1'b1)
    begin
        rejestr <= adder_to_reg;
    end
end

accumulator_adder adder
(
    .CE(ce),
    .A(in),
    .B(rejestr),
    .S(adder_to_reg)
);

assign out = rejestr;

endmodule