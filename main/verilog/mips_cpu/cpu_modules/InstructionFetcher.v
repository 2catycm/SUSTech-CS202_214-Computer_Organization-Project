`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Southern University of Science and Technology �Ϸ��Ƽ���ѧ
// Engineer: ���
// 
// Create Date: 2022/05/07 12:58:45
// Module Name: CPU_TOP
// Project Name: MIPS Single Cycle CPU
// Target Devices: Xilinx Board. Tested on MINISYS.
// Description: 
// 
//////////////////////////////////////////////////////////////////////////////////

module InstructionFetcher(
     input[31:0] iInstruction
    ,output[31:0] oInstruction			// ����PC��ֵ�Ӵ��ָ���prgrom��ȡ����ָ��
    ,output[31:0] oBranchBaseAddress      // ������������ת���ָ����ԣ���ֵΪ(pc+4)����ALU
    ,input[31:0]  iAluAddrResult            // ����ALUΪALU���������ת��ַ
    ,input[31:0]  iRegisterAddressResult           // ����Decoder��jrָ���õĵ�ַ
    ,input        iIsBeq                // ���Կ��Ƶ�Ԫ
    ,input        iIsBne               // ���Կ��Ƶ�Ԫ
    ,input        iIsJ                   // ���Կ��Ƶ�Ԫ
    ,input        iIsJal                   // ���Կ��Ƶ�Ԫ
    ,input        iIsJr                   // ���Կ��Ƶ�Ԫ
    ,input        iIsAluZero                  //����ALU��ZeroΪ1��ʾ����ֵ��ȣ���֮��ʾ�����
    ,input        iCpuClock, iCpuReset           //ʱ���븴λ��λ�ź����ڸ�PC����ʼֵ����λ�źŸߵ�ƽ��Ч
    ,output[31:0] oLinkAddress             // JALָ��ר�õ�PC+4
    ,output[13:0] oProgromFetchAddr        // ��Progrom����ĵ�ַ
);
    


    reg[31:0] dProgramCounter, dNextProgramCounter;
    reg [31:0] dJalPc;

    assign oProgromFetchAddr=dProgramCounter[15:2];
    assign oBranchBaseAddress = dProgramCounter+4;
    assign oLinkAddress = dJalPc;
    assign oInstruction=iInstruction;
    
    // ����߼���ֻҪALU���Ĵ������꣬������ dNextProgramCounter
    always @* begin
        if(((iIsBeq == 1) && (iIsAluZero == 1 )) || ((iIsBne == 1) && (iIsAluZero == 0))) // beq, bne
            dNextProgramCounter = iAluAddrResult; // the calculated new value for dProgramCounter
        else if(iIsJr == 1)
            dNextProgramCounter = iRegisterAddressResult; // the value of $31 register
        else dNextProgramCounter = dProgramCounter+4; // dProgramCounter+4
    end

    // ͬ��ʱ���߼�����λ���ı�PC
    always @(negedge iCpuClock) begin
        if(iCpuReset == 1)
            dProgramCounter <= 32'h0000_0000; // ��λ
        else begin
            if(iIsJal==1)   begin
                dJalPc = dProgramCounter+4; // �����Jal�� ��ô��JalPc ��һ��ֵ
            end
            if((iIsJ == 1) || (iIsJal == 1)) begin // �����Jal����J��������תJ����ָ��
                dProgramCounter <= {dProgramCounter[31:28], iInstruction[25:0],2'b00}; // ��������Ҫ���PC
            end
            //������֮ǰ����û���½���ʱ����������������Ǹ�always������߼����� dNextProgramCounter ������PC
            else dProgramCounter <= dNextProgramCounter; 
        end
    end
endmodule
