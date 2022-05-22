`timescale 1ns / 1ps
module TOP_all(
input[23:0]Minisys_Switches, output[23:0]Minisys_Lights, input Minisys_Clock, 
input[4:0] Minisys_Button,
input EGO1_Uart_fromPC, output EGO1_Uart_toPC
);

CPUTOP top_instance(
.switch2N4(Minisys_Switches),
.led2N4(Minisys_Lights),
.fpga_clk(Minisys_Clock),
.start_pg(Minisys_Button[4]),
.fpga_rst(Minisys_Button[3]),
.rx( EGO1_Uart_fromPC),
.tx( EGO1_Uart_toPC)
);
endmodule
