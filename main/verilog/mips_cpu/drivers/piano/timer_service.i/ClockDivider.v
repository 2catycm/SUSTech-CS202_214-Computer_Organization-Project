module ClockDivider #(parameter dividedBy = 4)(
    input clock,
    input reset,//应该像名字一样指示功能，而不是搞�?么�?�辑反转
    output reg clock_divided
);
    reg[31:0] count;
    always @(posedge clock or posedge reset) begin
        if (reset) begin
            count<=0;
            clock_divided = 0;
        end
        else begin
            if(count == (dividedBy>>1)-1)begin
                clock_divided = ~clock_divided;
                count<=0;
            end
            else
                count<=count+1;
        end
    end
endmodule