`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Southern University of Science and Technology 南方科技大学
// Engineer: 王睿
// 
// Create Date: 2022/05/07 12:58:45
// Module Name: CPU_TOP
// Project Name: MIPS Single Cycle CPU
// Target Devices: Xilinx Board. Tested on MINISYS.
// Description: 
// 
//////////////////////////////////////////////////////////////////////////////////

module InstructionFetcher(iInstruction,oInstruction,oBranchBaseAddress,iAluAddrResult,iRegisterAddressResult,iIsBeq,iIsBne,iIsJ,iIsJal,iIsJr,iIsAluZero,iCpuClock,iCpuReset,oLinkAddress,oProgromFetchAddr);
    input[31:0] iInstruction;
    output[31:0] oInstruction;			// 根据PC的值从存放指令的prgrom中取出的指令
    output[31:0] oBranchBaseAddress;      // 对于有条件跳转类的指令而言，该值为(pc+4)送往ALU
    input[31:0]  iAluAddrResult;            // 来自ALU,为ALU计算出的跳转地址
    input[31:0]  iRegisterAddressResult;           // 来自Decoder，jr指令用的地址
    input        iIsBeq;                // 来自控制单元
    input        iIsBne;               // 来自控制单元
    input        iIsJ;                   // 来自控制单元
    input        iIsJal;                   // 来自控制单元
    input        iIsJr;                   // 来自控制单元
    input        iIsAluZero;                  //来自ALU，Zero为1表示两个值相等，反之表示不相等
    input        iCpuClock,iCpuReset;           //时钟与复位,复位信号用于给PC赋初始值，复位信号高电平有效
    output[31:0] oLinkAddress;             // JAL指令专用的PC+4
    output[13:0] oProgromFetchAddr;        // 向Progrom请求的地址


    reg[31:0] dProgramCounter, dNextProgramCounter;
    reg [31:0] dJalPc;

    assign oProgromFetchAddr=dProgramCounter[15:2];
    assign oBranchBaseAddress = dProgramCounter+4;
    assign oLinkAddress = dJalPc;
    assign oInstruction=iInstruction;
    
    // 组合逻辑，只要ALU、寄存器算完，就设置 dNextProgramCounter
    always @* begin
        if(((iIsBeq == 1) && (iIsAluZero == 1 )) || ((iIsBne == 1) && (iIsAluZero == 0))) // beq, bne
            dNextProgramCounter = iAluAddrResult; // the calculated new value for dProgramCounter
        else if(iIsJr == 1)
            dNextProgramCounter = iRegisterAddressResult; // the value of $31 register
        else dNextProgramCounter = dProgramCounter+4; // dProgramCounter+4
    end

    // 同步时序逻辑：复位、改变PC
    always @(negedge iCpuClock) begin
        if(iCpuReset == 1)
            dProgramCounter <= 32'h0000_0000; // 复位
        else begin
            if(iIsJal==1)   begin
                dJalPc = dProgramCounter+4; // 如果是Jal， 那么把JalPc 赋一下值
            end
            if((iIsJ == 1) || (iIsJal == 1)) begin // 如果是Jal或者J，就是跳转J类型指令
                dProgramCounter <= {dProgramCounter[31:28], iInstruction[25:0],2'b00}; // 按照它的要求改PC
            end
            //否则按照之前（还没到下降沿时）我们算过（上面那个always的组合逻辑）的 dNextProgramCounter 来更新PC
            else dProgramCounter <= dNextProgramCounter; 
        end
    end
endmodule
