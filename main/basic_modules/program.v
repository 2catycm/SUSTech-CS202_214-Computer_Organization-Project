`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/05/10 01:36:24
// Design Name: 
// Module Name: programrom
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module programrom (
// Program ROM Pinouts
input rom_clk_i, // ROM clock
input[13:0] rom_adr_i, // From IFetch
output [31:0] Instruction_o, // To IFetch
// UART Programmer Pinouts
input upg_rst_i, // UPG reset (Active High)
input upg_clk_i, // UPG clock (10MHz)
input upg_wen_i, // UPG write enable
input[13:0] upg_adr_i, // UPG write address
input[31:0] upg_dat_i, // UPG write data
input upg_done_i // 1 if program finished
);
/* if kickOff is 1 means CPU work on normal mode, otherwise CPU work on Uart communication mode */
wire kickOff = upg_rst_i | (~upg_rst_i & upg_done_i );
prgrom instmem (
.clka (kickOff ? rom_clk_i : upg_clk_i ),
.wea (kickOff ? 1'b0 : upg_wen_i ),
.addra (kickOff ? rom_adr_i : upg_adr_i ),
.dina (kickOff ? 32'h00000000 : upg_dat_i ),
.douta (Instruction_o)
);
endmodule
