`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/05/18 01:21:06
// Design Name: 
// Module Name: Ifetc32
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module Ifetc32(Instruction_i,Instruction_o,branch_base_addr,Addr_result,Read_data_1,Branch,nBranch,Jmp,Jal,Jr,Zero,clock,reset,link_addr,rom_adr_o);
    input[31:0] Instruction_i;
    output[31:0] Instruction_o;			// 根据PC的值从存放指令的prgrom中取出的指令
    output[31:0] branch_base_addr;      // 对于有条件跳转类的指令而言，该值为(pc+4)送往ALU
    input[31:0]  Addr_result;            // 来自ALU,为ALU计算出的跳转地址
    input[31:0]  Read_data_1;           // 来自Decoder，jr指令用的地址
    input        Branch;                // 来自控制单元
    input        nBranch;               // 来自控制单元
    input        Jmp;                   // 来自控制单元
    input        Jal;                   // 来自控制单元
    input        Jr;                   // 来自控制单元
    input        Zero;                  //来自ALU，Zero为1表示两个值相等，反之表示不相等
    input        clock,reset;           //时钟与复位,复位信号用于给PC赋初始值，复位信号高电平有效
    output[31:0] link_addr;             // JAL指令专用的PC+4
    output[13:0] rom_adr_o;
reg[31:0] PC, Next_PC;
reg [31:0] jalpc;
assign rom_adr_o=PC[15:2];
assign branch_base_addr = PC+4;
assign link_addr = jalpc;
assign Instruction_o=Instruction_i;
always @* begin
if(((Branch == 1) && (Zero == 1 )) || ((nBranch == 1) && (Zero == 0))) // beq, bne
Next_PC = Addr_result; // the calculated new value for PC
else if(Jr == 1)
Next_PC = Read_data_1; // the value of $31 register
else Next_PC = PC+4; // PC+4
end
always @(negedge clock) begin
if(reset == 1)
PC <= 32'h0000_0000;
else begin
if(Jal==1)begin
jalpc = PC+4;
end
if((Jmp == 1) || (Jal == 1)) begin
PC <= {PC[31:28],Instruction_i[25:0],2'b00};
end
else PC <= Next_PC;
end
end
endmodule
