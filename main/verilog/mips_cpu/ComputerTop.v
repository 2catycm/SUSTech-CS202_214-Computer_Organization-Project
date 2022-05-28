`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Southern University of Science and Technology 南方科技大学
// Engineer: 叶璨铭
// Create Date: 2022/05/28 
// Project Name: MIPS Single Cycle CPU
// Target Devices: Xilinx Board. Tested on MINISYS.
// Description: 
// 
//////////////////////////////////////////////////////////////////////////////////

module ComputerTop (
     input[23:0]Minisys_Switches
    ,output[23:0]Minisys_Lights
    ,input Minisys_Clock
    ,input[4:0] Minisys_Button
    ,input Minisys_Uart_FromPc
    ,output Minisys_Uart_ToPc
    ,output[7:0] Minisys_DigitalTubes_NotEnable
    ,output[7:0]Minisys_DigitalTube_Shape
    ,output Minisys_Audio_Pwm
);
//////////////////////cpuclk//////////////////////
    // 计算提供 cpu_clk和 upgClock
    wire cpuClock, upgClock;
    cpuclk cpuclk_instance(
        .clk_in1(iFpgaClk)
        ,.clk_out1(cpuClock)
        ,.clk_out2(upgClock)
    );
//////////////////////CoeMemory//////////////////////
    //函数1：提供cpuReset
    wire cpuReset;
    //函数2: InstructionMemory
    wire[13:0] imAddressRequested; //来自 Fetcher //虽然是函数输入，但是也是wire类型。
    wire[31:0] instructionFetched; //给到其他模块
    //函数3: DataMemory
    wire doMemWrite; //来自controller
    //get
    wire[31:0] dmAddressRequested;
    wire[31:0] memoryFetched;
    //set
    wire[31:0] dataToStore;
    CoeMemory dCoeMemory(
        .iFpgaReset(Minisys_Button[3]) //西按钮
        ,.iFpgaClock(Minisys_Clock)
        ,.iUpgClock(upgClock)
        ,.iStartReceiveCoe(Minisys_Button[4]) //东按钮
        ,.iFpgaUartFromPc(Minisys_Uart_FromPc)
        ,.oCpuReset(cpuReset)
        ,.iCpuClock(cpuClock)
        ,.iImAddressRequested(imAddressRequested)
        ,.oInstructionFetched(instructionFetched)
        ,.iDoMemWrite(doMemWrite)
        ,.iDmAddressRequested(dmAddressRequested)
        ,.oMemoryFetched(memoryFetched)
        ,.iDataToStore(dataToStore)
    );
    

endmodule //ComputerTop