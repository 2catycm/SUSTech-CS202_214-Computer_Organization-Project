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

module CpuController(Opcode,Function_opcode,Jr,Branch,nBranch,Jmp,Jal, Alu_resultHigh, RegDST, MemorIOtoReg, RegWrite, MemRead, MemWrite, IORead, IOWrite,
ALUSrc,ALUOp,Sftmd,I_format);
    input[5:0] Opcode; // instruction[31:26], opcode
    input[5:0] Function_opcode; // instructions[5:0], funct
    output Jr; // 1 indicates the instruction is "jr", otherwise it's not "jr" output Jmp, // 1 indicate the instruction is "j", otherwise it's not
    output Branch; // 1 indicate the instruction is "beq" , otherwise it's not
    output nBranch; // 1 indicate the instruction is "bne", otherwise it's not
    output Jmp;
    output Jal;
    input[21:0] Alu_resultHigh; // From the execution unit Alu_Result[31..10]
    output RegDST; // 1 indicate destination register is "rd"(R),otherwise it's "rt"(I)
    output MemorIOtoReg; // 1 indicates that data needs to be read from memory or I/O to the register
    output RegWrite; // 1 indicates that the instruction needs to write to the register
    output MemRead; // 1 indicates that the instruction needs to read from the memory
    output MemWrite; // 1 indicates that the instruction needs to write to the memory
    output IORead; // 1 indicates I/O read
    output IOWrite; // 1 indicates I/O write
    output ALUSrc; // 1 indicate the 2nd data is immidiate (except "beq","bne")
    output Sftmd; // 1 indicate the instruction is shift instruction
    output I_format;/* 1 indicate the instruction is I-type but isn't "beq","bne","LW" or "SW" */
    output[1:0] ALUOp;/* if the instruction is R-type or I_format, ALUOp is 2'b10;
    if the instruction is"beq" or "bne", ALUOp is 2'b01??
    if the instruction is"lw" or "sw", ALUOp is 2'b00??*/ 
    
    wire Lw,sw,R_format;
    assign Lw = (Opcode==6'b100011)? 1'b1:1'b0;
    assign sw = (Opcode==6'b101011)? 1'b1:1'b0;
    
    assign Jr =((Opcode==6'b000000)&&(Function_opcode==6'b001000)) ? 1'b1 : 1'b0;
    assign Jal = (Opcode==6'b000011)? 1'b1:1'b0;
    assign Jmp = (Opcode==6'b000010)? 1'b1:1'b0;
    assign Branch = (Opcode==6'b000100)? 1'b1:1'b0;
    assign nBranch = (Opcode==6'b000101)? 1'b1:1'b0;
    assign R_format = (Opcode==6'b000000)? 1'b1:1'b0;
    assign RegDST = R_format;
    assign I_format = (Opcode[5:3]==3'b001)?1'b1:1'b0;
    assign ALUSrc = I_format||(Opcode==6'b100011)||(Opcode==6'b101011);
    assign ALUOp = {(R_format || I_format),(Branch || nBranch)};
    assign Sftmd = (((Function_opcode==6'b000000)||(Function_opcode==6'b000010)
    ||(Function_opcode==6'b000011)||(Function_opcode==6'b000100)
    ||(Function_opcode==6'b000110)||(Function_opcode==6'b000111))
    && R_format)? 1'b1:1'b0;
    
    
    assign RegWrite = (R_format || Lw || Jal || I_format) && !(Jr) ; // Write memory or write IO
    assign MemWrite = ((sw==1) && (Alu_resultHigh[21:0] != 22'h3FFFFF)) ? 1'b1:1'b0;
    assign MemRead = ((Lw==1) && (Alu_resultHigh[21:0] != 22'h3FFFFF)) ? 1'b1:1'b0; // Read memory
    assign IORead = ((Lw==1) && (Alu_resultHigh[21:0] == 22'h3FFFFF)) ? 1'b1:1'b0; // Read input port
    assign IOWrite = ((sw==1) && (Alu_resultHigh[21:0] == 22'h3FFFFF)) ? 1'b1:1'b0; // Write output port
    // Read operations require reading data from memory or I/O to write to the register
    assign MemorIOtoReg = IORead || MemRead;
endmodule
