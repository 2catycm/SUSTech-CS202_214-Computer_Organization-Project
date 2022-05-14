`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/04/20 10:55:52
// Design Name: 
// Module Name: dmemory32
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module dmemory32(clock,memWrite,address,writeData,readData );

    input clock, memWrite;  //memWrite 来自controller，为1'b1时表示要对data-memory做写操作

    input [31:0] address;   //address 以字节为单位

    input [31:0] writeData; //writeData ：向data-memory中写入的数据

    output[31:0] readData;  //writeData ：从data-memory中读出的数据
wire clk;
assign clk = !clock;

RAM ram (
.clka(clk), // input wire clka
.wea(memWrite), // input wire [0 : 0] wea
.addra(address[15:2]), // input wire [13 : 0] addra
.dina(writeData), // input wire [31 : 0] dina
.douta(readData) // output wire [31 : 0] douta
);

endmodule
