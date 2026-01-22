`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09.01.2026 17:03:27
// Design Name: 
// Module Name: IF_stage_tb
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



module IF_stage_tb;

    reg clk;
    reg rst_;
    reg stall;
    reg flush;
    reg branch;
    reg [31:0] pc_branch;
    reg [31:0] pc_flush;

    wire req;
    wire [31:0] pc;
    wire [31:0] instruction;
    wire valid;

    IF_stage m(
        .clk(clk),
        .rst_(rst_),
        .stall(stall),
        .flush(flush),
        .branch(branch),
        .pc_branch(pc_branch),
        .pc_flush(pc_flush),
        .req(req),
        .pc(pc),
        .instruction(instruction),
        .valid(valid)
    );

    always #5 clk = ~clk;

    initial begin
        $display("Time\tPC\t\tREQ\tVALID\tINSTR");
        $monitor("%0t\t%h\t%b\t%b\t%h",
                  $time, pc, req, valid, instruction);

        clk = 0;
        rst_ = 0;
        stall = 0;
        flush = 0;
        branch = 0;
        pc_branch = 32'h0;
        pc_flush  = 32'h0;

        #12;
        rst_ = 1;

        // Normal fetch
        #40;

        // Stall for 2 cycles
        stall = 1;
        #20;
        stall = 0;

        // Flush
        flush = 1;
        pc_flush = 32'h00000040;
        #10;
        flush = 0;

        // Branch taken
        #20;
        branch = 1;
        pc_branch = 32'h00000080;
        #10;
        branch = 0;
        
        #40;

        $finish;
    end
endmodule
