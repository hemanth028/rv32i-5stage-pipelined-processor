`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12.08.2025 16:15:25
// Design Name: 
// Module Name: alu
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


module alu(
    input [4:0] ALUControl,
    input [31:0] SrcA,SrcB,
    output reg Zero,
    output reg [31:0] ALUResult
    );
    
    always@(*)
    begin
        case(ALUControl)
        5'b00000: ALUResult=SrcA+SrcB;//add
        5'b00001 :ALUResult=SrcA-SrcB;//sub 
        5'b00010:ALUResult=SrcA&SrcB;//and
        5'b00011:ALUResult=SrcA|SrcB;//or
        5'b00100:ALUResult=SrcA^SrcB;//xor
        5'b00101:ALUResult=SrcA<<SrcB[4:0];//sll
        5'b00110:ALUResult=SrcA>>SrcB[4:0];//srl
        5'b00111:ALUResult=$signed(SrcA)>>>SrcB[4:0];//sra
        5'b01000:ALUResult=(SrcA<SrcB)?32'b01:32'b0;//sltu
        5'b01001:ALUResult=($signed(SrcA)<$signed(SrcB))?32'b01:32'b0;//slt
        5'b01010:ALUResult=SrcA<<SrcB[5:0];//slli
        5'b01011:ALUResult=SrcA>>SrcB[5:0];//srli
        5'b01100:ALUResult=$signed(SrcA)>>>SrcB[4:0];//srai
        5'b01101:ALUResult=((SrcA-SrcB)==0)?1'b1:1'b0;//bne
        5'b01110:ALUResult=($signed(SrcA)<$signed(SrcB))?32'b0:32'b1;//blt,bltu
        5'b01111:ALUResult=($signed(SrcA)>=$signed(SrcB))?32'b0:32'b1;//bge,bgeu
        5'b10000:ALUResult=SrcB;
        default:
            ALUResult=32'b0;
        endcase
        Zero=(ALUResult==32'b0)? 1'b1:1'b0; 
    end
endmodule
