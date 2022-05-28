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
module CoeMemory (
    input iFpgaReset //��ť�����º�����cpu ״̬��
    ,input iFpgaClock // upg��Ҫһ��ϵͳ�������á� 100MHz
    ,input iUpgClock // upg����ʹ���ͨ�ŵ�ʱ�ӡ�
    ,input iStartReceiveCoe // ��ť�����º�ʼ���ܴ������ݡ�
    ,input iFpgaUartFromPc// receive data by UART
    ,output oCpuReset //������ڽ������ݣ�Cpu��Ҫֹͣ��ת����˱�ģ���ṩ�����ͣת�����ݡ�

    ,input iCpuClock // ��������Memory�ϣ� 23MHz
    //InstructionMemory �ĺ����ӿ�
    ,input [13:0] iImAddressRequested //���� Fetcher
    ,output [31:0] oInstructionFetched //��������ģ�飬��ǰ��ָ�
    //DataMemory �ĺ����ӿ�
    ,input iDoMemWrite //����controller, ��ʾ��set��������get����
    // get
    ,input [31:0]iDmAddressRequested // ����ĵ�ַ����ʲô��ַ�ʹ�ʲô��
    ,output[31:0] oMemoryFetched //���õ� MemOrIo ���棬��Ϊ�ο� 
    //set
    ,input [31:0]iDataToStore //���� TODO
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

    // �������õ�����uart IP �˵��źţ������������ݡ�
    InstructionMemory dInstructionMemory(
        //InstructionMemory get�����Ľӿ�
        .iRomClock(iCpuClock),
        .iImAddressRequested(rom_adr_o),
        .oInstructionFetched(Instruction_i),

        //Coe�����޸� Instruction Memory�ĺ����ӿ�
        .iUpgReset(upg_rst),
        .iUpgClock(upg_clk_o),
        .iDoUpgWrites(upg_wen_o & (!upg_adr_o[14])),
        .iUpgWriteAddress(upg_adr_o[13:0]),
        .iUpgWriteData(upg_dat_o),
        .iIsUpgDone(upg_done_o)
    );

    // �������õ�����uart IP �˵��źţ������������ݡ�
    DataMemory  dDataMemory(
        //Data Memory Cpu get/set�����ӿ�
        .ram_clk_i(iCpuClock),
        .ram_wen_i(iDoMemWrite),
        .ram_adr_i(iDmAddressRequested[15:2]), //������λ��ַ���ã���Ϊֻ֧��load word/store word��
        .ram_dat_i(iDataToStore),
        .ram_dat_o(oMemoryFetched),

        //Coe�����޸� Data Memory�ĺ����ӿ�
        .upg_rst_i(upg_rst),
        .upg_clk_i(upg_clk_o),
        .upg_wen_i(upg_wen_o & upg_adr_o[14]),
        .upg_adr_i(upg_adr_o[13:0]),
        .upg_dat_i(upg_dat_o),
        .upg_done_i(upg_done_o)
    );

endmodule //CoeMemory