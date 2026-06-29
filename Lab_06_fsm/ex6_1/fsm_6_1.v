`timescale 1ns/1ps

module fsm_6_1
(
    input clk,
    input rst,
    input send,
    input [7:0] data,
    output txd
);

localparam STATE1=3'd1;
localparam STATE2=3'd2;
localparam STATE3=3'd3;
localparam STATE4=3'd4;

reg [2:0]state = STATE1;
reg [7:0]data_saved;
reg [2:0]sending_counter = 0;

reg send_reg = 0;
reg r_y = 0;

always @(posedge clk)
begin
    if(rst) state<=STATE1;
    else
        begin
        case(state)
        STATE1:
        begin    
            //stan 1
            if (send_reg != send && send == 1'b1)
            begin
                state <= STATE2;
                data_saved <= data;
            end else
            begin
                send_reg <= send;
            end

        end
        
        STATE2:
        begin
            //stan 2
            r_y <= 1'b1;
            state <= STATE3;
        end

        STATE3:
        begin
            //stan 3
            r_y <= data_saved[sending_counter];
            sending_counter <= sending_counter + 1;
            if (sending_counter == 7)
            begin
                state <= STATE4;
                sending_counter <= 0;
            end
        end

        STATE4:
        begin
            //stan 4
            r_y <= 1'b0;
            state <= STATE1;
        end
        endcase
    end
end

assign txd = r_y;

endmodule