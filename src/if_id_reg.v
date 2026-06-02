`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 27.05.2026 15:01:59
// Design Name: 
// Module Name: if_id_reg
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


module if_id_reg(
    input clk,
    input rst,
    input StallD,
    input FlushD,
    
    input [31:0]InstrF,
    input [31:0]PCF,
    input [31:0]PCPlus4F,
    
    output reg[31:0]InstrD,
    output reg[31:0]PCD,
    output reg[31:0]PCPlus4D
    );
    
    always@(posedge clk or negedge rst)begin
        if(!rst)begin
            InstrD <= 32'h00000013;
            PCD<=32'b0;
            PCPlus4D<=32'b0;            
        end
        else if(StallD)begin
            InstrD<=InstrD;
            PCD<=PCD;
            PCPlus4D<=PCPlus4D; 
        end
        else if(FlushD) begin
            InstrD   <= 32'h00000013;   // NOP
            PCD      <= 32'b0;
            PCPlus4D <= 32'b0;
        end
        else begin
            InstrD<=InstrF;
            PCD<=PCF;
            PCPlus4D<=PCPlus4F;  
        end
    end
endmodule
