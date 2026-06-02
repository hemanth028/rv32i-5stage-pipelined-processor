`timescale 1ns / 1ps

module tb;

//////////////////////////////////////////////////
// SIGNALS
//////////////////////////////////////////////////

reg clk;
reg rst;

//////////////////////////////////////////////////
// DUT
//////////////////////////////////////////////////

top_pipelined dut(
    .clk(clk),
    .rst(rst)
);

//////////////////////////////////////////////////
// CLOCK
//////////////////////////////////////////////////

always #5 clk = ~clk;

//////////////////////////////////////////////////
// CYCLE COUNTER
//////////////////////////////////////////////////

integer cycle_count;

initial
begin
    cycle_count = 0;
end

always @(posedge clk)
begin
    if(rst)
        cycle_count <= cycle_count + 1;
end

//////////////////////////////////////////////////
// STIMULUS
//////////////////////////////////////////////////

initial
begin

    clk = 0;
    rst = 0;

    #20;
    rst = 1;

    // Safety timeout
    #5000;

    $display("\n=======================================");
    $display("SIMULATION TIMEOUT");
    $display("TOTAL CYCLES = %0d", cycle_count);
    $display("=======================================");

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

//////////////////////////////////////////////////
// HALT DETECTION
//////////////////////////////////////////////////

always @(posedge clk)
begin

    if(dut.InstrF == 32'hFFFFFFFF)
    begin

        $display("\n=======================================");
        $display("HALT INSTRUCTION DETECTED");
        $display("TIME         = %0t", $time);
        $display("TOTAL CYCLES = %0d", cycle_count);
        $display("=======================================");

        // Allow pipeline to drain
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
// LIGHTWEIGHT EXECUTION MONITOR
//////////////////////////////////////////////////

always @(posedge clk)
begin

    if(rst)
    begin
        $display("Cycle=%0d  PC=%h  Instr=%h",
                 cycle_count,
                 dut.PCF,
                 dut.InstrF);
    end

end

//////////////////////////////////////////////////
// DEBUG MONITOR
//////////////////////////////////////////////////
// Uncomment only when debugging hazards,
// forwarding, branch issues, load-use stalls,
// pipeline flushes, etc.
//////////////////////////////////////////////////

/*

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

    ////////////////////////////////////////////////
    // BRANCH DEBUG
    ////////////////////////////////////////////////

    $display("\nBRANCH DEBUG");
    $display("BranchE       = %b", dut.BranchE);
    $display("ZeroE         = %b", dut.ZeroE);
    $display("PCSrcBranchE  = %b", dut.PCSrcBranchE);
    $display("PCTargetE     = %h", dut.PCTargetE);

    $display("================================================");

end

*/

endmodule