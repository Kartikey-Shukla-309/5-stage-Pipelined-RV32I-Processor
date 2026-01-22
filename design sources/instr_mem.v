`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08.01.2026 18:45:07
// Design Name: 
// Module Name: instr_mem
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




//-----------------------------------------//
/////////// for hardware only /////////////

//module instr_mem (
//    input        clk,
//    input        req,
//    input [9:0]  addr,
//    output reg   instr_valid,
//    output reg [31:0] instr
//);

//    reg [31:0] ROM [0:1023];

//    initial
//        $readmemh("instruction_memory.mem", ROM);

//    always @(posedge clk) begin
//        if (req) begin
//            instr <= ROM[addr];
//            instr_valid <= 1'b1;
//        end else begin
//            instr <= 32'h00000013;
//            instr_valid <= 1'b0;
//        end
//    end
//endmodule




//-----------------------------------------//
/////////// for simulation only /////////////
module instr_mem (
    input        clk,
    input        req,
    input [9:0]  addr,
    output reg   instr_valid,
    output reg [31:0] instr
);

    reg [31:0] ROM [0:1023];

    // Hard-coded program
    initial begin
        ROM[0] = 32'h00000013;
        ROM[1] = 32'h002081B3;
        ROM[2] = 32'h00F0C093;
        ROM[3] = 32'h0020E663;
        ROM[4] = 32'h12345097;
    end

    always @(posedge clk) begin
        if (req) begin
            instr <= ROM[addr];
            instr_valid <= 1'b1;
        end else begin
            instr <= 32'h00000013;
            instr_valid <= 1'b0;
        end
    end
endmodule