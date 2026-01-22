`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 18.01.2026 00:12:21
// Design Name: 
// Module Name: hazard_unit
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

module hazard_unit(
    input [4:0] id_rs1,     // from ID_stage
    input [4:0] id_rs2,     // from ID_stage
    input [4:0] ex_rd,      // from EX_stage
    input ex_reg_write,     // from EX_stage
    input [4:0] mem_rd,     // from MEM_stage
    input mem_reg_write,    // from MEM_stage

    output stall            // to ID_stage
    );
    wire ex_hazard;
    wire mem_hazard;

    assign ex_hazard = ex_reg_write && (ex_rd != 5'b0) && ((ex_rd == id_rs1) || (ex_rd == id_rs2));

    assign mem_hazard = mem_reg_write && (mem_rd != 5'b0) && ((mem_rd == id_rs1) || (mem_rd == id_rs2));

    assign stall = ex_hazard || mem_hazard;
endmodule
