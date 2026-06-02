`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 28.08.2025 16:57:50
// Design Name: 
// Module Name: mux_dmtoreg
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


module mux_dmtoreg(
    input [1:0]ResultSrc,
    input [31:0] ALUResult,
    input [31:0] ReadData,
    input [31:0] PCPlus4,
    output reg [31:0] Result
    );
    always@(*)begin
        case(ResultSrc)
            2'b00:Result=ALUResult;
            2'b01:Result=ReadData;
            2'b10:Result=PCPlus4;
            default: Result=32'b0;
        endcase
    end
endmodule
