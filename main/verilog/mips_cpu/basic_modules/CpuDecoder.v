`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Southern University of Science and Technology �Ϸ��Ƽ���ѧ
// Engineer: Ҷ���
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
    //////////////// ������� ////////////////
    output[31:0] oDataRead1;              // ����ĵ�һ������
    output[31:0] oDataRead2;               // ����ĵڶ�������
    input[31:0]  iInstruction;               // ȡָ��Ԫ����ָ��
    input[31:0]  iMemoryData;   				//  ��DATA RAM or I/O portȡ��������
    input[31:0]  iAluResult;   				// ��ִ�е�Ԫ��������Ľ��
    input        iIsJal;                       //  ���Կ��Ƶ�Ԫ��˵����JALָ�� 
    input        iDoWriteReg;                  // ���Կ��Ƶ�Ԫ, �Ƿ�д��Ĵ���
    input        iIsRegFromMem;              // ���Կ��Ƶ�Ԫ����ʾд�����ݵ���Դ
    input        iIsRdOrRtWritten;                //���Կ��Ƶ�Ԫ����ʾ��rd����rt��Ϊд�ؼĴ�����ַ
    output[31:0] oSignExtentedImmediate;               // ��չ���32λ������
    input		 iCpuClock,iCpuReset;                // ʱ�Ӻ͸�λ
    input[31:0]  iJalLinkAddress;                 // ����ȡָ��Ԫ��JAL����. ��PC plus 4
    //////////////// �����߼� ////////////////
    //////////////// ��Ա���� ////////////////
    wire [4:0] rs = iInstruction[25:21];
    wire [4:0] rt = iInstruction[20:16];
    wire [4:0] rd = iInstruction[15:11];
    wire [15:0] imm = iInstruction[15:0];
    //////////////// ʵ�����Ĵ��� ////////////////
    reg [4:0] dRegisterDestination; //Ҫ��д��ļĴ����ĵ�ַ
    reg [31:0] dWritingData; //Ҫ��д��Ĵ���������
    always @(*) begin // ��Ȼ��һ��Ҫд��Ĵ�����������Щ��ֵҪ��ֵ��
        if (iIsJal) begin
            dRegisterDestination = 5'b11111; //31�� Ҳ����ra�Ĵ���
            dWritingData = iJalLinkAddress; // Ҫ���ӵĵ�ַ��Ҳ����pc+4. �ݴ浽ra��
        end else begin
            dRegisterDestination = iIsRdOrRtWritten?rd:rt;
            dWritingData = iIsRegFromMem?iMemoryData:iAluResult;
        end
    end
    Registers dRegisters(iCpuClock, iCpuReset, rs, rt, 
    dRegisterDestination, dWritingData, 
    iDoWriteReg, oDataRead1, oDataRead2);
    //////////////// ʵ������չ�� ////////////////
    wire[5:0] opcode;                       // ָ����
    assign opcode = iInstruction[31:26];	//OP
    SignExtension mSignExtension(opcode, imm, oSignExtentedImmediate);
endmodule

module SignExtension (
    input [5:0] iOpcode,
    input [15:0] iImmediate,
    output[31:0] oExtendedImmediate
);
    // assign oExtendedImmediate=iImmediate[15]?{16{1'b1}, iImmediate}:{16{1'b0}, iImmediate};
    //andi, ori xori ���� zeroExtension���������I format����signExtension
    // sltiu �����������ȡ����ALU���ʵ��sltiu���㷨��
    // ����� 32λ��-ext(16λ������) Ȼ���жϷ��ţ���ô������չ�ȽϺ���
    // �ο�https://stackoverflow.com/questions/29284428/in-mips-when-to-use-a-signed-extend-when-to-use-a-zero-extend
    // �Ż�һ���߼��� ����001��ͷ��������3,4,5,6�� ��û���Ż�����ŵͼûʲô���ɡ�
    // another question: LUI ��ʲôextension��Ҳ��ȡ����ALU��ôʵ�֡�
    // Ŀǰ���ǰ���sign extensionȥ����
    assign oExtendedImmediate=(6'b001100 == iOpcode || 6'b001101 == iOpcode ||
    6'b001110 == iOpcode|| 6'b001011==iOpcode)?{{16{1'b0}},iImmediate}:
    {{16{iImmediate[15]}}, iImmediate}; 
    //Verilog�﷨��https://stackoverflow.com/questions/49539345/error-in-compilation-replication-operator-in-verilog
endmodule

module Registers(
    input iCpuClock,iCpuReset,               // ʱ�Ӻ͸�λ
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
            for (i=0; i<32; i=i+1) begin //for �Ǹ������ɵ�·���ֶΡ�
                dRegisters[i] <= 32'h00000000; // �����мĴ�����λΪ0��
            end
        end else begin
            if (regWrite && iRegisterDestination!=0) //$0Ҫ����Ϊ0
                dRegisters[iRegisterDestination] <= iWritingData;
        end
    end
endmodule //Registers