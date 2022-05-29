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

module SwitchDriver(switclk, switchrst, switchread, switchctl,switchaddr, switchrdata, switch_input);
    input switclk;			        //  时钟信号
    input switchrst;			        //  复位信号
    input switchctl;			        //  从memorio来的switch片  !!!!!!!!!!
    input[1:0] switchaddr;		    //  到switch模块的地??低端  !!!!!!!!!!!!!!!
    input switchread;			    //  controller 来的
    output [15:0] switchrdata;	    //  送到CPU的拨码开关???注意数据???线只有16??
    input [23:0] switch_input;		    //  从板上读的24位数

    reg [15:0] switchrdata;
    always@(negedge switclk or posedge switchrst) begin
        if(switchrst) begin
            switchrdata <= 0;
        end
		else if(switchctl && switchread) begin
			if(switchaddr==2'b00)
				switchrdata[15:0] <= switch_input[15:0];   // data output,lower 16 bits non-extended
			else if(switchaddr==2'b10)
				switchrdata[15:0] <= { 8'h00, switch_input[23:16] }; //data output, upper 8 bits extended with zero
			else 
				switchrdata <= switchrdata;
        end
		else begin
            switchrdata <= switchrdata;
        end
    end
endmodule

