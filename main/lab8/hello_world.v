module SetBit(
    input [15:0] switches,
    output [15:0] lights
    // ,
    // c
);
    wire [15:0] lights; //optional restatement of input output. 
    wire [15:0] middle;
    // input c;
    assign middle = switches;
    assign lights = middle;
endmodule