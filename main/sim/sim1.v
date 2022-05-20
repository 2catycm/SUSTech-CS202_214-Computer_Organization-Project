`timescale 1ns / 1ps
module TOP_all_test(

    );
reg[23:0]Minisys_Switches;
wire [23:0]Minisys_Lights; 
reg Minisys_Clock; 
reg[4:0] Minisys_Button;
    TOP_all  use_main(Minisys_Switches,Minisys_Lights,Minisys_Clock,Minisys_Button);
    initial begin
    Minisys_Switches = 24'b0;
    Minisys_Clock = 1'b0;
    Minisys_Button[4:0] = 5'b11111;
    # 5 Minisys_Button[4:0] = 5'b00000;
    
    //# 20 Minisys_Switches[23] =1;
    # 20 Minisys_Switches[15] =1;
    # 100 Minisys_Switches[15] =0;
    # 20 Minisys_Switches[23] =1;
    
    # 20 Minisys_Switches[22] =1;
    
     # 20 Minisys_Switches[21] =1;
      # 20 Minisys_Switches[20] =1;
       # 20 Minisys_Switches[19] =1;
       
        # 20 Minisys_Switches[13] =1;
         # 20 Minisys_Switches[12] =1;
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
#1 Minisys_Clock = ~Minisys_Clock;
    end
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
    
endmodule
