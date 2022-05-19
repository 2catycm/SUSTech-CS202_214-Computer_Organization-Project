`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/05/12 19:56:47
// Design Name: 
// Module Name: io_in
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: There are no description from yx.
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////

module Switch(switclk, switrst, switchread, switchcs,switchaddr, switchrdata, switch_i);
    input switclk;			        //  时钟信号
    input switrst;			        //  复位信号
    input switchcs;			        //  从memorio来的switch片�?�信�?  !!!!!!!!!!
    input[1:0] switchaddr;		    //  到switch模块的地�?低端  !!!!!!!!!!!!!!!
    input switchread;			    //  读信�?
    output [15:0] switchrdata;	    //  送到CPU的拨码开关�?�注意数据�?�线只有16�?
    input [23:0] switch_i;		    //  从板上读�?24位开关数�?

    reg [15:0] switchrdata;
    always@(negedge switclk or posedge switrst) begin
        if(switrst) begin
            switchrdata <= 0;
        end
		else if(switchcs && switchread) begin
			if(switchaddr==2'b00)
				switchrdata[15:0] <= switch_i[15:0];   // data output,lower 16 bits non-extended
			else if(switchaddr==2'b10)
				switchrdata[15:0] <= { 8'h00, switch_i[23:16] }; //data output, upper 8 bits extended with zero
			else 
				switchrdata <= switchrdata;
        end
		else begin
            switchrdata <= switchrdata;
        end
    end
endmodule

