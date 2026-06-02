`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 28.08.2025 16:56:04
// Design Name: 
// Module Name: mux_regtoalu
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


module mux_regtoalu(
    input ALUSrc,
    input [31:0] RD2,
    input [31:0] ImmExt,
    output [31:0] SrcB
    );
    
    assign SrcB=(ALUSrc)?ImmExt:RD2;
endmodule
