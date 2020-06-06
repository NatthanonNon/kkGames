`timescale 1ns / 1ps

module game_title(
        input wire clk,                    // input clock signal for synchronous ROMs
        input wire video_on,               // input from vga_sync signaling when video signal is on
        input wire [9:0] x, y,             // current pixel coordinates from vga_sync circuit
        output reg [11:0] rgb_out,         // output rgb signal for current pixel
        output reg game_title_on           // output signal asserted when vga x/y pixel is within platform location in display area
    );
    reg [5:0] row;
	reg [7:0] col;
	
	wire [11:0] game_title_color_data;
	
	reg [11:0] green_screen = 12'b011011011110;
	
	
	
	
	game_title_rom game_title (.clk(clk), .row(row), .col(col), .color_data(game_title_color_data));

	parameter top_left_x = 223;
	parameter top_left_y = 25;
	parameter bot_right_x = top_left_x + 192;
	parameter bot_right_y = top_left_y + 38;
    always @*
		begin
		game_title_on = 0;
		row = 0;
		col = 0;
		rgb_out = 12'b111111111111;
		
		if(video_on)begin
		      if ((x>=top_left_x && x<bot_right_x) && (y>=top_left_y && y<bot_right_y)) begin
		          row = y-top_left_y;
		          col = x-top_left_x;
		          if (game_title_color_data != green_screen) begin
		              game_title_on = 1;
				      rgb_out = game_title_color_data;
				    end
				  
			 end
	       end
	   end
endmodule
