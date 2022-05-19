`timescale 1ns / 1ps
module TOP_all(
input[23:0]Minisys_Switches, output[23:0]Minisys_Lights, input Minisys_Clock, input[4:0] Minisys_Button
);
CPUTOP top_instance(
.switch_topin(Minisys_Switches),
.led_topout(Minisys_Lights),
.cpu_clk(Minisys_Clock),
.reset(Minisys_Button[4])
);
endmodule