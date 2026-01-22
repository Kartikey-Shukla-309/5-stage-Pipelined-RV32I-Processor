`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09.01.2026 15:59:13
// Design Name: 
// Module Name: IF_stage
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


module IF_stage(
    input clk,
    input rst_,
    input stall,                    // from ID_stage
    input flush,                    // from EX_stage
    input branch,                   // from EX_stage
    input [31:0] pc_branch,         // from EX_stage
    input [31:0] pc_flush,          // from EX_stage
    
    output reg req,                 // to instr_mem
    output wire [31:0] pc,          // to instr_mem
    output reg [31:0] instruction,  // to IF_ID latch
    output reg valid                // to IF_ID latch
    );
        
    /////////// Program Counter //////////
    
    program_counter m1(
        .clk(clk),
        .rst_(rst_),
        .stall(stall),
        .branch(branch),
        .flush(flush),
        .pc_branch(pc_branch),
        .pc_flush(pc_flush),
        .pc(pc)
    );
    
    //////// Instruction Memory /////////
    
    wire [31:0] instr;     // to instr_mem
    wire instr_valid;      // from instr_mem
    
    always @(posedge clk or negedge rst_) begin
        req <= 1'b1;
        if(!rst_)   req <= 1'b0;
        else if(stall || flush || branch)   req <= 1'b0;
        else req <= 1'b1;
    end
    
    instr_mem m2(
        .clk(clk),
        .addr(pc[11:2]),
        .req(req),
        .instr(instr),
        .instr_valid(instr_valid)
    );
    
    ////////// To IF_ID latch //////////
    
    always @(posedge clk or negedge rst_) begin
        valid <= 1'b1;
        if(!rst_)   valid <= 1'b0;
        else if(flush || stall || branch)   valid <= 1'b0;
        else    valid <= 1'b1;
    end
    
    always @(posedge clk or negedge rst_) begin
        instruction <= 32'h00000013;
        if (!rst_) instruction <= 32'h00000000;
        else if(valid)   instruction <= instr;
        else    instruction <= 32'h00000013;
    end
endmodule
