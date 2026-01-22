`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12.01.2026 17:37:59
// Design Name: 
// Module Name: alu_tb
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


module alu_tb();
    reg [31:0] pc;
    reg [2:0]  func3;
    reg [6:0]  func7;
    reg [31:0] imm;
    reg is_Rtype;
    reg is_Itype;
    reg is_load;
    reg is_store;
    reg is_branch;
    reg is_jal;
    reg is_jalr;
    reg is_lui;
    reg is_auipc;
    reg [31:0] rs1;
    reg [31:0] rs2;

    wire branch;
    wire flush;
    wire [31:0] alu_result;
    wire [31:0] pc_branch;
    wire [31:0] pc_flush;

    alu m(
        .pc(pc),
        .func3(func3),
        .func7(func7),
        .imm(imm),
        .is_Rtype(is_Rtype),
        .is_Itype(is_Itype),
        .is_load(is_load),
        .is_store(is_store),
        .is_branch(is_branch),
        .is_jal(is_jal),
        .is_jalr(is_jalr),
        .is_lui(is_lui),
        .is_auipc(is_auipc),
        .rs1(rs1),
        .rs2(rs2),
        .branch(branch),
        .flush(flush),
        .alu_result(alu_result),
        .pc_branch(pc_branch),
        .pc_flush(pc_flush)
    );

    // Task to clear control signals
    task clear_ctrl;
        begin
            is_Rtype  = 0;
            is_Itype  = 0;
            is_load   = 0;
            is_store  = 0;
            is_branch = 0;
            is_jal    = 0;
            is_jalr   = 0;
            is_lui    = 0;
            is_auipc  = 0;
        end
    endtask

    initial begin
        // Default values
        pc    = 32'h1000;
        rs1   = 0;
        rs2   = 0;
        imm   = 0;
        func3 = 0;
        func7 = 0;
        clear_ctrl();

        #10;

        ////////////////// R-TYPE ADD //////////////////
        $display("R-type ADD");
        clear_ctrl();
        is_Rtype = 1;
        func3 = 3'b000;
        func7 = 7'b0000000;
        rs1 = 10;
        rs2 = 20;
        #10;
        $display("alu_result = %0d (expect 30)", alu_result);

        ////////////////// R-TYPE SUB //////////////////
        $display("R-type SUB");
        func7 = 7'b0100000;
        #10;
        $display("alu_result = %0d (expect -10)", alu_result);

        ////////////////// I-TYPE ADDI //////////////////
        $display("I-type ADDI");
        clear_ctrl();
        is_Itype = 1;
        func3 = 3'b000;
        rs1 = 32'd15;
        imm = 32'd5;
        #10;
        $display("alu_result = %0d (expect 20)", alu_result);

        ////////////////// LOAD //////////////////
        $display("LOAD address calculation");
        clear_ctrl();
        is_load = 1;
        rs1 = 32'h1000;
        imm = 32'h20;
        #10;
        $display("alu_result = %h (expect 1020)", alu_result);

        ////////////////// STORE //////////////////
        $display("STORE address calculation");
        clear_ctrl();
        is_store = 1;
        rs1 = 32'h2000;
        imm = 32'h10;
        #10;
        $display("alu_result = %h (expect 2010)", alu_result);

        ////////////////// BRANCH BEQ TAKEN //////////////////
        $display("BRANCH BEQ taken");
        clear_ctrl();
        is_branch = 1;
        func3 = 3'b000; // beq
        rs1 = 32'd5;
        rs2 = 32'd5;
        imm = 32'd16;
        #10;
        $display("branch=%b flush=%b pc_branch=%h",
                 branch, flush, pc_branch);

        ////////////////// BRANCH BNE NOT TAKEN //////////////////
        $display("BRANCH BNE not taken");
        func3 = 3'b001; // bne
        rs1 = 32'd5;
        rs2 = 32'd5;
        #10;
        $display("branch=%b flush=%b", branch, flush);

        ////////////////// JAL //////////////////
        $display("JAL");
        clear_ctrl();
        is_jal = 1;
        pc = 32'h3000;
        imm = 32'h40;
        #10;
        $display("alu_result (ra)=%h pc_branch=%h",
                 alu_result, pc_branch);

        ////////////////// JALR //////////////////
        $display("JALR");
        clear_ctrl();
        is_jalr = 1;
        pc = 32'h4000;
        rs1 = 32'h5000;
        imm = 32'h8;
        #10;
        $display("alu_result (ra)=%h pc_branch=%h",
                 alu_result, pc_branch);

        ////////////////// LUI //////////////////
        $display("LUI");
        clear_ctrl();
        is_lui = 1;
        imm = 32'h12345000;
        #10;
        $display("alu_result=%h (expect 12345000)", alu_result);

        ////////////////// AUIPC //////////////////
        $display("AUIPC");
        clear_ctrl();
        is_auipc = 1;
        pc = 32'h8000;
        imm = 32'h100;
        #10;
        $display("alu_result=%h (expect 8100)", alu_result);

        ////////////////// END //////////////////
        $display("ALU TEST COMPLETED");
        #20;
        $stop;
    end
endmodule
