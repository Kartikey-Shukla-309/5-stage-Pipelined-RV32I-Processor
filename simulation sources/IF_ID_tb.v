`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10.01.2026 16:35:13
// Design Name: 
// Module Name: IF_ID_tb
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


module IF_ID_tb;

    reg clk;
    reg rst_;
    reg stall;
    reg flush;
    reg branch;
    reg valid;
    reg [31:0] pc;
    reg [31:0] instr;

    wire [31:0] pc_out;
    wire [31:0] instruction;
    wire instr_valid;

    IF_ID m(
        .clk(clk),
        .rst_(rst_),
        .stall(stall),
        .flush(flush),
        .branch(branch),
        .valid(valid),
        .pc(pc),
        .instr(instr),
        .pc_out(pc_out),
        .instruction(instruction),
        .instr_valid(instr_valid)
    );

    always #5 clk = ~clk;

    initial begin
        clk    = 0;
        rst_   = 0;
        stall = 0;
        flush = 0;
        branch = 0;
        valid = 0;
        pc    = 32'b0;
        instr = 32'b0;

        #12;
        rst_ = 1;

        // -------- Normal instruction --------
        valid = 1;
        pc    = 32'h0000_0004;
        instr = 32'h00500093;
        #10
        
        // -------- Stall --------
        stall = 1;
        pc    = 32'h0000_0008;
        instr = 32'h00600113;
        #20
        stall = 0;

        // -------- Flush --------
        flush = 1;
        #20
        flush = 0;
        #5

        // -------- Branch --------
        branch = 1;
        #20
        branch = 0;
        #5

        // -------- valid = 0 --------
        valid = 0;
        pc    = 32'h0000_0010;
        instr = 32'h00700193;
        
        #20;
        $finish;
    end

    initial begin
        $monitor(
            "T=%0t | rst=%b stall=%b flush=%b branch=%b valid=%b | pc_out=%h instr=%h instr_valid=%b",
            $time, rst_, stall, flush, branch, valid,
            pc_out, instruction, instr_valid
        );
    end
endmodule
