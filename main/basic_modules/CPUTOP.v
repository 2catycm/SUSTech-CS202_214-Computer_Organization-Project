`timescale 1ns / 1ps
module CPUTOP(
input[23:0]switch, output[23:0]LED, input cpu_clk, input reset
);
    // Control signals
wire Branch, nBranch, Jmp, Jal, Jr, Zero, RegWrite, RegDst;
wire [31:0] branch_base_addr;
wire [31:0] Instruction; 
wire [31:0] Addr_Result; 
wire [31:0] read_data_1;     
wire [31:0] read_data_2; 
wire [31:0] read_data;
wire [31:0] link_addr;


IFetch ifetch_instance(
        .Instruction(Instruction), 
        .branch_base_addr(branch_base_addr),
        .Addr_result(Addr_Result),
        .Read_data_1(read_data_1),
        .Branch(Branch),
        .nBranch(nBranch),
        .Jmp(Jmp),
        .Jal(Jal),
        .Jr(Jr),
        .Zero(Zero),
        .clock(cpu_clk),
        .reset(reset),
        .link_addr(link_addr)
    );
    wire ALU_Result,MemorIOtoReg;
    wire[31:0]Sign_extend;
    decode32 decoder_instance(
    .read_data_1(read_data_1),
    .read_data_2(read_data_2),
    .Instruction(Instruction),
    .read_data(read_data),
    .ALU_result(ALU_Result),
    .Jal(Jal),
    .RegWrite(RegWrite),
    .MemtoReg(MemorIOtoReg),
    .RegDst(RegDst),
    . Sign_extend(Sign_extend),
    .clock(cpu_clk),
    .reset(reset),
    .opcplus4(link_addr)
    );
     wire MemRead,MemWrite, IORead, IOWrite, ALUSrc, I_format, Sftmd;
      wire[1:0]ALUOp;
    ControllerIO controller_instance(
            .Opcode(Instruction[31:26]), 
            .Function_opcode(Instruction[5:0]), 
            .Jr(Jr), 
            .Jmp(Jmp), 
            .Jal(Jal), 
            .Branch(Branch), 
            .nBranch(nBranch),
            .RegDST(RegDst), 
            .Alu_resultHigh(ALU_Result[31:10]), 
            .MemorIOtoReg(MemorIOtoReg), 
            .RegWrite(RegWrite), 
            .MemRead(MemRead), 
            .MemWrite(MemWrite), 
            .IORead(IORead), 
            .IOWrite(IOWrite), 
            .ALUSrc(ALUSrc), 
            .I_format(I_format), 
            .Sftmd(Sftmd), 
            .ALUOp(ALUOp)
        );

endmodule