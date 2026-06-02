//`timescale 1ns / 1ps

//module inst_mem(
//    input  [31:0] A,
//    output [31:0] RD
//);

//    localparam DEPTH = 1024;

//    reg [31:0] instr [0:DEPTH-1];

//    integer i;

//    initial begin

//        // Initialize entire memory to NOP
//        for(i = 0; i < DEPTH; i = i + 1)
//            instr[i] = 32'h00000013;

//        // Load program
//        $readmemh("instruction_memory.mem", instr);

//        $display("Instruction memory loaded");
//    end

//    assign RD = (A[31:2] < DEPTH) ?
//                instr[A[31:2]] :
//                32'h00000013;      // NOP if PC exceeds memory

//endmodule
`timescale 1ns / 1ps

module inst_mem(
    input  [31:0] A,
    output [31:0] RD
);

    localparam DEPTH = 1024;

    reg [31:0] instr [0:DEPTH-1];

    integer i;

    initial begin

        // Initialize entire memory to NOP
        for(i = 0; i < DEPTH; i = i + 1)
            instr[i] = 32'h00000013;

        // Load program
        $readmemh("instruction_memory.mem", instr);

        $display("Instruction memory loaded");
    end

    assign RD = (A[31:2] < DEPTH) ?
                instr[A[31:2]] :
                32'h00000013;      // NOP if PC exceeds memory

endmodule