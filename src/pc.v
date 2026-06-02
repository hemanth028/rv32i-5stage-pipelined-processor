`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11.08.2025 21:23:04
// Design Name: 
// Module Name: pc
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


module pc(
    input clk,
    input rst,
    input [31:0] PCNext,
    output reg [31:0] PC
    );
    always@(posedge clk or negedge rst)
    begin
        if(!rst)
            PC<=32'b0;
        else
            PC<=PCNext;
    end
endmodule
