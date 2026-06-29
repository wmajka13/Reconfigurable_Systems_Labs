`timescale 1ns/1ps

module tb_or_gate_6_3
(
);

reg [9:0]i = 0;
integer iter = 0;
wire o;
integer file;

initial
begin
    file = $fopen("10in_or_gate_logs.txt", "w");        
    #2;
    for (iter = 0; iter < 1024; iter = iter + 1)
    begin
        i = iter;
        #2;
        if (o !== (iter[0]|iter[1]|iter[2]|iter[3]|iter[4]|iter[5]|iter[6]|iter[7]|iter[8]|iter[9]))
        begin
            $fwrite(file, "%b\n", i);
        end
    end

    $fclose(file);
    $finish;
end


or_gate or_gate_i
(
    .i(i),
    .o(o)
);

endmodule