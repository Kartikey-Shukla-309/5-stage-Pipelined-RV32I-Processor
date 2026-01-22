`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 18.01.2026 00:18:20
// Design Name: 
// Module Name: hazard_unit_tb
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


module hazard_unit_tb();
    reg [4:0] id_rs1;
    reg [4:0] id_rs2;
    reg [4:0] ex_rd;
    reg ex_reg_write;
    reg [4:0] mem_rd;
    reg mem_reg_write;

    wire stall;

    hazard_unit m(
        .id_rs1(id_rs1),
        .id_rs2(id_rs2),
        .ex_rd(ex_rd),
        .ex_reg_write(ex_reg_write),
        .mem_rd(mem_rd),
        .mem_reg_write(mem_reg_write),
        .stall(stall)
    );

    initial begin
        id_rs1 = 5'd1;
        id_rs2 = 5'd2;
        ex_rd  = 5'd3;
        ex_reg_write = 1'b1;
        mem_rd = 5'd4;
        mem_reg_write = 1'b1;
        
        #10;
        id_rs1 = 5'd5;
        id_rs2 = 5'd2;
        ex_rd  = 5'd5;
        ex_reg_write = 1'b1;
        mem_rd = 5'd0;
        mem_reg_write = 1'b0;
        
        #10;
        id_rs1 = 5'd0;
        id_rs2 = 5'd1;
        ex_rd  = 5'd0;
        ex_reg_write = 1'b1;
        mem_rd = 5'd0;
        mem_reg_write = 1'b0;
        
        #10;
        id_rs1 = 5'd1;
        id_rs2 = 5'd6;
        ex_rd  = 5'd0;
        ex_reg_write = 1'b0;
        mem_rd = 5'd6;
        mem_reg_write = 1'b1;
        
        #10;
        id_rs1 = 5'd7;
        id_rs2 = 5'd8;
        ex_rd  = 5'd7;
        ex_reg_write = 1'b1;
        mem_rd = 5'd8;
        mem_reg_write = 1'b1;

        #10;
        $finish;
    end
endmodule
