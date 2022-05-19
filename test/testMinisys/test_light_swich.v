`timescale 1ns / 1ps
module lab1_sw_led_24_sim( );
//input
reg [23:0] sw=24'h000000;
//output
wire [23:0] led;
//instantiate the unit 
lab1_sw_led_24 usrc1(
sw,led
);

always #10 sw=sw+1;
endmodule