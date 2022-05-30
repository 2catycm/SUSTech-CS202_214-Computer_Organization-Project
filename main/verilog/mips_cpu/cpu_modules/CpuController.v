`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Southern University of Science and Technology ÄÏ·½¿Æ¼¼´óÑ§
// Engineer: Íõî£, Ò¶è²Ãú
// 
// Create Date: 2022/05/07 12:58:45
// Module Name: CPU_TOP
// Project Name: MIPS Single Cycle CPU
// Target Devices: Xilinx Board. Tested on MINISYS.
// Description: 
// 
//////////////////////////////////////////////////////////////////////////////////

module CpuController(
     input[5:0] iOperationCode // instruction[31:26], opcode
    ,input[5:0] iFunctionCode // instructions[5:0], funct
    ,output oIsJr // ï¿½ï¿½ï¿½Ò½ï¿½ï¿½ï¿½ï¿½ï¿½JrÖ¸ï¿½ï¿½ï¿½Î?1
    ,output oIsBeq // 1 indicate the instruction is "beq" , otherwise it's not
    ,output oIsBne // 1 indicate the instruction is "bne", otherwise it's not
    ,output oIsJ // ï¿½ï¿½ï¿½Ò½ï¿½ï¿½ï¿½ï¿½ï¿½JÖ¸ï¿½ï¿½ï¿½Î?1
    ,output oIsJal //ï¿½ï¿½ï¿½Ò½ï¿½ï¿½ï¿½ï¿½ï¿½JalÖ¸ï¿½ï¿½ï¿½Î?1
    ,input[21:0] iAluResultHigh // From the execution unit Alu_Result[31..10]
    ,input[3:0]  iAluResult7to4 //×î¶àÖ§³Ö16ÖÖioÉè±¸¡£
    ,output oIsRdOrRtWritten // 1 indicate destination register is "rd"(R),otherwise it's "rt"(I) ï¿½ï¿½ï¿½ï¿½iÖ¸ï¿½î£¬ï¿½ï¿½ï¿½ï¿½ï¿½rtï¿½ï¿½ï¿½ï¿½ï¿½ï¿½lw,addiï¿½ï¿½
    ,output oIsRegFromMemOrIo // 1 indicates that data needs to be read from memory or I/O to the register. ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½æ£¬ï¿½ï¿½Ò»ï¿½ï¿½Ó¦ï¿½ï¿½ï¿½Ç¼Ù¡ï¿½
    ,output oDoWriteReg // ï¿½ï¿½Ê¾ï¿½Ä´ï¿½ï¿½ï¿½Òªï¿½ï¿½Ð´ï¿½ë¡£Ð´ï¿½ï¿½ï¿½ï¿½ï¿½Ô´ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿? ï¿½Ú´æ¡¢IO ï¿½ï¿½ ALUï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ 
    
    ,output oDoMemoryRead // 1 indicates that the instruction needs to read from the memory
    ,output oDoMemoryWrite // 1 indicates that the instruction needs to write to the memory
    ,output oDoLedWrite // 1 indicates I/O write
    ,output oDoSwitchRead // 1 indicates I/O read
    ,output oDoTubeWrite

    ,output oIsAluSource2FromImm // 1 indicate the 2nd data is immidiate (except "beq","bne")
    ,output oIsShift // 1 indicate the instruction is shift instruction
    ,output oIsArthIType/* 1 indicate the instruction is I-type but isn't "beq","bne","LW" or "SW" */
    ,output[1:0] oAluOp/* if the instruction is R-type or oIsArthIType, oAluOp is 2'b10;
    if the instruction is"beq" or "bne", oAluOp is 2'b01??
    if the instruction is"lw" or "isSw", oAluOp is 2'b00??*/ 
);
    
    
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
    assign oDoWriteReg = (isRFormat || isLw || oIsJal || oIsArthIType) && !(oIsJr) ; // true if need to write rd or rt at "writeback" stage.

    wire isIo = (iAluResultHigh[21:0] == 22'h3FFFFF);  // note that even when isIo is true, the instruction may not be lw or sw.
    assign oDoMemoryWrite = ((isSw) && (!isIo)) ? 1'b1:1'b0;
    assign oDoMemoryRead = ((isLw) && (!isIo)) ? 1'b1:1'b0; // Read memory


    reg[15:0] ioDevices; //Ö»ÓÐÄÇÒ»Î»ÊÇ1£¬ÆäËû¶¼ÊÇ0
    assign oDoLedWrite = ioDevices[0];
    assign oDoSwitchRead = ioDevices[1];
    assign oDoTubeWrite = ioDevices[2];
    always @(*) begin
        if (isIo) begin
            ioDevices = (16'b1<< iAluResult7to4)>>6; //according to the markdown documentation under "drivers" folder.
        end
        else begin
            ioDevices = 16'b0;
        end
    end
    // Read operations require reading data from memory or I/O to write to the register
    assign oIsRegFromMemOrIo = isLw; //Ö»Òªload word¾ÍÒ»¶¨»áÔÚwriteback½×¶ÎÐ´Èë¼Ä´æÆ÷¡£
endmodule
