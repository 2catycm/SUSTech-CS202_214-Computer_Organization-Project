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
module IoManager (
     input Minisys_Clock
    ,input iCpuClock
    ,input iCpuReset

    ,input Minisys_Uart_FromPc
    ,output Minisys_Uart_ToPc
    ,output Minisys_Audio_Pwm

    //��д�뺯��
    ,input iDoLedWrite  //�Ƿ�Ҫд���
    ,input[1:0] iLightAddress //Ҫд��Ƶĵ�ַ
    ,input[15:0] iLightDataToWrite  //Ҫд��Ƶ�����
    ,output[23:0]Minisys_Lights //ֱ�ӿ��ƿ�����ĵ���Ϊ����Ч����
    //���ض�ȡ����
    ,input iDoSwitchRead  //�Ƿ�Ҫ��ȡ����
    ,input[1:0] iSwirchAddress //��ȡ�ĸ���ַ
    ,output [15:0] oSwitchDataRead //��ȡ������
    ,input [23:0] Minisys_Switches //������Ŀ���

    //�����д�뺯��
    ,input iDoTubeWrite //�Ƿ�Ҫд�������
    ,input[1:0] iTubeAddress //Ҫд��Ƶĵ�ַ
    ,input[15:0] iTubeDataToWrite //Ҫд������ܵ�����
    ,output [7:0] Minisys_DigitalTubes_NotEnable //������������
    ,output [7:0] Minisys_DigitalTube_Shape //������������

);
    LightDriver dLightDriver(
        .iCpuClock(iCpuClock)
        ,.iCpuReset(iCpuReset) 
        ,.iDoLedWrite(iDoLedWrite)  
        ,.iLightAddress(iLightAddress)
        ,.iLightDataToWrite(iLightDataToWrite) 
        ,.oFpgaLights(Minisys_Lights)
    );

    SwitchDriver dSwitchDriver(
        .iCpuClock(iCpuClock)
        ,.iCpuReset(iCpuReset)
        ,.iDoSwitchRead(iDoSwitchRead)
        ,.iSwirchAddress(iSwirchAddress)
        ,.oSwitchDataRead(oSwitchDataRead) 
        ,.iFpgaSwitches(Minisys_Switches)
    );
                           
    
    TubeDriver dTubeDriver(
        .iFpgaClock(Minisys_Clock)
        ,.iCpuClock(iCpuClock)
        ,.iCpuReset(iCpuReset)

        ,.iDoTubeWrite(iDoTubeWrite)
        ,.iTubeAddress(iTubeAddress)
        ,.iTubeDataToWrite(iTubeDataToWrite)
        ,.oDigitalTubeNotEnable(Minisys_DigitalTubes_NotEnable)
        ,.oDigitalTubeShape(Minisys_DigitalTube_Shape)
    );
endmodule //IoManager