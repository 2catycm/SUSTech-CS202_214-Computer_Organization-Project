`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Southern University of Science and Technology 南方科技大学
// Engineer: 叶璨�?
// 
// Create Date: 2022/05/07 12:58:45
// Project Name: MIPS Single Cycle CPU
// Target Devices: Xilinx Board. Tested on MINISYS.
// Description: 
// 
//////////////////////////////////////////////////////////////////////////////////
module TrackManager (
    input iFpgaClock, iFpgaReset 
    ,input[7:0] iPianoCommand 
    ,output reg [5:0] track0 
    ,output reg [5:0] track1 
    ,output reg [5:0] track2 
    ,output reg [5:0] track3
);
    always @(posedge iFpgaClock or posedge iFpgaReset) begin 
        if (iFpgaReset) begin
            track0 <= 0;
            track1 <= 0;
            track2 <= 0;
            track3 <= 0;
        end else
        case (iPianoCommand[7:6])
            0: track0 <= iPianoCommand[5:0];
            1: track1 <= iPianoCommand[5:0];
            2: track2 <= iPianoCommand[5:0];
            3: track3 <= iPianoCommand[5:0];
        endcase
    end
endmodule //TrackManager