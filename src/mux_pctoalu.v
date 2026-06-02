`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01.09.2025 21:24:42
// Design Name: 
// Module Name: mux_pctoalu
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


module mux_pctoalu(
    input [31:0] PC,
    input [31:0] RD1,
    input PCALUSrc,
    output [31:0] SrcA
    );
    
    assign SrcA=(PCALUSrc)?PC:RD1;
endmodule
