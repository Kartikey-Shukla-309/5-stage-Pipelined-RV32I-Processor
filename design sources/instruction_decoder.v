`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10.01.2026 18:13:51
// Design Name: 
// Module Name: instruction_decoder
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


module instruction_decoder(
    input [31:0] instr,
    
    output [6:0] opcode,
    output [2:0] func3,
    output [6:0] func7,
    output [4:0] rs1_addr,
    output [4:0] rs2_addr,
    output [4:0] rd_addr,
    output reg [31:0] imm
    );
    
    assign opcode   = instr[6:0];
    assign rd_addr  = instr[11:7];
    assign func3    = instr[14:12];
    assign rs1_addr = instr[19:15];
    assign rs2_addr = instr[24:20];
    assign func7    = instr[31:25];
    
    always @(*) begin
        case(opcode)
        
            // I-type instruction
            7'b0010011,
            7'b0000011,
            7'b1100111: imm = {{20{instr[31]}},instr[31:20]};
            
            // S-type instruction
            7'b0100011: imm = {{20{instr[31]}},instr[31:25],instr[11:7]};
            
            // B-type instruction
            7'b1100011: imm = {{19{instr[31]}},instr[31],instr[7],instr[30:25],instr[11:8],1'b0};
            
            // U-type instruction
            7'b0110111,
            7'b0010111: imm = {instr[31:12],12'b0};
            
            // J-type instruction
            7'b1101111: imm = {{11{instr[31]}},instr[31],instr[19:12],instr[20],instr[30:21],1'b0};
            
            default: imm = 32'b0;
        endcase
    end
endmodule
