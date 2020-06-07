`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/08/2020 12:52:46 AM
// Design Name: 
// Module Name: moveable_bar_rom
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


module moveable_bar_rom(
    input wire clk,
	input wire [9:0] row,
	input wire [9:0] col,
	output reg [11:0] color_data
    );
    (* rom_style = "block" *)
    
    reg [9:0] x;
	reg [9:0] y;
	
	parameter top_left_x = 320;
	parameter top_left_y = 251;
	parameter bot_right_x = top_left_x + 4;
	parameter bot_right_y = top_left_y + 186;

	always @(posedge clk)
		begin
		x <= row;
		y <= col;
		end
	always @*
	   begin
	       if ((x>=top_left_x && x<bot_right_x) && (y>=top_left_y && y<bot_right_y))
	           color_data = 12'b111010101000;
	   end
endmodule
