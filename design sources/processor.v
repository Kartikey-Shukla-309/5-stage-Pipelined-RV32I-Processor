`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10.01.2026 15:57:16
// Design Name: 
// Module Name: processor
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


module processor (
    input clk,
    input rst_,
    
    output [31:0] dbg_pc_if,
    output [31:0] dbg_instruction_if,
    output [31:0] dbg_imm_id,
    output [6:0] dbg_opcode_id,
    output [2:0] dbg_func3_id,
    output [6:0] dbg_func7_id,
    output [4:0] dbg_rs1_addr_id,
    output [4:0] dbg_rs2_addr_id,
    output [4:0] dbg_rd_addr_id,
    output [31:0] dbg_alu_result_ex,
    output [31:0] dbg_rs1_data_rf,
    output [31:0] dbg_rs2_data_rf,
    output dbg_branch_ex,
    output stall
);

    /////////////// Internal wires //////////////

    // IF stage
    wire        req_if;
    wire [31:0] pc_if;
    wire [31:0] instruction_if;
    wire        valid_if;

    // IF/ID latch
    wire [31:0] pc_if_id;
    wire [31:0] instruction_if_id;
    wire        instr_valid_if_id;

    // ID stage
    wire        stall_id;
    wire        valid_id;
    wire [31:0] pc_id;
    wire [31:0] imm_id;
    wire [6:0]  opcode_id;
    wire [2:0]  func3_id;
    wire [6:0]  func7_id;
    wire [4:0]  rs1_addr_id;
    wire [4:0]  rs2_addr_id;
    wire [4:0]  rd_addr_id;
    
    // ID/EX latch
    wire        valid_id_ex;
    wire [31:0] pc_id_ex;
    wire [31:0] imm_id_ex;
    wire [6:0]  opcode_id_ex;
    wire [2:0]  func3_id_ex;
    wire [6:0]  func7_id_ex;
    wire [4:0]  rs1_addr_id_ex;
    wire [4:0]  rs2_addr_id_ex;
    wire [4:0]  rd_addr_id_ex;
    
    // EX stage
    wire        valid_ex;
    wire        branch_ex;
    wire        flush_ex;
    wire [31:0] alu_result_ex;
    wire [31:0] pc_branch_ex;
    wire [31:0] pc_flush_ex;
    wire [31:0] data_ex;
    wire [4:0]  rs1_addr_ex;
    wire [4:0]  rs2_addr_ex;
    wire [4:0]  rd_addr_ex;
    wire        reg_write_ex;
    wire        mem_read_ex;
    wire        mem_write_ex;
    wire        mem_to_reg_ex;
    
    // EX/MEM latch
    wire        valid_ex_mem;
    wire [31:0] alu_result_ex_mem;
    wire [31:0] data_ex_mem;
    wire [4:0]  rd_addr_ex_mem;
    wire        reg_write_ex_mem;
    wire        mem_read_ex_mem;
    wire        mem_write_ex_mem;
    wire        mem_to_reg_ex_mem;
    wire        branch_ex_mem;
    wire        flush_ex_mem;
    wire [31:0] pc_branch_ex_mem;
    wire [31:0] pc_flush_ex_mem;
    
    // MEM stage
    wire [31:0] data_mem;
    wire [31:0] alu_mem;
    wire [4:0]  rd_addr_mem;
    wire        reg_write_mem;
    wire        mem_to_reg_mem;
    
    // WB stage
    wire wen_wb;
    wire [4:0] rd_addr_wb;
    wire [31:0] rd_data_wb;    
    
    // Register file
    wire [31:0] rs1_data_rf;
    wire [31:0] rs2_data_rf;
    
    // Hazard unit
    wire hazard_stall;
    
    ////////// Instruction Fetch Stage //////////
    
    IF_stage IF_stage_m(
        .clk(clk),
        .rst_(rst_),
        .stall(stall_id),
        .flush(flush_ex),
        .branch(branch_ex),
        .pc_branch(pc_branch_ex),
        .pc_flush(pc_flush_ex),

        .req(req_if),
        .pc(pc_if),
        .instruction(instruction_if),
        .valid(valid_if)
    );

    ////////// IF/ID Pipeline Latch //////////
    
    IF_ID IF_ID_m(
        .clk(clk),
        .rst_(rst_),
        .stall(stall_id),
        .flush(flush_ex),
        .branch(branch_ex),
        .valid(valid_if),
        .pc(pc_if),
        .instr(instruction_if),

        .pc_out(pc_if_id),
        .instruction(instruction_if_id),
        .instr_valid(instr_valid_if_id)
    );
    
    ///////// Instruction Decode Stage /////////
    
    ID_stage ID_stage_m(
        .clk(clk),
        .rst_(rst_),
        .stall(hazard_stall),
        .flush(flush_ex),
        .branch(branch_ex),
        .pc(pc_if_id),
        .instr(instruction_if_id),
        .valid(instr_valid_if_id),
        
        .stall_if(stall_id),
        .id_valid(valid_id),
        .id_pc(pc_id), 
        .imm(imm_id), 
        .opcode(opcode_id),
        .rd_addr(rd_addr_id),
        .rs1_addr(rs1_addr_id),
        .rs2_addr(rs2_addr_id),
        .func3(func3_id),
        .func7(func7_id)
    );
    
    ////////// ID/EX Pipeline Latch //////////
    
    ID_EX ID_EX_m(
        .clk(clk),
        .rst_(rst_),
        .stall(hazard_stall),
        .flush(flush_ex),
        .id_valid(valid_id),
        .id_pc(pc_id),
        .imm(imm_id),
        .opcode(opcode_id),
        .rd_addr(rd_addr_id),
        .rs1_addr(rs1_addr_id),
        .rs2_addr(rs2_addr_id),
        .func3(func3_id),
        .func7(func7_id),

        .ex_valid(valid_id_ex),
        .ex_pc(pc_id_ex),
        .ex_imm(imm_id_ex),
        .ex_opcode(opcode_id_ex),
        .ex_func3(func3_id_ex),
        .ex_func7(func7_id_ex),
        .ex_rs1_addr(rs1_addr_id_ex),
        .ex_rs2_addr(rs2_addr_id_ex),
        .ex_rd_addr(rd_addr_id_ex)
    );
    
    ////////////// Execution Stage /////////////

    EX_stage EX_stage_m (
        .ex_valid(valid_id_ex),
        .ex_pc(pc_id_ex),
        .ex_imm(imm_id_ex),
        .ex_opcode(opcode_id_ex),
        .ex_func3(func3_id_ex),
        .ex_func7(func7_id_ex),
        .ex_rs1_addr(rs1_addr_id_ex),
        .ex_rs2_addr(rs2_addr_id_ex),
        .ex_rd_addr(rd_addr_id_ex),
        .rs1_data(rs1_data_rf),
        .rs2_data(rs2_data_rf),

        .valid(valid_ex),
        .branch(branch_ex),
        .flush(flush_ex),
        .alu_result(alu_result_ex),
        .pc_branch(pc_branch_ex),
        .pc_flush(pc_flush_ex),
        .data(data_ex),
        .reg_write(reg_write_ex),
        .rs1_addr(rs1_addr_ex),
        .rs2_addr(rs2_addr_ex),
        .rd_addr(rd_addr_ex),
        .mem_read(mem_read_ex),
        .mem_write(mem_write_ex),
        .mem_to_reg(mem_to_reg_ex)
    );

    ////////// EX/MEM Pipeline Latch /////////
    
    EX_MEM EX_MEM_m (
        .clk(clk),
        .rst_(rst_),
        .ex_valid(valid_ex),
        .ex_alu_result(alu_result_ex),
        .ex_data(data_ex),
        .ex_rd_addr(rd_addr_ex),
        .ex_reg_write(reg_write_ex),
        .ex_mem_read(mem_read_ex),
        .ex_mem_write(mem_write_ex),
        .ex_mem_to_reg(mem_to_reg_ex),
        .ex_branch(branch_ex),
        .ex_flush(flush_ex),
        .ex_pc_branch(pc_branch_ex),
        .ex_pc_flush(pc_flush_ex),

        .mem_valid(valid_ex_mem),
        .mem_alu_result(alu_result_ex_mem),
        .mem_data(data_ex_mem),
        .mem_rd_addr(rd_addr_ex_mem),
        .mem_reg_write(reg_write_ex_mem),
        .mem_mem_read(mem_read_ex_mem),
        .mem_mem_write(mem_write_ex_mem),
        .mem_mem_to_reg(mem_to_reg_ex_mem),
        .mem_branch(branch_ex_mem),
        .mem_flush(flush_ex_mem),
        .mem_pc_branch(pc_branch_ex_mem),
        .mem_pc_flush(pc_flush_ex_mem)
    );
    
    ////////// Memory Access Stage //////////

    MEM_stage MEM_stage_m (
        .clk(clk),
        .rst_(rst_),
        .mem_valid(valid_ex_mem),
        .mem_alu_result(alu_result_ex_mem),
        .mem_data(data_ex_mem),
        .mem_rd_addr(rd_addr_ex_mem),
        .mem_reg_write(reg_write_ex_mem),
        .mem_mem_read(mem_read_ex_mem),
        .mem_mem_write(mem_write_ex_mem),
        .mem_mem_to_reg(mem_to_reg_ex_mem),

        .mem_wb_data(data_mem),
        .mem_wb_alu(alu_mem),
        .wb_rd_addr(rd_addr_mem),
        .wb_reg_write(reg_write_mem),
        .wb_mem_to_reg(mem_to_reg_mem)
    );

    /////////// Write-back Stage ////////////
    
    WB_stage WB_stage_m (
        .clk(clk),
        .rst_(rst_),
        .mem_wb_alu(alu_mem),
        .mem_wb_data(data_mem),
        .wb_rd_addr(rd_addr_mem),
        .wb_reg_write(reg_write_mem),
        .wb_mem_to_reg(mem_to_reg_mem),

        .rf_we(wen_wb),
        .rf_waddr(rd_addr_wb),
        .rf_wdata(rd_data_wb)
    );
    
    //////////// Register File /////////////

    register_file register_file_m (
        .clk      (clk),
        .rs1_addr (rs1_addr_ex),
        .rs2_addr (rs2_addr_ex),
        .w_en     (wen_wb),
        .w_addr   (rd_addr_wb),
        .w_data   (rd_data_wb),

        .rs1_data (rs1_data_rf),
        .rs2_data (rs2_data_rf)
    );
    
    ////////// Hazard Detection Unit //////////

    hazard_unit hazard_unit_m (
        .id_rs1(rs1_addr_id),        
        .id_rs2(rs2_addr_id),        
        .ex_rd(rd_addr_id_ex),      
        .ex_reg_write(mem_read_ex_mem),       
        .mem_rd(rd_addr_mem),     
        .mem_reg_write(reg_write_mem),

        .stall(hazard_stall)
    );
    
    assign dbg_pc_if = pc_if;
    assign dbg_instruction_if = instruction_if;
    assign dbg_imm_id = imm_id;
    assign dbg_opcode_id = opcode_id;
    assign dbg_func3_id = func3_id;
    assign dbg_func7_id = func7_id;
    assign dbg_rs1_addr_id = rs1_addr_id;
    assign dbg_rs2_addr_id = rs2_addr_id;
    assign dbg_rd_addr_id = rd_addr_id;
    assign dbg_alu_result_ex = alu_result_ex;
    assign dbg_rs1_data_rf = rs1_data_rf;
    assign dbg_rs2_data_rf = rs2_data_rf;
    assign dbg_branch_ex = branch_ex;
    assign stall = hazard_stall;
endmodule
