`timescale 1ns / 1ps
module TestNewSituation1(
    );
reg[23:0]Minisys_Switches;
wire [23:0]Minisys_Lights; 
reg Minisys_Clock; 
reg[4:0] Minisys_Button;
always begin 
    #1 Minisys_Clock = ~Minisys_Clock;//������ⲿ��clock
end

ComputerTop  use_main(Minisys_Switches,Minisys_Lights,Minisys_Clock,Minisys_Button);

initial begin
    Minisys_Clock = 1'b0;
    Minisys_Button = 5'b00000;
    Minisys_Switches[23:0] = 24'h0;
    # 100 Minisys_Button = 5'b01000;
    # 50   Minisys_Button = 5'b00000;
    #4000 
    // ��ʱ������ ������ЧԲ�������ˡ�
    
    // ����case 000.  
    Minisys_Switches[23:0] = 24'h1; // a��ֵ
    #10000
    Minisys_Switches[20] =1;  // enter��ֵ
    #10000
    // assert: �����ұߵĵ���ʾ1. ��ߵĵ���ʾenter���ڵȴ����¡���ʾcase0�� ��ʾ
    Minisys_Switches[20] =0; // ���½���case 0�� ������Ҫ����������
    #10000
    Minisys_Switches[20] =1; //�ٴ�����1.
    #100003
    Minisys_Switches[20] =1; //��ʱ�ҵ�Ӧ����1
end
    
endmodule
