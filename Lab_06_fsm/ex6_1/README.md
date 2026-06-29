This project implements a simplified UART transmitter using a four-state machine in Verilog. It serializes 8-bit parallel input data into a serial bitstream and appends start and stop bits for transmission.

Inputs:

clk - system clock.
rst - asynchronous or synchronous reset.
send - transmission trigger flag. Transmission begins only upon detecting a rising edge (transition from 0 to 1) on this signal.
data [7:0] - 8-bit data bus from which the value to be transmitted is fetched.

Outputs:

txd - data output (1-bit) where the serialized bitstream appears.

Finite State Machine:

State 1 - Waits for a rising edge on the send signal. When detected, the input data is latched into an internal register, and the machine transitions to the second state.
State 2 - Outputs a start bit of 1 to txd and proceeds to the third state.
State 3 - Transmits the stored 8-bit data serially, bit by bit, from the least significant bit to the most significant bit. Once all bits are sent, it enters the fourth state.
State 4 - Outputs a stop bit of 0 to txd and returns to the first state.
