`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Southern University of Science and Technology �Ϸ��Ƽ���ѧ
// Engineer: Ҷ���
// 
// Create Date: 2022/05/07 12:58:45
// Project Name: MIPS Single Cycle CPU
// Target Devices: Xilinx Board. Tested on MINISYS.
// Description: 
// 
//////////////////////////////////////////////////////////////////////////////////

module PianoDriver (
     input iFpgaClock, iCpuClock        // ʱ���ź�
    ,input iCpuReset 		            // ��λ�ź�
    ,input iDoPianoWrite,iDoIOWrite		      	// ��memorio����LEDƬѡ�ź�   !!!!!!!!!!!!!!
    ,input[7:0] iPianoDataToWrite	  	// д��Pianoģ������ݣ�ע��һ��ָ��ֻ��Ҫ8���ء�
    ,output oFpgaSpeaker		        // �����������ķ������ź�
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