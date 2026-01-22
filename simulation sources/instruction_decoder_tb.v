`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10.01.2026 18:31:18
// Design Name: 
// Module Name: instruction_decoder_tb
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


module instruction_decoder_tb();
    reg  [31:0] instr;

    wire [6:0] opcode;
    wire [2:0] func3;
    wire [6:0] func7;
    wire [4:0] rs1_addr;
    wire [4:0] rs2_addr;
    wire [4:0] rd_addr;
    wire [31:0] imm;

    instruction_decoder m(
        .instr(instr),
        .opcode(opcode),
        .func3(func3),
        .func7(func7),
        .rs1_addr(rs1_addr),
        .rs2_addr(rs2_addr),
        .rd_addr(rd_addr),
        .imm(imm)
    );

    initial begin
        // I-type
        instr = 32'b111111111000_00010_000_00001_0010011;
        #10;

        // S-type
        instr = 32'b0000000_00010_00011_010_10000_0100011;
        #10;

        // B-type
        instr = 32'b0_000001_00010_00001_000_1100_0_1100011;
        #10;

        // U-type
        instr = 32'b00010010001101000101_00001_0110111;
        #10;

        // J-type
        instr = 32'b0_0000001000_0_0000000001_00001_1101111;
        #10;

        $finish;
    end

    initial begin
        $monitor(
            "instr=%h opcode=%b imm=%h",
            instr, opcode, imm
        );
    end
endmodule
