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
module CoeMemory (
    input iFpgaReset //按钮，按下后重置cpu 状态。
    ,input iFpgaClock // upg需要一个系统钟来重置。 100MHz
    ,input iUpgClock // upg本身和串口通信的时钟。
    ,input iStartReceiveCoe // 按钮。按下后开始接受串口数据。
    ,input iFpgaUartFromPc// receive data by UART
    ,output oCpuReset //如果正在接受数据，Cpu需要停止运转。因此本模块提供给外界停转的依据。

    ,input iCpuClock // 用在两个Memory上， 23MHz
    //InstructionMemory 的函数接口
    ,input [13:0] iImAddressRequested //来自 Fetcher
    ,output [31:0] oInstructionFetched //给到其他模块，当前的指令。
    //DataMemory 的函数接口
    ,input iDoMemWrite //来自controller, 表示是set函数还是get函数
    // get
    ,input [31:0]iDmAddressRequested // 请求的地址（是什么地址就传什么）
    ,output[31:0] oMemoryFetched //将用到 MemOrIo 里面，作为参考 
    //set
    ,input [31:0]iDataToStore //来自 TODO
);
    ///////////// UART Programmer Pinouts ///////////// 
    wire upg_clk = iUpgClock;
    wire upg_clk_o;
    wire upg_wen_o; //Uart write out enable
    wire upg_done_o; //Uart iFpgaUartFromPc data have done
    //data to which memory unit of program_rom/dmemory32
    wire [14:0] upg_adr_o;
    //data to program_rom or dmemory32
    wire [31:0] upg_dat_o;
    wire spg_bufg;
    BUFG U1(.I(iStartReceiveCoe), .O(spg_bufg)); // de-twitter
    // Generate UART Programmer reset signal
    reg upg_rst;
    always @ (posedge iFpgaClock) begin
        if (spg_bufg) upg_rst = 0;
        if (iFpgaReset) upg_rst = 1;
    end
    //used for other modules which don't relate to UART
    assign oCpuReset = iFpgaReset | !upg_rst;

    uart_bmpg_0 uart_instance(
        .upg_clk_i(upg_clk),
        .upg_rst_i(upg_rst),
        .upg_rx_i(iFpgaUartFromPc),
        .upg_clk_o(upg_clk_o),
        .upg_wen_o(upg_wen_o),
        .upg_adr_o(upg_adr_o),
        .upg_dat_o(upg_dat_o),
        .upg_done_o(upg_done_o)
    );

    // 这里利用到到了uart IP 核的信号，用来接受数据。
    InstructionMemory dInstructionMemory(
        //InstructionMemory get函数的接口
        .iRomClock(iCpuClock),
        .iImAddressRequested(rom_adr_o),
        .oInstructionFetched(Instruction_i),

        //Coe串口修改 Instruction Memory的函数接口
        .iUpgReset(upg_rst),
        .iUpgClock(upg_clk_o),
        .iDoUpgWrites(upg_wen_o & (!upg_adr_o[14])),
        .iUpgWriteAddress(upg_adr_o[13:0]),
        .iUpgWriteData(upg_dat_o),
        .iIsUpgDone(upg_done_o)
    );

    // 这里利用到到了uart IP 核的信号，用来接受数据。
    DataMemory  dDataMemory(
        //Data Memory Cpu get/set函数接口
        .ram_clk_i(iCpuClock),
        .ram_wen_i(iDoMemWrite),
        .ram_adr_i(iDmAddressRequested[15:2]), //后面两位地址不用，因为只支持load word/store word。
        .ram_dat_i(iDataToStore),
        .ram_dat_o(oMemoryFetched),

        //Coe串口修改 Data Memory的函数接口
        .upg_rst_i(upg_rst),
        .upg_clk_i(upg_clk_o),
        .upg_wen_i(upg_wen_o & upg_adr_o[14]),
        .upg_adr_i(upg_adr_o[13:0]),
        .upg_dat_i(upg_dat_o),
        .upg_done_i(upg_done_o)
    );

endmodule //CoeMemory