`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12.08.2025 16:34:12
// Design Name: 
// Module Name: data_mem
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


module data_mem(
    input clk,
    input rst,
    input WE,
    input [31:0] A,
    input [31:0] WD,
    output reg [31:0] RD
    );
    reg [127:0] datamem [0:127];
    always@(*)begin
       // if(!WE)
            RD=datamem[A];
    end
    
    //always@(posedge clk)
    /*
    initial
    begin
        datamem[23]=10;
        datamem[56]=9;
        datamem[15]=15;
    end
    */
   initial 
    begin 
        $readmemh("data_mem.mem",datamem);
    end
    
    integer i;
    always@(posedge clk)
    begin
//    if(!rst) begin
//       // $readmemh("data_mem.mem",datamem);
 
//       for(i=0;i<64;i=i+1)
//          begin
//            datamem[i]<=0;
//          end  
//    end
//    else

        if(WE)begin
            datamem[A]<=WD;
            
            //$writememh("data_mem.mem",datamem);
        end     
        $display("datamem=%0d",datamem[A]);
    end
    
    //always@(posedge clk)begin
    
    //end 
    
endmodule
