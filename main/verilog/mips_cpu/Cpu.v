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
    //Instruction Fetcher 
    ,input[31:0] iInstructionFetched
    ,output[13:0] oProgromFetchAddr
    // DataMemory
    ,output oDoMemWrite
    ,output[31:0] oDmAddressRequested
    ,input[31:0]  iMemoryFetched
    ,output[31:0] oDataToStore
    // IoManager
    //灯写入函数
    ,output oDoLedWrite
    ,output[1:0]  oLightAddress
    ,output[15:0] oLightDataToWrite
    //开关读取函数
    ,output oDoSwitchRead
    ,output[1:0] oSwirchAddress
    ,input[15:0] iSwitchDataRead
    //数码管写入函数
    ,output oDoTubeWrite
    ,output[1:0] oTubeAddress
    ,output[15:0]oTubeDataToWrite
);
//////////// InstructionFetcher ////////////
    //输入
    wire isJr, isBeq, isBne, isJ, isJal;  //来自 controller
    wire[31:0] aluAddrResult; //来自 CpuExecutor
    wire isAluZero; //来自 CpuExecutor
    wire[31:0] registerAddressResult; //来自 Decoder, 用于jr指令的跳转。
    //输出：前面已定义: oProgromFetchAddr 用于向外设请求。
    //实际得到的指令。
    //目前的实现是和iInstructionFetched完全一样。
    //未来有可能有扩展功能,InstructionFetcher截断，重新计算。
    wire[31:0] cpuCurrentInstruction; 
    wire[31:0] branchBaseAddr; // branch 的基础地址，然后还要加上立即数的。
    wire[31:0] linkAddress; //jal要写入寄存器，这是要写入的值。

    InstructionFetcher dInstructionFetcher(
        .iInstruction(iInstructionFetched), 
        .oInstruction(cpuCurrentInstruction),
        .oBranchBaseAddress(branchBaseAddr),
        .iAluAddrResult(aluAddrResult),
        .iRegisterAddressResult(registerAddressResult),
        .iIsBeq(isBeq),
        .iIsBne(isBne),
        .iIsJ(isJ),
        .iIsJal(isJal),
        .iIsJr(isJr),
        .iIsAluZero(isAluZero),
        .iCpuClock(iCpuClock),
        .iCpuReset(iCpuReset),
        .oLinkAddress(linkAddress),
        .oProgromFetchAddr(oProgromFetchAddr)
    );
//////////// CpuDecoder //////////// 
    //输入
    wire[31:0] memoryOrIoData; //原来的r_wdata. 来自 DataMangaer
    wire[31:0] aluResult;  //来自 CpuExecutor. 与上面的aluAddrResult是不同的result。
    wire doWriteReg, isRegFromMem, isRdOrRtWritten; //来自 controller
    //输出：
    wire[31:0] registerReadData1;
    wire[31:0] registerReadData2;
    wire[31:0] signExtentedImmediate;
    // 与前面模块/信号的关系
    assign registerAddressResult = registerReadData1;
    CpuDecoder dCpuDecoder(
        .oDataRead1(registerReadData1),
        .oDataRead2(registerReadData2),
        .iInstruction(cpuCurrentInstruction),
        .iMemoryData(memoryOrIoData),
        .iAluResult(aluResult),
        .iIsJal(isJal),
        .iDoWriteReg(doWriteReg),
        .iIsRegFromMem(isRegFromMem),
        .iIsRdOrRtWritten(isRdOrRtWritten),
        .oSignExtentedImmediate(signExtentedImmediate),
        .iCpuClock(iCpuClock),
        .iCpuReset(iCpuReset),
        .iJalLinkAddress(linkAddress)
    );
