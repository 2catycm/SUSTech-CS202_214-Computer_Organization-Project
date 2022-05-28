`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Southern University of Science and Technology 南方科技大学
// Engineer: 张力宇, 叶璨铭
// 
// Create Date: 2022/05/07 12:58:45
// Project Name: MIPS Single Cycle CPU
// Target Devices: Xilinx Board. Tested on MINISYS.
// Description: 
// 
//////////////////////////////////////////////////////////////////////////////////
module TubeDriver (
    input iFpgaClock, iCpuClock 
    ,input iCpuReset

    ,input iDoTubeWrite
    ,input[1:0] iTubeAddress      //2表示左边四个，0表示右边四个
    ,input[15:0] iTubeDataToWrite

    ,output wire [7:0] oDigitalTubeNotEnable
    ,output wire [7:0] oDigitalTubeShape
);
    reg [15:0] left;
    reg [15:0] right;
    DigitalTube tube(iFpgaClock, iCpuReset, iDoTubeWrite, 
    oDigitalTubeNotEnable,oDigitalTubeShape,
    {left, right});
    always@(posedge iCpuClock or posedge iCpuReset) begin
        if(iCpuReset) begin
            left <= 15'b0;
            right <= 15'b0;
        end
		else if(iDoLedWrite) begin
			if(iTubeAddress == 2'b00)
				right <= iTubeDataToWrite[15:0];
			else if(iTubeAddress == 2'b10 )
                left <= iTubeDataToWrite[15:0];
        end
    end

endmodule //TubeDriver

module DigitalTube(iFpgaClock, iCpuReset, iDoTubeWrite, oDigitalTubeNotEnable, oDigitalTubeShape, iTubeDataToWrite);
    input iFpgaClock, iCpuReset, iDoTubeWrite;
    output wire [7:0] oDigitalTubeNotEnable;
    output wire [7:0] oDigitalTubeShape;
    input [31:0] iTubeDataToWrite; // The input from the top module. Just like the led.

    reg [7:0] Dig_r; // The rnverse of Digital selection.
    reg [6:0] Y_r; // The reverse of Digital.
    wire rst;
    assign oDigitalTubeNotEnable = ~Dig_r;
    assign oDigitalTubeShape = {{1'b1},{~Y_r}}; //this is notenable,
    assign rst =~iCpuReset;//有效是1
    reg clk;
    reg [31:0] clk_cnt;
    reg [3:0] scanner_cnt;
    initial begin
        clk = 1'b0;
    end

    parameter half_period = 40000;//这个是换一个clock
    always @(posedge iFpgaClock or negedge rst) begin
        if (!rst)
            clk_cnt <= 0;
        else  begin  
            clk_cnt <= clk_cnt + 1;
            if (clk_cnt  == (half_period >> 1) - 1)               
                clk <= 1'b1;
            else if (clk_cnt == half_period - 1) begin 
                clk <= 1'b0;
                clk_cnt <= 32'h00000000;      
            end
        end
    end

    always @(posedge clk or negedge rst) begin 
        if (!rst) begin
            scanner_cnt <= 4'b0000;
        end
        else begin
            scanner_cnt <= scanner_cnt + 1'b1;    
            if(scanner_cnt == 4'd9)  begin
                scanner_cnt <= 4'b0000;
            end
        end 
    end
    //下面这2个描述就是和当年开发EGO1是一样的需要分时显示
    always @(scanner_cnt) begin
        if(iDoTubeWrite) begin
            case(scanner_cnt)
                4'b0001 : Dig_r <= 8'b0000_0001;    
                4'b0010 : Dig_r <= 8'b0000_0010;    
                4'b0011 : Dig_r <= 8'b0000_0100;    
                4'b0100 : Dig_r <= 8'b0000_1000;    
                4'b0101 : Dig_r <= 8'b0001_0000;    
                4'b0110 : Dig_r <= 8'b0010_0000;    
                4'b0111 : Dig_r <= 8'b0100_0000;     
                4'b1000 : Dig_r <= 8'b1000_0000;    
                default :Dig_r <= 8'b0000_0000;
            endcase
        end
    end
reg [3:0] which_trans;

    always @(scanner_cnt) begin
        case(scanner_cnt)
            4'b0001 : which_trans <= iTubeDataToWrite[3:0];    
            4'b0010 : which_trans <= iTubeDataToWrite[7:4];      
            4'b0011 : which_trans <= iTubeDataToWrite[11:8];     
            4'b0100 :which_trans <= iTubeDataToWrite[15:12];      
            4'b0101 : which_trans <= iTubeDataToWrite[19:16];  
            4'b0110 : which_trans <= iTubeDataToWrite[23:20];  
            4'b0111 : which_trans <= iTubeDataToWrite[27:24];  
            4'b1000 : which_trans <= iTubeDataToWrite[31:28];  
            default :which_trans  <= 8'b0000_0000;
        endcase
    end
    
    always @(which_trans) begin
    case(which_trans)//higher bit is gfdcba,高位dp
                     4'd0 : Y_r <=7'b0111111;
                    4'd1 : Y_r <= 7'b0000110;//1
                    4'd2 : Y_r <= 7'b1011011; // 2
                    4'd3 : Y_r <=  7'b1001111; // 3
                    4'd4 : Y_r <=  7'b1100110; // 4
                    4'd5 : Y_r <= 7'b1101101; // 5
                    4'd6 : Y_r <= 7'b1111101; // 6
                    4'd7 : Y_r <= 7'b0100111; // 7
                    4'd8 : Y_r <= 7'b1111111; // 8
                    4'd9 : Y_r <= 7'b1100111; // 9
                    4'd10: Y_r <= 7'b1110111; // A
                    4'd11: Y_r <= 7'b1111100; // B
                    4'd12: Y_r <= 7'b0111001; // C
                    4'd13:Y_r <= 7'b1011110; // D
                    4'd14: Y_r <= 7'b1111001; // E
                    4'd15: Y_r <= 7'b1110001; // F
                    default: Y_r <=7'b0000000;
    endcase
    end
endmodule

