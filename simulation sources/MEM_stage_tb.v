`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 17.01.2026 11:05:21
// Design Name: 
// Module Name: MEM_stage_tb
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


module MEM_stage_tb();
    reg clk;
    reg rst_;
    reg mem_valid;
    reg [31:0] mem_alu_result;
    reg [31:0] mem_data;
    reg [4:0]  mem_rd_addr;
    reg mem_reg_write;
    reg mem_mem_read;
    reg mem_mem_write;
    reg mem_mem_to_reg;

    wire [31:0] mem_wb_data;
    wire [31:0] mem_wb_alu;
    wire [4:0]  wb_rd_addr;
    wire wb_reg_write;
    wire wb_mem_to_reg;

    MEM_stage m(
        .clk(clk),
        .rst_(rst_),
        .mem_valid(mem_valid),
        .mem_alu_result(mem_alu_result),
        .mem_data(mem_data),
        .mem_rd_addr(mem_rd_addr),
        .mem_reg_write(mem_reg_write),
        .mem_mem_read(mem_mem_read),
        .mem_mem_write(mem_mem_write),
        .mem_mem_to_reg(mem_mem_to_reg),
        .mem_wb_data(mem_wb_data),
        .mem_wb_alu(mem_wb_alu),
        .wb_rd_addr(wb_rd_addr),
        .wb_reg_write(wb_reg_write),
        .wb_mem_to_reg(wb_mem_to_reg)
    );

    always #5 clk = ~clk;

    initial begin
        clk = 0;
        rst_ = 0;
        mem_valid = 0;
        mem_alu_result = 0;
        mem_data = 0;
        mem_rd_addr = 0;
        mem_reg_write = 0;
        mem_mem_read = 0;
        mem_mem_write = 0;
        mem_mem_to_reg = 0;

        #20;
        rst_ = 1;

        // Store Word (SW)
        @(posedge clk);
        mem_valid       = 1;
        mem_mem_write   = 1;
        mem_mem_read    = 0;
        mem_alu_result  = 32'h0000_0010;   // address
        mem_data        = 32'hDEADBEEF;    // data to store

        @(posedge clk);
        mem_mem_write   = 0;
        mem_valid       = 0;

        // Load Word (LW)
        @(posedge clk);
        mem_valid       = 1;
        mem_mem_read    = 1;
        mem_mem_write   = 0;
        mem_mem_to_reg  = 1;
        mem_reg_write   = 1;
        mem_rd_addr     = 5'd3;
        mem_alu_result  = 32'h0000_0010;   // same address

        @(posedge clk);
        mem_valid       = 0;
        mem_mem_read    = 0;

        // ALU-only instruction
        @(posedge clk);
        mem_valid       = 1;
        mem_mem_read    = 0;
        mem_mem_write   = 0;
        mem_mem_to_reg  = 0;
        mem_reg_write   = 1;
        mem_rd_addr     = 5'd5;
        mem_alu_result  = 32'h12345678;

        @(posedge clk);
        mem_valid       = 0;

        #50;
        $finish;
    end
endmodule
