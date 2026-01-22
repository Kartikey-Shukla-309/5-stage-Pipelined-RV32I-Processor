`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 19.01.2026 00:40:59
// Design Name: 
// Module Name: processor_tb
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


module processor_tb();
    reg clk;
    reg rst_;

    wire [31:0] dbg_pc_if;
    wire [31:0] dbg_instruction_if;
    wire [31:0] dbg_imm_id;
    wire [6:0]  dbg_opcode_id;
    wire [2:0]  dbg_func3_id;
    wire [6:0]  dbg_func7_id;
    wire [4:0]  dbg_rs1_addr_id;
    wire [4:0]  dbg_rs2_addr_id;
    wire [4:0]  dbg_rd_addr_id;
    wire [31:0] dbg_alu_result_ex;
    wire [31:0] dbg_rs1_data_rf;
    wire [31:0] dbg_rs2_data_rf;
    wire branch_ex;
    wire stall;
    
    // processor insrantiation
    
    processor m(
        .clk(clk),
        .rst_(rst_),

        .dbg_pc_if(dbg_pc_if),
        .dbg_instruction_if(dbg_instruction_if),
        .dbg_imm_id(dbg_imm_id),
        .dbg_opcode_id(dbg_opcode_id),
        .dbg_func3_id(dbg_func3_id),
        .dbg_func7_id(dbg_func7_id),
        .dbg_rs1_addr_id(dbg_rs1_addr_id),
        .dbg_rs2_addr_id(dbg_rs2_addr_id),
        .dbg_rd_addr_id(dbg_rd_addr_id),
        .dbg_alu_result_ex(dbg_alu_result_ex),
        .dbg_rs1_data_rf(dbg_rs1_data_rf),
        .dbg_rs2_data_rf(dbg_rs2_data_rf),
        .dbg_branch_ex(branch_ex),
        .stall(stall)
    );
    
    // Clock: 10ns period
    always #5 clk = ~clk;

    initial begin
        clk = 0;
        rst_ = 0;

        // Hold reset
        #20;
        rst_ = 1;

        // Run simulation
        #90;
        $finish;
    end
endmodule