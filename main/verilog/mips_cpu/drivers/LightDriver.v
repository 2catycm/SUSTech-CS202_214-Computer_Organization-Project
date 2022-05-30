`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Southern University of Science and Technology �Ϸ��Ƽ���ѧ
// Engineer: ������
// 
// Create Date: 2022/05/07 12:58:45
// Module Name: LightDriver
// Project Name: MIPS Single Cycle CPU
// Target Devices: Xilinx Board. Tested on MINISYS.
// Description: 
// 
//////////////////////////////////////////////////////////////////////////////////

module LightDriver(iCpuClock, iCpuReset, iDoIOWrite, iDoLedWrite, iLightAddress,iLightDataToWrite, oFpgaLights);
    input iCpuClock;    		    // ʱ���ź�
    input iCpuReset; 		        // ��λ�ź�
    input iDoLedWrite;		      	// ��memorio����LEDƬѡ�ź�   !!!!!!!!!!!!!!
    input[1:0] iLightAddress;	        // ��LEDģ��ĵ�ַ�Ͷ�  !!!!!!!!!!!!!!!!!!!!
    input[15:0] iLightDataToWrite;	  	// д��LEDģ������ݣ�ע��������ֻ��16��
    output reg [23:0] oFpgaLights;		// ������������24λLED�ź�
  
    
    always@(posedge iCpuClock or posedge iCpuReset) begin
        if(iCpuReset) begin
            oFpgaLights <= 24'h000000;
        end
		else if(iDoLedWrite) begin
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
