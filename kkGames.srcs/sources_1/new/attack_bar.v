`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/08/2020 01:52:05 PM
// Design Name: 
// Module Name: attack_bar
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


module attack_bar(
        input wire clk,                    // input clock signal for synchronous ROMs
        input wire video_on,               // input from vga_sync signaling when video signal is on
        input wire [9:0] x, y,             // current pixel coordinates from vga_sync circuit
        output reg [11:0] rgb_out,         // output rgb signal for current pixel
        output reg attack_bar_on           // output signal asserted when vga x/y pixel is within platform location in display area
    );
    reg [7:0] row;
	reg [8:0] col;
	
	wire [11:0] attack_bar_color_data;
	
	reg [11:0] green_screen = 12'b011011011110;
	
	
	
	
	/*attack_bar_rom attack_bar (.clk(clk), .row(row), .col(col), .color_data(attack_bar_color_data));*/

	parameter top_left_x = 104;
	parameter top_left_y = 252;
	parameter bot_right_x = top_left_x + 432;
	parameter bot_right_y = top_left_y + 184;
    always @*
		begin
		attack_bar_on = 0;
		row = 0;
		col = 0;
		rgb_out = 12'b111111111111;
		
		if(video_on)begin
		     if (y>=top_left_y && y<bot_right_y) begin
	       //////red
	           if (x >=8+104 && x <=25+104) begin
	               attack_bar_on = 1;
				   rgb_out = 12'b111100000000;
	           end
	           else if (x >=406+104 && x <=423+104) begin
	               attack_bar_on = 1;
				   rgb_out = 12'b111100000000;
	           end
	           //////////////orange
	           else if (x >=79+104 && x <=103+104) begin
	               attack_bar_on = 1;
				   rgb_out = 12'b111110110000;
	           end
	           else if (x >=328+104 && x <=352+104) begin
	               attack_bar_on = 1;
				   rgb_out = 12'b111110110000;
	           end
	           ///////////////green
	           else if (x >=195+104 && x <=236+104) begin
	               attack_bar_on = 1;
				   rgb_out = 12'b000011110000;
	           end
	           ////// blue
	           else begin
	               attack_bar_on = 1;
				   rgb_out = 12'b000000000000;
	           end
	           
	       end
				  
				  
			 end
	       end
endmodule
/*
	always@ (posedge clk) begin
	   damage =0;
	   if (video_on)begin
	       if ((y>=top_left_y && y<bot_right_y))) begin
	       //////red
	           if (top_left_x >=8 && top_left_x <=25) begin
	               attack_bar_on = 1;
				   rgb_out = 12'b111100000000;
	           end
	           else if (bot_right_x >=8 && bot_right_x <=25) begin
	               damage = 2;
	           end
	           //////////////orange
	           else if (top_left_x >=79 && top_left_x <=103) begin
	               attack_bar_on = 1;
				   rgb_out = 12'111110110000;
	           end
	           else if (bot_right_x >=328 && bot_right_x <=352) begin
	               attack_bar_on = 1;
				   rgb_out = 12'111110110000;
	           end
	           ///////////////green
	           else if (top_left_x >=195 && top_left_x <=236) begin
	               attack_bar_on = 1;
				   rgb_out = 12'b000011110000;
	           end
	           ////// blue
	           else begin
	               attack_bar_on = 1;
				   rgb_out = 12'b000000000000;
	           end
	           
	       end
	   end
	end
*/