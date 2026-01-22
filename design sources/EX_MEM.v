`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 16.01.2026 17:06:49
// Design Name: 
// Module Name: EX_MEM
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


module EX_MEM (
    input clk,
    input rst_,
    input ex_valid,
    input [31:0] ex_alu_result,
    input [31:0] ex_data,
    input [4:0] ex_rd_addr,
    input ex_reg_write,
    input ex_mem_read,
    input ex_mem_write,
    input ex_mem_to_reg,
    input ex_branch,
    input ex_flush,
    input [31:0] ex_pc_branch,
    input [31:0] ex_pc_flush,

    output reg mem_valid,
    output reg [31:0] mem_alu_result,
    output reg [31:0] mem_data,
    output reg [4:0]  mem_rd_addr,
    output reg mem_reg_write,
    output reg mem_mem_read,
    output reg mem_mem_write,
    output reg mem_mem_to_reg,
    output reg mem_branch,
    output reg mem_flush,
    output reg [31:0] mem_pc_branch,
    output reg [31:0] mem_pc_flush
);
    always @(posedge clk or negedge rst_) begin
        mem_valid       <= 1'b0;
        mem_alu_result  <= 32'b0;
        mem_data        <= 32'b0;
        mem_rd_addr     <= 5'b0;
        mem_reg_write   <= 1'b0;
        mem_mem_read    <= 1'b0;
        mem_mem_write   <= 1'b0;
        mem_mem_to_reg  <= 1'b0;
        mem_branch      <= 1'b0;
        mem_flush       <= 1'b0;
        mem_pc_branch   <= 32'b0;
        mem_pc_flush    <= 32'b0;
        if (!rst_) begin
            mem_valid       <= 1'b0;
            mem_alu_result  <= 32'b0;
            mem_data        <= 32'b0;
            mem_rd_addr     <= 5'b0;
            mem_reg_write   <= 1'b0;
            mem_mem_read    <= 1'b0;
            mem_mem_write   <= 1'b0;
            mem_mem_to_reg  <= 1'b0;
            mem_branch      <= 1'b0;
            mem_flush       <= 1'b0;
            mem_pc_branch   <= 32'b0;
            mem_pc_flush    <= 32'b0;
        end
        else if (ex_flush) begin
            mem_valid       <= 1'b0;
            mem_alu_result  <= 32'b0;
            mem_data        <= 32'b0;
            mem_rd_addr     <= 5'b0;
            mem_reg_write   <= 1'b0;
            mem_mem_read    <= 1'b0;
            mem_mem_write   <= 1'b0;
            mem_mem_to_reg  <= 1'b0;
            mem_branch      <= 1'b0;
            mem_flush       <= 1'b0;
            mem_pc_branch   <= 32'b0;
            mem_pc_flush    <= 32'b0;
        end
        else begin
            mem_valid       <= ex_valid;
            mem_alu_result  <= ex_alu_result;
            mem_data        <= ex_data;
            mem_rd_addr     <= ex_rd_addr;
            mem_reg_write   <= ex_reg_write;
            mem_mem_read    <= ex_mem_read;
            mem_mem_write   <= ex_mem_write;
            mem_mem_to_reg  <= ex_mem_to_reg;
            mem_branch      <= ex_branch;
            mem_flush       <= ex_flush;
            mem_pc_branch   <= ex_pc_branch;
            mem_pc_flush    <= ex_pc_flush;
        end
    end
endmodule
