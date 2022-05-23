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

module Switch(switclk, switchrst, switchread, switchctl,switchaddr, switchrdata, switch_input);
    input switclk;			        //  ʱ���ź�
    input switchrst;			        //  ��λ�ź�
    input switchctl;			        //  ��memorio����switchƬ  !!!!!!!!!!
    input[1:0] switchaddr;		    //  ��switchģ��ĵ�??�Ͷ�  !!!!!!!!!!!!!!!
    input switchread;			    //  controller ����
    output [15:0] switchrdata;	    //  �͵�CPU�Ĳ��뿪��???ע������???��ֻ��16??
    input [23:0] switch_input;		    //  �Ӱ��϶���24λ��

    reg [15:0] switchrdata;
    always@(negedge switclk or posedge switchrst) begin
        if(switchrst) begin
            switchrdata <= 0;
        end
		else if(switchctl && switchread) begin
			if(switchaddr==2'b00)
				switchrdata[15:0] <= switch_input[15:0];   // data output,lower 16 bits non-extended
			else if(switchaddr==2'b10)
				switchrdata[15:0] <= { 8'h00, switch_input[23:16] }; //data output, upper 8 bits extended with zero
			else 
				switchrdata <= switchrdata;
        end
		else begin
            switchrdata <= switchrdata;
        end
    end
endmodule

