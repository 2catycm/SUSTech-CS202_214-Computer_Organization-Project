`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Southern University of Science and Technology 南方科技大学
// Engineer: 叶璨铭
// 
// Create Date: 2022/05/07 12:58:45
// Module Name: CPU_TOP
// Project Name: MIPS Single Cycle CPU
// Target Devices: Xilinx Board. Tested on MINISYS.
// Description: 
// 
//////////////////////////////////////////////////////////////////////////////////
module CpuDecoder(oDataRead1,oDataRead2,iInstruction,iMemoryData,iAluResult,
                 iIsJal,iDoWriteReg,iIsRegFromMem,iIsRdOrRtWritten,oSignExtentedImmediate,iCpuClock,iCpuReset,iJalLinkAddress);
    //////////////// 输入输出 ////////////////
    output[31:0] oDataRead1;              // 输出的第一操作数
    output[31:0] oDataRead2;               // 输出的第二操作数
    input[31:0]  iInstruction;               // 取指单元来的指令
    input[31:0]  iMemoryData;   				//  从DATA RAM or I/O port取出的数据
    input[31:0]  iAluResult;   				// 从执行单元来的运算的结果
    input        iIsJal;                       //  来自控制单元，说明是JAL指令 
    input        iDoWriteReg;                  // 来自控制单元, 是否写入寄存器
    input        iIsRegFromMem;              // 来自控制单元，表示写回数据的来源
    input        iIsRdOrRtWritten;                //来自控制单元，表示是rd还是rt作为写回寄存器地址
    output[31:0] oSignExtentedImmediate;               // 扩展后的32位立即数
    input		 iCpuClock,iCpuReset;                // 时钟和复位
    input[31:0]  iJalLinkAddress;                 // 来自取指单元，JAL中用. 是PC plus 4
    //////////////// 代码逻辑 ////////////////
    //////////////// 成员变量 ////////////////
    wire [4:0] rs = iInstruction[25:21];
    wire [4:0] rt = iInstruction[20:16];
    wire [4:0] rd = iInstruction[15:11];
    wire [15:0] imm = iInstruction[15:0];
    //////////////// 实例化寄存器 ////////////////
    reg [4:0] dRegisterDestination; //要被写入的寄存器的地址
    reg [31:0] dWritingData; //要被写入寄存器的数据
    always @(*) begin // 虽然不一定要写入寄存器，但是这些数值要赋值。
        if (iIsJal) begin
            dRegisterDestination = 5'b11111; //31， 也就是ra寄存器
            dWritingData = iJalLinkAddress; // 要链接的地址，也就是pc+4. 暂存到ra。
        end else begin
            dRegisterDestination = iIsRdOrRtWritten?rd:rt;
            dWritingData = iIsRegFromMem?iMemoryData:iAluResult;
        end
    end
    Registers dRegisters(iCpuClock, iCpuReset, rs, rt, 
    dRegisterDestination, dWritingData, 
    iDoWriteReg, oDataRead1, oDataRead2);
    //////////////// 实例化扩展器 ////////////////
    wire[5:0] opcode;                       // 指令码
    assign opcode = iInstruction[31:26];	//OP
    SignExtension mSignExtension(opcode, imm, oSignExtentedImmediate);
endmodule

module SignExtension (
    input [5:0] iOpcode,
    input [15:0] iImmediate,
    output[31:0] oExtendedImmediate
);
    // assign oExtendedImmediate=iImmediate[15]?{16{1'b1}, iImmediate}:{16{1'b0}, iImmediate};
    //andi, ori xori 属于 zeroExtension情况，其他I format都是signExtension
    // sltiu 是特殊情况，取决于ALU如何实现sltiu的算法。
    // 如果是 32位数-ext(16位立即数) 然后判断符号，那么用零扩展比较合理。
    // 参考https://stackoverflow.com/questions/29284428/in-mips-when-to-use-a-signed-extend-when-to-use-a-zero-extend
    // 优化一下逻辑？ 都是001开头，连续的3,4,5,6？ 答：没法优化，卡诺图没什么规律。
    // another question: LUI 是什么extension？也是取决于ALU怎么实现。
    // 目前我是按照sign extension去处理。
    assign oExtendedImmediate=(6'b001100 == iOpcode || 6'b001101 == iOpcode ||
    6'b001110 == iOpcode|| 6'b001011==iOpcode)?{{16{1'b0}},iImmediate}:
    {{16{iImmediate[15]}}, iImmediate}; 
    //Verilog语法：https://stackoverflow.com/questions/49539345/error-in-compilation-replication-operator-in-verilog
endmodule

module Registers(
    input iCpuClock,iCpuReset,               // 时钟和复位
    input [4:0] iRegisterSource1, //iRegisterSource1
    input [4:0] iRegisterSource2, //iRegisterSource2
    input [4:0] iRegisterDestination, //iRegisterDestination
    input [31:0] iWritingData, // the data being written to R[iRegisterDestination]. 
    input regWrite, //whether enable write
    output [31:0] oDataRead1, // R[iRegisterSource1], the data that is read.
    output [31:0] oDataRead2 // R[iRegisterSource2], the data that is read.
);
    reg[31:0] dRegisters [0:31];
    assign oDataRead1 = dRegisters[iRegisterSource1];
    assign oDataRead2 = dRegisters[iRegisterSource2];
    // write data when posedge, so that when cpu goes to reg, the data has been written.
    integer i;
    always @(posedge iCpuClock, posedge iCpuReset) begin
        if (iCpuReset) begin
            for (i=0; i<32; i=i+1) begin //for 是辅助生成电路的手段。
                dRegisters[i] <= 32'h00000000; // 把所有寄存器复位为0。
            end
        end else begin
            if (regWrite && iRegisterDestination!=0) //$0要焊死为0
                dRegisters[iRegisterDestination] <= iWritingData;
        end
    end
endmodule //Registers