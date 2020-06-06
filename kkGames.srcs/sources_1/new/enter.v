`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/06/2020 04:48:06 PM
// Design Name: 
// Module Name: enter
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


module enter(
        input wire clk,                    // input clock signal for synchronous ROMs
        input wire video_on,               // input from vga_sync signaling when video signal is on
        input wire [9:0] x, y,             // current pixel coordinates from vga_sync circuit
        output reg [11:0] rgb_out,         // output rgb signal for current pixel
        output reg enter_on           // output signal asserted when vga x/y pixel is within platform location in display area
    );
    reg [4:0] row;
	reg [8:0] col;
	
	wire [11:0] enter_color_data;
	
	reg [11:0] green_screen = 12'b000000000000;
	
    enter_rom game_title (.clk(clk), .row(row), .col(col), .color_data(enter_color_data));
    
    parameter top_left_x = 128;
	parameter top_left_y = 350;
	parameter bot_right_x = top_left_x + 384;
	parameter bot_right_y = top_left_y + 20;
    always @*
		begin
		enter_on = 0;
		row = 0;
		col = 0;
		rgb_out = 12'b111111111111;
		
		if(video_on)begin
		      if ((x>=top_left_x && x<bot_right_x) && (y>=top_left_y && y<bot_right_y)) begin
		          row = y-top_left_y;
		          col = x-top_left_x;
		          if (enter_color_data != green_screen) begin
		              enter_on = 1;
				      rgb_out = enter_color_data;
				    end
				  
			 end
	       end
	   end
    
endmodule
