`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10.01.2026 18:22:21
// Design Name: 
// Module Name: register_file
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


module register_file(
    input clk,
    input [4:0] rs1_addr,
    input [4:0] rs2_addr,
    input w_en,
    input [4:0] w_addr,
    input [31:0] w_data,
    
    output [31:0] rs1_data,
    output [31:0] rs2_data
    );
    
    reg [31:0] gpio [0:31];
    
    // this block for simulation 
    integer i;
    initial begin
        for (i = 0; i < 32; i = i + 1)
            gpio[i] = 32'b0;

        gpio[5'd1] = 32'd10;  // x1 = 10
        gpio[5'd2] = 32'd20;  // x2 = 20
    end
    
    // Read operation
    assign rs1_data = (rs1_addr == 5'b0) ? 32'b0 : gpio[rs1_addr];
    assign rs2_data = (rs2_addr == 5'b0) ? 32'b0 : gpio[rs2_addr];
    
    // Write operation
    always @(posedge clk) begin
        if (w_en && (w_addr != 5'b0))
            gpio[w_addr] <= w_data;
        gpio[5'd0] <= 32'b0;
    end
endmodule
