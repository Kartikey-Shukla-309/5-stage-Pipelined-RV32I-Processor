# 5-Stage-Pipelined-RV32I-Processor

This is a beginner project on designing a 5-stage Pipelined 32-bit processor based on RISC-V Base Integer Instruction Set (RV32I) in Verilog using Xilinx-Vivado software. Being a college project, this is a very low-level implementation for my own learning and understanding the pipeline architecture.

It follows the traditional IF -> ID -> EX -> MEM -> WB stages. I tried using the complete the instruction set (37 instructions). I also tried implementing hazard handling.

The processor is not in perfect working condition, but works well for maximum instructions and helped me in learning a lot. I am trying to learn more about processor designing and will try to improve this design.

<img width="881" height="373" alt="image" src="https://github.com/user-attachments/assets/a073e33d-af5f-47ee-8db5-b3c19503ddee" />
<img width="1290" height="730" alt="image" src="https://github.com/user-attachments/assets/5bdb1c24-aaa7-4ccb-8349-08f9998a97cd" />
<img width="1625" height="826" alt="image" src="https://github.com/user-attachments/assets/e48f3693-39d9-46a4-aa6a-ba32a3d33305" />

## PROJECT STRUCTURE

processor
1.  IF_stage
    i)   program_counter
    ii) instruction_memory
2.  IF_ID
3.  ID_stage
    i) instruction_decoder
4.  ID_EX
5.  EX_stage
    i) alu
6.  EX_MEM
7.  MEM_stage
8.  WB_stage
9.  register_file
10. hazard_unit

## FUTURE ASPECTS

1. Optimizing the design for low power and area consumption
2. Adding M-extension for performing multiplication and division

## REFERENCES
1. Maven Silicon - https://youtube.com/playlist?list=PL3_RRtJ5Iqgg94er7ErGAUSyhTXwPv6zy&si=3MyYincp9P1cYd0w
2. Chipmunk Logic - https://chipmunklogic.com/digital-logic-design/designing-pequeno-risc-v-cpu-from-scratch-part-1-getting-hold-of-the-isa/
