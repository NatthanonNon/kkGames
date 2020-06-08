`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/06/2020 11:39:50 AM
// Design Name: 
// Module Name: bullet
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


module movable_bar(
        input wire clk,                 // input clock signal for synchronous ROMs
        input [7:0] keyboard,
        input wire video_on,            // input from vga_sync signaling when video signal is on
        input wire [9:0] x, y,
        output reg damage_taken_monster,
        output reg [11:0] rgb_out,      // output rgb signal for current pixel
        output reg bar_on            // output signal asserted when vga x/y pixel is within platform location in display area
    );
    
    wire [11:0] move_bar_data;
	
	reg [11:0] green_screen = 12'b011011011110;
	
    
	
	reg [9:0] top_left_x = 104 ;
	reg [9:0] top_left_y = 252 ;
	//integer bot_right_x = top_left_x + 32;
	
	reg [9:0] bot_right_x;
	reg [9:0] bot_right_y;
	/////////////////////
	/*
	always @ (posedge video_on) begin
	   top_left_x = 104;
	   top_left_y = 252;
	end
	*/
	///////////////////////
	always @ (*) begin
	
	bot_right_x <= top_left_x + 8;
	bot_right_y <= top_left_y + 184; // <= to y
	
	end
	reg direction =0;
	always@ (posedge clk) begin
	   direction = (bot_right_x >= 536) ? 1 :
	               (top_left_x <= 104) ? 0 :
	               direction ;
	   end
	   
	integer move = 0;
	always @ (posedge clk) begin
	       move = (move + 1) % 2500000;
	end
	
	always @ (posedge clk) begin
	   if (move == 0 && video_on) begin
	   top_left_x = (direction == 0) ? top_left_x + 1 : top_left_x - 1 ;
	   end
	end
	
	
	
	always@ (posedge clk) begin
	   damage_taken_monster =0;
	   if (video_on)begin
	       if (keyboard == 8'h20) begin
	       //////red
	           if (top_left_x >=8+104 && top_left_x <=25+104) begin
	               damage_taken_monster = 20;
	           end
	           else if (bot_right_x >=406+104 && bot_right_x <=423+104) begin
	               damage_taken_monster = 20;
	           end
	           //////////////orange
	           else if (top_left_x >=79+104 && top_left_x <=103+104) begin
	               damage_taken_monster = 40;
	           end
	           else if (bot_right_x >=328+104 && bot_right_x <=352+104) begin
	               damage_taken_monster = 40;
	           end
	           ///////////////green
	           else if (top_left_x >=195+104 && top_left_x <=236+104) begin
	               damage_taken_monster = 60;
	           end
	           ////// blue
	           else begin
	               damage_taken_monster =10;
	           end
	           
	       end
	   end
	end
	
    always @*
		begin
		bar_on = 0;

		rgb_out = 12'b111111111111;
		
		if(video_on)begin
		      if ((x>=top_left_x && x<bot_right_x) && (y>=top_left_y && y<bot_right_y)) begin
		          /*row = y-top_left_y;
		          col = x-top_left_x;*/
		          rgb_out = 12'b111111111111;
		          bar_on = 1;
				  
			 end
	       end
	   end
    
endmodule