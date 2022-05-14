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

    input clock, memWrite;  //memWrite ����controller��Ϊ1'b1ʱ��ʾҪ��data-memory��д����

    input [31:0] address;   //address ���ֽ�Ϊ��λ

    input [31:0] writeData; //writeData ����data-memory��д�������

    output[31:0] readData;  //writeData ����data-memory�ж���������
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
