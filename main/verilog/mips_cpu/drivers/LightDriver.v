`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Southern University of Science and Technology 南方科技大学
// Engineer: 张力宇
// 
// Create Date: 2022/05/07 12:58:45
// Module Name: LightDriver
// Project Name: MIPS Single Cycle CPU
// Target Devices: Xilinx Board. Tested on MINISYS.
// Description: 
// 
//////////////////////////////////////////////////////////////////////////////////

module LightDriver(iCpuClock, iCpuReset, iDoIOWrite, iDoLedWrite, iLightAddress,iLightDataToWrite, oFpgaLights);
    input iCpuClock;    		    // 时钟信号
    input iCpuReset; 		        // 复位信号
    input iDoIOWrite;		       	// 写信号
    input iDoLedWrite;		      	// 从memorio来的LED片选信号   !!!!!!!!!!!!!!
    input[1:0] iLightAddress;	        // 到LED模块的地址低端  !!!!!!!!!!!!!!!!!!!!
    input[15:0] iLightDataToWrite;	  	// 写到LED模块的数据，注意数据线只有16根
    output reg [23:0] oFpgaLights;		// 向板子上输出的24位LED信号
  
    
    always@(posedge iCpuClock or posedge iCpuReset) begin
        if(iCpuReset) begin
            oFpgaLights <= 24'h000000;
        end
		else if(iDoLedWrite && iDoIOWrite) begin
			if(iLightAddress == 2'b00)
				oFpgaLights[15:0] <=  iLightDataToWrite[15:0];
			else if(iLightAddress == 2'b10 )
				oFpgaLights[23:16] <= iLightDataToWrite[7:0];
			else
				oFpgaLights <= oFpgaLights;
        end
		else begin
            oFpgaLights <= oFpgaLights;
        end
    end
endmodule
