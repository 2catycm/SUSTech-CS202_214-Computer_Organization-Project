`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Southern University of Science and Technology �Ϸ��Ƽ���ѧ
// Engineer: Ҷ���
// Create Date: 2022/05/28 
// Project Name: MIPS Single Cycle CPU
// Target Devices: Xilinx Board. Tested on MINISYS.
// Description: 
//  Cpu�Ǽ���������봦�������𵽺��ĵ����á�
//  ���ǵ�Cpu����У�Cpu��ָ������в���IO���衢�����ڴ����һ���֡�
//  ��Ҫ������5��ģ�飺IF(InstructionFetcher), 
//  CC(CpuController), CD(CpuDecoder), CE(CpuExecutor), 
//  DM(DataManager, �ɳ�MemoryOrIo)
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
    //��д�뺯��
    ,output oDoLedWrite
    ,output[1:0]  oLightAddress
    ,output[15:0] oLightDataToWrite
    //���ض�ȡ����
    ,output oDoSwitchRead
    ,output[1:0] oSwirchAddress
    ,input[15:0] iSwitchDataRead
    //�����д�뺯��
    ,output oDoTubeWrite
    ,output[1:0] oTubeAddress
    ,output[15:0]oTubeDataToWrite
);
//////////// InstructionFetcher ////////////
    //����
    wire isJr, isBeq, isBne, isJ, isJal;  //���� controller
    wire[31:0] aluAddrResult; //���� CpuExecutor
    wire isAluZero; //���� CpuExecutor
    wire[31:0] registerAddressResult; //���� Decoder, ����jrָ�����ת��
    //�����ǰ���Ѷ���: oProgromFetchAddr ��������������
    //ʵ�ʵõ���ָ�
    //Ŀǰ��ʵ���Ǻ�iInstructionFetched��ȫһ����
    //δ���п�������չ����,InstructionFetcher�ضϣ����¼��㡣
    wire[31:0] cpuCurrentInstruction; 
    wire[31:0] branchBaseAddr; // branch �Ļ�����ַ��Ȼ��Ҫ�����������ġ�
    wire[31:0] linkAddress; //jalҪд��Ĵ���������Ҫд���ֵ��

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
    //����
    wire[31:0] memoryOrIoData; //ԭ����r_wdata. ���� DataMangaer
    wire[31:0] aluResult;  //���� CpuExecutor. �������aluAddrResult�ǲ�ͬ��result��
    wire doWriteReg, isRegFromMem, isRdOrRtWritten; //���� controller
    //�����
    wire[31:0] registerReadData1;
    wire[31:0] registerReadData2;
    wire[31:0] signExtentedImmediate;
    // ��ǰ��ģ��/�źŵĹ�ϵ
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
    //����
    wire isShift, isAluSource2FromImm, isArthIType, isJr;// ����controller
    wire[1:0] aluOp;// ����controller
    //�����ǰ���Ѷ��� isAluZero��aluResult��aluAddrResult
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
        .Zero(isAluZero), //InstructionFetcher�õ�
        .ALU_Result(aluResult),
        .Addr_Result(aluAddrResult),//This means that upper right output
        .PC_plus_4(branchBaseAddr)
    );
//////////// DataManager ////////////
    //����
    wire doWriteReg, doMemoryRead, doMemoryWrite;
    wire doLedWrite, doSwitchRead, doSwitchRead, doTubeWrite;
    //����
    wire doIoRead = doSwitchRead|| doSwitchRead;
    wire doIoWrite = doLedWrite || doTubeWrite;

    //��io ����Ĵ���
    wire[15:0] dataFromIo = iSwitchDataRead;
    //��io ����Ĵ���
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
        .oDataToStore(dataToStore), //��ʵ���� registerReadData2
    );

//////////// CpuController ѹ���������ǰ������������źŶ��ɹ��������㡣////////////
    
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