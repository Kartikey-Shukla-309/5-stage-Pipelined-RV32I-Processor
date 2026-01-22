`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10.01.2026 20:27:33
// Design Name: 
// Module Name: ID_EX
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


module ID_EX(
    input clk,
    input rst_,
    input stall,                    // from EX_stage
    input flush,                    // from EX_stage
    input id_valid,                 // from ID_stage
    input [31:0] id_pc,             // from ID_stage 
    input [31:0] imm,               // from ID_stage
    input [6:0]  opcode,            // from ID_stage
    input [4:0]  rd_addr,           // from ID_stage
    input [4:0]  rs1_addr,          // from ID_stage
    input [4:0]  rs2_addr,          // from ID_stage
    input [2:0]  func3,             // from ID_stage
    input [6:0]  func7,             // from ID_stage
    
    output reg ex_valid,            // to EX_stage
    output reg [31:0] ex_pc,        // to EX_stage
    output reg [31:0] ex_imm,       // to EX_stage
    output reg [6:0] ex_opcode,     // to EX_stage
    output reg [2:0] ex_func3,      // to EX_stage
    output reg [6:0] ex_func7,      // to EX_stage
    output reg [4:0] ex_rs1_addr,   // to EX_stage
    output reg [4:0] ex_rs2_addr,   // to EX_stage
    output reg [4:0] ex_rd_addr     // to EX_stage
    );
    
    always @(posedge clk or negedge rst_) begin
        ex_valid     <= 1'b0;
        ex_pc        <= 32'b0;
        ex_imm       <= 32'b0;
        ex_opcode    <= 7'b0;
        ex_func3     <= 3'b0;
        ex_func7     <= 7'b0;
        ex_rs1_addr  <= 5'b0;
        ex_rs2_addr  <= 5'b0;
        ex_rd_addr   <= 5'b0;
        if (!rst_) begin
            ex_valid     <= 1'b0;
            ex_pc        <= 32'b0;
            ex_imm       <= 32'b0;
            ex_opcode    <= 7'b0;
            ex_func3     <= 3'b0;
            ex_func7     <= 7'b0;
            ex_rs1_addr  <= 5'b0;
            ex_rs2_addr  <= 5'b0;
            ex_rd_addr   <= 5'b0;
        end
        else if (flush) begin
            ex_valid     <= 1'b0;
            ex_pc        <= 32'b0;
            ex_imm       <= 32'b0;
            ex_opcode    <= 7'b0;
            ex_func3     <= 3'b0;
            ex_func7     <= 7'b0;
            ex_rs1_addr  <= 5'b0;
            ex_rs2_addr  <= 5'b0;
            ex_rd_addr   <= 5'b0;
        end
        else if(stall) begin
            ex_valid     <= ex_valid;
            ex_pc        <= ex_pc;
            ex_imm       <= ex_imm;
            ex_opcode    <= ex_opcode;
            ex_func3     <= ex_func3;
            ex_func7     <= ex_func7;
            ex_rs1_addr  <= ex_rs1_addr;
            ex_rs2_addr  <= ex_rs2_addr;
            ex_rd_addr   <= ex_rd_addr;
        end
        else begin
            ex_valid     <= id_valid;
            ex_pc        <= id_pc;
            ex_imm       <= imm;
            ex_opcode    <= opcode;
            ex_func3     <= func3;
            ex_func7     <= func7;
            ex_rs1_addr  <= rs1_addr;
            ex_rs2_addr  <= rs2_addr;
            ex_rd_addr   <= rd_addr;
        end
    end
endmodule
