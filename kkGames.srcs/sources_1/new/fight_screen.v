`timescale 1ns / 1ps

module fight(
    input clk,
    input wire video_fight_on,
    input this_state,
    input [7:0] keyboard,
    input wire [9:0] x, y,
    output reg [11:0] rgb_out,
    output reg fight_on
    );
        
	                      
	
	always @*
		begin
		if (~video_fight_on)
			rgb_out = 12'b0;
	    else
               rgb_out = 12'b0;
		end
endmodule
