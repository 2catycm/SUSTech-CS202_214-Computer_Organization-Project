`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Southern University of Science and Technology 南方科技大学
// Engineer: 张力宇，叶璨铭
// 
// Create Date: 2022/05/07 12:58:45
// Project Name: MIPS Single Cycle CPU
// Target Devices: Xilinx Board. Tested on MINISYS.
// Description: 
// 
//////////////////////////////////////////////////////////////////////////////////

module DataManager(
    input iDoMemoryRead // read memory, from Controller
    ,input iDoMemoryWrite // write memory, from Controller
    ,input iDoIoRead // read IO, from Controller
    ,input iDoIoWrite // write IO, from Controller
    // address
    ,input[31:0] iAluResultAsAddress // from alu_result in ALU
    ,output[31:0] oDataMemoryAddress // address to Data-Memory
    // load word
    ,input[31:0] iDataFromMemory // data read from Data-Memory
    ,input[15:0] iDataFromIo // data read from IO,16 bits
    ,output[31:0] oMemOrIODataRead // data to Decoder(register file)
    // store word
    ,input[31:0] iDataFromRegister // data read from Decoder(register file)
    ,output reg[31:0] oDataToStore // data to memory or I/O（m_wdata, io_wdata）
);
    assign oDataMemoryAddress= iAluResultAsAddress;
    // The data wirte to register file may be from memory or io. 
    // While the data is from io, it should be the lower 16bit of oMemOrIODataRead. 
    assign oMemOrIODataRead = (iDoMemoryRead == 1)? iDataFromMemory:{{16'b0},iDataFromIo};
    

    always @* begin
        if((iDoMemoryWrite==1)||(iDoIoWrite==1))
            //wirte_data could go to either memory or IO. where is it from?
            oDataToStore = iDataFromRegister;
        else
            oDataToStore = 32'hZZZZZZZZ;
    end
endmodule
