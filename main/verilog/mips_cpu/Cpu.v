`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Southern University of Science and Technology 南方科技大学
// Engineer: 叶璨铭
// Create Date: 2022/05/28 
// Project Name: MIPS Single Cycle CPU
// Target Devices: Xilinx Board. Tested on MINISYS.
// Description: 
//  Cpu是计算机的中央处理器，起到核心的作用。
//  我们的Cpu设计中，Cpu特指计算机中不是IO外设、不是内存的那一部分。
//  主要包括了5大模块：IF(InstructionFetcher), 
//  CC(CpuController), CD(CpuDecoder), CE(CpuExecutor), 
//  DM(DataManager, 旧称MemoryOrIo)
//////////////////////////////////////////////////////////////////////////////////

module Cpu (
     input iCpuClock, iCpuReset
    ,input[31:0] iInstructionFetched
    ,
);
    wire isRdOrRtWritten;
     CpuController dCpuController(
        .Opcode(iInstructionFetched[31:26])
        ,.Function_opcode(iInstructionFetched[5:0])
        ,.Jr(Jr)
        ,.Branch(Branch)
        ,.nBranch(nBranch)
        ,.Jmp(Jmp)
        ,.Jal(Jal)
        ,.Alu_resultHigh(ALU_Result[31:10])
        ,.RegDST(RegDst)
        ,.MemorIOtoReg(MemorIOtoReg)
        ,.RegWrite(RegWrite)
        ,.MemRead(MemRead)
        ,.MemWrite(MemWrite)
        ,.IORead(IORead)
        ,.IOWrite(IOWrite)
        ,.ALUSrc(ALUSrc)
        ,.Sftmd(Sftmd)
        ,.I_format(I_format)
        ,.ALUOp(ALUOp)
    );
endmodule //Cpu