`timescale 1ns / 1ps
module CPUTOP(
input[23:0]switch_topin, output[23:0]led_topout, input cpu_clk, input reset
);
    // Control signals
wire Branch, nBranch, Jmp, Jal, Jr, Zero, RegWrite, RegDst;
wire [31:0] branch_base_addr;
wire [31:0] Instruction; 
wire [31:0] Addr_Result; //�����ALU������ĵ�ַ,����ifetch
wire [31:0] read_data_1;     
wire [31:0] read_data_2; 

wire [31:0] link_addr;


Ifetc32 ifetch_instance(
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
    control32 controller_instance(
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
                    .Exe_opcode(Instruction[31:26]), 
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
                
        wire[31:0]write_data_fromMemoryIO;
        wire[31:0] m_wdata; // д��memory������
        assign m_wdata = write_data_fromMemoryIO;//���Ҳ��ior_data
        wire[31:0]m_rdata; //��memory������������
        wire[31:0]addr_out;//ָ��memoryд����
         dmemory32 memory_instance(
               .readData(m_rdata), 
               .address(addr_out), 
               .writeData(m_wdata), 
               .memWrite(MemWrite), 
               .clock(cpu_clk)
           );
           wire [31:0] r_wdata;//д��register������
//           wire [31:0]r_rdata;//�������read����data2

           decode32 decoder_instance(
               .read_data_1(read_data_1), //decoder�����
               .read_data_2(read_data_2),//decoder�����,�������Ǹ�memory�����
               .Instruction(Instruction),
               .mem_data(r_wdata),
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
            wire [15:0] ioread_data;//����Ǿ��������16bit����
            wire ledctl,switchctl;
            assign addr_in = ALU_Result; //��һ�ε�������������ͬ
             MemOrIO memoryIO_instance(
                   .mRead(MemRead), 
                   .mWrite(MemWrite), 
                   .ioRead(IORead), 
                   .ioWrite(IOWrite),
                   .addr_in(addr_in), 
                   .addr_out(addr_out), 
                   .m_rdata(m_rdata), //��memory����������
                   .io_rdata(ioread_data), 
                   .r_wdata(r_wdata), 
                   .r_rdata(read_data_2), 
                   .write_data(write_data_fromMemoryIO), 
                   .LEDCtrl(ledctl), 
                   .SwitchCtrl(switchctl)
               );
               
              Switch switch_instance(
                       .switclk(cpu_clk),
                       .switchrst(reset), 
                       .switchread(IORead), 
                       .switchctl(switchctl),
                       .switchaddr(addr_in[1:0]), 
                       .switchrdata(ioread_data), //�����15λ��
                       .switch_input(switch_topin)
                   );
                   
                 LED led_instance(
                       .led_clk(cpu_clk), 
                       .ledrst(reset), 
                       .ledwrite(IOWrite),//��controller���� 
                       .ledcs(ledctl), 
                       .ledaddr(addr_in[1:0]),
                       .ledwdata(write_data_fromMemoryIO[15:0]), 
                       .ledout(led_topout)
                   );
               
endmodule