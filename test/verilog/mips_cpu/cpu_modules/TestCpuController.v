`timescale 1ns/1ps

module TestCpuController;

// CpuController Parameters
    parameter PERIOD = 10;
    parameter CASE_INTERVAL = PERIOD*10;

// CpuController Inputs
    reg[31:0] currentInstruction = 0;
    wire[5:0] iOperationCode = currentInstruction[31:26];
    wire[5:0] iFunctionCode = currentInstruction[5:0];
    reg[31:0] aluResult = 0;
    wire[21:0] iAluResultHigh = aluResult[31:10];
    wire[3:0] iAluResult7to4 = aluResult[7:4];

// CpuController Outputs
    wire oIsJr;
    wire oIsBeq;
    wire oIsBne;
    wire oIsJ;
    wire oIsJal;
    wire oIsRdOrRtWritten;
    wire oIsRegFromMemOrIo;
    wire oDoWriteReg;
    wire oDoMemoryRead;
    wire oDoMemoryWrite;
    wire oDoLedWrite;
    wire oDoSwitchRead;
    wire oDoTubeWrite;
    wire oIsAluSource2FromImm;
    wire oIsShift;
    wire oIsArthIType;
    wire[1:0] oAluOp;

    initial begin
        #CASE_INTERVAL //Test Case: load from switches: lw $a0 0x72($gp)
            currentInstruction = 32'h8f840072;
        aluResult = 32'hFFFFFC72;
        #CASE_INTERVAL //Test Case: load from switches: lw $a0 0x70($gp)
            currentInstruction = 32'h8f840070;
        aluResult = 32'hFFFFFC70;

        #CASE_INTERVAL //Test Case: store to lights: sw $t0 0x62($gp)
            currentInstruction = 32'haf880062;
        aluResult = 32'hFFFFFC62;
        #CASE_INTERVAL //Test Case: store to lights: sw $t0 0x62($gp)
            currentInstruction = 32'haf880060;
        aluResult = 32'hFFFFFC60;

        #CASE_INTERVAL //Test Case: load from memory: lw $t0 4($k0)  (在我们的mips框架中，k0永远是240)
            currentInstruction = 32'h8f480004;
        aluResult = 32'd244;

        #CASE_INTERVAL //Test Case: store to memory: sw $a0 0($k0)  (在我们的mips框架中，k0永远是240)
            currentInstruction = 32'haf440000;
        aluResult = 32'd244;

    end
    CpuController u_CpuController(
        .iOperationCode(iOperationCode[5:0]),
        .iFunctionCode(iFunctionCode[5:0]),
        .iAluResultHigh(iAluResultHigh[21:0]),
        .iAluResult7to4(iAluResult7to4[3:0]),

        .oIsJr(oIsJr),
        .oIsBeq(oIsBeq),
        .oIsBne(oIsBne),
        .oIsJ(oIsJ),
        .oIsJal(oIsJal),
        .oIsRdOrRtWritten(oIsRdOrRtWritten),
        .oIsRegFromMemOrIo(oIsRegFromMemOrIo),
        .oDoWriteReg(oDoWriteReg),
        .oDoMemoryRead(oDoMemoryRead),
        .oDoMemoryWrite(oDoMemoryWrite),
        .oDoLedWrite(oDoLedWrite),
        .oDoSwitchRead(oDoSwitchRead),
        .oDoTubeWrite(oDoTubeWrite),
        .oIsAluSource2FromImm(oIsAluSource2FromImm),
        .oIsShift(oIsShift),
        .oIsArthIType(oIsArthIType),
        .oAluOp(oAluOp[1:0])
    );
endmodule