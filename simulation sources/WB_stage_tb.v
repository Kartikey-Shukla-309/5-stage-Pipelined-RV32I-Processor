`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 17.01.2026 23:02:44
// Design Name: 
// Module Name: WB_stage_tb
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


module WB_stage_tb();
    reg clk;
    reg rst_;
    reg [31:0] mem_wb_alu;
    reg [31:0] mem_wb_data;
    reg [4:0] wb_rd_addr;
    reg wb_reg_write;
    reg wb_mem_to_reg;

    wire rf_we;
    wire [4:0] rf_waddr;
    wire [31:0] rf_wdata;

    WB_stage m(
        .clk(clk),
        .rst_(rst_),
        .mem_wb_alu(mem_wb_alu),
        .mem_wb_data(mem_wb_data),
        .wb_rd_addr(wb_rd_addr),
        .wb_reg_write(wb_reg_write),
        .wb_mem_to_reg(wb_mem_to_reg),
        .rf_we(rf_we),
        .rf_waddr(rf_waddr),
        .rf_wdata(rf_wdata)
    );

    always #5 clk = ~clk;

    initial begin
        clk = 0;
        rst_ = 0;
        mem_wb_alu    = 32'b0;
        mem_wb_data   = 32'b0;
        wb_rd_addr    = 5'b0;
        wb_reg_write  = 1'b0;
        wb_mem_to_reg = 1'b0;

        #20;
        rst_ = 1;

        // ALU write-back
        #10
        mem_wb_alu    = 32'h1234_5678;
        wb_rd_addr    = 5'd10;
        wb_reg_write  = 1'b1;
        wb_mem_to_reg = 1'b0;

        // Memory write-back
        #10
        mem_wb_data   = 32'hDEAD_BEEF;
        wb_rd_addr    = 5'd7;
        wb_reg_write  = 1'b1;
        wb_mem_to_reg = 1'b1;

        @(posedge clk);

        // Write disabled
        #10
        mem_wb_alu    = 32'hFFFF_0000;
        wb_rd_addr    = 5'd3;
        wb_reg_write  = 1'b0;
        wb_mem_to_reg = 1'b0;

        #30;
        $finish;
    end
endmodule
