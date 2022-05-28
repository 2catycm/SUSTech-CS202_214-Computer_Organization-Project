`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Southern University of Science and Technology 南方科技大学
// Engineer: 张力宇，叶璨铭
// 
// Create Date: 2022/05/07 12:58:45
// Module Name: MemOrIO
// Project Name: MIPS Single Cycle CPU
// Target Devices: Xilinx Board. Tested on MINISYS.
// Description: 
// 
//////////////////////////////////////////////////////////////////////////////////

module MemOrIO(
    input iDoMemoryRead, // read memory, from Controller
    input iDoMemoryWrite, // write memory, from Controller
    input iDoIoRead, // read IO, from Controller
    input iDoIoWrite, // write IO, from Controller
    // address
    input[31:0] iAluResultAsAddress, // from alu_result in ALU
    output[31:0] oDataMemoryAddress, // address to Data-Memory
    // load word
    input[31:0] iDataFromMemory, // data read from Data-Memory
    input[15:0] iDataFromIo, // data read from IO,16 bits
    output[31:0] oMemOrIODataRead, // data to Decoder(register file)
    // store word
    input[31:0] iDataFromRegister, // data read from Decoder(register file)
    output reg[31:0] iDataToStore, // data to memory or I/O（m_wdata, io_wdata）
    // what to do with led and switch
    output LEDCtrl, // LED Chip Select
    output SwitchCtrl // Switch Chip Select
);
    assign oDataMemoryAddress= iAluResultAsAddress;
    // The data wirte to register file may be from memory or io. 
    // While the data is from io, it should be the lower 16bit of oMemOrIODataRead. 
    assign oMemOrIODataRead = (iDoMemoryRead == 1)? iDataFromMemory:{{16{iDataFromIo[15]}},iDataFromIo};
    // Chip select signal of Led and Switch are all active high;
    assign LEDCtrl = (iDoIoWrite == 1'b1) ? 1'b1 : 1'b0;
    assign SwitchCtrl = (iDoIoRead == 1'b1) ? 1'b1 : 1'b0;

    always @* begin
        if((iDoMemoryWrite==1)||(iDoIoWrite==1))
            //wirte_data could go to either memory or IO. where is it from?
            iDataToStore = iDataFromRegister;
        else
            iDataToStore = 32'hZZZZZZZZ;
    end
endmodule
