`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 30.05.2026 12:22:15
// Design Name: 
// Module Name: forwarding_unit
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


`timescale 1ns / 1ps

module forwarding_unit(

    input [4:0] Rs1E,
    input [4:0] Rs2E,

    input [4:0] RdM,
    input [4:0] RdW,

    input RegWriteM,
    input RegWriteW,

    output reg [1:0] ForwardAE,
    output reg [1:0] ForwardBE
);

always @(*) begin

    ForwardAE = 2'b00;

    if(RegWriteM &&
       (RdM != 0) &&
       (RdM == Rs1E))
        ForwardAE = 2'b10;

    else if(RegWriteW &&
            (RdW != 0) &&
            (RdW == Rs1E))
        ForwardAE = 2'b01;

end

always @(*) begin

    ForwardBE = 2'b00;

    if(RegWriteM &&
       (RdM != 0) &&
       (RdM == Rs2E))
        ForwardBE = 2'b10;

    else if(RegWriteW &&
            (RdW != 0) &&
            (RdW == Rs2E))
        ForwardBE = 2'b01;

end

endmodule