//****************************************Copyright (c)***********************************//
//原子哥在线教学平台：www.yuanzige.com
//�?术支持：www.openedv.com
//淘宝店铺：http://openedv.taobao.com 
//关注微信公众平台微信号："正点原子"，免费获取ZYNQ & FPGA & STM32 & LINUX资料�?
//版权�?有，盗版必究�?
//Copyright(C) 正点原子 2018-2028
//All rights reserved	                               
//----------------------------------------------------------------------------------------
// File name:           uart_loopback_top
// Last modified Date:  2019/10/9 9:56:36
// Last Version:        V1.0
// Descriptions:        �?发板通过串口接收PC发�?�的字符，然后将收到的字符发送给PC
//----------------------------------------------------------------------------------------
// Created by:          正点原子
// Created date:        2019/10/9 9:56:36
// Version:             V1.0
// Descriptions:        The original version
//
//----------------------------------------------------------------------------------------
//****************************************************************************************//

// chosen by 叶璨�? for this project
// modify the input and output, the buad rate and the clock for ego1 and my project
// This one is more stable than the one in EGO1 Student Pack, and more portable and reusable. Good Code!
module UartDriver(
    input iFpgaClock, iCpuClock, iCpuReset
    ,input iUartCtrl, iIoRead //�?个来自memorio, �?个来自controller
    ,input iUartFromPc
    ,output reg [15:0] oUartData
);
    wire [7:0] dataReceived;
    always@(negedge iCpuClock or posedge iCpuReset) begin
        if(iCpuReset) begin
            oUartData <= 0;
        end
		else if(iUartCtrl && iIoRead) begin
			oUartData <= {8'h00, dataReceived};
        end
		else begin
            oUartData <= oUartData;
        end
    end
    wire fakeUartToPc;
    //parameter define
    parameter  CLK_FREQ = 100_000000;         //定义系统时钟频率 
    parameter  UART_BPS = 128000;           //定义串口波特率
    uart_manager #(
        .CLK_FREQ ( CLK_FREQ ),
        .UART_BPS ( UART_BPS ))
    u_uart_manager (
        .sys_clk                 ( iFpgaClock              ),
        .sys_rst_n               ( ~iCpuReset            ),
        .uart_rxd                ( iUartFromPc             ),

        .uart_txd                ( fakeUartToPc             ),
        .data_received           ( dataReceived  [7:0] )
    );

endmodule