module one_track_player (
    input clk_6mhz,clk_16hz,reset,
    input [5:0] current_track,
    output reg speaker
);
    reg [13:0] divider,origin;
	reg carry;

    always @(posedge clk_6mhz or posedge reset)						//通过置数，改变分频比
	begin
        if (reset) begin
            divider <= 0;
            carry <= 0;
        end
        else
		if(divider == 16383)
		begin
			divider <= origin;
			carry <= 1;
		end
		else begin
			divider <= divider + 1;
			carry <= 0;
		end
	end
	
	always @(posedge carry or posedge reset)							//2分频得到方波信号
	begin
        if (reset) begin
            speaker <= 0;
        end else
		    speaker <= ~speaker;
	end
	
	always @(posedge clk_16hz or posedge reset)						//根据不同的音符，预置分频比
	begin
        if (reset) begin
            origin <=16383;
        end else
		case(current_track)
            0:  origin <=16383;
			1:	origin <= 4916;
			2:	origin <= 5560;
			3:	origin <= 6167;
			4:	origin <= 6741;
			5:	origin <= 7282;
			6:	origin <= 7793;
			7:	origin <= 8275;
			8:	origin <= 8730;
			9:	origin <= 9159;
			10:	origin <= 9565;
			11:	origin <= 9947;
			12:	origin <= 10309;
			13:	origin <= 10650;
			14:	origin <= 10971;
			15:	origin <= 11275;
			16:	origin <= 11562;
			17:	origin <= 11832;
			18:	origin <= 12088;
			19:	origin <= 12329;
			20:	origin <= 12556;
			21:	origin <= 12771;
			22:	origin <= 12974;
			23:	origin <= 13165;
			24:	origin <= 13346;
			25:	origin <= 13516;
			26:	origin <= 13677;
			27:	origin <= 13829;
			28:	origin <= 13972;
			29:	origin <= 14108;
			30:	origin <= 14235;
			31:	origin <= 14356;
			32:	origin <= 14470;
			33:	origin <= 14577;
			34:	origin <= 14678;
			35:	origin <= 14774;
			36:	origin <= 14864;
		endcase
	end
endmodule