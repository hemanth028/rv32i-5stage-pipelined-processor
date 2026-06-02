`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 27.08.2025 10:32:46
// Design Name: 
// Module Name: PCMux
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


module PCMux(
input [31:0] PCTarget,
input [31:0] PCPlus4,
input PCSrc,
output [31:0] PCNext
    );
    assign PCNext=(PCSrc)?PCTarget:PCPlus4;
endmodule
