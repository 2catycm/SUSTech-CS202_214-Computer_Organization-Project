`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Southern University of Science and Technology 南方科技大学
// Engineer: 张力宇, 叶璨铭
// 
// Create Date: 2022/05/07 12:58:45
// Module Name: CPU_TOP
// Project Name: MIPS Single Cycle CPU
// Target Devices: Xilinx Board. Tested on MINISYS.
// Description: 
// 
//////////////////////////////////////////////////////////////////////////////////

module CpuTop(
    input iFpgaRst, //Active High
    input iFpgaClk, 
    input[23:0] iSwitches, 
    output[23:0] oLights, 
    // UART Programmer Pinouts
    // start Uart communicate at high level
    input iStartReceiveCoe, // Active High艁殴 if
    input iFpgaUartFromPc,// receive data by UART
    output oFpgaUartToPc, // send data by UART // 实际上没有用到。
    output[7:0] oDigitalTubeNotEnable, //which tubs to light
    output[7:0] oDigitalTubeShape  //light what
);
///////////// UART Programmer Pinouts ///////////// 
    wire upg_clk, upg_clk_o;
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
    always @ (posedge iFpgaClk) begin
    if (spg_bufg) upg_rst = 0;
    if (iFpgaRst) upg_rst = 1;
    end
    //used for other modules which don't relate to UART
    wire rst;
    assign rst = iFpgaRst | !upg_rst;

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
///////////// Cpu Clock ///////////// 
        wire cpu_clk;
        cpuclk cpuclk_instance(
            .clk_in1(iFpgaClk),
            .clk_out1(cpu_clk),
            .clk_out2(upg_clk)
        );
///////////// Ifetc32 和 progrom ///////////// 
    // Control signals
    wire Branch, nBranch, Jmp, Jal, Jr, Zero, RegWrite, RegDst;
    wire [31:0] branch_base_addr;
    wire [31:0] Addr_Result; 
    wire [31:0] read_data_1;     
    wire [31:0] read_data_2; 
    wire [31:0] read_data;
    wire [31:0] link_addr;
    wire [31:0] Instruction_i; 
    wire [31:0] Instruction_o_Ifetc32; 
    wire [13:0] rom_adr_o;
    InstructionFetcher dInstructionFetcher(
        .iInstruction(Instruction_i), 
        .oInstruction(Instruction_o_Ifetc32),
        .oBranchBaseAddress(branch_base_addr),
        .iAluAddrResult(Addr_Result),
        .iRegisterAddressResult(read_data_1),
        .iIsBeq(Branch),
        .iIsBne(nBranch),
        .iIsJ(Jmp),
        .iIsJal(Jal),
        .iIsJr(Jr),
        .iIsAluZero(Zero),
        .iCpuClock(cpu_clk),
        .iCpuReset(rst),
        .oLinkAddress(link_addr),
        .oProgromFetchAddr(rom_adr_o)
    );
    
    // 这里利用到到了uart IP 核的信号，用来接受数据。
    InstructionMemory dInstructionMemory(
        .iRomClock(cpu_clk),
        .iAddressRequested(rom_adr_o),
        .oInstructionFetched(Instruction_i),
        .iUpgReset(upg_rst),
        .iUpgClock(upg_clk_o),
        .iDoUpgWrites(upg_wen_o & (!upg_adr_o[14])),
        .iUpgWriteAddress(upg_adr_o[13:0]),
        .iUpgWriteData(upg_dat_o),
        .iIsUpgDone(upg_done_o)
    );
    
///////////// CpuDecoder ///////////// 
    wire [31:0]ALU_Result;
    wire MemorIOtoReg;
    wire[31:0]Sign_extend;
    wire [31:0] r_wdata;//暮聠聶暮聢掳register莽職聞膰聲掳膰聧?
    CpuDecoder dCpuDecoder(
        .oDataRead1(read_data_1),//decoder莽職聞膷啪聯暮聡?
        .oDataRead2(read_data_2),//decoder莽職聞膷啪聯暮聡?,膷偶聶盲赂艦膷啪聯暮聡艧膰聵呕莽钮聶memory莽職聞膷啪聯暮聡?
        .iInstruction(Instruction_o_Ifetc32),
        .iMemoryData(r_wdata),
        .iAluResult(ALU_Result),
        .iIsJal(Jal),
        .iDoWriteReg(RegWrite),
        .iIsRegFromMem(MemorIOtoReg),
        .iIsRdOrRtWritten(RegDst),
        .oSignExtentedImmediate(Sign_extend),
        .iCpuClock(cpu_clk),
        .iCpuReset(rst),
        .iJalLinkAddress(link_addr)
    );
    
    
///////////// CpuController ///////////// 
    wire MemRead,MemWrite, IORead, IOWrite, ALUSrc, I_format, Sftmd;
    wire[1:0]ALUOp;
    CpuController dCpuController(
        .Opcode(Instruction_o_Ifetc32[31:26]), 
        .Function_opcode(Instruction_o_Ifetc32[5:0]), 
        .Jr(Jr), 
        .Branch(Branch), 
        .nBranch(nBranch),
        .Jmp(Jmp), 
        .Jal(Jal), 
        .Alu_resultHigh(ALU_Result[31:10]),
        .RegDST(RegDst), 
        .MemorIOtoReg(MemorIOtoReg), 
        .RegWrite(RegWrite), 
        .MemRead(MemRead), 
        .MemWrite(MemWrite), 
        .IORead(IORead), 
        .IOWrite(IOWrite), 
        .ALUSrc(ALUSrc), 
        .Sftmd(Sftmd), 
        .I_format(I_format), 
        .ALUOp(ALUOp)
    );
///////////// DataMemory ///////////// 
    wire[31:0]write_data_fromMemoryIO;
    wire[31:0] m_wdata; // 暮聠聶暮聢掳memory莽職聞膰聲掳膰聧?
    assign m_wdata = write_data_fromMemoryIO;//膷偶聶盲赂艦盲拧聼膰聵呕ior_data
    wire [31:0] ram_dat_o;
    wire [31:0] addr_out;
    // 这里利用到到了uart IP 核的信号，用来接受数据。
    DataMemory   dDataMemory(
        .ram_clk_i(cpu_clk),
        .ram_wen_i(MemWrite),
        .ram_adr_i(addr_out[15:2]),
        .ram_dat_i(m_wdata),
        .ram_dat_o(ram_dat_o),
        .upg_rst_i(upg_rst),
        .upg_clk_i(upg_clk_o),
        .upg_wen_i(upg_wen_o & upg_adr_o[14]),
        .upg_adr_i(upg_adr_o[13:0]),
        .upg_dat_i(upg_dat_o),
        .upg_done_i(upg_done_o)
    );
        
        
    wire [31:0] addr_in;
    wire [15:0] ioread_data;//膷偶聶盲赂艦膰聵呕莽钮聫膷偶聡暮陇聞莽聬聠莽職聞16bit膰聲掳膰聧沤
    wire LEDCtrl;
    wire SwitchCtrl;
    assign addr_in = ALU_Result; //膷偶聶盲赂聙膰沤木暮聧聲莽艧呕盲偶聺膰聦聛暮聬聧暮颅聴莽聸赂暮聬?
    MemOrIO  MemOrIO_instance(
        .mRead(MemRead), // read memory, from Controller
        .mWrite(MemWrite), // write memory, from Controller
        .ioRead(IORead), // read IO, from Controller
        .ioWrite(IOWrite), // write IO, from Controller
        .addr_in(addr_in), // from alu_result in ALU
        .addr_out(addr_out), // address to Data-Memory
        .m_rdata(ram_dat_o), // data read from Data-Memory
        .io_rdata(ioread_data), // data read from IO,16 bits
        .r_wdata(r_wdata), // data to Decoder(register file)
        .r_rdata(read_data_2), // data read from Decoder(register file)
        .write_data(write_data_fromMemoryIO), // data to memor y or I/O膹藕聢m_wdata, io_wdata膹藕?
        .LEDCtrl(LEDCtrl), // LED Chip Select
        .SwitchCtrl(SwitchCtrl) // Switch Chip Select
    );
///////////////////// CpuExecutor /////////////////////
    CpuExecutor dCpuExecutor(
        .Read_data_1(read_data_1),//the source of Ainput
        .Read_data_2(read_data_2),//one of the sources of Binput
        .Sign_extend(Sign_extend),//one of the sources of Binputllinstruction[31:26]
        // from lFetch
        .Function_opcode(Instruction_o_Ifetc32[5:0]),//instructions[5:0]
        .Exe_opcode(Instruction_o_Ifetc32[31:26]),
        .ALUOp(ALUOp),//{(R_format || l_format), (Branch|| nBranch)}
        .Shamt(Instruction_o_Ifetc32[10:6]),//instruction[10:6], the amount of shift bits
        .Sftmd(Sftmd),    // means this is a shift instruction
        .ALUSrc(ALUSrc),//means the 2nd operand is an immediate (except beq,bne)
        //means l-Type instruction except beq, bne, LW,sw
            .I_format(I_format),
            .Jr(Jr),
            .Zero(Zero),//膷偶聶盲赂艦盲拧聼膰聵呕膷沤膭莽沤聴膰聵呕暮聬艢茅聹?膷艢聛膷藝艂膷藵?
            .ALU_Result(ALU_Result),
            .Addr_Result(Addr_Result),//This means that upper right output
            .PC_plus_4(branch_base_addr)//pc+4
    );
        
    SwitchDriver dSwitchDriver(
        .switclk(cpu_clk),
        .switchrst(rst), 
        .switchread(IORead), 
        .switchctl(SwitchCtrl),
        .switchaddr(addr_in[1:0]), 
        .switchrdata(ioread_data), //膷偶聶盲赂艦膰聵?15盲藵聧莽職聞
        .switch_input(iSwitches)
    );
                           
    LightDriver dLightDriver(
        .led_clk(cpu_clk), 
        .ledrst(rst), 
        .ledwrite(IOWrite),//盲钮聨controller膰聺慕莽職聞 
        .ledcs(LEDCtrl),    
        .ledaddr(addr_in[1:0]),
        .ledwdata(write_data_fromMemoryIO[15:0]), 
        .ledout(oLights)
    );
    TubeDriver dTubeDriver(
        .clock(iFpgaClk),
        .reset(iFpgaRst),
        .IOWrite(IOWrite),
        .oDigitalTubeNotEnable(oDigitalTubeNotEnable),
        .oDigitalTubeShape(oDigitalTubeShape),
        .in_num(write_data_fromMemoryIO)
    );
        
endmodule
