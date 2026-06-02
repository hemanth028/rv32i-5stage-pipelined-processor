`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 28.08.2025 15:11:42
// Design Name: 
// Module Name: aludecoder
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


module aludecoder(
    //input[1:0] ALUOp,
    input [6:0]opcode,
    input [6:0]funct7,
    input[2:0] funct3,
    input Zero,
    output PCSrc,
    output reg PCTargetSrc,
    output reg [1:0] ResultSrc,
    output reg MemWrite,
    output reg ALUSrc,
    output reg [2:0] ImmSrc,
    output reg RegWrite,
   // output reg [1:0] ALUOp,
    output reg Jump,
    output reg PCALUSrc,
    output reg [4:0] ALUControl,
    output reg [1:0]StoreSRC,
    output reg [2:0] LoadSRC
    );
    reg Branch;
    assign PCSrc=(Branch&Zero)|Jump;
    always@(*)
    begin
        case(opcode)
           7'b0110011://R type
           begin
            RegWrite=1'b1;
            ImmSrc = 3'b000;//dont care
            ALUSrc=1'b0;
            MemWrite=1'b0;
            ResultSrc=2'b00;
            Branch=1'b0;
          //  ALUOp=2'b10;
            Jump=1'b0;
            PCTargetSrc=1'b0;
            PCALUSrc=1'b0;
            StoreSRC=2'b00;
            LoadSRC=3'b010;
                if(funct3 == 3'b000 && funct7 == 7'b0000000) 
                     ALUControl<= 5'b0000; //ADD 
                else if(funct3 == 3'b000 && funct7 == 7'b0100000) 
                     ALUControl<= 5'b0001; //SUB 
                else  if(funct3 == 3'b100 && funct7 == 7'b0000000) 
                     ALUControl<= 5'b0100; //XOR 
                else  if(funct3 == 3'b110 && funct7 == 7'b0000000) 
                     ALUControl<= 5'b0011; //OR
                      
                else  if(funct3 == 3'b111 && funct7 == 7'b0000000) 
                     ALUControl<= 5'b0010; //AND 
                else  if(funct3 == 3'b001 && funct7 == 7'b0000000) 
                     ALUControl<= 5'b0101;//SLL
                      
                else  if(funct3 == 3'b101 && funct7 == 7'b0000000) 
                     ALUControl<= 5'b0110; //SRL 
                else  if(funct3 == 3'b101 && funct7 == 7'b0100000) 
                     ALUControl<= 5'b0111; //SRA  
                else if(funct3 == 3'b010 && funct7 == 7'b0000000) 
                     ALUControl<= 5'b1001; //SLT  
                else  if(funct3 == 3'b011 && funct7 == 7'b0000000) 
                     ALUControl<= 5'b1000;//SLTU  
                else 
                    ALUControl<= 5'bxxxxx;
            end
            
            7'b0010011://i type addi
            begin
            RegWrite=1'b1;
            ImmSrc = 3'b000;
            ALUSrc=1'b1;
            MemWrite=1'b0;
            ResultSrc=2'b00;
            Branch=1'b0;
         //   ALUOp=2'b10;
            Jump=1'b0;
            PCTargetSrc=1'b0;
            PCALUSrc=1'b0;
            StoreSRC=2'b00;
            LoadSRC=3'b010;
               if(funct3 == 3'b000) 
                    ALUControl <= 5'b0000; //ADDI 
               else if(funct3 == 3'b100)
                    ALUControl <= 5'b0100; //XORI 
               else if(funct3 == 3'b110)
                    ALUControl <= 5'b0011; //ORI 
               else if(funct3 == 3'b111)
                    ALUControl <=5'b0010 ; //ANDI 
               else if(funct3 == 3'b001 && funct7 == 7'b0000000)
                    ALUControl <= 5'b1010; //SLLI 
               else if(funct3 == 3'b101 && funct7 == 7'b0000000)
                    ALUControl <= 5'b1011; //SRLI
               else if(funct3 == 3'b101 && funct7 == 7'b0100000)
                    ALUControl <= 5'b01100; //SRAI 
               else if(funct3 == 3'b010)
                    ALUControl <=5'b1001; //SLTI 
               else if(funct3 == 3'b011)
                    ALUControl <= 5'b1000; //SLTIU 
                else
                    ALUControl <=5'bxxxx;
            end
         7'b0000011://load instruction
         begin
            ALUControl <= 5'b0000; //load
            RegWrite=1'b1;
            ImmSrc = 3'b000;
            ALUSrc=1'b1;
            MemWrite=1'b0;
            ResultSrc=2'b01;
            Branch=1'b0;
         //   ALUOp=2'b00;
            Jump=1'b0;
            PCTargetSrc=1'b0;
            PCALUSrc=1'b0;
              StoreSRC=2'b00;
               //LoadSRC=3'b010;
              if(funct3==000)
                LoadSRC=3'b00;
              else  if(funct3==3'b001)
                LoadSRC=3'd1;
              else  if(funct3==3'b010)
                LoadSRC=3'd2;
              else  if(funct3==3'b011)
                LoadSRC=3'd3;
              else  if(funct3==3'b100)
                LoadSRC=3'd4;
         end
                
         /*
               if(funct3 == 3'b000) 
                    ALUControl <= 5'b01101; //LB 
               else if(funct3 == 3'b001)
                    ALUControl <= 5'b01110; //LH 
               else if(funct3 == 3'b010)
                    ALUControl <= 5'b01111; //LW
               else if(funct3 == 3'b011)
                    ALUControl <=5'b10000 ; //LD 
               else if(funct3 == 3'b100)
                    ALUControl <= 5'b10001; //LBU
               else if(funct3 == 3'b101)
                    ALUControl <= 5'b10010;  //LHU
               else if(funct3 == 3'b110)
                    ALUControl <= 5'b10011; //LWU 
                else
                    ALUControl <=5'bxxxx;   
                    */      
            7'b0100011://store instruction
            begin
                RegWrite=1'b0;
                ImmSrc = 3'b001;
                ALUSrc=1'b1;
                MemWrite=1'b1;
                ResultSrc=2'b00;//dont care condition
                Branch=1'b0;
             //   ALUOp=2'b00;
                Jump=1'b0;
                PCTargetSrc=1'b0;
                PCALUSrc=1'b0;
                ALUControl <= 5'b0000;//store
                 LoadSRC=3'b010;
                
                if(funct3==0)
                      StoreSRC=2'b00;// SB
                else if(funct3==1)
                      StoreSRC=2'b01; //SH
                else if(funct3==2)
                      StoreSRC=2'b10;  //SW
            end
                     
            /*
               if(funct3 == 3'b000) 
                    ALUControl <= 5'b01101; //SB 
               else if(funct3 == 3'b001)
                    ALUControl <= 5'b01110; //SH 
               else if(funct3 == 3'b010)
                    ALUControl <= 5'b01111; //SW
               else if(funct3 == 3'b011)
                    ALUControl <=5'b10000 ; //SD 
               else
                    ALUControl <=5'bxxxx;  
                    */
          7'b1100011://B type
          begin
            RegWrite=1'b0;
            ImmSrc = 3'b010;
            ALUSrc=1'b0;
            MemWrite=1'b0;
            ResultSrc=2'b00;//dont care
            Branch=1'b1;
           // ALUOp=2'b01;
            Jump=1'b0;
            PCTargetSrc=1'b0;
            PCALUSrc=1'b0;
             LoadSRC=3'b010;
              StoreSRC=2'b00;
                if(funct3 == 3'b000) 
                    ALUControl <= 5'b00001; //BEQ
               else if(funct3 == 3'b001)
                    ALUControl <= 5'b01101; //BNE
               else if(funct3 == 3'b100)
                    ALUControl <= 5'b01110; //BLT
               else if(funct3 == 3'b101)
                    ALUControl <=5'b01111; //BGE 
               else if(funct3 == 3'b110)
                    ALUControl <=5'b01110 ; //BLTU  
               else if(funct3 == 3'b111)
                    ALUControl <=5'b01111; //BGEU 
               else
                    ALUControl <=5'bxxxx; 
          end
            7'b0110111:// u type lui
            begin
                RegWrite=1'b1;
                ImmSrc = 3'b100;
                ALUSrc=1'b1;
                MemWrite=1'b0;
                ResultSrc=2'b00;
                Branch=1'b0;
             //  ALUOp=2'b00;//dont care
                Jump=1'b0;
                PCTargetSrc=1'b0;
                PCALUSrc=1'b0;
                ALUControl<=5'b10000;
                 LoadSRC=3'b010;
                  StoreSRC=2'b00;
            end
            7'b0010111:// u type auipc
            begin
                RegWrite=1'b1;
                ImmSrc = 3'b100;
                ALUSrc=1'b1;
                MemWrite=1'b0;
                ResultSrc=2'b00;
                Branch=1'b0;
             //  ALUOp=2'b00;
                Jump=1'b0;
                PCTargetSrc=1'b0;
                PCALUSrc=1'b1;
                ALUControl<=5'b00000;
                  StoreSRC=2'b00;
                   LoadSRC=3'b010;
            end
            
        7'b1101111://jump
        begin
            RegWrite=1'b1;
            ImmSrc = 3'b011;
            ALUSrc=1'b0;//dont care
            MemWrite=1'b0;
            ResultSrc=2'b10;
            Branch=1'b0;
         //  ALUOp=2'b00;//dont care
            Jump=1'b1;
            PCTargetSrc=1'b0;
            PCALUSrc=1'b0;
            ALUControl<=5'b00000;//temporary
              StoreSRC=2'b00;
               LoadSRC=3'b010;
        end
        
        7'b1100111://jump(jalr)
        begin
            RegWrite=1'b1;
            ImmSrc = 3'b000;// use i type imm src since jalr is an i type information 
            ALUSrc=1'b0;//dont care
            MemWrite=1'b0;
            ResultSrc=2'b10;
            Branch=1'b0;
         //   ALUOp=2'b00;//dont care
            Jump=1'b1;
            PCTargetSrc=1'b1;
            PCALUSrc=1'b0;
            ALUControl<=5'b00000;//temporary
              StoreSRC=2'b00;
               LoadSRC=3'b010;
        end
            default:
            begin
                RegWrite=1'b0;
                ImmSrc = 3'b000;
                ALUSrc=1'b0;
                MemWrite=1'b0;
                ResultSrc=2'bxx;
                Branch=1'b0;
             //   ALUOp=2'b00;
                Jump=1'b0;
                PCTargetSrc=1'b0;
                PCALUSrc=1'b0;
                ALUControl<=5'bxxxxx;
                  StoreSRC=2'b00;
                   LoadSRC=3'b010;
            end 
        endcase
    end
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    /*
        case({ALUOp,functt7,functt3})
            12'b00_0000000_010:ALUControl=4'b0000;//lw sw add 2.
            12'b00_0000000_001:ALUControl=4'b0000;// 3. slli 
            12'b10_0000000_000:ALUControl=4'b0000;//add r type 1.
            12'b10_0100000_000:ALUControl=4'b0001;//sub r type
            12'b01_0000000_000:ALUControl=4'b0001;//beq
            12'b10_0000000_111:ALUControl=4'b0010;//and 
            12'b10_0000000_110:ALUControl=4'b0011;//or
            12'b10_0000000_010:ALUControl=4'b0101;//slt
            //12'b10_0000000_000:ALUControl=3'b000;//addi i type same as r type
            12'b10_0000000_100 : ALUControl = 4'b0100;    // XOR
            12'b10_0000000_001 : ALUControl = 4'b0101;    // SLL
            12'b10_0000000_101 : ALUControl = 4'b0110;    // SRL
            12'b10_0100000_101 : ALUControl = 4'b0111;    // SRA.
            
            default: ALUControl=3'b111;
        endcase
    end
    */
   
endmodule
