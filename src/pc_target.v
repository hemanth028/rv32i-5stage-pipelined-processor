`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 27.08.2025 10:23:52
// Design Name: 
// Module Name: pc_target
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


module pc_target(
input [31:0] PCSrcA,
input [31:0] ImmExt,
//input Zero,
output [31:0] PCTarget
    );
    assign PCTarget=ImmExt+PCSrcA;
    
endmodule
