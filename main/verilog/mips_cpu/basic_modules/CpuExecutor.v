`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Southern University of Science and Technology 南方科技大学
// Engineer: 张力宇
// 
// Create Date: 2022/05/07 12:58:45
// Module Name: CPU_TOP
// Project Name: MIPS Single Cycle CPU
// Target Devices: Xilinx Board. Tested on MINISYS.
// Description: 
// 
//////////////////////////////////////////////////////////////////////////////////

module CpuExecutor(
    input[31:0] Read_data_1,//the source of Ainput
    input[31:0] Read_data_2,//one of the sources of Binput
    input[31:0] Sign_extend,//one of the sources of Binputllinstruction[31:26]
    // from lFetch
    input[5:0] Function_opcode,//instructions[5:0]
    input[5:0]Exe_opcode,
    input[1:0]ALUOp,//{(R_format || l_format), (Branch|| nBranch)}
    input[4:0]Shamt,//instruction[10:6], the amount of shift bits
    input Sftmd,	// means this is a shift instruction
    input ALUSrc,//means the 2nd operand is an immediate (except beq,bne)
        //means l-Type instruction except beq, bne, LW,sw
    input I_format,
    input Jr,
    output Zero,//这个也是计算是否需要跳转
    output [31:0] ALU_Result,
    output [31:0]Addr_Result,//This means that upper right output,这个是instruction的addr
    input[31:0] PC_plus_4//pc+4
);
    wire[31:0]Ainput,Binput;
    assign Ainput = Read_data_1;
    assign Binput = (ALUSrc == 0) ? Read_data_2 : Sign_extend[31:0];

    wire[2:0] ALU_ctL;
    wire[5:0] Exe_code;
    assign Exe_code = ( I_format==0) ? Function_opcode : { 3'b000 , Exe_opcode[2:0] };

    assign ALU_ctL[0] = (Exe_code[0] | Exe_code[3]) & ALUOp[1]; 
    assign ALU_ctL[1] = ((!Exe_code[2]) | (!ALUOp[1])); 
    assign ALU_ctL[2] = (Exe_code[1] & ALUOp[1]) | ALUOp[0];
    reg [31:0] reg_ALU_Result;
    reg [31:0] ALU_output_mux;
    assign ALU_Result = reg_ALU_Result;
    assign Addr_Result = (Sign_extend << 2)+PC_plus_4;
    
    always @(ALU_ctL or Ainput or Binput)
    begin
         case (ALU_ctL)
            3'b000:ALU_output_mux =Ainput & Binput ;
            3'b001:ALU_output_mux =Ainput | Binput ;
            3'b010:ALU_output_mux =$signed(Ainput) + $signed(Binput);
            3'b011: ALU_output_mux = Ainput + Binput ;
            3'b100: ALU_output_mux = Ainput ^ Binput;
            3'b101:ALU_output_mux = ~(Ainput | Binput);//nor
            3'b110:ALU_output_mux = $signed(Ainput) - $signed(Binput);//sub,beq,bne都是一个因为
            3'b111:ALU_output_mux = Ainput-Binput;//subu
    default:ALU_output_mux = 32'h00000000;
    endcase
    end
    //////////////////////////////
    wire[2:0] Sftm; 
    assign Sftm = Function_opcode[2:0]; //the code of shift operations
    reg[31:0] Shift_Result; //the result of shift operation
    always @* begin// six types of shift instructions	
    if(Sftmd)	
        case(Sftm[2:0])	
            3'b000:Shift_Result =Binput<<Shamt;	//Sll rd,rt,shamt 00000
            3'b010:Shift_Result = Binput >> Shamt;	//Srl rd,rt,shamt 00010
            3'b100:Shift_Result = Binput<<Ainput;	//Sllv rd,rt,rs 000100
            3'b110:Shift_Result = Binput >>Ainput;	//Srlv rd,rt,rs 000110
            3'b011:Shift_Result = $signed(Binput) >>>Shamt;	//Sra rd,rt,shamt 00011  这个有可能有sign
            3'b111:Shift_Result =$signed(Binput) >>>Ainput;	//Srav rd,rt,rs 00111
            default:Shift_Result= Binput;
            endcase
    else
            Shift_Result = Binput;
    end	
//////////////////////////////////////////////////////////////////////
    always @* begin 
    //set type operation (slt, slti, sltu, sltiu)
    if(((ALU_ctL==3'b111) && (Exe_code[3]==1)) || (I_format==1 && ALU_ctL[2:1]==2'b11))
    reg_ALU_Result[31:0] = (Exe_code[2:0] == 3'b011) ? Ainput < Binput : $signed(Ainput) < $signed(Binput);
    //    if((ALU_ctL==3'b111) && (Exe_code[0]==1)) begin 
    //        reg_ALU_Result =  (Ainput< Binput) ? 32'd1 : 32'd0; 
    //    end
    //    else if((ALU_ctL ==3'b111 && Exe_code[3:0]==4'b1010)||(ALU_ctL ==3'b110 && Exe_code[3:0]==4'b0010))begin
    //        reg_ALU_Result =  ($signed(Ainput) < $signed(Binput)) ? 32'd1 : 32'd0;
    //    end
        //lui operation 
        else if((ALU_ctL==3'b101) && (I_format==1)) begin 
            reg_ALU_Result[31:0]={Binput[15:0],{16{1'b0}}}; 
        end
        //shift operation 
        else if(Sftmd==1) begin
            reg_ALU_Result = Shift_Result; 
        end
        //other types of operation in ALU (arithmatic or logic calculation) 
        else begin
        reg_ALU_Result = ALU_output_mux[31:0]; 
        end 
    end
    ///////////////////////////////////////////////////////////////////

    assign Zero = (ALU_output_mux==32'h00000000)? 1'b1:1'b0;//1代表等于，0代表不等于

endmodule