`timescale 1ns / 1ps

module ex_mem_reg(
    input clk,
    input rst,

    //====================================================
    // DATA SIGNALS
    //====================================================

    input [31:0] ALUResultE,
    input [31:0] WriteDataE,
    input [31:0] PCPlus4E,

    input [4:0] RdE,

    //====================================================
    // CONTROL SIGNALS
    //====================================================

    input RegWriteE,
    input [1:0] ResultSrcE,
    input MemWriteE,

    input [1:0] StoreSRCE,
    input [2:0] LoadSRCE,

    //====================================================
    // OUTPUTS TO MEM STAGE
    //====================================================

    output reg [31:0] ALUResultM,
    output reg [31:0] WriteDataM,
    output reg [31:0] PCPlus4M,

    output reg [4:0] RdM,

    output reg RegWriteM,
    output reg [1:0] ResultSrcM,
    output reg MemWriteM,

    output reg [1:0] StoreSRCM,
    output reg [2:0] LoadSRCM
);

always @(posedge clk or negedge rst)
begin
    if(!rst)
    begin
        ALUResultM <= 32'b0;
        WriteDataM <= 32'b0;
        PCPlus4M   <= 32'b0;

        RdM <= 5'b0;

        RegWriteM  <= 1'b0;
        ResultSrcM <= 2'b0;
        MemWriteM  <= 1'b0;

        StoreSRCM <= 2'b0;
        LoadSRCM  <= 3'b0;
    end
    else
    begin
        ALUResultM <= ALUResultE;
        WriteDataM <= WriteDataE;
        PCPlus4M   <= PCPlus4E;

        RdM <= RdE;

        RegWriteM  <= RegWriteE;
        ResultSrcM <= ResultSrcE;
        MemWriteM  <= MemWriteE;

        StoreSRCM <= StoreSRCE;
        LoadSRCM  <= LoadSRCE;
    end
end

endmodule