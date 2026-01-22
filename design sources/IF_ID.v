`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09.01.2026 17:29:43
// Design Name: 
// Module Name: IF_ID
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


module IF_ID(
    input clk,
    input rst_,
    input stall,                    // from ID_stage
    input flush,                    // from EX_stage
    input branch,                   // from EX_stage
    input valid,                    // from IF_stage
    input [31:0] pc,                // from IF_stage
    input [31:0] instr,             // from IF_stage
    
    output reg [31:0] pc_out,       // to ID_stage
    output reg [31:0] instruction,  // to ID stage
    output reg instr_valid
    );
    
    always @(posedge clk or negedge rst_) begin
        instruction <= 32'h00000013;
        pc_out <= 32'b0;
        instr_valid <= 1'b1;
        if(!rst_) begin
            instruction <= 32'h00000013;
            pc_out <= 32'b0;
            instr_valid <= 1'b0;
        end
        else if(flush || branch) begin
            instruction <= 32'h00000013;
            pc_out <= 32'b0;
            instr_valid <= 1'b0;
        end
        else if(stall) begin
            instruction <= instruction;
            pc_out <= pc_out;
            instr_valid <= instr_valid;
        end
        else begin
            if (valid) begin
                instruction  <= instr;
                pc_out       <= pc;
                instr_valid  <= 1'b1;
            end
            else begin
                instruction  <= 32'h00000013;
                pc_out       <= pc_out;
                instr_valid  <= 1'b0;
            end
        end
    end
endmodule
