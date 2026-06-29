This project requires designing a state machine to receive the serial data transmitted by the module from Task 6.1, effectively acting as a simplified UART receiver.

Inputs:

clk - system clock.
rst - reset signal.
rxd - serial data input.

Outputs:

data - 8-bit output containing the received byte.
received - a flag that is set after a complete data packet has been successfully received.

Testbench Requirements:

An additional module must be created within the testbench to save the received data to an output file as a sequence of ASCII characters. The functionality of the entire system must be fully verified through simulation.
