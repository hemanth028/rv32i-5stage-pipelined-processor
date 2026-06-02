`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 25.09.2025 15:12:06
// Design Name: 
// Module Name: mux_load
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


module mux_load(
    input [31:0]Result,
    input [2:0]LoadSRC,
    output reg [31:0] WD3
    );
    
    always@(*)begin
        case(LoadSRC)
            3'b000: WD3={{24{Result[7]}},Result[7:0]};
            3'b001: WD3={{16{Result[15]}},Result[15:0]};
            3'b010: WD3=Result;
            3'b011: WD3={{24'b0},Result[7:0]};
            3'b100: WD3={{16'b0},Result[15:0]};
    
        endcase
    end
endmodule
