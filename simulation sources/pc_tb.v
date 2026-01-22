`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08.01.2026 18:37:09
// Design Name: 
// Module Name: pc_tb
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


module program_counter_tb();

    reg clk;
    reg rst_;
    reg stall;
    reg branch;
    reg flush;
    reg [31:0] pc_branch;
    reg [31:0] pc_flush;

    wire [31:0] pc;

    program_counter m(
        .clk(clk),
        .rst_(rst_),
        .stall(stall),
        .branch(branch),
        .flush(flush),
        .pc_branch(pc_branch),
        .pc_flush(pc_flush),
        .pc(pc)
    );

    always #5 clk = ~clk;

    initial begin
        clk=0;
        rst_ = 0;
        stall = 0;
        branch = 0;
        flush = 0;
        pc_branch = 32'h00000000;
        pc_flush  = 32'h00000000;

        $display("Time\tPC\tAction");
        $monitor("%0t\t%h\tstall=%b branch=%b flush=%b",
                  $time, pc, stall, branch, flush);

        #12;
        rst_ = 1;
        #10;
        stall = 1;
        #20;
        stall = 0;
        
        pc_branch = 32'h00000040;
        branch = 1;
        #10;
        branch = 0;
        #10;

        pc_flush = 32'h00000100;
        flush = 1;
        #10;
        flush = 0;

        #20;
        $finish;
    end
endmodule
