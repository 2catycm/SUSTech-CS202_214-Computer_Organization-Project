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

module PianoDriver (
     input iFpgaClock, iCpuClock        // 时钟信号
    ,input iCpuReset 		            // 复位信号
    ,input iDoPianoWrite,iDoIOWrite		      	// 从memorio来的LED片选信号   !!!!!!!!!!!!!!
    ,input[7:0] iPianoDataToWrite	  	// 写到Piano模块的数据，注意一次指令只需要8比特。
    ,output oFpgaSpeaker		        // 向板子上输出的蜂鸣器信号
);
    reg [7:0] currentPianoCommand;

    always@(posedge iCpuClock or posedge iCpuReset) begin
        if(iCpuReset) begin
            currentPianoCommand <= 8'b0;
        end
		else if(iDoIOWrite && iDoPianoWrite) begin
			currentPianoCommand<=iPianoDataToWrite;
        end
    end

    wire [5:0] track0, track1, track2, track3;
    TrackManager tm(
        iFpgaClock, iCpuReset, currentPianoCommand,
            track0, track1, track2, track3);
    SongDriver   sd(
        iFpgaClock, iCpuReset, 
        track0, track1, track2, track3, 
        oFpgaSpeaker);
endmodule //PianoDriver