module fsm_6_4
(
    input clk,
    input rst,
    input rxd,
    output data,        // Ramka
    output received     //Flaga odebrania ramki
);
localparam STATE1 = 3'd1;
localparam STATE2 = 3'd2;
localparam STATE3 = 3'd3;
localparam STATE4 = 3'd4;

reg [2:0]STATE = STATE1;
reg Rx_monitor = 0;
reg [7:0]inner_data = 0;
reg [3:0]counter = 0;
reg received_flag = 0;

always @(posedge clk) 
begin
    if (rst == 1) STATE <= STATE1;

    case (STATE)
    STATE1: 
    begin
        //STAN 1 - oczekiwanie na sygnał startu - gdy na data pojawi sie jeden to start i przejscie do 2 stanu
        if (Rx_monitor == 0 && rxd == 1)
        begin
            STATE <= STATE2;
            Rx_monitor <= 1;
        end else Rx_monitor <= 0;
    end

    STATE2:
    begin
        //STAN 2 - Odbiór ramki danych? - deserializacja
        inner_data[counter] = rxd;
        counter = counter + 1;
        if (counter == 8)
        begin
            STATE <= STATE3;
            counter <= 0;
        end
    end 

    STATE3:
    begin
        //STAN 3 - Po odebraniu całej ramki przepisanie jej na wyjście?
        STATE <= STATE4;
    end 

    STATE4:
    begin
        //STAN 4 - ustawienie flagi, powrot do stanu 1?
        received_flag <= 1;
        
    end 
    endcase
end

assign received = received_flag;

endmodule