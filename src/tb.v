`timescale 1ns / 1ps

module tb;

reg clk;
reg rst;

top_pipelined dut(
    .clk(clk),
    .rst(rst)
);

//////////////////////////////////////////////////
// CLOCK
//////////////////////////////////////////////////

always #5 clk = ~clk;

//////////////////////////////////////////////////
// STIMULUS
//////////////////////////////////////////////////

initial begin

    clk = 0;
    rst = 0;

    #20;
    rst = 1;

    #2000;

    $display("\n");
    $display("=======================================");
    $display("FINAL REGISTER FILE CONTENTS");
    $display("=======================================");
    $display("x0 = %0d", dut.u_regfile.register[0]);
    $display("x1 = %0d", dut.u_regfile.register[1]);
    $display("x2 = %0d", dut.u_regfile.register[2]);
    $display("x3 = %0d", dut.u_regfile.register[3]);
    $display("x4 = %0d", dut.u_regfile.register[4]);
    $display("x5 = %0d", dut.u_regfile.register[5]);
    $display("x6 = %0d", dut.u_regfile.register[6]);
    $display("x7 = %0d", dut.u_regfile.register[7]);
    $display("=======================================");

    $finish;
end

//////////////////////////////////////////////////
// HALT DETECTION
//////////////////////////////////////////////////

always @(posedge clk)
begin
    if(dut.InstrF == 32'hFFFFFFFF)
    begin
        $display("\n====================================");
        $display("HALT INSTRUCTION DETECTED");
        $display("TIME = %0t",$time);
        $display("====================================");

        #50;

        $display("\n=======================================");
        $display("FINAL REGISTER FILE CONTENTS");
        $display("=======================================");
        $display("x0 = %0d", dut.u_regfile.register[0]);
        $display("x1 = %0d", dut.u_regfile.register[1]);
        $display("x2 = %0d", dut.u_regfile.register[2]);
        $display("x3 = %0d", dut.u_regfile.register[3]);
        $display("x4 = %0d", dut.u_regfile.register[4]);
        $display("x5 = %0d", dut.u_regfile.register[5]);
        $display("x6 = %0d", dut.u_regfile.register[6]);
        $display("x7 = %0d", dut.u_regfile.register[7]);
        $display("=======================================");

        $finish;
    end
end

//////////////////////////////////////////////////
// PIPELINE MONITOR
//////////////////////////////////////////////////

always @(posedge clk)
begin

    $display("\n================================================");
    $display("TIME = %0t",$time);

    ////////////////////////////////////////////////
    // HAZARD UNIT
    ////////////////////////////////////////////////

    $display("HAZARD UNIT");
    $display("StallF     = %b", dut.StallF);
    $display("StallD     = %b", dut.StallD);
    $display("FlushE     = %b", dut.FlushE);

    ////////////////////////////////////////////////
    // FORWARDING UNIT
    ////////////////////////////////////////////////

    $display("\nFORWARDING UNIT");
    $display("ForwardAE  = %b", dut.ForwardAE);
    $display("ForwardBE  = %b", dut.ForwardBE);

    ////////////////////////////////////////////////
    // IF STAGE
    ////////////////////////////////////////////////

    $display("\nIF STAGE");
    $display("PCF        = %h", dut.PCF);
    $display("InstrF     = %h", dut.InstrF);

    ////////////////////////////////////////////////
    // ID STAGE
    ////////////////////////////////////////////////

    $display("\nID STAGE");
    $display("InstrD     = %h", dut.InstrD);
    $display("Rs1D       = %0d", dut.Rs1D);
    $display("Rs2D       = %0d", dut.Rs2D);
    $display("RdD        = %0d", dut.RdD);
    $display("RD1D       = %0d", dut.RD1D);
    $display("RD2D       = %0d", dut.RD2D);
    $display("ImmExtD    = %0d", dut.ImmExtD);

    ////////////////////////////////////////////////
    // EX STAGE
    ////////////////////////////////////////////////

    $display("\nEX STAGE");
    $display("RD1E       = %0d", dut.RD1E);
    $display("RD2E       = %0d", dut.RD2E);
    $display("SrcAE      = %0d", dut.SrcAE);
    $display("SrcBE      = %0d", dut.SrcBE);
    $display("ALUResultE = %0d", dut.ALUResultE);

    ////////////////////////////////////////////////
    // MEM STAGE
    ////////////////////////////////////////////////

    $display("\nMEM STAGE");
    $display("ALUResultM = %0d", dut.ALUResultM);
    $display("WriteDataM = %0d", dut.WriteDataM);
    $display("ReadDataM  = %0d", dut.ReadDataM);

    ////////////////////////////////////////////////
    // WB STAGE
    ////////////////////////////////////////////////

    $display("\nWB STAGE");
    $display("ALUResultW = %0d", dut.ALUResultW);
    $display("ReadDataW  = %0d", dut.ReadDataW);
    $display("PCPlus4W   = %0d", dut.PCPlus4W);
    $display("ResultW    = %0d", dut.ResultW);
    $display("RdW        = %0d", dut.RdW);
    $display("RegWriteW  = %0b", dut.RegWriteW);

    ////////////////////////////////////////////////
    // FORWARDING DATA
    ////////////////////////////////////////////////

    $display("\nFORWARD PATHS");
    $display("ForwardAData = %0d", dut.ForwardAData);
    $display("ForwardBData = %0d", dut.ForwardBData);
    $display("WriteDataE   = %0d", dut.WriteDataE);

    ////////////////////////////////////////////////
    // RESULTSRC TRACKING
    ////////////////////////////////////////////////

    $display("\nRESULTSRC PIPELINE");
    $display("ResultSrcD  = %b", dut.ResultSrcD);
    $display("ResultSrcE  = %b", dut.ResultSrcE);
    $display("ResultSrcM  = %b", dut.ResultSrcM);
    $display("ResultSrcW  = %b", dut.ResultSrcW);

    ////////////////////////////////////////////////
    // DESTINATION REGISTERS
    ////////////////////////////////////////////////

    $display("\nDESTINATION REGISTERS");
    $display("RdD         = %0d", dut.RdD);
    $display("RdE         = %0d", dut.RdE);
    $display("RdM         = %0d", dut.RdM);
    $display("RdW         = %0d", dut.RdW);

    $display("================================================");
    
    $display("BranchE       = %b", dut.BranchE);
$display("ZeroE         = %b", dut.ZeroE);
$display("PCSrcBranchE  = %b", dut.PCSrcBranchE);
$display("PCTargetE     = %h", dut.PCTargetE);

end

endmodule