module four_track_player (
    input clk_6mhz,clk_16hz,reset,
    input[5:0] track0,
	input[5:0] track1,
	input[5:0] track2,
	input[5:0] track3,
    output speaker
);
	wire clk_128hz;
	ClockDivider #(8)cd(clk_16hz, reset, clk_128hz);

	reg [5:0] current_track;
	one_track_player otp(clk_6mhz,clk_128hz,reset,current_track, speaker);

	reg[1:0] count;
	always @(posedge clk_128hz or posedge reset)						
	begin
		if (reset) begin
			current_track<=0;
			count<=0;
		end else begin
			count<=count+1;
			case (count)
				0: current_track<=track0;
				1: current_track<=track1;
				2: current_track<=track2;
				3: current_track<=track3;
			endcase
		end
	end
endmodule