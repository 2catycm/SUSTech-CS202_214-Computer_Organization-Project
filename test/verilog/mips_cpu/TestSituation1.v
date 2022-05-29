`timescale 1ns / 1ps
module TestSituation1(
    );
reg[23:0]Minisys_Switches;
wire [23:0]Minisys_Lights; 
reg Minisys_Clock; 
reg[4:0] Minisys_Button;
    TopAll  use_main(Minisys_Switches,Minisys_Lights,Minisys_Clock,Minisys_Button);
    initial begin
    Minisys_Clock = 1'b0;
     Minisys_Button = 5'b00000;
     # 100 Minisys_Button = 5'b01000;
  # 50   Minisys_Button = 5'b00000;
Minisys_Switches[23:0] = 24'h000000;
 #100 Minisys_Switches[21] =1; 
# 10000 Minisys_Switches[1:0] = 2'b11;
# 10000 Minisys_Switches[16] =1;
# 10000 Minisys_Switches[18] =1;
#10000 Minisys_Switches[2:0] = 3'b101;
# 10000 Minisys_Switches[17] =1;
#10000 Minisys_Switches[23:21] = 3'b010;
    end
    
    
    
    
    //module TOP_all_test(

//    );
//reg[23:0]Minisys_Switches;
//wire [23:0]Minisys_Lights; 
//reg Minisys_Clock; 
//reg Minisys_Button;
//    CPUTOP  use_main(Minisys_Switches,Minisys_Lights,Minisys_Clock,Minisys_Button);
 
//    initial begin
//Minisys_Switches = 24'b0;
//Minisys_Clock = 1'b0;
//Minisys_Button = 1'b1;
//# 5 Minisys_Button = 1'b0;

////# 20 Minisys_Switches[23] =1;
//# 20 Minisys_Switches[15] =1;
//# 100 Minisys_Switches[15] =0;
//# 20 Minisys_Switches[23] =1;
//    end
//    always begin

    
//   #100000 $finish;
//    end
    always begin 
#5 Minisys_Clock = ~Minisys_Clock;//这个是外部的clock
    end
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
    
endmodule
