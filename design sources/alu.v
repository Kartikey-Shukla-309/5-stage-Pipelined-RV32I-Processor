`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11.01.2026 22:59:40
// Design Name: 
// Module Name: alu
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


module alu(
    input [31:0] pc,
    input [2:0] func3,
    input [6:0] func7,
    input [31:0] imm,
    input is_Rtype,
    input is_Itype,
    input is_load,
    input is_store,
    input is_branch,
    input is_jal,
    input is_jalr,
    input is_lui,
    input is_auipc,
    input [31:0] rs1,
    input [31:0] rs2,
    
    output reg branch,
    output reg flush,
    output reg [31:0] alu_result,
    output reg [31:0] pc_branch,
    output reg [31:0] pc_flush
    );
    
    always @(*) begin
        alu_result = 32'b0;
        branch = 1'b0;
        flush = 1'b0;
        pc_branch = 32'b0;
        pc_flush = 32'b0;
        
        ////////////////// R-Type /////////////////
        
        if(is_Rtype) begin
            if(func3==3'b000 && func7[5]==1'b0)      alu_result = $signed(rs1) + $signed(rs2);  // add
            else if(func3==3'b000 && func7[5]==1'b1) alu_result = $signed(rs1) - $signed(rs2);  // sub
            else if(func3==3'b100)  alu_result = rs1 ^ rs2;  // xor
            else if(func3==3'b110)  alu_result = rs1 | rs2;  // or
            else if(func3==3'b111)  alu_result = rs1 & rs2;  // and
            else if(func3==3'b010)  alu_result = ($signed(rs1) < $signed(rs2)) ? 32'b1 : 32'b0;  // slt
            else if(func3==3'b011)  alu_result = (rs1 < rs2) ? 32'b1 : 32'b0;  // sltu
            else if(func3==3'b001)  alu_result = rs1 << rs2[4:0];  // sll
            else if(func3==3'b101 && func7[5]==1'b0)  alu_result = rs1 >> rs2[4:0];  // srl
            else if(func3==3'b101 && func7[5]==1'b1)  alu_result = $signed(rs1) >>> rs2[4:0];  // sra
        end
        
        ////////////////// I-Type /////////////////
        
        else if(is_Itype) begin
            if(func3==3'b000)       alu_result = $signed(rs1) + $signed(imm);  // addi
            else if(func3==3'b100)  alu_result = rs1 ^ imm;  // xori
            else if(func3==3'b110)  alu_result = rs1 | imm;  // ori
            else if(func3==3'b111)  alu_result = rs1 & imm;  // andi
            else if(func3==3'b010)  alu_result = ($signed(rs1) < $signed(imm)) ? 32'b1 : 32'b0;  // slti
            else if(func3==3'b011)  alu_result = (rs1 < imm) ? 32'b1 : 32'b0;  // sltiu
            else if(func3==3'b001 && imm[11:5]==7'b0)  alu_result = rs1 << imm[4:0];  // slli
            else if(func3==3'b101 && imm[11:5]==7'b0)  alu_result = rs1 >> imm[4:0];  // srli
            else if(func3==3'b101 && imm[11:5]==7'b0100000)  alu_result = $signed(rs1) >>> imm[4:0];  // srai
        end
        
        /////// Load and Store instructions ///////
        
        else if(is_load || is_store) begin
            alu_result = rs1 + imm;
        end
        
        ////////////////// B-Type /////////////////
        
        else if(is_branch) begin
            if(func3==3'b000 && rs1==rs2) begin     // beq
                flush = 1'b1;
                branch = 1'b1;
                pc_branch = pc + imm;
                pc_flush = pc_branch;
            end
            else if(func3==3'b001 && rs1!=rs2) begin    // bne
                flush = 1'b1;
                branch = 1'b1;
                pc_branch = pc + imm;
                pc_flush = pc_branch;
            end
            else if(func3==3'b100 && $signed(rs1)<$signed(rs2)) begin   // blt
                flush = 1'b1;
                branch = 1'b1;
                pc_branch = pc + imm;
                pc_flush = pc_branch;
            end
            else if(func3==3'b101 && $signed(rs1)>=$signed(rs2)) begin   // bge
                flush = 1'b1;
                branch = 1'b1;
                pc_branch = pc + imm;
                pc_flush = pc_branch;
            end
            else if(func3==3'b110 && rs1<rs2) begin   // bltu
                flush = 1'b1;
                branch = 1'b1;
                pc_branch = pc + imm;
                pc_flush = pc_branch;
            end
            else if(func3==3'b111 && rs1>=rs2) begin   // bgeu
                flush = 1'b1;
                branch = 1'b1;
                pc_branch = pc + imm;
                pc_flush = pc_branch;
            end
        end

        ///////////// jal instruction /////////////
        
        else if (is_jal) begin
            alu_result = pc + 32'd4;   // return address stored in 'rd'
            flush = 1'b1;
            branch = 1'b1;
            pc_branch = pc + imm;   // jump address
            pc_flush = pc_branch;
        end
        
        ///////////// jalr instruction ////////////
        
        else if (is_jalr) begin
            alu_result = pc + 32'd4;    // return address stored in 'rd'
            flush      = 1'b1;
            branch     = 1'b1;
            pc_branch  = rs1 + imm;     // jump address
            pc_flush   = pc_branch;
        end
        
        ///////////// lui instruction /////////////
        
        else if(is_lui) alu_result = imm;
        
        //////////// auipc instruction ////////////
        
        else if(is_auipc)   alu_result = pc + imm;
    end
endmodule
