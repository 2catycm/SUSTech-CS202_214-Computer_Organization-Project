`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Southern University of Science and Technology 南方科技大学
// Engineer: 张力宇, 叶璨铭
// 
// Create Date: 2022/05/07 12:58:45
// Module Name: CPU_TOP
// Project Name: MIPS Single Cycle CPU
// Target Devices: Xilinx Board. Tested on MINISYS.
// Description: 
// 
//////////////////////////////////////////////////////////////////////////////////
module TOP_all(
input[23:0]Minisys_Switches, output[23:0]Minisys_Lights, input Minisys_Clock, 
input[4:0] Minisys_Button,
input Minisys_Uart_fromPC, output Minisys_Uart_toPC
);

CPUTOP top_instance(
.switch2N4(Minisys_Switches),
.led2N4(Minisys_Lights),
.fpga_clk(Minisys_Clock),
.start_pg(Minisys_Button[4]),
.fpga_rst(Minisys_Button[3]),
.rx( Minisys_Uart_fromPC),
.tx( Minisys_Uart_toPC)
);
endmodule
