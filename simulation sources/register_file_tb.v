`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10.01.2026 18:49:45
// Design Name: 
// Module Name: register_file_tb
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


module register_file_tb();
    reg clk;
    reg [4:0] rs1_addr;
    reg [4:0] rs2_addr;
    reg w_en;
    reg [4:0] w_addr;
    reg [31:0] w_data;

    wire [31:0] rs1_data;
    wire [31:0] rs2_data;

    register_file m(
        .clk(clk),
        .rs1_addr(rs1_addr),
        .rs2_addr(rs2_addr),
        .w_en(w_en),
        .w_addr(w_addr),
        .w_data(w_data),
        .rs1_data(rs1_data),
        .rs2_data(rs2_data)
    );

    always #5 clk = ~clk;

    initial begin
        clk = 0;
        w_en = 0;
        rs1_addr = 0;
        rs2_addr = 0;
        w_addr = 0;
        w_data = 0;

        // Write x1 = 0000AAAA
        #10
        w_en   = 1;
        w_addr = 5'b00001;
        w_data = 32'h0000AAAA;

        // Write x2 = 00005555
        #10
        w_addr = 5'b00010;
        w_data = 32'h00005555;

        // Disable write
        #10
        w_en = 0;

        // Read x1 and x2
        #10
        rs1_addr = 5'b00001;
        rs2_addr = 5'b00010;

        // Try writing x0 (should be ignored)
        #20
        w_en   = 1;
        w_addr = 5'd0;
        w_data = 32'hFFFFFFFF;

        // Read x0
        #10
        w_en = 0;
        rs1_addr = 5'd0;

        #20;
        $finish;
    end

    initial begin
        $monitor(
            "T=%0t | rs1=%0d rs1_data=%h | rs2=%0d rs2_data=%h",
            $time, rs1_addr, rs1_data, rs2_addr, rs2_data
        );
    end
endmodule
