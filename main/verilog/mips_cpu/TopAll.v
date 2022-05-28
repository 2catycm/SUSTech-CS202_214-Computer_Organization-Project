`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Southern University of Science and Technology 南方科技大学
// Engineer: 张力宇, 叶璨铭
// 
// Create Date: 2022/05/07 12:58:45
// Project Name: MIPS Single Cycle CPU
// Target Devices: Xilinx Board. Tested on MINISYS.
// Description: 
// 
//////////////////////////////////////////////////////////////////////////////////
module ComputerTop(
    input[23:0]Minisys_Switches, 
    output[23:0]Minisys_Lights, 
    input Minisys_Clock, 
    input[4:0] Minisys_Button,
    input Minisys_Uart_FromPc, 
    output Minisys_Uart_ToPc,
    output[7:0] Minisys_DigitalTubes_NotEnable,
    output[7:0]Minisys_DigitalTube_Shape
    ,output Minisys_Audio_Pwm
);

CpuTop dCpuTop(
    .iSwitches(Minisys_Switches),
    .oLights(Minisys_Lights),
    .iFpgaClk(Minisys_Clock),
    .iStartReceiveCoe(Minisys_Button[4]),
    .iFpgaRst(Minisys_Button[3]),
    .iFpgaUartFromPc( Minisys_Uart_FromPc),
    .oFpgaUartToPc( Minisys_Uart_ToPc),
    .oDigitalTubeNotEnable(Minisys_DigitalTubes_NotEnable),
    .oDigitalTubeShape(Minisys_DigitalTube_Shape)
);
endmodule
