`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Southern University of Science and Technology 南方科技大学
// Engineer: 张力宇
// 
// Create Date: 2022/05/07 12:58:45
// Module Name: CPU_TOP
// Project Name: MIPS Single Cycle CPU
// Target Devices: Xilinx Board. Tested on MINISYS.
// Description: 
// 
//////////////////////////////////////////////////////////////////////////////////

module SwitchDriver(iCpuClock, iCpuReset, switchread, iDoSwitchRead,iSwirchAddress, iSwitchDataRead, iFpgaSwitches);
    input iCpuClock;			        //  时钟信号
    input iCpuReset;			        //  复位信号
    input iDoSwitchRead;			        //  从memorio来的switch片  !!!!!!!!!!
    input[1:0] iSwirchAddress;		    //  到switch模块的地??低端  !!!!!!!!!!!!!!!
    output [15:0] iSwitchDataRead;	    //  送到CPU的拨码开关???注意数据???线只有16??
    input [23:0] iFpgaSwitches;		    //  从板上读的24位数

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

