# Design and Verification of 5-Stage Pipelined RISC Processor

## Overview

This project implements a 5-Stage Pipelined RISC Processor using Verilog HDL. The processor architecture is divided into five stages: Instruction Fetch (IF), Instruction Decode (ID), Execute (EX), Memory Access (MEM), and Write Back (WB). The design incorporates pipeline registers, hazard detection, and forwarding logic to improve instruction throughput and overall processor performance.

## Features

* 5-stage pipelined processor architecture
* Instruction Fetch (IF) stage
* Instruction Decode (ID) stage
* Execute (EX) stage
* Memory Access (MEM) stage
* Write Back (WB) stage
* Pipeline register implementation
* Hazard Detection Unit
* Forwarding Unit
* Verilog HDL implementation
* Functional verification using testbench simulation

## Architecture

The processor follows a classic RISC pipeline architecture:

```text
        +-----+
        | PC  |
        +--+--+
           |
           v
     +-----------+
     | IF Stage  |
     +-----+-----+
           |
      IF/ID Reg
           |
           v
     +-----------+
     | ID Stage  |
     +-----+-----+
           |
      ID/EX Reg
           |
           v
     +-----------+
     | EX Stage  |
     +-----+-----+
           |
      EX/MEM Reg
           |
           v
     +-----------+
     | MEM Stage |
     +-----+-----+
           |
      MEM/WB Reg
           |
           v
     +-----------+
     | WB Stage  |
     +-----------+
```

## Project Structure

```text
├── pc.v
├── instruction_memory.v
├── register_file.v
├── alu.v
├── control_unit.v
├── forwarding_unit.v
├── hazard_detection.v
├── if_id.v
├── id_ex.v
├── ex_mem.v
├── mem_wb.v
├── data_memory.v
├── processor_top.v
└── tb_processor.v
```

## Pipeline Hazards

### Data Hazards

Handled using:

* Forwarding Unit
* Pipeline Stalling

### Control Hazards

Handled using:

* Branch decision logic
* Pipeline flushing techniques

### Structural Hazards

Minimized through separate instruction and data memory structures.

## Simulation

The design can be simulated using:

* EDA Playground
* ModelSim
* QuestaSim
* Icarus Verilog
* Vivado Simulator

### Running the Simulation

1. Compile all Verilog design files.
2. Compile the testbench (`tb_processor.v`).
3. Run the simulation.
4. Observe waveforms using EPWave or a supported waveform viewer.

## Learning Outcomes

* Processor Microarchitecture Design
* Pipelining Concepts
* Hazard Detection and Resolution
* RTL Design using Verilog HDL
* Functional Verification
* Debugging and Simulation Techniques

## Future Enhancements

* Cache Integration
* Branch Prediction
* Performance Benchmarking
* Superscalar Architecture
* Multi-Core Extensions

## Author

**Kathula Hareesh**

B.Tech Electronics and Communication Engineering

## License

This project is developed for educational and internship learning purposes.
