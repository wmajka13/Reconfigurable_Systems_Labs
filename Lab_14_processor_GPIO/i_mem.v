`timescale 1ns / 1ps
//-----------------------------------------------
// Company: agh
//-----------------------------------------------
module i_mem
(
  input [7:0]address,
  output [31:0]data
);
//-----------------------------------------------
//instruction memory
wire [31:0]program[255:0];


// --------------------- ZADANIE 14_2 ------------------------
assign program[0]=32'h00168401;
assign program[1]=32'h001681E7;
assign program[2]=32'h00118101;
assign program[3]=32'h03318602;
assign program[4]=32'h00168402;
assign program[5]=32'h00058001;
assign program[6]=32'h03308605;
assign program[7]=32'h00058001;
assign program[8]=32'h02308607;
assign program[9]=32'h00168404;
assign program[10]=32'h001681E7;
assign program[11]=32'h00118101;
assign program[12]=32'h0331860B;
assign program[13]=32'h00168408;
assign program[14]=32'h00058002;
assign program[15]=32'h0330860E;
assign program[16]=32'h00058002;
assign program[17]=32'h02308610;
assign program[18]=32'h01308600;

// Zestaw instrukcji:

/*
pc_op   [25:24]   :  2 bity odpowiedzialne za skoki - wchodzi do bloku "warunek skoku"
alu_op  [21:20]   : Wybiera wyjście z ALU (AND, +, ==0, przepisanie imm_mux) 
rx_op   [18:16]   : Wybiera pierwszy argument (rejestr od r0 do r7) do ALU z `rx_mux`.
imm_op  [15]      : Wybiera źródło drugiego argumentu, steruje `imm_mux` –  wartość z (`ry`), czy liczba bezpośrednio z instrukcji (`imm`).
ry_op   [14:12]   : Wybiera potencjalny drugi argument do obliczeń. Steruje `ry_mux`.
rd_op   [11]      : Wybiera dane do zapisu w rejestrze: wynik operacji z ALU czy wartość odczytana z "pamięci danych".
d_op    [10:8]    : Wybiera rejestr docelowy, do którego trafia wartość z rd_op
imm     [7:0]     : Stała wartość (immediate). Gotowa, 8-bitowa liczba w kodzie rozkazu
*/

// mov Rd, Rx = 0x{001, Rx, 6, Rd, 00}`
// movi Rd, imm = 0x{00168,Rd,imm}

// nop              - pusty przebieg, stan rejestrów (R0-R6) nie jest zmieniany, 
//                    pobierana jest kolejna instrukcja.
// 0x0000_0000 - Bierzemy r0 & r0 i wpisujemy do r0, zwiększamy pc o 1.

// jump Rx          - wartość licznika instrukcji (PC) jest ustawiana na wartość z rejestru Rx, 
//                   kolejna instrukcja jest pobierana z lokacji o adresie Rx.
// 0x0130_{rx}600 - Przepisujemy wartość z rx przez imm i alu_mux[3] do pc_mux. umozliwliamy bezwarunkowy skok, wpisujemy 0 do r6
// zeby zajac rd_mux i d_op 

// jumpi imm        - wartość licznika instrukcji (PC) jest ustawiana na wartość bezpośrednią imm, 
//                    kolejna instrukcja jest pobierana z lokacji o adresie imm.
// 0x0130_86{imm}

// jz Rx, imm       - w przypadku, gdy rejestr Rx ma wartość 0, wartość licznika instrukcji (PC) 
//                    jest ustawiana na wartość bezpośrednią imm.
// 0x023{rx}_86{imm}

// jnz Rx, imm      - w przypadku, gdy rejestr Rx ma wartość inną niż 0, wartość licznika instrukcji 
//                    (PC) jest ustawiana na wartość bezpośrednią imm.
// 0x033{rx}_86{imm} 

//  add Rd, Rx, Ry   - wynik sumowania wartości z rejestrów Rx i Ry jest zapisywany do rejestru Rd.
// 0x001{rx}_{ry}{rd}00

// addi Rd, Rx, imm - wynik sumowania wartości z rejestru Rx i wartości bezpośredniej imm 
//                   jest zapisywany do rejestru Rd.
// 0x001{rx}_8{rd}{imm}

// and Rd, Rx, Ry   - wynik operacji logicznej AND wartości z rejestrów Rx i Ry jest zapisywany 
//                    do rejestru Rd.
// 0x000{rx}_{ry}{rd}00

// andi Rd, Rx, imm - wynik operacji logicznej AND wartości z rejestru Rx i wartości bezpośredniej 
//                    imm jest zapisywany do rejestru Rd.
// 0x000{rx}_8{rd}{imm}

// load Rd, Rx      - załadowanie do rejestru Rd wartości z pamięci danych spod adresu o wartości 
//                    z rejestru Rx.  Rd = pamieć[Rx]
// 0x0030_{rx}{1,rd}00

// loadi Rd, imm    - załadowanie do rejestru Rd wartości z pamięci danych spod adresu o wartości 
//                    bezpośredniej imm.  Rd = pamieć[imm]
// 0x0030_8{1,rd}{imm}



//-----------------------------------------------
assign data=program[address];
//-----------------------------------------------
endmodule
//-----------------------------------------------
