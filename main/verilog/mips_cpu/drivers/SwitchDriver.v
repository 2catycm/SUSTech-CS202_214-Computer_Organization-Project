`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Southern University of Science and Technology �Ϸ��Ƽ���ѧ
// Engineer: ������
// 
// Create Date: 2022/05/07 12:58:45
// Module Name: CPU_TOP
// Project Name: MIPS Single Cycle CPU
// Target Devices: Xilinx Board. Tested on MINISYS.
// Description: 
// 
//////////////////////////////////////////////////////////////////////////////////

module SwitchDriver(iCpuClock, iCpuReset, switchread, iDoSwitchRead,iSwirchAddress, iSwitchDataRead, iFpgaSwitches);
    input iCpuClock;			        //  ʱ���ź�
    input iCpuReset;			        //  ��λ�ź�
    input iDoSwitchRead;			        //  ��memorio����switchƬ  !!!!!!!!!!
    input[1:0] iSwirchAddress;		    //  ��switchģ��ĵ�??�Ͷ�  !!!!!!!!!!!!!!!
    output [15:0] iSwitchDataRead;	    //  �͵�CPU�Ĳ��뿪��???ע������???��ֻ��16??
    input [23:0] iFpgaSwitches;		    //  �Ӱ��϶���24λ��

    reg [15:0] iSwitchDataRead;
    always@(negedge iCpuClock or posedge iCpuReset) begin
        if(iCpuReset) begin
            iSwitchDataRead <= 0;
        end
		else if(iDoSwitchRead) begin
			if(iSwirchAddress==2'b00)
				iSwitchDataRead[15:0] <= iFpgaSwitches[15:0];   // data output,lower 16 bits non-extended
			else if(iSwirchAddress==2'b10)
				iSwitchDataRead[15:0] <= { 8'h00, iFpgaSwitches[23:16] }; //data output, upper 8 bits extended with zero
			else 
				iSwitchDataRead <= iSwitchDataRead;
        end
		else begin
            iSwitchDataRead <= iSwitchDataRead;
        end
    end
endmodule

