`timescale 1ns / 1ps

module mem_wb_reg(
    input clk,
    input rst,

    //====================================================
    // DATA SIGNALS
    //====================================================

    input [31:0] ReadDataM,
    input [31:0] ALUResultM,
    input [31:0] PCPlus4M,

    input [4:0] RdM,

    //====================================================
    // CONTROL SIGNALS
    //====================================================

    input RegWriteM,
    input [1:0] ResultSrcM,

    //====================================================
    // OUTPUTS TO WB STAGE
    //====================================================

    output reg [31:0] ReadDataW,
    output reg [31:0] ALUResultW,
    output reg [31:0] PCPlus4W,

    output reg [4:0] RdW,

    output reg RegWriteW,
    output reg [1:0] ResultSrcW
);

always @(posedge clk or negedge rst)
begin
    if(!rst)
    begin
        ReadDataW  <= 32'b0;
        ALUResultW <= 32'b0;
        PCPlus4W   <= 32'b0;

        RdW <= 5'b0;

        RegWriteW  <= 1'b0;
        ResultSrcW <= 2'b0;
    end
    else
    begin
        ReadDataW  <= ReadDataM;
        ALUResultW <= ALUResultM;
        PCPlus4W   <= PCPlus4M;

        RdW <= RdM;

        RegWriteW  <= RegWriteM;
        ResultSrcW <= ResultSrcM;
    end
end

endmodule