`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/18/2026 09:05:04 PM
// Design Name: 
// Module Name: median5x5
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


module median5x5
#(
    parameter H_SIZE = 83 //POPRAWNA WARTOŚĆ DLA OBRAZKA 64x64
) 
(
    input clk,
    
    input hsync_in,
    input vsync_in,
    input de_in,
    input bit_pixel_in,

    output hsync_out,
    output vsync_out,
    output de_out,
    output [7:0] byte_pixel_out
);


reg [3:0] D11 = 0;
reg [3:0] D12 = 0;
reg [3:0] D13 = 0;
reg [3:0] D14 = 0;
reg [3:0] D15 = 0;

reg [3:0] D21 = 0;
reg [3:0] D22 = 0;
reg [3:0] D23 = 0;
reg [3:0] D24 = 0;
reg [3:0] D25 = 0;

reg [3:0] D31 = 0;
reg [3:0] D32 = 0;
reg [3:0] D33 = 0;
reg [3:0] D34 = 0;
reg [3:0] D35 = 0;

reg [3:0] D41 = 0;
reg [3:0] D42 = 0;
reg [3:0] D43 = 0;
reg [3:0] D44 = 0;
reg [3:0] D45 = 0;

reg [3:0] D51 = 0;
reg [3:0] D52 = 0;
reg [3:0] D53 = 0;
reg [3:0] D54 = 0;
reg [3:0] D55 = 0;

wire [15:0] BRAM_in;
wire [15:0] BRAM_out;

assign BRAM_in = {D15, D25, D35, D45};


delayLineBRAM_WP 
#(
    .WIDTH(16),
    .BRAM_SIZE_W(13)
) median5x5_delayLineBRAM_WP
(
    .clk    (clk        ),
    .rst    (1'b0       ),
    .ce     (1'b1       ),
    .din    (BRAM_in    ),
    .dout   (BRAM_out   ),
    .h_size (H_SIZE - 5 )
);


// OPÓŹNIENIE DANYCH
always @(posedge clk) 
begin
    
    D11 <= {bit_pixel_in, de_in, vsync_in, hsync_in}; 

    D12 <= D11;     D13 <= D12;     D14 <= D13;     D15 <= D14; 
    
    D22 <= D21;     D23 <= D22;     D24 <= D23;     D25 <= D24; 

    D32 <= D31;     D33 <= D32;     D34 <= D33;     D35 <= D34; 

    D42 <= D41;     D43 <= D42;     D44 <= D43;     D45 <= D44; 

    D52 <= D51;     D53 <= D52;     D54 <= D53;     D55 <= D54; 

    D21 <= BRAM_out[15:12];
    D31 <= BRAM_out[11:8];
    D41 <= BRAM_out[7:4];
    D51 <= BRAM_out[3:0];

end


// SPRAWDZENIE POPRAWNOŚCI DANYCH
wire context_valid;
assign context_valid = D11[2] & D12[2] & D13[2] & D14[2] & D15[2] & D21[2] & D22[2]
                       & D23[2] & D24[2] & D25[2] & D31[2] & D32[2] & D33[2] & D34[2]
                       & D35[2] & D41[2] & D42[2] & D43[2] & D44[2] & D45[2] & D51[2]
                       & D52[2] & D53[2] & D54[2] & D55[2];

// OBLICZENIE MASKI
reg [2:0] sum_ABCDE = 0;
reg [2:0] sum_FGHIJ = 0;
reg [2:0] sum_KLMNO = 0;
reg [2:0] sum_PQRST = 0;
reg [2:0] sum_UWXYZ = 0;

reg [4:0] mask_sum = 0;

always @(posedge clk) 
begin
    sum_ABCDE <= D51[3] + D52[3] + D53[3] + D54[3] + D55[3];
    sum_FGHIJ <= D41[3] + D42[3] + D43[3] + D44[3] + D45[3];
    sum_KLMNO <= D31[3] + D32[3] + D33[3] + D34[3] + D35[3];    
    sum_PQRST <= D21[3] + D22[3] + D23[3] + D24[3] + D25[3];
    sum_UWXYZ <= D11[3] + D12[3] + D13[3] + D14[3] + D15[3];

    mask_sum <= sum_ABCDE + sum_FGHIJ + sum_KLMNO + sum_PQRST + sum_UWXYZ;
end

// OPOŹNIENIE SYGNAŁÓW DE, VSYNC, HSYNC
wire [3:0] after_sum_delay_out;

delay_module 
#(
    .N(4),
    .DELAY(2)
) median5x5_after_sum_delay_module
(
    .clk            (clk                        ),
    .signal_in      ({D33[2:0], context_valid}  ),
    .signal_delayed (after_sum_delay_out        )
);

wire context_valid_delayed;
assign context_valid_delayed = after_sum_delay_out[0];

assign byte_pixel_out = context_valid_delayed == 1 ? (mask_sum > 5'd12 ? 8'd255 : 8'd0) : 8'd0;
assign {de_out, vsync_out, hsync_out} =  after_sum_delay_out[3:1];

endmodule
