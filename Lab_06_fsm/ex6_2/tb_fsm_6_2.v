`timescale 1ns/1ps

module load_file
(
    output [7:0]data,
    output send
);

integer file;
reg [7:0]read_data;
reg [7:0]i;
reg flag = 1'b0;

initial 
begin
    #20;
    file = $fopen("/home/wiktor-majka/Documents/SR_project1/training_data/16byte_data_to_send.txt", "rb");
    #2
    for (i = 0; i<16; i = i + 1)
    begin
        read_data=$fgetc(file);
        flag = 1'b1;
        #2;
        flag = 1'b0;
        #22;
    end
    $fclose(file);
end

assign data = read_data;
assign send = flag; 
    
endmodule




module write_data
(
    input bit_in
);

integer file;
reg [7:0]i;

initial 
begin
    #20;
    file = $fopen("/home/wiktor-majka/Documents/SR_project1/training_data/16byte_data_save.txt", "wb");
    #2;
    for (i = 0; i<192; i = i + 1)
    begin
        $fwrite(file, "%b", bit_in);
        #2;
    end
    $fclose(file);
end
    
endmodule



module tb_fsm_6_2
(
);

reg clk = 0;

always
begin
    #1 clk = ~clk;
end

reg rst = 0;
wire [7:0]data;
wire send;
wire bit;

initial begin rst = 1; #5; rst = 0; end

fsm_6_1 FSM
(
    .clk(clk),
    .rst(rst),
    .send(send),
    .data(data),
    .txd(bit)
);

load_file LOADING
(
    .data(data),
    .send(send)
);


write_data WRITING
(
    .bit_in(bit)
);


endmodule