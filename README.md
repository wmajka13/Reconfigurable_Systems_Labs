# Reconfigurable Systems - Laboratories

This repository contains projects, source codes, and software models developed during the **Reconfigurable Systems** laboratory course. The projects focus on FPGA programming using Verilog and Xilinx/AMD toolchains.

## Course Materials
The tasks and projects included in this repository were implemented based on the official course manual:
* **Title:** Systemy Rekonfigurowalne - skrypt do ćwiczeń laboratoryjnych (Reconfigurable Systems - Laboratory Manual)
* **Authors:** Mateusz Komorkiewicz, Tomasz Kryjak
* **Environment:** Vivado 2022.2

## Technologies & Tools
* **Hardware Description Language:** Verilog
* **EDA Tools:** Xilinx Vivado (2022.2), Xilinx Vitis
* **Auxiliary Models & Scripts:** Python, MATLAB
* **Target Hardware:** FPGA / SoC platforms (e.g., Kria, Zybo)

## Repository Structure

The project is divided into folders corresponding to the consecutive learning stages and laboratory sessions:

* **`Lab_03_basic_modules`** - Implementation of basic combinational circuits and logic gates (e.g., cascaded circuits).
* **`Lab_05_verilog_practice`** - Utility modules: modulo counters, universal delay lines for synchronizing processing pipelines.
* **`Lab_06_fsm`** - Design and implementation of Finite State Machines (Moore/Mealy).
* **`Lab_07_arithmethic_oper`** - Arithmetic operations on FPGA using IP Cores: pipelined adders, multipliers, and accumulators.
* **`Lab_08_12_vision_system`** - Advanced, real-time pipelined vision system. Features include:
  * Color space conversion (RGB -> YCbCr).
  * Segmentation and thresholding of skin-color areas.
  * Contextual filtering modules (median filter, morphological operations).
  * Calculation and visualization of the detected object's center of gravity (centroid).
  * Complex Block Design featuring an ARM processor and video interfaces.
* **`Lab_13_processor`** - Building a simple processor architecture from scratch (instruction memory, data memory, control unit, and a Python-based assembler parser).
* **`Lab_14_processor_GPIO`** - Expanding the designed processor with external world communication via General-Purpose Input/Output (GPIO) ports.
