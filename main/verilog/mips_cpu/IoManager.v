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
module IoManager (
     input Minisys_Clock
    ,input iCpuClock
    ,input iCpuReset

    ,input Minisys_Uart_FromPc
    ,output Minisys_Uart_ToPc
    ,output Minisys_Audio_Pwm

    //灯写入函数
    ,input iDoLedWrite  //是否要写入灯
    ,input[1:0] iLightAddress //要写入灯的地址
    ,input[15:0] iLightDataToWrite  //要写入灯的数据
    ,output[23:0]Minisys_Lights //直接控制开发板的灯作为函数效果。
    //开关读取函数
    ,input iDoSwitchRead  //是否要读取开关
    ,input[1:0] iSwirchAddress //读取哪个地址
    ,output [15:0] iSwitchDataRead //读取到的数
    ,input [23:0] Minisys_Switches //开发板的开关

    //数码管写入函数
    ,input iDoTubeWrite //是否要写入数码管
    ,input[1:0] iTubeAddress //要写入灯的地址
    ,input[15:0] iTubeDataToWrite //要写入数码管的数据
    ,output [7:0] Minisys_DigitalTubes_NotEnable //开发板的数码管
    ,output [7:0] Minisys_DigitalTube_Shape //开发板的数码管

);
    LightDriver dLightDriver(
        .iCpuClock(iCpuClock)
        ,.iCpuReset(iCpuReset) 
        ,.iDoLedWrite(iDoLedWrite)  
        ,.iLightAddress(iLightAddress)
        ,.iLightDataToWrite(iLightDataToWrite) 
        ,.oFpgaLights(oLights)
    );

    SwitchDriver dSwitchDriver(
        .switclk(iCpuClock)
        ,.switchrst(iCpuReset)
        ,.iDoSwitchRead(iDoSwitchRead)
        ,.iSwirchAddress(iSwirchAddress)
        ,.switchrdata(iSwitchDataRead) 
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