`timescale 1ns / 1ps

module id_ex_reg(
    input clk,
    input rst,
    input FlushE,
    //====================================================
    // DATA SIGNALS
    //====================================================

    input [31:0] RD1D,
    input [31:0] RD2D,
    input [31:0] PCD,
    input [31:0] PCPlus4D,
    input [31:0] ImmExtD,

    input [4:0] Rs1D,
    input [4:0] Rs2D,
    input [4:0] RdD,

    //====================================================
    // CONTROL SIGNALS
    //====================================================

    input RegWriteD,
    input [1:0] ResultSrcD,
    input MemWriteD,
    input JumpD,
    input ALUSrcD,
    input [4:0] ALUControlD,

    // Additional control signals
    input PCSrcD,
    input PCTargetSrcD,
    input PCALUSrcD,

    input [1:0] StoreSRCD,
    input [2:0] LoadSRCD,
    input  BranchD,

    //====================================================
    // OUTPUTS TO EXECUTE STAGE
    //====================================================

    output reg [31:0] RD1E,
    output reg [31:0] RD2E,
    output reg [31:0] PCE,
    output reg [31:0] PCPlus4E,
    output reg [31:0] ImmExtE,

    output reg [4:0] Rs1E,
    output reg [4:0] Rs2E,
    output reg [4:0] RdE,

    output reg RegWriteE,
    output reg [1:0] ResultSrcE,
    output reg MemWriteE,
    output reg JumpE,
    output reg ALUSrcE,
    output reg [4:0] ALUControlE,

    output reg PCSrcE,
    output reg PCTargetSrcE,
    output reg PCALUSrcE,

    output reg [1:0] StoreSRCE,
    output reg [2:0] LoadSRCE,
    output reg BranchE 
);

always @(posedge clk or negedge rst)
begin
    if(!rst)  begin
        // Data Signals
        RD1E      <= 32'b0;
        RD2E      <= 32'b0;
        PCE       <= 32'b0;
        PCPlus4E  <= 32'b0;
        ImmExtE   <= 32'b0;

        Rs1E      <= 5'b0;
        Rs2E      <= 5'b0;
        RdE       <= 5'b0;

        // Control Signals
        RegWriteE   <= 1'b0;
        ResultSrcE  <= 2'b0;
        MemWriteE   <= 1'b0;
        JumpE       <= 1'b0;
        ALUSrcE     <= 1'b0;
        ALUControlE <= 5'b0;

        PCSrcE       <= 1'b0;
        PCTargetSrcE <= 1'b0;
        PCALUSrcE    <= 1'b0;

        StoreSRCE <= 2'b0;
        LoadSRCE  <= 3'b0;
        BranchE <= 1'b0;
    end
  else if(FlushE) begin

    RD1E      <= 32'b0;
    RD2E      <= 32'b0;
    PCE       <= 32'b0;
    PCPlus4E  <= 32'b0;
    ImmExtE   <= 32'b0;

    Rs1E      <= 5'b0;
    Rs2E      <= 5'b0;
    RdE       <= 5'b0;

    RegWriteE   <= 1'b0;
    ResultSrcE  <= 2'b0;
    MemWriteE   <= 1'b0;
    JumpE       <= 1'b0;
    ALUSrcE     <= 1'b0;
    ALUControlE <= 5'b0;

    PCSrcE       <= 1'b0;
    PCTargetSrcE <= 1'b0;
    PCALUSrcE    <= 1'b0;

    StoreSRCE <= 2'b0;
    LoadSRCE  <= 3'b0;
    BranchE <= 1'b0;
end
    else begin
        // Data Signals
        RD1E      <= RD1D;
        RD2E      <= RD2D;
        PCE       <= PCD;
        PCPlus4E  <= PCPlus4D;
        ImmExtE   <= ImmExtD;

        Rs1E      <= Rs1D;
        Rs2E      <= Rs2D;
        RdE       <= RdD;

        // Control Signals
        RegWriteE   <= RegWriteD;
        ResultSrcE  <= ResultSrcD;
        MemWriteE   <= MemWriteD;
        JumpE       <= JumpD;
        ALUSrcE     <= ALUSrcD;
        ALUControlE <= ALUControlD;

        PCSrcE       <= PCSrcD;
        PCTargetSrcE <= PCTargetSrcD;
        PCALUSrcE    <= PCALUSrcD;

        StoreSRCE <= StoreSRCD;
        LoadSRCE  <= LoadSRCD;
        BranchE <= BranchD;
    end
end

endmodule