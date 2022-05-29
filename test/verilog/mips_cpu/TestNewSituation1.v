`timescale 1ns / 1ps
module TestNewSituation1(
    );
reg[23:0]Minisys_Switches;
wire [23:0]Minisys_Lights; 
reg Minisys_Clock; 
reg[4:0] Minisys_Button;
always begin 
    #1 Minisys_Clock = ~Minisys_Clock;//这个是外部的clock
end

TopAll  use_main(Minisys_Switches,Minisys_Lights,Minisys_Clock,Minisys_Button);

initial begin
    Minisys_Clock = 1'b0;
    Minisys_Button = 5'b00000;
    Minisys_Switches[23:0] = 24'h0;
    # 100 Minisys_Button = 5'b01000;
    # 50   Minisys_Button = 5'b00000;
    #4000 
    // 此时理论上 开机特效圆满结束了。
    
    // 测试case 000.  
    Minisys_Switches[23:0] = 24'h1; // a的值
    #10000
    Minisys_Switches[20] =1;  // enter的值
    #10000
    // assert: 现在右边的灯显示1. 左边的灯显示enter正在等待放下。显示case0， 显示
    Minisys_Switches[20] =0; // 重新进入case 0， 理论上要求重新输入
    #10000
    Minisys_Switches[20] =1; //再次输入1.
    #100003
    Minisys_Switches[20] =1; //此时右灯应该是1
end
    
endmodule
