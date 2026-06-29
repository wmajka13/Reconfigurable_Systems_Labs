`timescale 1ns / 1ps
//-----------------------------------------------
// Company: agh
//-----------------------------------------------
module d_mem
(
  input [7:0]address,
  output [7:0]data
);
//-----------------------------------------------
//data memory
wire [7:0]data_memory[255:0];
assign data_memory[0]=8'b00000001;
assign data_memory[1]=8'b00000010;
assign data_memory[103]=8'h66;
assign data_memory[151]=8'h77;


//-----------------------------------------------
assign data=data_memory[address];
//-----------------------------------------------
endmodule
//-----------------------------------------------
