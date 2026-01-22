`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10.01.2026 20:51:48
// Design Name: 
// Module Name: ID_EX_tb
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


module ID_EX_tb();
    reg clk;
    reg rst_;
    reg stall;
    reg flush;
    reg id_valid;
    reg [31:0] id_pc;
    reg [31:0] imm;
    reg [6:0]  opcode;
    reg [4:0]  rd_addr;
    reg [4:0]  rs1_addr;
    reg [4:0]  rs2_addr;
    reg [2:0]  func3;
    reg [6:0]  func7;

    wire ex_valid;
    wire [31:0] ex_pc;
    wire [31:0] ex_imm;
    wire [6:0]  ex_opcode;
    wire [2:0]  ex_func3;
    wire [6:0]  ex_func7;
    wire [4:0]  ex_rs1_addr;
    wire [4:0]  ex_rs2_addr;
    wire [4:0]  ex_rd_addr;

    ID_EX m(
        .clk(clk),
        .rst_(rst_),
        .stall(stall),
        .flush(flush),
        .id_valid(id_valid),
        .id_pc(id_pc),
        .imm(imm),
        .opcode(opcode),
        .rd_addr(rd_addr),
        .rs1_addr(rs1_addr),
        .rs2_addr(rs2_addr),
        .func3(func3),
        .func7(func7),
        .ex_valid(ex_valid),
        .ex_pc(ex_pc),
        .ex_imm(ex_imm),
        .ex_opcode(ex_opcode),
        .ex_func3(ex_func3),
        .ex_func7(ex_func7),
        .ex_rs1_addr(ex_rs1_addr),
        .ex_rs2_addr(ex_rs2_addr),
        .ex_rd_addr(ex_rd_addr)
    );

    always #5 clk = ~clk;

    initial begin
        clk = 0;
        rst_ = 0;
        stall = 0;
        flush = 0;
        id_valid = 0;
        id_pc = 0;
        imm = 0;
        opcode = 0;
        func3 = 0;
        func7 = 0;
        rs1_addr = 0;
        rs2_addr = 0;
        rd_addr  = 0;

        #12;
        rst_ = 1;
        
        // ---------- Normal transfer ----------
        #10
        id_valid = 1;
        id_pc    = 32'h00000010;
        imm      = 32'h00000004;
        opcode   = 7'b0010011; // ADDI
        func3    = 3'b000;
        func7    = 7'b0000000;
        rs1_addr = 5'd1;
        rs2_addr = 5'd2;
        rd_addr  = 5'd3;

        // ---------- Stall (hold values) ----------
        #10
        stall = 1;
        id_pc = 32'hFFFFFFFF; // should NOT propagate
        imm   = 32'hFFFFFFFF;

        #10
        stall = 0;

        // ---------- Flush (clear latch) ----------
        #10
        flush = 1;
        #10
        flush = 0;

        #20;
        $finish;
    end
endmodule
