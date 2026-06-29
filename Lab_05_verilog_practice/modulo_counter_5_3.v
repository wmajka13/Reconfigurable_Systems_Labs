module modulo_counter 
#(
    parameter N = 32,
    parameter WIDTH = $clog2(N)
)
(
    input clk,
    input ce,
	input rst,
    output [WIDTH-1:0]y
);

reg [WIDTH-1:0] val = 0;

always @(posedge clk)
begin
    if(rst == 1)
    begin
        val <= 0;
    end else
    begin
        if(ce == 1)
        begin
            if (val == N-1)
            begin
                val <= 0;   
            end else
            begin
                val <= val + 1;
            end
        end
    end
end

assign y = val;
    
endmodule