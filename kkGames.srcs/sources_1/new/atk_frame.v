`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/07/2020 05:40:07 PM
// Design Name: 
// Module Name: atk_frame
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


module atk_frame(
        input wire clk,                   // input clock signal for synchronous ROMs
        input wire video_on,               // input from vga_sync signaling when video signal is on
        input wire [9:0] x, y,             // current pixel coordinates from vga_sync circuit
        output reg [11:0] rgb_out         // output rgb signal for current pixel
    );
    
    reg [10:0] row ;
	reg [12:0] col ;
	/*assign row = x;
	assign col = y;*/
	wire [11:0] atk_frame_color_data;
	
	reg [11:0] green_screen = 12'b111111111111;
	
    atk_frame_rom atk_frame_rom (.clk(clk), .row(row), .col(col), .color_data(heart_color_data));
    
    reg [9:0] top_left_x = 104;
	reg [9:0] top_left_y = 252;
	
	reg [9:0] bot_right_x;
	reg [9:0] bot_right_y;

	
	always @*
		begin
		row = 0;
		col = 0;
		rgb_out = 12'h000;
		
		if(video_on)begin
		      if ((x>=top_left_x && x<bot_right_x) && (y>=top_left_y && y<bot_right_y)) begin
		          row = (y-top_left_y);
		          col = x-top_left_x;
		          if (atk_frame_color_data != green_screen) begin
				      rgb_out = atk_frame_color_data;
				    end
			 end
	   end
	end
endmodule