//////////// CpuExecutor //////////// 
    //输入
    wire isShift, isAluSource2FromImm, isArthIType, isJr;// 来自controller
    wire[1:0] aluOp;// 来自controller
    //输出：前面已定义 isAluZero，aluResult，aluAddrResult
    CpuExecutor dCpuExecutor(
        .Read_data_1(registerReadData1),//the source of Ainput
        .Read_data_2(registerReadData2),//one of the sources of Binput
        .Sign_extend(signExtentedImmediate),//one of the sources of Binput llinstruction[31:26]
        // from lFetch
        .Function_opcode(cpuCurrentInstruction[5:0]),//instructions[5:0]
        .Exe_opcode(cpuCurrentInstruction[31:26]),
        .ALUOp(aluOp),//{(R_format || l_format), (Branch|| nBranch)}
        .Shamt(cpuCurrentInstruction[10:6]),//instruction[10:6], the amount of shift bits
        .Sftmd(isShift),    // means this is a shift instruction
        .ALUSrc(isAluSource2FromImm),//means the 2nd operand is an immediate (except beq,bne)
        //means l-Type instruction except beq, bne, LW,sw
        .I_format(isArthIType),
        .Jr(isJr),
        .Zero(isAluZero), //InstructionFetcher用到
        .ALU_Result(aluResult),
        .Addr_Result(aluAddrResult),//This means that upper right output
        .PC_plus_4(branchBaseAddr)
    );
//////////// DataManager ////////////
    //输入
    wire doWriteReg, doMemoryRead, doMemoryWrite;
    wire doLedWrite, doSwitchRead, doSwitchRead, doTubeWrite;
    //处理
    wire doIoRead = doSwitchRead|| doSwitchRead;
    wire doIoWrite = doLedWrite || doTubeWrite;

    //对io 输入的处理
    wire[15:0] dataFromIo = iSwitchDataRead;
    //对io 输出的处理
    wire[31:0] dataToStore;
    assign oDataToStore = dataToStore;
    assign oLightDataToWrite = dataToStore[15:0];
    assign oTubeDataToWrite  = dataToStore[15:0];
    DataManager dDataManager(
        .iDoMemoryRead(doMemoryRead), // read memory, from Controller
        .iDoMemoryWrite(doMemoryWrite), // write memory, from Controller
        .iDoIoRead(doIoRead), // read IO, from Controller
        .iDoIoWrite(doIoWrite), // write IO, from Controller
        .iAluResultAsAddress(aluResult), // from alu_result in ALU
        .oDataMemoryAddress(oDmAddressRequested), // address to Data-Memory
        .iDataFromMemory(iMemoryFetched), // data read from Data-Memory
        .iDataFromIo(dataFromIo), // data read from IO,16 bits
        .oMemOrIODataRead(memoryOrIoData), // data to Decoder(register file)
        .iDataFromRegister(registerReadData2), // data read from Decoder(register file)
        .oDataToStore(dataToStore), //其实就是 registerReadData2
    );

//////////// CpuController 压轴出场，把前面需求的输入信号都成功计算满足。////////////
    
    CpuController dCpuController(
        .iOperationCode(cpuCurrentInstruction[31:26])
        ,.iFunctionCode(cpuCurrentInstruction[5:0])
        ,.oIsJr(isJr)
        ,.oIsBeq(isBeq)
        ,.oIsBne(isBne)
        ,.oIsJ(isJ)
        ,.oIsJal(isJal)
        ,.iAluResultHigh(aluResult[31:10])
        ,.iAluResult7to4(aluResult[7:4])
        ,.oIsRdOrRtWritten(isRdOrRtWritten)
        ,.oIsRegFromMemOrIo(isRegFromMem)
        ,.oDoWriteReg(doWriteReg)

        ,.oDoMemoryRead(doMemoryRead)
        ,.oDoMemoryWrite(doMemoryWrite)
        ,.oDoLedWrite(doLedWrite)
        ,.oDoSwitchRead(doSwitchRead)
        ,.oDoTubeWrite(doTubeWrite)

        ,.oIsAluSource2FromImm(isAluSource2FromImm)
        ,.oIsShift(isShift)
        ,.oIsArthIType(isArthIType)
        ,.oAluOp(aluOp)
    );
endmodule //Cpu