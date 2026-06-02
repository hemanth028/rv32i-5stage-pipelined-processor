`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 25.09.2025 13:55:14
// Design Name: 
// Module Name: mux_store
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


module mux_store(input [31:0]RD2,input [1:0]StoreSRC,output  reg [31:0]WriteData
    );
    always@(*)begin
        case(StoreSRC)
            2'b00:begin
              WriteData={24'b0,RD2[7:0]};  
            end
            2'b01:begin
              WriteData={16'b0,RD2[15:0]};  
            end
            2'b10:begin
              WriteData=RD2;  
            end
          endcase
          //$display("write data =%h",WriteData);
    end
endmodule
