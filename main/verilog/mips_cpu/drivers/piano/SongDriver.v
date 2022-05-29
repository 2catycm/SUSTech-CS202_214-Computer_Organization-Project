`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Southern University of Science and Technology 南方科技大学
// Engineer: 叶璨铭
// 
// Create Date: 2022/05/07 12:58:45
// Project Name: MIPS Single Cycle CPU
// Target Devices: Xilinx Board. Tested on MINISYS.
// Description: 
// 
//////////////////////////////////////////////////////////////////////////////////
module SongDriver(
	input iFpgaClock, iFpgaReset,	//注意这个reset是高有效，我写的, 需要一个手动复位按钮 //输入时钟100MHz，管脚绑定P17
    input[5:0] track0,
    input[5:0] track1,
    input[5:0] track2, 
    input[5:0] track3, 
	output speaker							//输出至扬声器的信号，本例中为方波. 
);
	wire clk_6mhz;									//用于产生各种音阶频率的基准频率
	ClockDivider  #(8)  u1(
						iFpgaClock,iFpgaReset,
						clk_6mhz		//6.25MHz时钟信号
						);
	
	wire clk_16hz;									//用于控制音长（节拍）的时钟频率
	ClockDecelerator  #(64)	u2(
								iFpgaClock,iFpgaReset,
								clk_16hz	//得到16Hz时钟信号
								);
								//先用4做个测试
								
	// 
	wire [5:0] current_track;
	assign current_track = track0;

	one_track_player otp(clk_6mhz,clk_16hz,iFpgaReset,current_track,speaker);
	// four_track_player ftp(clk_6mhz,clk_16hz,iFpgaReset,track0,track1,track2,track3,speaker);
	
endmodule //SongDriver
