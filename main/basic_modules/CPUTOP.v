`timescale 1ns / 1ps
module CPUTOP(
input[23:0]switch, output[23:0]LED, input cpu_clk, input reset
);
    // Control signals
wire Branch, nBranch, Jmp, Jal, Jr, Zero, RegWrite, RegDst;
wire [31:0] branch_base_addr;
wire [31:0] Instruction; 
wire [31:0] Addr_Result; //这个是ALU算出来的地址,给到ifetch
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
    wire [31:0]ALU_Result;
    wire MemorIOtoReg;
    wire[31:0]Sign_extend;
    
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
            executs32 executs32_instance(
                    .Read_data_1(read_data_1), 
                    .Read_data_2(read_data_2), 
                    .Sign_extend(Sign_extend), 
                    .Function_opcode(Instruction[5:0]), 
                    .opcode(Instruction[31:26]), 
                    .ALUOp(ALUOp), 
                    .Shamt(Instruction[10:6]), 
                    .Sftmd(Sftmd), 
                    .ALUSrc(ALUSrc), 
                    .I_format(I_format), 
                    .Jr(Jr), 
                    .PC_plus_4(branch_base_addr),
                    .Zero(Zero), 
                    .ALU_Result(ALU_Result), 
                    .Addr_Result(Addr_Result)
                );
                
        
        wire[31:0] m_wdata; // 写到memory的数据
        wire[31:0]m_rdata; //从memory读出来的数据
        wire[31:0]addr_out;//指导memory写到哪
         dmemory32 memory_instance(
               .readData(m_rdata), 
               .address(addr_out), 
               .writeData(m_wdata), 
               .Memwrite(MemWrite), 
               .clock(cpu_clk)
           );
           decode32 decoder_instance(
               .read_data_1(read_data_1), //decoder的输出
               .read_data_2(read_data_2),//decoder的输出
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
               
    
            wire [31:0] addr_in;
            assign addr_in = Addr_Result; //这一段单纯保持名字相同
             MemOrIO memoryIO_instance(
                   .mRead(MemRead), 
                   .mWrite(MemWrite), 
                   .ioRead(IORead), 
                   .ioWrite(IOWrite),
                   .addr_in(addr_in), 
                   .addr_out(address), 
                   .m_rdata(read_data_from_memory), 
                   .io_rdata(ioread_data), 
                   .r_wdata(read_data), 
                   .r_rdata(Read_data_2), 
                   .write_data(write_data), 
                   .LEDCtrl(ledcs), 
                   .SwitchCtrl(switchcs)
               );
endmodule