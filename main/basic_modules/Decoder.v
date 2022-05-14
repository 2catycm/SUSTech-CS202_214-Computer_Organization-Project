module decode32(read_data_1,read_data_2,Instruction,mem_data,ALU_result,
                 Jal,RegWrite,MemtoReg,RegDst,Sign_extend,clock,reset,opcplus4);
    //////////////// 输入输出 ////////////////
    output[31:0] read_data_1;              // 输出的第一操作数
    output[31:0] read_data_2;               // 输出的第二操作数
    input[31:0]  Instruction;               // 取指单元来的指令
    input[31:0]  mem_data;   				//  从DATA RAM or I/O port取出的数据
    input[31:0]  ALU_result;   				// 从执行单元来的运算的结果
    input        Jal;                       //  来自控制单元，说明是JAL指令 
    input        RegWrite;                  // 来自控制单元, 是否写入寄存器
    input        MemtoReg;              // 来自控制单元，表示写回数据的来源
    input        RegDst;                //来自控制单元，表示是rd还是rt作为写回寄存器地址
    output[31:0] Sign_extend;               // 扩展后的32位立即数
    input		 clock,reset;                // 时钟和复位
    input[31:0]  opcplus4;                 // 来自取指单元，JAL中用. 是PC plus 4
    //////////////// 代码逻辑 ////////////////
    //////////////// 成员变量 ////////////////
    wire [4:0] rs = Instruction[25:21];
    wire [4:0] rt = Instruction[20:16];
    wire [4:0] rd = Instruction[15:11];
    wire [15:0] imm = Instruction[15:0];
    //////////////// 实例化寄存器 ////////////////
    reg [4:0] registerDestination;
    reg [31:0] writingData;
    always @(*) begin
        if (!Jal) begin
            registerDestination = RegDst?rd:rt;
            writingData = MemtoReg?mem_data:ALU_result;
        end else begin
            registerDestination = 5'b11111;
            writingData = opcplus4;
        end
    end
    Registers mRegisters(clock, reset, rs, rt, 
    registerDestination, writingData, 
    RegWrite, read_data_1, read_data_2);
    //////////////// 实例化扩展器 ////////////////
    wire[5:0] opcode;                       // 指令码
    assign opcode = Instruction[31:26];	//OP
    SignExtension mSignExtension(opcode, imm, Sign_extend);
endmodule

module SignExtension (
    input [5:0] opcode,
    input [15:0] immediate,
    output[31:0] extendedImmediate
);
    // assign extendedImmediate=immediate[15]?{16{1'b1}, immediate}:{16{1'b0}, immediate};
    //andi, ori xori 属于 zeroExtension情况，其他I format都是signExtension
    // sltiu 是特殊情况，取决于ALU如何实现sltiu的算法。
    // 如果是 32位数-ext(16位立即数) 然后判断符号，那么用零扩展比较合理。
    // 参考https://stackoverflow.com/questions/29284428/in-mips-when-to-use-a-signed-extend-when-to-use-a-zero-extend
    // 优化一下逻辑？ 都是001开头，连续的3,4,5,6？ 答：没法优化，卡诺图没什么规律。
    // another question: LUI 是什么extension？也是取决于ALU怎么实现。
    // 目前我是按照sign extension去处理。
    assign extendedImmediate=(6'b001100 == opcode || 6'b001101 == opcode ||
    6'b001110 == opcode|| 6'b001011==opcode)?{{16{1'b0}},immediate}:
    {{16{immediate[15]}}, immediate}; 
    //Verilog语法：https://stackoverflow.com/questions/49539345/error-in-compilation-replication-operator-in-verilog
endmodule
module Registers(
    input clock,reset,               // 时钟和复位
    input [4:0] registerSource1, //registerSource1
    input [4:0] registerSource2, //registerSource2
    input [4:0] registerDestination, //registerDestination
    input [31:0] writingData, // the data being written to R[registerDestination]. 
    input regWrite, //whether enable write
    output [31:0] dataRead1, // R[registerSource1], the data that is read.
    output [31:0] dataRead2 // R[registerSource2], the data that is read.
);
    reg[31:0] mRegisters [0:31];
    assign dataRead1 = mRegisters[registerSource1];
    assign dataRead2 = mRegisters[registerSource2];
    // write data when posedge, so that when cpu goes to reg, the data has been written.
    integer i;
    always @(posedge clock, posedge reset) begin
        if (reset) begin
            for (i=0; i<32; i=i+1) begin //for 是辅助生成电路的手段。
                mRegisters[i] <= 32'h00000000; // 把所有寄存器复位为0。
            end
        end else begin
            if (regWrite && registerDestination!=0) //$0要焊死为0
                mRegisters[registerDestination] <= writingData;
        end
    end
endmodule //Registers