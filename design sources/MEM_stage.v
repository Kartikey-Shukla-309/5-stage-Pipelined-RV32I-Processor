`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 16.01.2026 19:02:32
// Design Name: 
// Module Name: MEM_stage
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


module MEM_stage(
    input clk,
    input rst_,
    input mem_valid,                    // from EX_stage
    input [31:0] mem_alu_result,        // from EX_stage
    input [31:0] mem_data,              // from EX_stage
    input [4:0]  mem_rd_addr,           // from EX_stage
    input mem_reg_write,                // from EX_stage
    input mem_mem_read,                 // from EX_stage
    input mem_mem_write,                // from EX_stage
    input mem_mem_to_reg,               // from EX_stage

    output reg [31:0] mem_wb_data,      // to WB_stage
    output reg [31:0] mem_wb_alu,       // to WB_stage
    output reg [4:0] wb_rd_addr,        // to WB_stage
    output reg wb_reg_write,            // to WB_stage
    output reg wb_mem_to_reg            // to WB_stage
    );
    
    reg [31:0] data_mem [0:1023];
    
    initial begin
        $readmemh("data_memory.mem",data_mem);
    end
    
    wire [9:0] mem_addr = mem_alu_result[11:2];
    
    // Memory Read 
//    always @(posedge clk) begin
//        if (mem_valid && mem_mem_read)
//            mem_wb_data <= data_mem[mem_addr];
//        else
//            mem_wb_data <= 32'b0;
//    end
    
    // Memory write
    always @(posedge clk) begin
        if (mem_valid && mem_mem_write)
            data_mem[mem_addr] <= mem_data;
    end
    
    always @(posedge clk or negedge rst_) begin
        mem_wb_data <= 32'b0;
        mem_wb_alu <= 32'b0;
        wb_rd_addr <= 5'b0;
        wb_reg_write <= 1'b0;
        wb_mem_to_reg  <= 1'b0;
        if (!rst_) begin
            mem_wb_data <= 32'b0;
            mem_wb_alu <= 32'b0;
            wb_rd_addr <= 5'b0;
            wb_reg_write <= 1'b0;
            wb_mem_to_reg  <= 1'b0;
        end
        else begin
            // Memory read
            if (mem_valid && mem_mem_read)
                mem_wb_data <= data_mem[mem_addr];
            else
                mem_wb_data <= 32'b0;
            
            mem_wb_alu <= mem_alu_result;
            wb_rd_addr <= mem_rd_addr;
            wb_reg_write <= mem_reg_write;
            wb_mem_to_reg <= mem_mem_to_reg;
        end
    end
endmodule
