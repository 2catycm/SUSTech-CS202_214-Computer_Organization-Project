module ClockDecelerator #(parameter frequency = 500)(
    input clock,
    input reset,//应该像名字一样指示功能，而不是搞什么逻辑反转
    output reg clock_delayed
);
    reg[31:0] count;
    always @(posedge clock or posedge reset) begin
        if (reset) begin
            count<=0;
            clock_delayed = 0;
        end
        else begin
            if(count == ((10000_0000 / frequency)>>1)-1)begin
                clock_delayed = ~clock_delayed;
                count<=0;
            end
            else
                count<=count+1;
        end
    end
endmodule