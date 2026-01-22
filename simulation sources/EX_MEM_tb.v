`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 16.01.2026 17:10:46
// Design Name: 
// Module Name: EX_MEM_tb
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


module EX_MEM_tb();
    reg clk;
    reg rst_;
    reg stall;
    reg flush;
    reg        ex_valid;
    reg [31:0] ex_alu_result;
    reg [31:0] ex_data;
    reg [4:0]  ex_rd_addr;
    reg        ex_reg_write;
    reg        ex_mem_read;
    reg        ex_mem_write;
    reg        ex_mem_to_reg;
    reg        ex_branch;
    reg        ex_flush;
    reg [31:0] ex_pc_branch;
    reg [31:0] ex_pc_flush;

    wire        mem_valid;
    wire [31:0] mem_alu_result;
    wire [31:0] mem_data;
    wire [4:0]  mem_rd_addr;
    wire        mem_reg_write;
    wire        mem_mem_read;
    wire        mem_mem_write;
    wire        mem_mem_to_reg;
    wire        mem_branch;
    wire        mem_flush;
    wire [31:0] mem_pc_branch;
    wire [31:0] mem_pc_flush;

    EX_MEM m(
        .clk(clk),
        .rst_(rst_),
        .stall(stall),
        .flush(flush),
        .ex_valid(ex_valid),
        .ex_alu_result(ex_alu_result),
        .ex_data(ex_data),
        .ex_rd_addr(ex_rd_addr),
        .ex_reg_write(ex_reg_write),
        .ex_mem_read(ex_mem_read),
        .ex_mem_write(ex_mem_write),
        .ex_mem_to_reg(ex_mem_to_reg),
        .ex_branch(ex_branch),
        .ex_flush(ex_flush),
        .ex_pc_branch(ex_pc_branch),
        .ex_pc_flush(ex_pc_flush),

        .mem_valid(mem_valid),
        .mem_alu_result(mem_alu_result),
        .mem_data(mem_data),
        .mem_rd_addr(mem_rd_addr),
        .mem_reg_write(mem_reg_write),
        .mem_mem_read(mem_mem_read),
        .mem_mem_write(mem_mem_write),
        .mem_mem_to_reg(mem_mem_to_reg),
        .mem_branch(mem_branch),
        .mem_flush(mem_flush),
        .mem_pc_branch(mem_pc_branch),
        .mem_pc_flush(mem_pc_flush)
    );

    always #5 clk = ~clk;

    initial begin
        clk = 0;
        rst_ = 0;
        stall = 0;
        flush = 0;

        ex_valid = 0;
        ex_alu_result = 0;
        ex_data = 0;
        ex_rd_addr = 0;
        ex_reg_write = 0;
        ex_mem_read = 0;
        ex_mem_write = 0;
        ex_mem_to_reg = 0;
        ex_branch = 0;
        ex_flush = 0;
        ex_pc_branch = 0;
        ex_pc_flush = 0;

        // Reset
        #12;
        rst_ = 1;
        $display("Reset released");

        // Normal working
        @(negedge clk);
        ex_valid = 1;
        ex_alu_result = 32'h12345678;
        ex_data = 32'hDEADBEEF;
        ex_rd_addr = 5'd10;
        ex_reg_write = 1;
        ex_mem_read = 1;
        ex_mem_write = 0;
        ex_mem_to_reg = 1;
        ex_branch = 0;
        ex_flush = 0;
        ex_pc_branch = 32'h100;
        ex_pc_flush = 32'h200;

        @(posedge clk);
        $display("Normal latch:");
        $display("mem_alu_result = %h", mem_alu_result);

        // Stall
        @(negedge clk);
        stall = 1;
        ex_alu_result = 32'hAAAAAAAA;

        @(posedge clk);
        $display("After stall (should be unchanged):");
        $display("mem_alu_result = %h", mem_alu_result);

        #10
        stall = 0;

        // Flush
        @(negedge clk);
        flush = 1;

        @(posedge clk);
        $display("After flush:");
        $display("mem_valid=%b mem_reg_write=%b mem_mem_read=%b",
                  mem_valid, mem_reg_write, mem_mem_read);

        #10
        flush = 0;

        #20;
        $stop;
    end
endmodule
