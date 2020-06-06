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


module bullet(
        input wire clk,                    // input clock signal for synchronous ROMs
        input wire video_on,               // input from vga_sync signaling when video signal is on
        input wire [9:0] x, y,
        input [9:0] heart_x,heart_y,            // current pixel coordinates from vga_sync circuit
        output reg [11:0] rgb_out,
        output reg collision,         // output rgb signal for current pixel
        output reg bullet_on          // output signal asserted when vga x/y pixel is within platform location in display area
    );
    reg [4:0] row;
	reg [4:0] col;
	
	wire [11:0] bullet_color_data;
	
	reg [11:0] green_screen = 12'b011011011110;
    
    bullet_rom bullet (.clk(clk), .row(row), .col(col), .color_data(bullet_color_data));
    
    parameter t_l_x = 110;
    parameter t_l_y = 260;
    
    reg [9:0] top_left_x = t_l_x;
	reg [9:0] top_left_y = t_l_y;
	
	//integer bot_right_x = top_left_x + 32;
	
	reg [9:0] bot_right_x;
	reg [9:0] bot_right_y;
    
   always @ (*) begin
	
	bot_right_x <= top_left_x + 32;
	bot_right_y <= top_left_y + 32; // <= to y
	
	end
	
	integer move = 0;
	always @ (posedge clk) begin
	       move = (move + 1) % 5000000;
	end
	
	reg is_collision = 0; 
	
	always@(posedge clk) begin
	if (move == 0 && video_on && !is_collision) begin
	/*
	   if(heart_x<top_left_x) begin
	       top_left_x <= top_left_x +1;
	       
	       if (heart_y<top_left_y)begin
	       top_left_y <= top_left_y +1;
	       end
	       
	       else if (heart_y>top_left_y)begin
	       top_left_y <= top_left_y -1;
	       end
	   end
	   
	   else if(heart_x>top_left_x) begin
	       top_left_x <= top_left_x -1;
	       
	       if (heart_y<top_left_y)begin
	       top_left_y <= top_left_y +1;
	       end
	       
	       else if (heart_y>top_left_y)begin
	       top_left_y <= top_left_y -1;
	       end
	   end*/
	   top_left_x <= (top_left_x<heart_x) ? top_left_x+1 :
	                (top_left_x>heart_x) ? top_left_x-1 : top_left_x;
	   top_left_y <= (top_left_y<heart_y) ? top_left_y+1 :
	                (top_left_y>heart_y) ? top_left_y-1 : top_left_x;
	  // if (!collision) begin
	   collision = ((top_left_x>=heart_x)&&(top_left_x<=heart_x+32)&&(top_left_y>=heart_y)&&(top_left_y<=heart_y+32)) ? 1 : //ซ้ายบน
	               ((bot_right_x>=heart_x)&&(bot_right_x<=heart_x+32)&&(top_left_y>=heart_y)&&(top_left_y<=heart_y+32)) ? 1 : //ขวาบน
	               ((top_left_x>=heart_x)&&(top_left_x<=heart_x+32)&&(bot_right_y>=heart_y)&&(bot_right_y<=heart_y+32)) ? 1 : //ซ้ายล่าง
	               ((bot_right_x>=heart_x)&&(bot_right_x<=heart_x+32)&&(bot_right_y>=heart_y)&&(bot_right_y<=heart_y+32)) ? 1 : 0; //ขวาล่าง
	  // end
	end
	
	end
	
	
	
	
	/*
	assign collision = ((top_left_x>=heart_x)&&(top_left_x<=heart_x+32)&&(top_left_y>=heart_y)&&(top_left_y<=heart_y+32)) ? 1 : //ซ้ายบน
	                   ((bot_right_x>=heart_x)&&(bot_right_x<=heart_x+32)&&(top_left_y>=heart_y)&&(top_left_y<=heart_y+32)) ? 1 : //ขวาบน
	                   ((top_left_x>=heart_x)&&(top_left_x<=heart_x+32)&&(bot_right_y>=heart_y)&&(bot_right_y<=heart_y+32)) ? 1 : //ซ้ายล่าง
	                   ((bot_right_x>=heart_x)&&(bot_right_x<=heart_x+32)&&(bot_right_y>=heart_y)&&(bot_right_y<=heart_y+32)) ? 1 : 0; //ขวาล่าง
	*/                   
	
	always @*
		begin
		bullet_on = 0;
		row = 0;
		col = 0;
		rgb_out = 12'h000;
		
		if (collision) begin
		  is_collision = 1;
		end
		
		if(video_on)begin
		      if ((x>=top_left_x && x<bot_right_x) && (y>=top_left_y && y<bot_right_y)) begin
		          row = (y-top_left_y);
		          col = x-top_left_x;
		          if (bullet_color_data != green_screen) begin
		              bullet_on = !is_collision;
				      rgb_out = bullet_color_data;
				    end
				  
			 end
	   end
	end
	
endmodule
