`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Southern University of Science and Technology ??????
// Engineer: ???
// 
// Create Date: 2022/05/07 12:58:45
// Module Name: CPU_TOP
// Project Name: MIPS Single Cycle CPU
// Target Devices: Xilinx Board. Tested on MINISYS.
// Description: 
// 
//////////////////////////////////////////////////////////////////////////////////

module MemOrIO( mRead, mWrite, ioRead, ioWrite,addr_in, addr_out, m_rdata, io_rdata, r_wdata, r_rdata, write_data, LEDCtrl, SwitchCtrl);
input mRead; // read memory, from Controller
input mWrite; // write memory, from Controller
input ioRead; // read IO, from Controller
input ioWrite; // write IO, from Controller
input[31:0] addr_in; // from alu_result in ALU
output[31:0] addr_out; // address to Data-Memory
input[31:0] m_rdata; // data read from Data-Memory
input[15:0] io_rdata; // data read from IO,16 bits
output[31:0] r_wdata; // data to Decoder(register file)
input[31:0] r_rdata; // data read from Decoder(register file)
output reg[31:0] write_data; // data to memory or I/O£¨m_wdata, io_wdata£©
output LEDCtrl; // LED Chip Select
output SwitchCtrl; // Switch Chip Select
assign addr_out= addr_in;
// The data wirte to register file may be from memory or io. 
// While the data is from io, it should be the lower 16bit of r_wdata. 
assign r_wdata = (mRead == 1)? m_rdata:{{16{io_rdata[15]}},io_rdata};
// Chip select signal of Led and Switch are all active high;
 assign LEDCtrl = (ioWrite == 1'b1) ? 1'b1 : 1'b0;
  assign SwitchCtrl = (ioRead == 1'b1) ? 1'b1 : 1'b0;
always @* begin
if((mWrite==1)||(ioWrite==1))
//wirte_data could go to either memory or IO. where is it from?
write_data = r_rdata;
else
write_data = 32'hZZZZZZZZ;
end
endmodule
