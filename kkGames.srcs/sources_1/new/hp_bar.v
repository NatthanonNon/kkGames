`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/06/2020 02:28:21 PM
// Design Name: 
// Module Name: hp_bar
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


module hp_bar(
        input wire clk,                    // input clock signal for synchronous ROMs
        input wire video_on,               // input from vga_sync signaling when video signal is on
        input wire [9:0] x, y,
        input damage_taken,            // current pixel coordinates from vga_sync circuit
        output reg [11:0] rgb_out,         // output rgb signal for current pixel
        output reg hp_on           // output signal asserted when vga x/y pixel is within platform location in display area
    );
    /*reg [3:0] row;
	reg [6:0] col;*/
	parameter max_hp = 150;
    integer current_hp= max_hp ;
    
	wire [11:0] hp_color_data;
	
	reg [11:0] green_screen = 12'b011011011110;
	
	parameter top_left_x = 90;
	parameter top_left_y = 450;
	parameter bot_right_x = top_left_x + max_hp;
	parameter bot_right_y = top_left_y + 7;
	
	// flag to check whether hero(0) or moster(1) 
	parameter color = 0;
	
	// HP management
	always@(posedge damage_taken) begin
	       current_hp = (current_hp - 1 <= 0)? 0 : current_hp - 1;
	   
	end
	
    always @*
		begin
		hp_on = 0;
		/*row = 0;
		col = 0;*/
		rgb_out = 12'b111111111111;
		
		if(video_on)begin
		      if ((x>=top_left_x && x<bot_right_x) && (y>=top_left_y && y<bot_right_y)) begin
		          /*row = y-top_left_y;
		          col = x-top_left_x;*/
		          if( x < bot_right_x - (max_hp-current_hp)) begin
		              hp_on = 1;
		              //current hp
				      rgb_out = (color == 0) ? 12'b000011110000 : 12'b111010001000;
				    end
				  else if( x >= bot_right_x - (max_hp-current_hp)) begin
		              hp_on = 1;
		              //dealing hp
				      rgb_out = (color == 0) ? 12'b111100000000 : 12'b111010111100;
				    end
				  
			 end
	       end
	   end

endmodule
