module single_register
#(
    parameter N = 0
)
(
    input clk,
    input [N-1:0]d,
    output [N-1:0]q
);

reg [N-1:0]val = 0;

always @(posedge clk) 
begin
    val <= d;
end

assign q = val;

endmodule


module delay_line2
#(
    parameter N = 1,
    parameter DELAY = 0
)
(
    input clk,
    input [N-1:0]idata,
    output [N-1:0]odata
);

wire [N-1:0] tdata[DELAY:0];

assign tdata[0] = idata;

genvar i;
generate
    for (i = 0; i < DELAY; i = i + 1)
    begin
    
        single_register 
        #(
            .N(N)
        )
        single_delay
        (
            .clk(clk),
            .d(tdata[i]),
            .q(tdata[i+1])
        );
    end
endgenerate

assign odata = tdata[DELAY];

endmodule