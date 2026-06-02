`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 27.05.2026
// Design Name:
// Module Name: top_pipelined
// Project Name:
// Target Devices:
// Tool Versions:
// Description:
//
// First stage pipelined processor:
// IF stage + IF/ID register + Decode stage
//
//////////////////////////////////////////////////////////////////////////////////

module top_pipelined(
    input clk,
    input rst
);

//====================================================
// FETCH STAGE SIGNALS
//====================================================

wire [31:0] PCF;
wire [31:0] PCNextF;
wire [31:0] InstrF;
wire [31:0] PCPlus4F;

//====================================================
// DECODE STAGE SIGNALS
//====================================================

wire [31:0] InstrD;
wire [31:0] PCD;
wire [31:0] PCPlus4D;

//----------------------------------------------------
// Instruction Fields
//----------------------------------------------------

wire [6:0] opD;
wire [2:0] funct3D;
wire funct7b5D;

wire [4:0] Rs1D;
wire [4:0] Rs2D;
wire [4:0] RdD;

//----------------------------------------------------
// Control Signals
//----------------------------------------------------

wire PCSrcD;
wire PCTargetSrcD;

wire [1:0] ResultSrcD;

wire MemWriteD;
wire ALUSrcD;

wire [2:0] ImmSrcD;

wire RegWriteD;
wire JumpD;

wire PCALUSrcD;

wire [4:0] ALUControlD;

wire [1:0] StoreSRCD;
wire [2:0] LoadSRCD;

//----------------------------------------------------
// Register File Signals
//----------------------------------------------------

wire [31:0] RD1D;
wire [31:0] RD2D;
wire StallF;
wire StallD;
wire FlushE;
wire FlushD;
wire FlushE_branch;
//assign FlushD       = PCSrcE;
assign FlushD = PCSrcBranchE;
assign FlushE_branch = PCSrcE;
//----------------------------------------------------
// Immediate Extend Signal
//----------------------------------------------------

wire [31:0] ImmExtD;

//====================================================
// TEMPORARY WRITEBACK SIGNALS
//====================================================
// WB stage not implemented yet

wire RegWriteW;
wire [4:0] RdW;
wire [31:0] ResultW;

//====================================================
// EXECUTE STAGE SIGNALS
//====================================================

wire [31:0] RD1E;
wire [31:0] RD2E;
wire [31:0] PCE;
wire [31:0] PCPlus4E;
wire [31:0] ImmExtE;

wire [4:0] Rs1E;
wire [4:0] Rs2E;
wire [4:0] RdE;

wire RegWriteE;
wire [1:0] ResultSrcE;
wire MemWriteE;
wire JumpE;
wire ALUSrcE;
wire [4:0] ALUControlE;

wire PCSrcE;
wire PCTargetSrcE;
wire PCALUSrcE;

wire [1:0] StoreSRCE;
wire [2:0] LoadSRCE;
//assign RegWriteW = 1'b0;
//assign RdW       = 5'b0;
//assign ResultW   = 32'b0;


//====================================================
// FETCH STAGE
//====================================================

//----------------------------------------------------
// PC + 4
//----------------------------------------------------

assign PCNextF =PCSrcBranchE ?PCTargetE :PCPlus4F;
//----------------------------------------------------
// PC Register
//----------------------------------------------------

pc u_pc(
    .clk(clk),
    .rst(rst),
    .StallF(StallF),
    .PCNext(PCNextF),
    .PC(PCF)
);

//----------------------------------------------------
// PC + 4 Adder
//----------------------------------------------------

pc_next u_pc_next(
    .PC(PCF),
    .PCPlus4(PCPlus4F)
);

//----------------------------------------------------
// Instruction Memory
//----------------------------------------------------

inst_mem u_inst_mem(
    .A(PCF),
    .RD(InstrF)
);

//====================================================
// IF/ID PIPELINE REGISTER
//====================================================

if_id_reg if_id(
    .clk(clk),
    .rst(rst),
    .StallD(StallD),
    .FlushD(FlushD),
    .InstrF(InstrF),
    .PCF(PCF),
    .PCPlus4F(PCPlus4F),

    .InstrD(InstrD),
    .PCD(PCD),
    .PCPlus4D(PCPlus4D)
);

//====================================================
// DECODE STAGE
//====================================================

//----------------------------------------------------
// Instruction Field Extraction
//----------------------------------------------------

assign opD       = InstrD[6:0];
assign funct3D   = InstrD[14:12];
assign funct7b5D = InstrD[30];

assign Rs1D = InstrD[19:15];
assign Rs2D = InstrD[24:20];
assign RdD  = InstrD[11:7];


 

//====================================================
// CONTROL UNIT
//====================================================
wire BranchD;
wire BranchE;
wire PCSrcBranchE;

aludecoder u_decoder(
    .opcode(InstrD[6:0]),
    .funct7(InstrD[31:25]),
    .funct3(InstrD[14:12]),

    .Zero(1'b0),

    .PCSrc(PCSrcD),
    .PCTargetSrc(PCTargetSrcD),

    .ResultSrc(ResultSrcD),

    .MemWrite(MemWriteD),
    .ALUSrc(ALUSrcD),

    .ImmSrc(ImmSrcD),

    .RegWrite(RegWriteD),

    .Jump(JumpD),
    .Branch(BranchD),

    .PCALUSrc(PCALUSrcD),

    .ALUControl(ALUControlD),

    .StoreSRC(StoreSRCD),
    .LoadSRC(LoadSRCD)
);

//====================================================
// REGISTER FILE
//====================================================

register_file u_regfile(
    .clk(clk),
    .rst(rst),
    .WE3(RegWriteW),

    .A1(Rs1D),
    .A2(Rs2D),
    .A3(RdW),

    .WD3(ResultW),

    .RD1(RD1D),
    .RD2(RD2D)
);

//====================================================
// IMMEDIATE EXTEND UNIT
//====================================================
extend u_extend(
    .instr(InstrD),
    .ImmSrc(ImmSrcD),
    .ImmExt(ImmExtD)
);
//====================================================
// ID/EX PIPELINE REGISTER
//====================================================

id_ex_reg u_id_ex(
    .clk(clk),
    .rst(rst),
    .FlushE(FlushE),
    .RD1D(RD1D),
    .RD2D(RD2D),
    .PCD(PCD),
    .PCPlus4D(PCPlus4D),
    .ImmExtD(ImmExtD),
    .BranchD(BranchD),
    .Rs1D(Rs1D),
    .Rs2D(Rs2D),
    .RdD(RdD),

    .RegWriteD(RegWriteD),
    .ResultSrcD(ResultSrcD),
    .MemWriteD(MemWriteD),
    .JumpD(JumpD),
    .ALUSrcD(ALUSrcD),
    .ALUControlD(ALUControlD),

    .PCSrcD(PCSrcD),
    .PCTargetSrcD(PCTargetSrcD),
    .PCALUSrcD(PCALUSrcD),

    .StoreSRCD(StoreSRCD),
    .LoadSRCD(LoadSRCD),

    .RD1E(RD1E),
    .RD2E(RD2E),
    .PCE(PCE),
    .PCPlus4E(PCPlus4E),
    .ImmExtE(ImmExtE),

    .Rs1E(Rs1E),
    .Rs2E(Rs2E),
    .RdE(RdE),

    .RegWriteE(RegWriteE),
    .ResultSrcE(ResultSrcE),
    .MemWriteE(MemWriteE),
    .JumpE(JumpE),
    .ALUSrcE(ALUSrcE),
    .ALUControlE(ALUControlE),

    .PCSrcE(PCSrcE),
    .PCTargetSrcE(PCTargetSrcE),
    .PCALUSrcE(PCALUSrcE),

    .StoreSRCE(StoreSRCE),
    .LoadSRCE(LoadSRCE),
    .BranchE(BranchE)  
);


//====================================================
// EXECUTE STAGE
//====================================================
wire [31:0] SrcAE;
wire [31:0] SrcBE;

wire [31:0] ALUResultE;
wire ZeroE;

wire [31:0] PCTargetE;
wire [31:0] WriteDataE;

assign PCSrcBranchE =(BranchE & ZeroE) |JumpE;

// ALU Operand A
//assign SrcAE = RD1E;

//// ALU Operand B
//assign SrcBE = (ALUSrcE) ? ImmExtE : RD2E;

// Store Data Path


// Branch Target Address
//assign PCTargetE = PCE + ImmExtE;
assign PCTargetE =PCTargetSrcE ? ((SrcAE + ImmExtE) & 32'hFFFFFFFE):(PCE + ImmExtE);
// ALU
alu u_alu(
    .ALUControl(ALUControlE),
    .SrcA(SrcAE),
    .SrcB(SrcBE),
    .Zero(ZeroE),
    .ALUResult(ALUResultE)
);
//====================================================
// MEMORY STAGE SIGNALS
//====================================================

wire [31:0] ALUResultM;
wire [31:0] WriteDataM;
wire [31:0] PCPlus4M;

wire [4:0] RdM;

wire RegWriteM;
wire [1:0] ResultSrcM;
wire MemWriteM;

wire [1:0] StoreSRCM;
wire [2:0] LoadSRCM;


ex_mem_reg u_ex_mem(
    .clk(clk),
    .rst(rst),

    .ALUResultE(ALUResultE),
    .WriteDataE(WriteDataE),
    .PCPlus4E(PCPlus4E),

    .RdE(RdE),

    .RegWriteE(RegWriteE),
    .ResultSrcE(ResultSrcE),
    .MemWriteE(MemWriteE),

    .StoreSRCE(StoreSRCE),
    .LoadSRCE(LoadSRCE),

    .ALUResultM(ALUResultM),
    .WriteDataM(WriteDataM),
    .PCPlus4M(PCPlus4M),

    .RdM(RdM),

    .RegWriteM(RegWriteM),
    .ResultSrcM(ResultSrcM),
    .MemWriteM(MemWriteM),

    .StoreSRCM(StoreSRCM),
    .LoadSRCM(LoadSRCM)
);

//====================================================
// MEMORY STAGE SIGNALS
//====================================================

wire [31:0] ReadDataM;

data_mem u_data_mem(
    .clk(clk),
    .rst(rst),

    .WE(MemWriteM),

    .A(ALUResultM),

    .WD(WriteDataM),

    .RD(ReadDataM)
);
//====================================================
// WRITEBACK STAGE SIGNALS
//====================================================

wire [31:0] ReadDataW;
wire [31:0] ALUResultW;
wire [31:0] PCPlus4W;

wire [1:0] ResultSrcW;

mem_wb_reg u_mem_wb(
    .clk(clk),
    .rst(rst),

    .ReadDataM(ReadDataM),
    .ALUResultM(ALUResultM),
    .PCPlus4M(PCPlus4M),

    .RdM(RdM),

    .RegWriteM(RegWriteM),
    .ResultSrcM(ResultSrcM),

    .ReadDataW(ReadDataW),
    .ALUResultW(ALUResultW),
    .PCPlus4W(PCPlus4W),

    .RdW(RdW),

    .RegWriteW(RegWriteW),
    .ResultSrcW(ResultSrcW)
);

//====================================================
// WRITEBACK MUX
//====================================================

assign ResultW =
       (ResultSrcW == 2'b00) ? ALUResultW :
       (ResultSrcW == 2'b01) ? ReadDataW  :
                               PCPlus4W;
wire [1:0]ForwardAE;
wire [1:0]ForwardBE;
wire [31:0] ForwardAData;
wire [31:0] ForwardBData;


forwarding_unit u_forwarding(

    .Rs1E(Rs1E),
    .Rs2E(Rs2E),
    .RdM(RdM),
    .RdW(RdW),
    .RegWriteM(RegWriteM),
    .RegWriteW(RegWriteW),
    .ForwardAE(ForwardAE),
    .ForwardBE(ForwardBE)
);
//inputs to the alu (forwarding logic applied)
assign ForwardAData =(ForwardAE == 2'b00) ? RD1E :(ForwardAE == 2'b10) ? ALUResultM :ResultW;           
assign ForwardBData =(ForwardBE == 2'b00) ? RD2E :(ForwardBE == 2'b10) ? ALUResultM :ResultW;
assign SrcAE = ForwardAData;
assign SrcBE =(ALUSrcE)?ImmExtE:ForwardBData;

//assign WriteDataE = RD2E;
assign WriteDataE = ForwardBData;



hazard_unit u_hazard(

    .Rs1D(Rs1D),
    .Rs2D(Rs2D),
    .PCSrcE(PCSrcBranchE),
    .RdE(RdE),

    .ResultSrcE(ResultSrcE),

    .StallF(StallF),
    .StallD(StallD),
    .FlushE(FlushE)

);
endmodule