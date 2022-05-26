`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Southern University of Science and Technology ??????
// Engineer: ???
// 
// Create Date: 2022/05/07 12:58:45
// Module Name: CPU_TOP
// Project Name: MIPS Single Cycle CPU
// Target Devices: Xilinx Board. Tested on MINISYS.
// Description: 
// 
//////////////////////////////////////////////////////////////////////////////////

module CPUTOP(
input fpga_rst, //Active High
input fpga_clk, 
input[23:0] switch2N4, 
output[23:0] led2N4, 
// UART Programmer Pinouts
// start Uart communicate at high level
input start_pg, // Active HighŁŹ if
input rx,// receive data by UART
output tx, // send data by UART
output[7:0] Dig, //which tubs to light
output[7:0]Y  //light what
);


// UART Programmer Pinouts
wire upg_clk, upg_clk_o;
wire upg_wen_o; //Uart write out enable
wire upg_done_o; //Uart rx data have done
//data to which memory unit of program_rom/dmemory32
wire [14:0] upg_adr_o;
//data to program_rom or dmemory32
wire [31:0] upg_dat_o;
wire spg_bufg;
BUFG U1(.I(start_pg), .O(spg_bufg)); // de-twitter
// Generate UART Programmer reset signal
reg upg_rst;
always @ (posedge fpga_clk) begin
if (spg_bufg) upg_rst = 0;
if (fpga_rst) upg_rst = 1;
end
//used for other modules which don't relate to UART
wire rst;
assign rst = fpga_rst | !upg_rst;

uart_bmpg_0 uart_instance(
.upg_clk_i(upg_clk),
.upg_rst_i(upg_rst),
.upg_rx_i(rx),
.upg_clk_o(upg_clk_o),
.upg_wen_o(upg_wen_o),
.upg_adr_o(upg_adr_o),
.upg_dat_o(upg_dat_o),
.upg_done_o(upg_done_o)
);

wire cpu_clk;
cpuclk cpuclk_instance(
.clk_in1(fpga_clk),
.clk_out1(cpu_clk),
.clk_out2(upg_clk)
);



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
Ifetc32 Ifetc32_instance(
        .Instruction_i(Instruction_i), 
        .Instruction_o(Instruction_o_Ifetc32),
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
        .reset(rst),
        .link_addr(link_addr),
        .rom_adr_o(rom_adr_o)
    );
    
    programrom programrom_instance(
    .rom_clk_i(cpu_clk),
    .rom_adr_i(rom_adr_o),
    .Instruction_o(Instruction_i),
    .upg_rst_i(upg_rst),
    .upg_clk_i(upg_clk_o),
    .upg_wen_i(upg_wen_o & (!upg_adr_o[14])),
    .upg_adr_i(upg_adr_o[13:0]),
    .upg_dat_i(upg_dat_o),
    .upg_done_i(upg_done_o)
    );
    
    wire [31:0]ALU_Result;
    wire MemorIOtoReg;
    wire[31:0]Sign_extend;
    wire [31:0] r_wdata;//ĺĺ°registerçć°ć?
    decode32 decoder_instance(
    .read_data_1(read_data_1),//decoderçčžĺ?
    .read_data_2(read_data_2),//decoderçčžĺ?,čżä¸ŞčžĺşćŻçťmemoryçčžĺ?
    .Instruction(Instruction_o_Ifetc32),
    .mem_data(r_wdata),
    .ALU_result(ALU_Result),
    .Jal(Jal),
    .RegWrite(RegWrite),
    .MemtoReg(MemorIOtoReg),
    .RegDst(RegDst),
    .Sign_extend(Sign_extend),
    .clock(cpu_clk),
    .reset(rst),
    .opcplus4(link_addr)
    );
    
    
    
    wire MemRead,MemWrite, IORead, IOWrite, ALUSrc, I_format, Sftmd;
    wire[1:0]ALUOp;
    control32 control32_instance(
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
        
        wire[31:0]write_data_fromMemoryIO;
        wire[31:0] m_wdata; // ĺĺ°memoryçć°ć?
        assign m_wdata = write_data_fromMemoryIO;//čżä¸ŞäšćŻior_data
        wire [31:0] ram_dat_o;
        wire [31:0] addr_out;
        dmemory32   dmemory32_instance(
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
        wire [15:0] ioread_data;//čżä¸ŞćŻçťčżĺ¤çç16bitć°ćŽ
        wire LEDCtrl;
        wire SwitchCtrl;
        assign addr_in = ALU_Result; //čżä¸ćŽľĺçşŻäżćĺĺ­ç¸ĺ?
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
        .write_data(write_data_fromMemoryIO), // data to memor y or I/Oďźm_wdata, io_wdataďź?
        .LEDCtrl(LEDCtrl), // LED Chip Select
        .SwitchCtrl(SwitchCtrl) // Switch Chip Select
        );
        
        
        
        executs32 executs32_instance(
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
         .Zero(Zero),//čżä¸ŞäšćŻčŽĄçŽćŻĺŚé?čŚčˇłč˝?
         .ALU_Result(ALU_Result),
         .Addr_Result(Addr_Result),//This means that upper right output
         .PC_plus_4(branch_base_addr)//pc+4
        );
        
        Switch switch_instance(
         .switclk(cpu_clk),
         .switchrst(rst), 
         .switchread(IORead), 
         .switchctl(SwitchCtrl),
         .switchaddr(addr_in[1:0]), 
         .switchrdata(ioread_data), //čżä¸Şć?15ä˝ç
         .switch_input(switch2N4)
        );
                           
          LED led_instance(
          .led_clk(cpu_clk), 
          .ledrst(rst), 
          .ledwrite(IOWrite),//äťcontrollerćĽç 
          .ledcs(LEDCtrl), 
          .ledaddr(addr_in[1:0]),
          .ledwdata(write_data_fromMemoryIO[15:0]), 
          .ledout(led2N4)
         );
        Tubs tubs_instance(
            .clock(fpga_clk),
            .reset(fpga_rst),
            .IOWrite(IOWrite),
            .Dig(Dig),
            .Y(Y),
            .in_num(write_data_fromMemoryIO)
        );
        
endmodule
