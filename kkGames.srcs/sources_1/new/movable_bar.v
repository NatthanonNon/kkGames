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
        output reg [11:0] rgb_out,      // output rgb signal for current pixel
        output reg bar_on            // output signal asserted when vga x/y pixel is within platform location in display area
    );
//    reg stop = 0;
    
//    parameter t_l_x = 0;
//    parameter t_l_y = 0;
    
//    reg [9:0] top_left_x = t_l_x;
//	reg [9:0] top_left_y = t_l_y;
    
//    integer move = 0;
//	always @ (posedge clk) 
//	   begin
//	       move = (move + 1) % 5000000;
//	   end
	
//    reg is_going_left = 0;
//    parameter bar_width = 4;
//    parameter right_screen_edge = 639;

	
	reg top_left_x = 320;
	reg top_left_y = 251;
	reg bot_right_x;
	reg bot_right_y;
	
	// assign location of (x,y) bottom right by (x,y) top left
    always @ (*) 
        begin
            bot_right_x <= top_left_x + 4;
	        bot_right_y <= top_left_y + 186;
		end

    // decrease speed of move
	integer move = 0;
	always @ (posedge clk) 
	   begin
	       move = (move + 1) % 5000000;
	   end
	
	// flag to check the direction :   
	// direction = 0 : right
	// direction = 1 : left 
	reg direction = 0;
	
	// assign direction
	always @ (posedge clk) 
	   begin
	       direction <= (bot_right_x >= 544) ? 1 :
	                   (top_left_x <= 95) ? 0 : 
	                   direction;
	   end
    
	always@(posedge clk)
	   begin
	       if (move == 0 && video_on) 
	       begin
	           top_left_x <= (direction == 0) ? top_left_x + 1 :
	                       top_left_x - 1 ;
	       end
	   end
	   
	always @*
	   begin
	       rgb_out = 12'b111111111111;
	       bar_on = 0;
	       if ((x>=top_left_x && x<bot_right_x) && (y>=top_left_y && y<bot_right_y))
	       begin
	           rgb_out = 12'b111010101000;
	           bar_on = 1;
	       end
	   end
    
    
//    always @ (posedge clk) begin
//        if ( keyboard == 8'h20 ) stop = 1;
//    end
    
//    always @ (posedge clk) begin
//        if ( move == 0 && !stop ) begin
//            if ( is_going_left ) begin
//                top_left_x = top_left_x - 1;
//            end
//            else begin
//                top_left_x = top_left_x + 1;
//            end 
            
//            if ( top_left_x == 0 ) is_going_left = 0; // going right
//            else if ( top_left_x + bar_width == right_screen_edge ) is_going_left = 1; // going left
//        end
       
//    end
    
//    always @ (posedge clk) begin
//        if ( x >= top_left_x && x <= top_left_x + bar_width ) begin
//            rgb_out = 12'b1;
//            bar_on = 1;
//        end
//        else begin 
//            rgb_out = 0;
//            bar_on = 0;
//        end
//    end
   
endmodule