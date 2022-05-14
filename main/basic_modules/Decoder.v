module decode32(read_data_1,read_data_2,Instruction,mem_data,ALU_result,
                 Jal,RegWrite,MemtoReg,RegDst,Sign_extend,clock,reset,opcplus4);
    //////////////// ������� ////////////////
    output[31:0] read_data_1;              // ����ĵ�һ������
    output[31:0] read_data_2;               // ����ĵڶ�������
    input[31:0]  Instruction;               // ȡָ��Ԫ����ָ��
    input[31:0]  mem_data;   				//  ��DATA RAM or I/O portȡ��������
    input[31:0]  ALU_result;   				// ��ִ�е�Ԫ��������Ľ��
    input        Jal;                       //  ���Կ��Ƶ�Ԫ��˵����JALָ�� 
    input        RegWrite;                  // ���Կ��Ƶ�Ԫ, �Ƿ�д��Ĵ���
    input        MemtoReg;              // ���Կ��Ƶ�Ԫ����ʾд�����ݵ���Դ
    input        RegDst;                //���Կ��Ƶ�Ԫ����ʾ��rd����rt��Ϊд�ؼĴ�����ַ
    output[31:0] Sign_extend;               // ��չ���32λ������
    input		 clock,reset;                // ʱ�Ӻ͸�λ
    input[31:0]  opcplus4;                 // ����ȡָ��Ԫ��JAL����. ��PC plus 4
    //////////////// �����߼� ////////////////
    //////////////// ��Ա���� ////////////////
    wire [4:0] rs = Instruction[25:21];
    wire [4:0] rt = Instruction[20:16];
    wire [4:0] rd = Instruction[15:11];
    wire [15:0] imm = Instruction[15:0];
    //////////////// ʵ�����Ĵ��� ////////////////
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
    //////////////// ʵ������չ�� ////////////////
    wire[5:0] opcode;                       // ָ����
    assign opcode = Instruction[31:26];	//OP
    SignExtension mSignExtension(opcode, imm, Sign_extend);
endmodule

module SignExtension (
    input [5:0] opcode,
    input [15:0] immediate,
    output[31:0] extendedImmediate
);
    // assign extendedImmediate=immediate[15]?{16{1'b1}, immediate}:{16{1'b0}, immediate};
    //andi, ori xori ���� zeroExtension���������I format����signExtension
    // sltiu �����������ȡ����ALU���ʵ��sltiu���㷨��
    // ����� 32λ��-ext(16λ������) Ȼ���жϷ��ţ���ô������չ�ȽϺ���
    // �ο�https://stackoverflow.com/questions/29284428/in-mips-when-to-use-a-signed-extend-when-to-use-a-zero-extend
    // �Ż�һ���߼��� ����001��ͷ��������3,4,5,6�� ��û���Ż�����ŵͼûʲô���ɡ�
    // another question: LUI ��ʲôextension��Ҳ��ȡ����ALU��ôʵ�֡�
    // Ŀǰ���ǰ���sign extensionȥ����
    assign extendedImmediate=(6'b001100 == opcode || 6'b001101 == opcode ||
    6'b001110 == opcode|| 6'b001011==opcode)?{{16{1'b0}},immediate}:
    {{16{immediate[15]}}, immediate}; 
    //Verilog�﷨��https://stackoverflow.com/questions/49539345/error-in-compilation-replication-operator-in-verilog
endmodule
module Registers(
    input clock,reset,               // ʱ�Ӻ͸�λ
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
            for (i=0; i<32; i=i+1) begin //for �Ǹ������ɵ�·���ֶΡ�
                mRegisters[i] <= 32'h00000000; // �����мĴ�����λΪ0��
            end
        end else begin
            if (regWrite && registerDestination!=0) //$0Ҫ����Ϊ0
                mRegisters[registerDestination] <= writingData;
        end
    end
endmodule //Registers