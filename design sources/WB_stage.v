`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 17.01.2026 22:53:27
// Design Name: 
// Module Name: WB_stage
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


module WB_stage(
    input clk,
    input rst_,
    input [31:0] mem_wb_alu,    // from MEM_stage
    input [31:0] mem_wb_data,   // from MEM_stage
    input [4:0] wb_rd_addr,     // from MEM_stage
    input wb_reg_write,         // from MEM_stage
    input wb_mem_to_reg,        // from MEM_stage

    output reg rf_we,           // to register_file
    output reg [4:0] rf_waddr,  // to register_file
    output reg [31:0] rf_wdata  // to register_file
    );
    always @(posedge clk or negedge rst_) begin
        rf_we <= 1'b0;
        rf_waddr <= 5'b0;
        rf_wdata <= 32'b0;
        if (!rst_) begin
            rf_we <= 1'b0;
            rf_waddr <= 5'b0;
            rf_wdata <= 32'b0;
        end
        else begin
            rf_we <= wb_reg_write;
            rf_waddr <= wb_rd_addr;
            if (wb_mem_to_reg)
                rf_wdata <= mem_wb_data;
            else
                rf_wdata <= mem_wb_alu;
        end
    end
endmodule
