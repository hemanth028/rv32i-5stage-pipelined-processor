`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01.06.2026 10:50:36
// Design Name: 
// Module Name: hazard_unit
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


module hazard_unit(
    input [4:0] Rs1D,
    input [4:0] Rs2D,
    input [4:0] RdE,
    input PCSrcE,
    input [1:0] ResultSrcE,
    output StallF,
    output StallD,
    output FlushE
);

  wire lwstall;
  
assign lwstall =
       (ResultSrcE == 2'b01) &&
       (RdE != 5'd0) &&
       ((Rs1D == RdE) || (Rs2D == RdE));
  assign StallF=lwstall;
  assign StallD=lwstall;
assign FlushE = lwstall | PCSrcE;
  
  
  
endmodule