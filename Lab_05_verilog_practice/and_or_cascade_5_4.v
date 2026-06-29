
module and_gate
(
    input a,
    input b,
    output c
);
 
assign c = a&b;
endmodule

module or_gate
(
	input a,
	input b,
	output c
);
assign c=a|b;
endmodule

module and_or_cascade
(
    input [7:0]x,
    input [7:0]y,
    output z
);

wire [15:1] tab;

genvar i;
generate
    for (i = 1; i <= 15; i = i + 1)
    begin
        if (i >= 8)
        begin
            and_gate and_gate_i
            (
                .a(x[i % 8]),
                .b(y[i % 8]),
                .c(tab[i])
            );
        end else
        begin
            if (i >= 4)
            begin
                or_gate or_gate_i
                (
                    .a(tab[2*i]),
                    .b(tab[2*i + 1]),
                    .c(tab[i])
                );
            end else if (i >= 2)
            begin
                and_gate and_gate_i
                (
                    .a(tab[2*i]),
                    .b(tab[2*i + 1]),
                    .c(tab[i])
                );
            end else if (i == 1)
            begin
                or_gate or_gate_i
                (
                    .a(tab[2*i]),
                    .b(tab[2*i + 1]),
                    .c(tab[i])
                );
            end            
        end
    end
endgenerate

assign z = tab[1];
endmodule
