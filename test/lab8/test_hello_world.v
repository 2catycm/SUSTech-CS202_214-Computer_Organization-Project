`timescale 1ns/100ps
module test_hello_world(); //也可以没括号
    parameter DELAY = 10;
    reg [15:0] switches = 0;
    wire [15:0] lights;
    SetBit set_bit(switches, lights);
    initial begin
        #DELAY switches = 16'hFE24;
        if (lights!=switches) begin
            $display("Assertian failed. ");
        end
        else begin
            $display("Test passed. ");
        end
        #1000 $finish;
    end
    always #DELAY switches+=1;
    //iverilog 专用
    initial begin
        $dumpfile("hello_wave.vcd");
        $dumpvars(0, test_hello_world);
    end
endmodule //test_hello_world