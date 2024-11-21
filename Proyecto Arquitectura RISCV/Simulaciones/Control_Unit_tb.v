`timescale 1ns / 1ps

module Control_Unit_tb;

    // Inputs
    reg [6:0] Op;
    reg [2:0] Funct3;
    reg [6:0] Funct7;

    // Outputs
    wire PCSrc;
    wire ResultSrc;
    wire MemWrite;
    wire [3:0] ALUControl;
    wire ALUSrc;
    wire [2:0] ImmSrc;
    wire RegWrite;

    // Instantiate the Unit Under Test (UUT)
    Control_Unit uut (
        .Op(Op),
        .Funct3(Funct3),
        .Funct7(Funct7),
        .PCSrc(PCSrc),
        .ResultSrc(ResultSrc),
        .MemWrite(MemWrite),
        .ALUControl(ALUControl),
        .ALUSrc(ALUSrc),
        .ImmSrc(ImmSrc),
        .RegWrite(RegWrite)
    );

    initial begin
        // Monitor to display outputs for each instruction
        $monitor("Time=%0t | Op=%b | Funct3=%b | Funct7=%b | PCSrc=%b | ResultSrc=%b | MemWrite=%b | ALUControl=%b | ALUSrc=%b | ImmSrc=%b | RegWrite=%b", 
                  $time, Op, Funct3, Funct7, PCSrc, ResultSrc, MemWrite, ALUControl, ALUSrc, ImmSrc, RegWrite);

        // Test Case 1: ADDI (Tipo I)
        Op = 7'b0010011;
        Funct3 = 3'b000; // ADDI
        Funct7 = 7'b1111111;
        #10;

        // Test Case 2: ANDI (Tipo I)
        Op = 7'b0010011;
        Funct3 = 3'b111; // ANDI
        Funct7 = 7'b1111111;
        #10;

        // Test Case 3: SW (Store Word, Tipo S)
        Op = 7'b0100011;
        Funct3 = 3'b010;
        Funct7 = 7'b0000000;
        #10;

        // Test Case 4: LUI (Load Upper Immediate, Tipo U)
        Op = 7'b0110111;
        Funct3 = 3'b000;
        Funct7 = 7'b0000000;
        #10;

        // Test Case 5: LW (Load Word, Tipo I)
        Op = 7'b0000011;
        Funct3 = 3'b010; // LW
        Funct7 = 7'b0000000;
        #10;

        // Test Case 6: LBU (Load Byte Unsigned, Tipo I)
        Op = 7'b0000011;
        Funct3 = 3'b100; // LBU
        Funct7 = 7'b0000000;
        #10;

        // Test Case 7: BEQ (Branch if Equal, Tipo B)
        Op = 7'b1100011;
        Funct3 = 3'b000; // BEQ
        Funct7 = 7'b0000000;
        #10;

        // Test Case 8: BNE (Branch if Not Equal, Tipo B)
        Op = 7'b1100011;
        Funct3 = 3'b001; // BNE
        Funct7 = 7'b0000000;
        #10;

        // Test Case 9: BLT (Branch if Less Than, Tipo B)
        Op = 7'b1100011;
        Funct3 = 3'b100; // BLT
        Funct7 = 7'b0000000;
        #10;

        // Test Case 10: JAL (Jump and Link, Tipo J)
        Op = 7'b1101111;
        Funct3 = 3'b000;
        Funct7 = 7'b0000000;
        #10;

        // Test Case 11: JALR (Jump and Link Register, Tipo I)
        Op = 7'b1100111;
        Funct3 = 3'b000;
        Funct7 = 7'b0000000;
        #10;

        // End simulation
        $stop;
    end

endmodule