`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/31/2026 07:22:37 PM
// Design Name: 
// Module Name: processor
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module processor
(
    input clk
);

// MULTIPLEXERS
wire [7:0] rd_mux [1:0];
wire [7:0] pc_mux [1:0];

wire [7:0] rx_mux [7:0];
wire [7:0] ry_mux [7:0];
wire [7:0] imm_mux [1:0];

wire [7:0] alu_mux [3:0];

// MULTIPLEXERS OUTPUTS
wire [7:0] rd_mux_out;
wire [7:0] pc_mux_out;

wire [7:0] rx_mux_out;
wire [7:0] ry_mux_out;
wire [7:0] imm_mux_out;

wire [7:0] alu_res;

// OTHER OUTPUTS
wire [7:0] data_mem_out;
wire [7:0] pc_addr;
wire [7:0] cmp_res;
wire jump_con;


// REGISTERES
reg [7:0] r0 = 8'b0;
reg [7:0] r1 = 8'b0;
reg [7:0] r2 = 8'b0;
reg [7:0] r3 = 8'b0;
reg [7:0] r4 = 8'b0;
reg [7:0] r5 = 8'b0;
reg [7:0] r6 = 8'b0;
reg [7:0] r7_pc = 8'b0;


// INSTRUCTION MEMORY
wire [31:0] instr;

wire [1:0] pc_op;
wire [1:0] alu_op;
wire [2:0] rx_op;
wire imm_op;
wire [2:0] ry_op;
wire rd_op;
wire [2:0] d_op;
wire [7:0] imm;

i_mem instr_mem
(
    .address (r7_pc ),
    .data    (instr )
);

assign imm =    instr[7:0];
assign d_op =   instr[10:8];
assign rd_op =  instr[11];
assign ry_op =  instr[14:12];
assign imm_op = instr[15];
assign rx_op =  instr[18:16];
assign alu_op = instr[21:20];
assign pc_op =  instr[25:24];


// DATA MEMORY

d_mem data_mem
(
    .address (alu_res),
    .data    (data_mem_out   )
);


// RD_MUX
assign rd_mux[0] = alu_mux[alu_op];
assign rd_mux[1] = data_mem_out;

assign rd_mux_out = rd_mux[rd_op];


// PC_MUX
assign pc_mux[0] = alu_mux[alu_op];
assign pc_mux[1] = pc_addr + 1;

assign pc_mux_out = pc_mux[jump_con];


// DECODER/REGISTERS PROCESS
always @(posedge clk) 
begin
    case (d_op)
        0:  r0 <= rd_mux[rd_op];
        1:  r1 <= rd_mux[rd_op];
        2:  r2 <= rd_mux[rd_op];
        3:  r3 <= rd_mux[rd_op];
        4:  r4 <= rd_mux[rd_op];
        5:  r5 <= rd_mux[rd_op];
        default:  r6 <= 8'b0;
    endcase
        r6 <= 8'b0;
        r7_pc <= pc_mux_out;
end

assign pc_addr = r7_pc;


// JUMP CONDITION
// **`pc_op`: (2bity) Steruje rejestrem R7 - PC. Przekazuje sygnał do bloku "warunek skoku" i 
// multipleksera `pc_mux`, decydując, czy pobrać kolejną instrukcję z rzędu (+1), czy wykonać skok.

// `jnz` (jump if not zero) - skok do adresu z alu_res, gdy wartość porównywana na komparatorze nie wynosi zero, 
// pc_mux[0], pc_op = 3 (11), cmp_res = 0

// `jz` (jump if zero) - skok do adresu z alu_res, gdy wartość na komparatorze wynosi zero.
// pc_mux[0], pc_op = 2 (10), cmp_res = 1

// `jump` - skok bezwarunkowy do adresu danego przez wartość na linii `alu_res`, 
// pc_mux[0],  pc_op = 1 (01), cmp_res = _

// else
// pc_mux[1], pc_op = 0 (00), cmp_res = _

assign jump_con = (pc_op == 2'b00) ? 1'b1 :                          // ZWYKŁE ZWIĘKSZENIE PC O 1
                  (pc_op == 2'b01) ? 1'b0 :                          // SKOK BEZWARUNKOWY
                  (pc_op == 2'b10 && cmp_res == 1'b1) ? 1'b0 :       // SKOK WARUNKOWY IF ZERO
                  (pc_op == 2'b11 && cmp_res == 1'b0) ? 1'b0 :       // SKOK WARUNKOWY IF NOT ZERO
                                                        1'b1;


// RX_OP
assign rx_mux[0] = r0;
assign rx_mux[1] = r1;
assign rx_mux[2] = r2;
assign rx_mux[3] = r3;
assign rx_mux[4] = r4;
assign rx_mux[5] = r5;
assign rx_mux[6] = r6;
assign rx_mux[7] = r7_pc;

assign rx_mux_out = rx_mux[rx_op];


// RY_OP
assign ry_mux[0] = r0;
assign ry_mux[1] = r1;
assign ry_mux[2] = r2;
assign ry_mux[3] = r3;
assign ry_mux[4] = r4;
assign ry_mux[5] = r5;
assign ry_mux[6] = r6;
assign ry_mux[7] = r7_pc;

assign ry_mux_out = ry_mux[ry_op];


// IMM_MUX
assign imm_mux[0] = ry_mux_out; 
assign imm_mux[1] = imm;

assign imm_mux_out = imm_mux[imm_op];


//ALU
assign alu_mux[0] = rx_mux_out & imm_mux_out; 
assign alu_mux[1] = rx_mux_out + imm_mux_out;
assign alu_mux[2] = rx_mux_out == r6 ? 8'b1 : 8'b0;
assign alu_mux[3] = imm_mux_out;

assign alu_res = alu_mux[alu_op];
assign cmp_res = alu_mux[2];


endmodule
