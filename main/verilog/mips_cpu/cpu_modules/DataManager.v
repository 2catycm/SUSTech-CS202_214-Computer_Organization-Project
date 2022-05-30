`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Southern University of Science and Technology ÄÏ·½¿Æ¼¼´óÑ§
// Engineer: ÕÅÁ¦Óî£¬Ò¶è²Ãú
// 
// Create Date: 2022/05/07 12:58:45
// Project Name: MIPS Single Cycle CPU
// Target Devices: Xilinx Board. Tested on MINISYS.
// Description: 
// 
//////////////////////////////////////////////////////////////////////////////////

module DataManager(
    // 0.controller commands
    input iDoMemoryRead, iDoMemoryWrite // read or write memory, from Controller
    ,input iDoSwitchRead // read IO, from Controller
    ,input iDoLedWrite, iDoTubeWrite // write IO, from Controller
    // 1.address for memory access
    ,input[31:0] iAluResultAsAddress // from alu_result in ALU
    ,output[31:0] oDataMemoryAddress // address to Data-Memory
    // 2.load word: given data sources, gives out the correct data read.
    ,input[31:0] iDataFromMemory // data read from Data-Memory
    // todo: can extend here: more io data source. (input device)
    ,input[15:0] iSwitchDataRead // data read from IO, need to decide.
    ,output[31:0] oMemOrIODataRead // data to Decoder(register file)
    // 3.store word: give the map from register data to memory and io
    ,input[31:0] iDataFromRegister // data read from Decoder(register file)
    ,output[15:0] oDataToStore // data to memory
    ,output[15:0] oLightDataToWrite // data to light
    ,output[15:0] oTubeDataToWrite // data to tube
);
    //0.internal control signals
    //ï¿½ï¿½ï¿½ï¿½
    wire doIoRead = iDoSwitchRead;
    wire doIoWrite = iDoLedWrite || iDoTubeWrite;

    // 1.address for memory access
    assign oDataMemoryAddress= iAluResultAsAddress;

    // 2.load word
    //ï¿½ï¿½io ï¿½ï¿½ï¿½ï¿½Ä´ï¿½ï¿½ï¿?
    wire dataFromIo = iSwitchDataRead; // currently we only have this.
    assign oMemOrIODataRead = iDoMemoryRead? iDataFromMemory:{{16'b0},dataFromIo};

    // 3. store word
    //ï¿½ï¿½io ï¿½ï¿½ï¿½ï¿½Ä´ï¿½ï¿½ï¿?
    reg[31:0] dataToStore;
    assign oDataToStore = dataToStore;  // tell memory to write this.
    assign oLightDataToWrite = dataToStore[15:0];
    assign oTubeDataToWrite  = dataToStore[15:0];  //whether write this device or not, the data is there.
    always @* begin
        if((iDoMemoryWrite==1)||(iDoIoWrite==1))
            //wirte_data could go to either memory or IO. where is it from?
            dataToStore = iDataFromRegister;
        else
            dataToStore = 32'hZZZZZZZZ;
    end
endmodule
