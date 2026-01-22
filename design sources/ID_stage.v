`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10.01.2026 17:03:12
// Design Name: 
// Module Name: ID_stage
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


module ID_stage(
    input clk,
    input rst_,
    input stall,                   // from EX_stage
    input flush,                   // from EX_stage
    input branch,                  // from Ex_stage
    input [31:0] pc,               // from IF_ID
    input [31:0] instr,            // from IF_ID
    input valid,                   // from IF_ID
    
    output reg stall_if,           // to IF_stage and IF_ID
    output reg id_valid,           // to ID_EX 
    output reg [31:0] id_pc,       // to ID_EX 
    output reg [31:0] imm,         // to ID_EX 
    output reg [6:0]  opcode,      // to ID_EX
    output reg [4:0]  rd_addr,     // to ID_EX
    output reg [4:0]  rs1_addr,    // to ID_EX
    output reg [4:0]  rs2_addr,    // to ID_EX
    output reg [2:0]  func3,       // to ID_EX
    output reg [6:0]  func7        // to ID_EX
    );
    
    wire [31:0] dec_imm;
    wire [6:0]  dec_opcode;
    wire [4:0]  dec_rd;
    wire [4:0]  dec_rs1;
    wire [4:0]  dec_rs2;
    wire [2:0]  dec_func3;
    wire [6:0]  dec_func7;
    
    ////////// TO Decoder ///////////
    
    instruction_decoder decoder_m (
        .instr(instr),
        .opcode(dec_opcode),
        .func3(dec_func3),
        .func7(dec_func7),
        .rs1_addr(dec_rs1),
        .rs2_addr(dec_rs2),
        .rd_addr(dec_rd),
        .imm(dec_imm)
    );

    ////////// ID/EX latch //////////
    
    always @(posedge clk or negedge rst_) begin
        id_valid <= 1'b0;
        id_pc    <= 32'b0;
        opcode   <= 7'b0;
        func3    <= 3'b0;
        func7    <= 7'b0;
        rs1_addr <= 5'b0;
        rs2_addr <= 5'b0;
        rd_addr  <= 5'b0;
        imm      <= 32'b0;
        stall_if <= 1'b0;
        if (!rst_) begin
            id_valid <= 1'b0;
            id_pc    <= 32'b0;
            opcode   <= 7'b0;
            func3    <= 3'b0;
            func7    <= 7'b0;
            rs1_addr <= 5'b0;
            rs2_addr <= 5'b0;
            rd_addr  <= 5'b0;
            imm      <= 32'b0;
            stall_if <= 1'b0;
        end
        else if (flush) begin
            id_valid <= 1'b0;
            id_pc    <= 32'b0;
            opcode   <= 7'b0;
            func3    <= 3'b0;
            func7    <= 7'b0;
            rs1_addr <= 5'b0;
            rs2_addr <= 5'b0;
            rd_addr  <= 5'b0;
            imm      <= 32'b0;
            stall_if <= 1'b0;
        end
        else if (stall) begin
            id_valid <= id_valid;
            id_pc    <= id_pc;
            opcode   <= opcode;
            func3    <= func3;
            func7    <= func7;
            rs1_addr <= rs1_addr;
            rs2_addr <= rs2_addr;
            rd_addr  <= rd_addr;
            imm      <= imm;
            stall_if <= 1'b1;
        end
        else begin
            if (valid) begin
                id_valid <= 1'b1;
                id_pc    <= pc;
                opcode   <= dec_opcode;
                func3    <= dec_func3;
                func7    <= dec_func7;
                rs1_addr <= dec_rs1;
                rs2_addr <= dec_rs2;
                rd_addr  <= dec_rd;
                imm      <= dec_imm;
                stall_if <= 1'b0;
            end
            else begin
                id_valid <= 1'b0;
                stall_if <= 1'b0;
            end
        end
    end
endmodule
