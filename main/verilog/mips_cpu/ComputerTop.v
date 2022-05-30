`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Southern University of Science and Technology �Ϸ��Ƽ���ѧ
// Engineer: Ҷ���
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
    // �����ṩ cpu_clk�� upgClock
    wire cpuClock, upgClock;
    cpuclk cpuclk_instance(
        .clk_in1(Minisys_Clock)
        ,.clk_out1(cpuClock)
        ,.clk_out2(upgClock)
    );
//////////////////////CoeMemory//////////////////////
    //����1���ṩcpuReset
    wire cpuReset;
    //����2: InstructionMemory
    wire[13:0] imAddressRequested; //���� Fetcher //��Ȼ�Ǻ������룬����Ҳ��wire���͡�
    wire[31:0] instructionFetched; //��������ģ��
    //����3: DataMemory
    wire doMemWrite; //����controller
    //get
    wire[31:0] dmAddressRequested;
    wire[31:0] memoryFetched;
    //set
    wire[31:0] dataToStore;
    CoeMemory dCoeMemory(
        .iFpgaReset(Minisys_Button[3]) //����ť
        ,.iFpgaClock(Minisys_Clock)
        ,.iUpgClock(upgClock)
        ,.iStartReceiveCoe(Minisys_Button[4]) //����ť
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
//////////////////////IoManager////////////////////// 
    //��д�뺯��
    wire doLedWrite;
    wire[1:0] lightAddress;
    wire[15:0] lightDataToWrite;
    //���ض�ȡ����
    wire doSwitchRead;
    wire[1:0] swirchAddress;
    //���
    wire[15:0] switchDataRead;
    //�����д�뺯��
    wire doTubeWrite;
    wire[1:0] tubeAddress;
    wire[15:0] tubeDataToWrite;
    IoManager dIoManager(
        .Minisys_Clock(Minisys_Clock)
        ,.iCpuClock(cpuClock)
        ,.iCpuReset(cpuReset)
        ,.Minisys_Uart_FromPc(Minisys_Uart_FromPc)
        ,.Minisys_Uart_ToPc(Minisys_Uart_ToPc)
        ,.Minisys_Audio_Pwm(Minisys_Audio_Pwm)
        ,.iDoLedWrite(doLedWrite)
        ,.iLightAddress(lightAddress)
        ,.Minisys_Lights(Minisys_Lights)
        ,.iDoSwitchRead(doSwitchRead)
        ,.iSwirchAddress(swirchAddress)
        ,.iSwitchDataRead(switchDataRead)
        ,.Minisys_Switches(Minisys_Switches)
        ,.iDoTubeWrite(doTubeWrite)
        ,.iTubeAddress(tubeAddress)
        ,.iTubeDataToWrite(tubeDataToWrite)
        ,.Minisys_DigitalTubes_NotEnable(Minisys_DigitalTubes_NotEnable)
        ,.Minisys_DigitalTube_Shape(Minisys_DigitalTube_Shape)
    );
//////////////////////Cpuѹ��ǳ�������ǰ����豸////////////////////// 

    Cpu dCpu(
        .iCpuClock(cpuClock)
        ,.iCpuReset(cpuReset)
        //CPU����ָ��
        ,.iInstructionFetched(instructionFetched)
        ,.oProgromFetchAddr(imAddressRequested)
        //CPU�����д�ڴ�
        ,.oDoMemWrite(doMemWrite)
        ,.oDmAddressRequested(dmAddressRequested)
        ,.iMemoryFetched(memoryFetched)
        ,.oDataToStore(dataToStore)  //��cpu��֪Ҫ��ʲô���ݵ�IO/�ڴ�
        //CPU�����дIO�豸
        ,.oDoLedWrite(doLedWrite) //��cpu��֪
        ,.oLightAddress(lightAddress)
        ,.oLightDataToWrite(lightDataToWrite)
        ,.oDoSwitchRead(doSwitchRead)
        ,.oSwirchAddress(swirchAddress)
        ,.iSwitchDataRead(switchDataRead)
        ,.oDoTubeWrite(doTubeWrite)
        ,.oTubeAddress(tubeAddress)
        ,.oTubeDataToWrite(tubeDataToWrite)
    );

endmodule //ComputerTop