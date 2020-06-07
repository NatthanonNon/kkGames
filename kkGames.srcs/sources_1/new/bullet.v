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
        input wire clk,                 // input clock signal for synchronous ROMs
        input wire video_on,            // input from vga_sync signaling when video signal is on
        input wire [9:0] x, y,
        input [9:0] heart_x,heart_y,    // current pixel coordinates from vga_sync circuit
        output reg [11:0] rgb_out,      // output rgb signal for current pixel
        output reg collision,         
        output reg bullet_on            // output signal asserted when vga x/y pixel is within platform location in display area
    );
    reg [4:0] row;
	reg [4:0] col;
	
	wire [11:0] bullet_color_data;
	
	reg [11:0] green_screen = 12'b011011011110;
    
    // rom
    bullet_rom bullet 
    (
        .clk(clk), 
        .row(row), 
        .col(col), 
        .color_data(bullet_color_data)
    );
    
    // location
    parameter t_l_x = 110;
    parameter t_l_y = 260;
    
    // pattern that the bullet move
    parameter pattern = 0;
    
    reg [9:0] top_left_x = t_l_x;
	reg [9:0] top_left_y = t_l_y;
	
	//integer bot_right_x = top_left_x + 32;
	
	reg [9:0] bot_right_x;
	reg [9:0] bot_right_y;
    
    // assign location of (x,y) bottom right by (x,y) top left
    always @ (*) 
        begin
            bot_right_x <= top_left_x + 32;
	        bot_right_y <= top_left_y + 32; // <= to y
		end
	
	// decrease speed of move
	integer move = 0;
	always @ (posedge clk) 
	   begin
	       move = (move + 1) % 5000000;
	   end
	
	
	// flag to chech the direction :   
	// direction = 0 : right(horizontal pattern) or down (vertical pattern), 
	// direction = 1 : left (horizontal pattern) or up (vertical pattern) 
	reg direction = 0;
	
	// assign direction
	always @ (posedge clk) 
	   begin
	       case (pattern)
	               // horizontal pattern
	               0 : begin
	                   direction <= (bot_right_x >= 544) ? 1 :
	                               (top_left_x <= 95) ? 0 : 
	                               direction;
	               end
	               // vertical pattern
	               1 : begin
	                   direction <= (bot_right_y >= 252) ? 1 :
	                               (top_left_y <= 243) ? 0 : 
	                               direction;
	               end
	       endcase
	   end
	
	
	// flag to check is the bullet collided ?
	reg is_collision = 0; 
	always@(posedge clk)
	   begin
	       if (move == 0 && video_on && !is_collision) 
	       begin
	           // pattern
	           case (pattern)
	               // horizontal pattern
	                   // direction = 0 : right, 
	                   // direction = 1 : left 
	               0 : begin
	                   top_left_x <= (direction == 0) ? top_left_x + 1 :
	                               top_left_x - 1 ;
	               end
	               // vertical pattern
	                   // direction = 0 : down, 
	                   // direction = 1 : up
	               1 : begin
	                   top_left_y <= (direction == 0) ? top_left_y + 1 :
	                               top_left_y - 1 ;
	               end
	               // follow pattern
	               2 : begin
	                   top_left_x <= (top_left_x < heart_x) ? top_left_x + 1 :
	                               (top_left_x > heart_x) ? top_left_x - 1 : 
	                               top_left_x;
	               
	                   top_left_y <= (top_left_y < heart_y) ? top_left_y + 1 :
	                               (top_left_y > heart_y) ? top_left_y - 1 : 
	                               top_left_x;
	               end
	           endcase
	           
	           // check collision
	           collision = ((top_left_x >= heart_x) && (top_left_x <= heart_x + 32) && (top_left_y >= heart_y) && (top_left_y <= heart_y + 32)) ? 1 : //ซ้ายบน
	               ((bot_right_x >= heart_x) && (bot_right_x <= heart_x + 32) && (top_left_y >= heart_y) && (top_left_y <= heart_y + 32)) ? 1 : //ขวาบน
	               ((top_left_x >= heart_x) && (top_left_x <= heart_x + 32) && (bot_right_y >= heart_y) && (bot_right_y <= heart_y + 32)) ? 1 : //ซ้ายล่าง
	               ((bot_right_x >= heart_x) && (bot_right_x <= heart_x + 32) && (bot_right_y >= heart_y) && (bot_right_y <= heart_y + 32)) ? 1 : 
	               0; //ขวาล่าง
	       end
	   end
	
// dont use
//	always@(posedge clk) 
//	   begin
//	       if (move == 0 && video_on && !is_collision) begin
//            /*
//               if(heart_x<top_left_x) begin
//                   top_left_x <= top_left_x +1;
                   
//                   if (heart_y<top_left_y)begin
//                   top_left_y <= top_left_y +1;
//                   end
                   
//                   else if (heart_y>top_left_y)begin
//                   top_left_y <= top_left_y -1;
//                   end
//               end
               
//               else if(heart_x>top_left_x) begin
//                   top_left_x <= top_left_x -1;
                   
//                   if (heart_y<top_left_y)begin
//                   top_left_y <= top_left_y +1;
//                   end
                   
//                   else if (heart_y>top_left_y)begin
//                   top_left_y <= top_left_y -1;
//                   end
//               end*/
           
                            
//              // if (!collision) begin
               
//              // end
//	       end
//	   end
//	/*
//	assign collision = ((top_left_x>=heart_x)&&(top_left_x<=heart_x+32)&&(top_left_y>=heart_y)&&(top_left_y<=heart_y+32)) ? 1 : //ซ้ายบน
//	                   ((bot_right_x>=heart_x)&&(bot_right_x<=heart_x+32)&&(top_left_y>=heart_y)&&(top_left_y<=heart_y+32)) ? 1 : //ขวาบน
//	                   ((top_left_x>=heart_x)&&(top_left_x<=heart_x+32)&&(bot_right_y>=heart_y)&&(bot_right_y<=heart_y+32)) ? 1 : //ซ้ายล่าง
//	                   ((bot_right_x>=heart_x)&&(bot_right_x<=heart_x+32)&&(bot_right_y>=heart_y)&&(bot_right_y<=heart_y+32)) ? 1 : 0; //ขวาล่าง
//	*/                   
	
	always @*
		begin
		  bullet_on = 0;
		  row = 0;
		  col = 0;
		  rgb_out = 12'h000;
		
		  if (collision) 
		  begin
		      is_collision = 1;
		  end
		
		  if(video_on)
		  begin
		      if ((x>=top_left_x && x<bot_right_x) && (y>=top_left_y && y<bot_right_y)) 
		      begin
		          row = (y-top_left_y);
		          col = x-top_left_x;
		          if (bullet_color_data != green_screen) 
		          begin
		              bullet_on = !is_collision;
				      rgb_out = bullet_color_data;
				  end
			  end
	       end
	   end
	
endmodule
