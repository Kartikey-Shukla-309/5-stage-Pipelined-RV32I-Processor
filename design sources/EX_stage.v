`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11.01.2026 22:12:26
// Design Name: 
// Module Name: EX_stage
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


module EX_stage(
    input ex_valid,                 // from ID_EX
    input [31:0] ex_pc,             // from ID_EX
    input [31:0] ex_imm,            // from ID_EX
    input [6:0] ex_opcode,          // from ID_EX
    input [2:0] ex_func3,           // from ID_EX
    input [6:0] ex_func7,           // from ID_EX
    input [4:0] ex_rs1_addr,        // from ID_EX
    input [4:0] ex_rs2_addr,        // from ID_EX
    input [4:0] ex_rd_addr,         // from ID_EX
    input [31:0] rs1_data,          // from register_file
    input [31:0] rs2_data,          // from register_file
    
    output valid,                   // to EX_MEM
    output reg branch,              // to IF_stage and ID_stage
    output reg flush,               // to IF_stage and ID_stage
    output reg [31:0] alu_result,   // to MEM_stage
    output reg [31:0] pc_branch,    // to IF_stage
    output reg [31:0] pc_flush,     // to IF_stage
    output reg [31:0] data,         // to register_file
    output reg reg_write,           // to register_file
    output reg [4:0] rs1_addr,      // to register_file
    output reg [4:0] rs2_addr,      // to register_file
    output reg [4:0] rd_addr,       // to hazard_unit
    output reg mem_read,            // to memory
    output reg mem_write,           // to memory
    output reg mem_to_reg           // to load from memory to register_file
    );
    
    ///////////// Internal Wires //////////////
    
    wire is_Rtype  = (ex_opcode == 7'b0110011);
    wire is_Itype  = (ex_opcode == 7'b0010011);
    wire is_load   = (ex_opcode == 7'b0000011);
    wire is_store  = (ex_opcode == 7'b0100011);
    wire is_branch = (ex_opcode == 7'b1100011);
    wire is_jal    = (ex_opcode == 7'b1101111);
    wire is_jalr   = (ex_opcode == 7'b1100111);
    wire is_lui    = (ex_opcode == 7'b0110111);
    wire is_auipc  = (ex_opcode == 7'b0010111);
    
    wire alu_branch;
    wire alu_flush;
    wire [31:0] alu_out;
    wire [31:0] alu_pc_branch;
    wire [31:0] alu_pc_flush;
    
    //////////// ALU operation ////////////
    
    alu m(
        .pc(ex_pc),
        .func3(ex_func3),
        .func7(ex_func7),
        .imm(ex_imm),
        .is_Rtype(is_Rtype),
        .is_Itype(is_Itype),
        .is_load(is_load),
        .is_store(is_store),
        .is_branch(is_branch),
        .is_jal(is_jal),
        .is_jalr(is_jalr),
        .is_lui(is_lui),
        .is_auipc(is_auipc),
        .rs1(rs1_data),
        .rs2(rs2_data),
        
        .branch(alu_branch),
        .flush(alu_flush),
        .alu_result(alu_out),
        .pc_branch(alu_pc_branch),
        .pc_flush(alu_pc_flush)
    );
    
    always @(*) begin
        branch = alu_branch;
        flush = alu_flush;
        alu_result = alu_out;
        pc_branch = alu_pc_branch;
        pc_flush = alu_pc_flush;

        reg_write = 1'b0;
        mem_read = 1'b0;
        mem_write = 1'b0;
        mem_to_reg = 1'b0;

        data = rs2_data; // store in register file: 'rd'
        rd_addr = ex_rd_addr;
        rs1_addr = ex_rs1_addr;
        rs2_addr = ex_rs2_addr;

        if (!ex_valid) begin
            reg_write = 0;
            mem_read  = 0;
            mem_write = 0;
        end
        else if (is_Rtype || is_Itype || is_lui || is_auipc) begin
            reg_write = 1'b1;
        end
        else if (is_load) begin
            reg_write  = 1'b1;
            mem_read   = 1'b1;
            mem_to_reg = 1'b1;
        end
        else if (is_store) begin
            mem_write = 1'b1;
        end
        else if (is_jal || is_jalr) begin
            reg_write = 1'b1;
        end
    end
    
    assign valid = ex_valid;
endmodule
