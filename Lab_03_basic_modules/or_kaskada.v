module or_gate
(
	input a,
	input b,
	output c
);
assign c=a|b;
endmodule

module or_kaskada
#(
    parameter N = 1 //Liczba zkaskadowanych bramek
)
(
    input [N-1:0]x,
    output y
);

wire [N:0]chain;
assign chain[0] = 0;

genvar i;
generate
    for (i = 0; i < N; i = i + 1)
    begin
        or_gate gate_i
        (
            .a(chain[i]),
            .b(x[i]),
            .c(chain[i+1])
        );
    end
endgenerate

assign y = chain[N];

endmodule
