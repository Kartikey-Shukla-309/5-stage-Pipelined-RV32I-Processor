`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08.01.2026 18:12:17
// Design Name: 
// Module Name: pc
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


module program_counter(
    input clk,
    input rst_,
    input stall,            // from ID_stage
    input branch,           // from EX_stage
    input flush,            // from EX_stage
    input [31:0] pc_branch, // from EX_stage
    input [31:0] pc_flush,  // from EX_stage
    
    output reg [31:0] pc    // to instr_mem
    );
    
    reg [31:0] pc_next;
    always @(*) begin
        if(flush)           pc_next = pc_flush;
        else if(branch)     pc_next = pc_branch;
        else if(stall)      pc_next = pc;
        else                pc_next = pc + 32'd4;
    end
    
    always @(posedge clk or negedge rst_) begin
        pc <= pc_next;
        if(!rst_)   pc <= 32'b0;
        else        pc <= pc_next;
    end
endmodule
