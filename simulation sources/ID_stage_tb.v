`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10.01.2026 20:16:57
// Design Name: 
// Module Name: ID_stage_tb
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


module ID_stage_tb();
    reg clk;
    reg rst_;
    reg stall;
    reg flush;
    reg branch;
    reg valid;
    reg [31:0] pc;
    reg [31:0] instr;

    wire stall_if;
    wire id_valid;
    wire [31:0] id_pc;
    wire [31:0] imm;
    wire [6:0]  opcode;
    wire [4:0]  rd_addr;
    wire [4:0]  rs1_addr;
    wire [4:0]  rs2_addr;
    wire [2:0]  func3;
    wire [6:0]  func7;

    ID_stage m(
        .clk(clk),
        .rst_(rst_),
        .stall(stall),
        .flush(flush),
        .branch(branch),
        .pc(pc),
        .instr(instr),
        .valid(valid),

        .stall_if(stall_if),
        .id_valid(id_valid),
        .id_pc(id_pc),
        .imm(imm),
        .opcode(opcode),
        .rd_addr(rd_addr),
        .rs1_addr(rs1_addr),
        .rs2_addr(rs2_addr),
        .func3(func3),
        .func7(func7)
    );

    always #5 clk = ~clk;

    initial begin
        clk    = 0;
        rst_   = 0;
        stall  = 0;
        flush  = 0;
        branch = 0;
        valid  = 0;
        pc     = 32'b0;
        instr  = 32'b0;

        #20;
        rst_ = 1;

        // Valid I-type instruction
        #10
        valid = 1;
        pc    = 32'h0000_1000;
        instr = 32'b000000001010_00010_000_00001_0010011;

        // Stall asserted
        #10
        stall = 1;
        #10
        stall = 0;

        // Flush
        #10
        flush = 1;
        #10
        flush = 0;

        // Invalid instruction
        #10
        valid = 0;
        instr = 32'b0;

        // J-type instruction
        #10
        valid = 1;
        pc    = 32'h0000_2000;
        instr = 32'b00000000000100000000_00101_1101111;

        #50;
        $finish;
    end
endmodule
