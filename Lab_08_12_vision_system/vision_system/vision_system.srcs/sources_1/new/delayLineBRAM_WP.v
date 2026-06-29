`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:      AGH
// Engineer: 	  Tomasz Kryjak 	
// 
// Create Date:    08:17:01 10/29/2013 
// Design Name: 
// Module Name:    delayLineBRAM_WP 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////

// IMPLEMENTACJA ELASTYCZNEJ LINII OPÓŹNIAJĄCEJ Z WYKORZYSTANIEM BRAM'U
module delayLineBRAM_WP
#(
  parameter WIDTH = 16,             // SZEROKOŚĆ DANYCH DO OPÓŹNIENIA
  parameter BRAM_SIZE_W = 13        // SZEROKOŚĆ MAGISTRALI ADRESOWEJ BRAM - ILE MAKSYMALNIE ADRESÓW MOŻEMY ZAADRESOWAĆ
)
(
  input 		    clk,
  input 		    rst,
  input 		    ce,
  input [WIDTH-1:0] 	    din,
  output [WIDTH-1:0] 	    dout,
  input [BRAM_SIZE_W-1:0] h_size    // CAŁKOWITA DŁUGOŚĆ LINII WIDEO - WIDOCZNE PIKSELE + NIEWIDOCZNE OBSZARY SYNCHRONIZACJI
);

// WSKAŹNIK ADRESU W PAMIĘCI BRAM
reg [BRAM_SIZE_W-1:0]    position = 0;

wire [WIDTH-1:0] dina;
wire [WIDTH-1:0] douta;


// RING BUFFER - WARTOŚĆ POSITION KRĘCI SIĘ W KÓŁKO 
// WARTOŚĆ Z DANEGO ADRESU CZEKA POD NIM (JEST OPÓŹNIONA) DOTĄD
// AŻ `POSITION` OBIEGNIE CAŁY ZAKRES, DLUGOŚĆ DELAYA OKREŚLA H_SIZE
// NIŻEJ JEST H_SIZE - 3 ŻEBY UWZGLĘDNIĆ 2 TAKTY ZEGARA Z BRAM'U

// RAM controller
always @(posedge clk)
begin
  if ( ce == 1'b1)
  begin
    if (rst == 1'b1)
    begin
      position <= 0;
    end else
    begin
      position <= position+1;
      if (position == h_size-3)
      begin
        position <= 0;
      end
    end		
  end	
end


// Block RAM
delayLineBRAM BRAM (
  .clka(clk), // input clka
  .wea(1'b1), // input [0 : 0] wea
  .addra(position), // input [11 : 0] addra
  .dina(din), // input [15 : 0] dina
  .douta(dout) // output [15 : 0] douta
);
   
endmodule
