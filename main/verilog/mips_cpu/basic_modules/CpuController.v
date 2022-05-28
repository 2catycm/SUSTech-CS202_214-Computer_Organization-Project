`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Southern University of Science and Technology 南方科技大学
// Engineer: 王睿, 叶璨铭
// 
// Create Date: 2022/05/07 12:58:45
// Module Name: CPU_TOP
// Project Name: MIPS Single Cycle CPU
// Target Devices: Xilinx Board. Tested on MINISYS.
// Description: 
// 
//////////////////////////////////////////////////////////////////////////////////

module CpuController(iOperationCode,iFunctionCode,oIsJr,oIsBeq,oIsBne,oIsJ,oIsJal, iAluResultHigh, oIsRdOrRtWritten, oIsRegFromMemOrIo, oDoWriteReg, iDoMemoryRead, oDoMemoryWrite, oDoSwitchRead, oDoLedWrite,
oIsAluSource2FromImm,oAluOp,oIsShift,oIsArthIType);
    input[5:0] iOperationCode; // instruction[31:26], opcode
    input[5:0] iFunctionCode; // instructions[5:0], funct
    output oIsJr; // 1 indicates the instruction is "jr", otherwise it's not "jr" output oIsJ, // 1 indicate the instruction is "j", otherwise it's not
    output oIsBeq; // 1 indicate the instruction is "beq" , otherwise it's not
    output oIsBne; // 1 indicate the instruction is "bne", otherwise it's not
    output oIsJ;
    output oIsJal;
    input[21:0] iAluResultHigh; // From the execution unit Alu_Result[31..10]
    input[3:0]  iAluResult7to4; //最多支持16种IO设备，根据地址的7:4来确定.
    output oIsRdOrRtWritten; // 1 indicate destination register is "rd"(R),otherwise it's "rt"(I)
    output oIsRegFromMemOrIo; // 1 indicates that data needs to be read from memory or I/O to the register
    output oDoWriteReg; // 1 indicates that the instruction needs to write to the register
    output oDoMemoryRead; // 1 indicates that the instruction needs to read from the memory
    output oDoMemoryWrite; // 1 indicates that the instruction needs to write to the memory
    output oDoLedWrite; // 1 indicates I/O write
    output oDoSwitchRead; // 1 indicates I/O read
    output oDoTubeWrite;

    output oIsAluSource2FromImm; // 1 indicate the 2nd data is immidiate (except "beq","bne")
    output oIsShift; // 1 indicate the instruction is shift instruction
    output oIsArthIType;/* 1 indicate the instruction is I-type but isn't "beq","bne","LW" or "SW" */
    output[1:0] oAluOp;/* if the instruction is R-type or oIsArthIType, oAluOp is 2'b10;
    if the instruction is"beq" or "bne", oAluOp is 2'b01??
    if the instruction is"lw" or "isSw", oAluOp is 2'b00??*/ 
    
    wire isLw,isSw,isRFormat;
    assign isLw = (iOperationCode==6'b100011)? 1'b1:1'b0;
    assign isSw = (iOperationCode==6'b101011)? 1'b1:1'b0;
    assign oIsJr =((iOperationCode==6'b000000)&&(iFunctionCode==6'b001000)) ? 1'b1 : 1'b0;
    assign oIsJal = (iOperationCode==6'b000011)? 1'b1:1'b0;
    assign oIsJ = (iOperationCode==6'b000010)? 1'b1:1'b0;
    assign oIsBeq = (iOperationCode==6'b000100)? 1'b1:1'b0;
    assign oIsBne = (iOperationCode==6'b000101)? 1'b1:1'b0;
    assign isRFormat = (iOperationCode==6'b000000)? 1'b1:1'b0;
    assign oIsRdOrRtWritten = isRFormat;
    assign oIsArthIType = (iOperationCode[5:3]==3'b001)?1'b1:1'b0;
    assign oIsAluSource2FromImm = oIsArthIType||(iOperationCode==6'b100011)||(iOperationCode==6'b101011);
    assign oAluOp = {(isRFormat || oIsArthIType),(oIsBeq || oIsBne)};
    assign oIsShift = (((iFunctionCode==6'b000000)||(iFunctionCode==6'b000010)
    ||(iFunctionCode==6'b000011)||(iFunctionCode==6'b000100)
    ||(iFunctionCode==6'b000110)||(iFunctionCode==6'b000111))
    && isRFormat)? 1'b1:1'b0;
    assign oDoWriteReg = (isRFormat || isLw || oIsJal || oIsArthIType) && !(oIsJr) ; // Write memory or write IO

    wire isIo = (iAluResultHigh[21:0] != 22'h3FFFFF);
    assign oDoMemoryWrite = ((isSw) && isIo) ? 1'b1:1'b0;
    assign iDoMemoryRead = ((isLw) && isIo) ? 1'b1:1'b0; // Read memory


    wire[15:0] ioDevices; //只有那一位是1，其他都是0
    assign oDoLedWrite = ioDevices[0];
    assign oDoSwitchRead = ioDevices[1];
    assign oDoTubeWrite = ioDevices[2];
    always @(*) begin
        if (isIo) begin
            ioDevices = (16'b1<< iAluResult7to4)>>6; 
        end
        else begin
            ioDevices = 16'b0;
        end
    end
    // Read operations require reading data from memory or I/O to write to the register
    assign oIsRegFromMemOrIo = (isIo&&isLw) || iDoMemoryRead;
endmodule
