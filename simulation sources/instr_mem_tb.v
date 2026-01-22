`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08.01.2026 19:00:49
// Design Name: 
// Module Name: instr_mem_tb
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



module instr_mem_tb();

    reg  [9:0] addr;
    reg         req;

    wire [31:0] instr;
    wire instr_valid;
    instr_mem m(
        .addr(addr),
        .req(req),
        .instr(instr),
        .instr_valid(instr_valid)
    );

    initial begin
        $display("Time\taddr\tinstr");
        $monitor("%0t\t%h\t%h",
                  $time, addr, instr);

        addr = 10'd0;
        req  = 0;
        #10;

        req  = 1;
        addr = 10'd0;
        #10;

        addr = 10'd1;
        #10;

        addr = 10'd4;
        #10;

        req = 0;
        #10;

        $finish;
    end
endmodule
