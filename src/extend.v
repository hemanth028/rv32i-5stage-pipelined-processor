`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12.08.2025 16:59:09
// Design Name: 
// Module Name: extend
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


module extend(
    input[31:0] instr,
    input [2:0] ImmSrc,
    output reg [31:0] ImmExt
        );
        
    always@(*) 
    begin
        case(ImmSrc)
            3'b000: ImmExt={{20{instr[31]}},instr[31:20]};// i type 12 bit immediate
            3'b001: ImmExt={{20{instr[31]}},instr[31:25],instr[11:7]};//s type 12 bit signed immediate
            3'b010: ImmExt={{20{instr[31]}},instr[7],instr[30:25],instr[11:8],1'b0}; // b type 13 bit signed immediate
            3'b011: ImmExt={{12{instr[31]}},instr[19:12],instr[20],instr[30:21],1'b0};//j type 21 bit signed immediate
            3'b100: ImmExt={instr[31:12],{12'b0}};// u type 20 bit signed immediate
            default: ImmExt=32'b0;
        endcase
    end
endmodule
