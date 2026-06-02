`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01.09.2025 17:34:54
// Design Name: 
// Module Name: reg_to_pctarget
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


module reg_to_pctarget(
    input [31:0]RD1,
    input PCTargetSrc,
    input [31:0] PC,
    output [31:0] PCSrcA
    );
    assign PCSrcA=(PCTargetSrc)? RD1:PC;
endmodule
