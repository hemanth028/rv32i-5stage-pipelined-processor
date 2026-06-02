`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12.08.2025 00:07:46
// Design Name: 
// Module Name: register_file
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


module register_file(
    input clk,
    input rst,
    input [4:0]A1, A2, A3,
    input WE3,
    input [31:0] WD3,
    output  [31:0] RD1,
    output  [31:0] RD2
    );
    reg [31:0] register [31:0];
    
    initial 
    begin
        $readmemh("register_memory.mem",register);
    end
   
   
    //always@(*)
    /*
    initial
    begin
        register[0] = 0;
        register[1] = 3;
        register[2] =8 ;
        register[3] = 12;
        register[4] = 20;
        register[5] = 3;
        register[6] = 4;
        register[7] = 4;
        register[8] = 2;
        register[9] = 1;
        register[10] = 23;
        register[11] = 4;
        register[12] = 90;
        register[13] = 10;
        register[14] = 20;
        register[15] = 30;
        register[16] = 40;
        register[17] = 50;
        register[18] = 60;
        register[19] = 70;
        register[20] = 80;
        register[21] = 80;
        register[22] = 90;
        register[23] = 70;
        register[24] = 60;
        register[25] = 65;
        register[26] = 4;
        register[27] = 32;
        register[28] = 12;
        register[29] = 34;
        register[30] = 5;
        register[31] = 10;
    
    */
    
    
    assign  RD1=register[A1];
    assign  RD2=register[A2];
    integer i;
        
    always@(posedge clk )//or negedge rst)
    begin
  
//        if(!rst)
//        begin
//        /*
//          for(i=0;i<32;i=i+1)
//          begin
//            register[i]<=0;
//          end          
//          */
//         // $readmemh("register_file.mem",register);
//        end
//        else begin 
        
          if(WE3)
                register[A3]<=WD3;
        end
        
          
            
//    end
endmodule
