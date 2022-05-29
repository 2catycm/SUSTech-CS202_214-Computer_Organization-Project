`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Southern University of Science and Technology 南方科技大学
// Engineer: 王睿， 叶璨铭
// 
// Create Date: 2022/05/07 12:58:45
// Module Name: InstructionMemory
// Project Name: MIPS Single Cycle CPU
// Target Devices: Xilinx Board. Tested on MINISYS.
// Description: 
// 
//////////////////////////////////////////////////////////////////////////////////

module InstructionMemory (
    // Program ROM Pinouts
    input iRomClock, // ROM clock
    input[13:0] iAddressRequested, // From IFetch
    output [31:0] oInstructionFetched, // To IFetch
    // UART Programmer Pinouts
    input iUpgReset, // UPG reset (Active High)
    input iUpgClock, // UPG clock (10MHz)
    input iDoUpgWrites, // UPG write enable
    input[13:0] iUpgWriteAddress, // UPG write address
    input[31:0] iUpgWriteData, // UPG write data
    input iIsUpgDone // 1 if program finished
);
    /* if kickOff is 1 means CPU work on normal mode, otherwise CPU work on Uart communication mode */
    wire kickOff = iUpgReset | (~iUpgReset & iIsUpgDone );
    prgrom instmem (
        .clka (kickOff ? iRomClock : iUpgClock ),
        .wea (kickOff ? 1'b0 : iDoUpgWrites ),
        .addra (kickOff ? iAddressRequested : iUpgWriteAddress ),
        .dina (kickOff ? 32'h00000000 : iUpgWriteData ),
        .douta (oInstructionFetched)
    );
endmodule
