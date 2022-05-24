module lab1_sw_led_24(
    input [23:0] Minisys_Switches,
    output [23:0] Minisys_Lights
    );
    assign Minisys_Lights=Minisys_Switches;
endmodule