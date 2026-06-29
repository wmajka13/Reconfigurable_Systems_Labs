`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/16/2026 04:47:20 PM
// Design Name: 
// Module Name: centroid
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


module centroid
#(
    parameter IMG_H = 64,
    parameter IMG_W = 64
)
(
    input clk,
    input hsync,
    input vsync,
    input de,
    input mask,

    output [10:0] x,
    output [10:0] y
);


// POZYCJA AKTUALNIE PRZETWARZANEGO PIKSELA
reg [10:0] x_pos = 0;
reg [10:0] y_pos = 0;

//Rozmiar N = log2(1920*1080)
reg [20:0] m00 = 0;


wire [30:0] m01;
wire [30:0] m10;

// WYJSĆIA Z DZIELAREK
wire [31:0] x_div_out;
wire [31:0] y_div_out;
wire x_qv;
wire y_qv;


// WYLICZONY ŚRODEK CIĘŻKOŚCI
reg [31:0] x_grav_cent;
reg [31:0] y_grav_cent;

// OBLICZANIE EOF
// ZAPISYWANIE WARTOSCI VSYNC Z POPRZENDIEGO ZBOCZA
// WYKRYWANIE NOWEJ STRONY I USTAWIANIE EOF = 1
wire eof;
reg prev_vsync = 0;
always @(posedge clk) prev_vsync <= vsync;  
assign eof = (prev_vsync == 1'b0 & vsync == 1'b1) ? 1'b1 : 1'b0;

// OPÓŹNIENIE SYGNAŁU EOF ABY
// CYKL 1: WLACZYC DZIELARKE
// CYKL 2: WZYEROWAC AKUMULATORY
reg start_dzielenia = 0;
reg reset_akumulatorow = 0;

always @(posedge clk) begin
    start_dzielenia <= eof; 
    reset_akumulatorow <= start_dzielenia; 
end


//WYLICZANIE POZYCJI PIKSELA
always @(posedge clk)
begin
    if (vsync == 1)
    begin
        x_pos <= 0 ;   
        y_pos <= 0;
    end else if (de == 1)
        begin
            x_pos <= x_pos + 1;
            if (x_pos == IMG_W - 1) 
            begin
                x_pos <= 0;
                y_pos <= y_pos + 1;
                if (y_pos == IMG_H - 1) y_pos <= 0;
            end
        end
end
  

// OBLICZANIE M00
always @(posedge clk) 
begin
    if (reset_akumulatorow)
    begin
        m00 <= 0;
    end else if (mask && de)
        begin
            m00 <= m00 + mask;
        end
end


// WYLICZANIE M10 Z AKUMULATORA
accumulator M01_accumulator(
    .clk (clk   ),
    .ce  (mask & de),
    .rst (reset_akumulatorow),
    .in  (x_pos ),
    .out (m10   )
);

// WYLICZANIE M01 Z AKUMULATORA
accumulator M10_accumulator(
    .clk (clk   ),
    .ce  (mask & de),
    .rst (reset_akumulatorow),
    .in  (y_pos ),
    .out (m01   )
);

// DZIELARKA OD X
divider_32_21_0 x_divider (
  .clk(clk),                        // input wire clk
  .start(start_dzielenia),                      // input wire start
  .dividend({1'b0, m10}),           // input wire [31 : 0] dividend     LICZNIK
  .divisor(m00),                    // input wire [20 : 0] divisor      MIANOWNIK
  .quotient(x_div_out),             // output wire [31 : 0] quotient    WYNIK
  .qv(x_qv)                         // output wire qv                   POPRAWNY WYNIK GDY QV=1
);

// DZIELARKA OD Y
divider_32_21_0 y_divider (
  .clk(clk),                        // input wire clk
  .start(start_dzielenia),                      // input wire start
  .dividend({1'b0, m01}),           // input wire [31 : 0] dividend     LICZNIK
  .divisor(m00),                    // input wire [20 : 0] divisor      MIANOWNIK
  .quotient(y_div_out),             // output wire [31 : 0] quotient    WYNIK
  .qv(y_qv)                         // output wire qv                   POPRAWNY WYNIK GDY QV=1
);


// ZATRZASKIWANIE POPRAWNEGO WYJŚCIA Z DZIELARKI
always @(posedge clk) 
begin
    if (x_qv == 1) x_grav_cent <= x_div_out;    
    if (y_qv == 1) y_grav_cent <= y_div_out;
end

// PRZYPISANIE OBLICZONEGO ŚRODKA CIĘŻKOŚCI NA WYJŚCIE MODUŁU
assign x = x_grav_cent[10:0];
assign y = y_grav_cent[10:0];

endmodule
