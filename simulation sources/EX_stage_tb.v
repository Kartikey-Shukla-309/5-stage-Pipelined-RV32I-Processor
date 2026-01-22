`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 15.01.2026 00:22:23
// Design Name: 
// Module Name: EX_stage_tb
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


module EX_stage_tb();
    reg clk;
    reg rst_;
    reg ex_valid;
    reg [31:0] ex_pc;
    reg [31:0] ex_imm;
    reg [6:0]  ex_opcode;
    reg [2:0]  ex_func3;
    reg [6:0]  ex_func7;
    reg [4:0]  ex_rs1_addr;
    reg [4:0]  ex_rs2_addr;
    reg [4:0]  ex_rd_addr;
    reg [31:0] rs1_data;
    reg [31:0] rs2_data;

    wire branch;
    wire flush;
    wire [31:0] alu_result;
    wire [31:0] pc_branch;
    wire [31:0] pc_flush;
    wire [31:0] data;
    wire reg_write;
    wire mem_read;
    wire mem_write;
    wire mem_to_reg;

    EX_stage m(
        .ex_valid(ex_valid),
        .ex_pc(ex_pc),
        .ex_imm(ex_imm),
        .ex_opcode(ex_opcode),
        .ex_func3(ex_func3),
        .ex_func7(ex_func7),
        .ex_rs1_addr(ex_rs1_addr),
        .ex_rs2_addr(ex_rs2_addr),
        .ex_rd_addr(ex_rd_addr),
        .rs1_data(rs1_data),
        .rs2_data(rs2_data),
        .branch(branch),
        .flush(flush),
        .alu_result(alu_result),
        .pc_branch(pc_branch),
        .pc_flush(pc_flush),
        .data(data),
        .reg_write(reg_write),
        .mem_read(mem_read),
        .mem_write(mem_write),
        .mem_to_reg(mem_to_reg)
    );

    initial begin
        ex_valid = 0;

        ex_pc = 0;
        ex_imm = 0;
        ex_opcode = 0;
        ex_func3 = 0;
        ex_func7 = 0;
        ex_rs1_addr = 0;
        ex_rs2_addr = 0;
        ex_rd_addr  = 0;
        rs1_data = 0;
        rs2_data = 0;
        
        // ADD x3 = x1 + x2
        #10;
        ex_valid   = 1;
        ex_pc      = 32'h1000;
        ex_opcode  = 7'b0110011; // R-type
        ex_func3   = 3'b000;
        ex_func7   = 7'b0000000;
        rs1_data   = 32'd10;
        rs2_data   = 32'd20;

        #10;
        $display("ADD: alu=%0d reg_write=%b", alu_result, reg_write);

        // ADDI x4 = x1 + 5
        #10;
        ex_opcode  = 7'b0010011; // I-type
        ex_func3   = 3'b000;
        ex_imm     = 32'd5;
        rs1_data   = 32'd15;

        #10;
        $display("ADDI: alu=%0d reg_write=%b", alu_result, reg_write);

        // LW x5, 8(x1)
        #10;
        ex_opcode  = 7'b0000011; // load
        ex_func3   = 3'b010;
        ex_imm     = 32'd8;
        rs1_data   = 32'd100;

        #10;
        $display("LW: addr=%0d mem_read=%b mem_to_reg=%b",
                  alu_result, mem_read, mem_to_reg);

        // SW x5, 12(x1)
        #10;
        ex_opcode  = 7'b0100011; // store
        ex_func3   = 3'b010;
        ex_imm     = 32'd12;
        rs1_data   = 32'd100;
        rs2_data   = 32'hDEADBEEF;

        #10;
        $display("SW: addr=%0d mem_write=%b data=%h",
                  alu_result, mem_write, data);

        // BEQ taken
        #10;
        ex_opcode  = 7'b1100011;
        ex_func3   = 3'b000; // beq
        ex_imm     = 32'd16;
        ex_pc      = 32'h2000;
        rs1_data   = 32'd5;
        rs2_data   = 32'd5;

        #10;
        $display("BEQ: branch=%b flush=%b pc_branch=%h",
                  branch, flush, pc_branch);

        // JAL
        #10;
        ex_opcode  = 7'b1101111;
        ex_imm     = 32'd32;
        ex_pc      = 32'h3000;

        #10;
        $display("JAL: ra=%h pc_branch=%h reg_write=%b",
                  alu_result, pc_branch, reg_write);

        #20;
        $finish;
    end
endmodule
