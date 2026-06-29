`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Zadanie 14.3 - Testbench dla programu z pętlami opóźniającymi i zboczami
//////////////////////////////////////////////////////////////////////////////////

module processor_tb();

    // ZEGAR
    reg clk = 1'b0;

    always 
    begin
        #10 clk = ~clk;     // 20ns okres (50 MHz)
    end

    // POPRAWKA: Rozszerzamy kable do 8 bitów, aby nie było "wiszących" stanów Z
    reg [7:0] gpi = 8'b00000000;
    wire [7:0] gpo;

    processor DUT
    (
        .clk (clk ),
        .gpi (gpi ),
        .gpo (gpo )
    );

    initial 
    begin
        // Stan początkowy: wszystkie przełączniki w dół
        gpi = 8'b00000000; 

        // 1. Czekamy aż procesor wyjdzie z pętli opóźniającej dla LED0 (ok. 1000 ns)
        #1500; 

        // 2. Jesteśmy na LED1. Symulujemy wciśnięcie SW0 (zbocze narastające)
        gpi = 8'b00000001; 
        #200;               // Trzymamy przełącznik w górze przez 10 taktów zegara
        gpi = 8'b00000000;  // Zsuwamy go z powrotem w dół

        // 3. Czekamy aż procesor wyjdzie z pętli opóźniającej dla LED2 (ok. 1000 ns)
        #1500;

        // 4. Jesteśmy na LED3. Symulujemy wciśnięcie SW1
        gpi = 8'b00000010;
        #200;               // Trzymamy w górze
        gpi = 8'b00000000;  // Zsuwamy w dół

        // 5. Czekamy chwilę, aby udowodnić, że instrukcja "jumpi 00" zadziałała
        // i program wrócił do zapalania LED0.
        #1000;
        
        $finish;
    end

endmodule