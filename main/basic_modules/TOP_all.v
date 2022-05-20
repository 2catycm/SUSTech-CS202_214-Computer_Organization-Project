`timescale 1ns / 1ps
module TOP_all(
input[23:0]Minisys_Switches, output[23:0]Minisys_Lights, input Minisys_Clock, input[4:0] Minisys_Button
);
wire clk_temp;
CPUTOP top_instance(
.switch_topin(Minisys_Switches),
.led_topout(Minisys_Lights),
.cpu_clk(clk_temp),
.reset(Minisys_Button[4])
);
clk_wiz_0 clk23(
.clk_in1(Minisys_Clock),
.clk_out1(clk_temp)
);
endmodule
