`timescale 1ns / 1ps

module heart(
        input wire clk,                   // input clock signal for synchronous ROMs
        input [7:0] keyboard,
        input wire video_on,               // input from vga_sync signaling when video signal is on
        input wire [9:0] x, y,             // current pixel coordinates from vga_sync circuit
        output reg [11:0] rgb_out,         // output rgb signal for current pixel
        output reg heart_on,
        output reg [9:0] heart_x,heart_y
                   // output signal asserted when vga x/y pixel is within platform location in display area
    );
    reg [5:0] row ;
    reg [7:0] keyDebouncer;
    /*reg [7:0] row;*/
	reg [5:0] col ;
	/*assign row = x;
	assign col = y;*/
	wire [11:0] heart_color_data;
	
	reg [11:0] green_screen = 12'b111111111111;
	
	heart_rom test_heart_beta (.clk(clk), .row(row), .col(col), .color_data(heart_color_data));
	
	reg [9:0] top_left_x = 308;
	reg [9:0] top_left_y = 328;
	//integer bot_right_x = top_left_x + 32;
	
	reg [9:0] bot_right_x;
	reg [9:0] bot_right_y;
	
	always @ (*) begin
	
	bot_right_x <= top_left_x + 32;
	bot_right_y <= top_left_y + 32; // <= to y
	
	end
	/*
	always @(btnU,btnL,btnR,btnD) begin
	   top_left_y <= (btnU) ?
	                (top_left_y - 1 > 252) ? top_left_y - 1 : top_left_y
	                : top_left_y;
	   top_left_y <= (btnD) ?
	                (top_left_y + 1 < 404) ? top_left_y + 1 : top_left_y   //436-32
	                : top_left_y;
	   top_left_x <= (btnL) ?
	                (top_left_x - 1 > 104) ? top_left_x - 1 : top_left_x
	                : top_left_x;
	   top_left_x <= (btnR) ?
	                (top_left_x + 1 < 504) ? top_left_x + 1 : top_left_x  //536-32
	                : top_left_x;
	   
	end*/
	integer move = 0;
	always @ (posedge clk) begin
	       move = (move + 1) % 2500000;
	end
	/*
	always @ (posedge clk) begin
	if (shift_divider == 0 && video_on) begin
	   if (btnU) begin
	       top_left_y = (top_left_y - 1 > 252) ? top_left_y - 1 : top_left_y ;
	   end
	   else if (btnD) begin
	       top_left_y = (top_left_y + 1 < 404) ? top_left_y + 1 : top_left_y ;
	   end
	   else if (btnL) begin
	       top_left_x = (top_left_x - 1 > 104) ? top_left_x - 1 : top_left_x ;
	   end
	   else if (btnR) begin
	       top_left_x = (top_left_x + 1 < 504) ? top_left_x + 1 : top_left_x ;
	   end
	end
	end
	*/
	always@(posedge clk) 
	begin
	   if (move == 0 && video_on) 
	   begin
	       case(keyboard)
	           // w key
	           8'h77 : begin
	               top_left_y = (top_left_y - 1 > 252) ? top_left_y - 1 : top_left_y ;
	           end
	           // a key
	           8'h61 : begin
	               top_left_x = (top_left_x - 1 > 104) ? top_left_x - 1 : top_left_x ;
	           end
	           // s key
	           8'h73 : begin
	               top_left_y = (top_left_y + 1 < 404) ? top_left_y + 1 : top_left_y ;
	           end
	           // d key
	           8'h64 : begin
	               top_left_x = (top_left_x + 1 < 504) ? top_left_x + 1 : top_left_x ;
	           end
	   endcase
	   heart_x <= top_left_x;
	   heart_y <= top_left_y;
	end
	
	end
	
	always @*
		begin
		heart_on = 0;
		row = 0;
		col = 0;
		rgb_out = 12'h000;
		
		if(video_on)begin
		      if ((x>=top_left_x && x<bot_right_x) && (y>=top_left_y && y<bot_right_y)) begin
		          row = (y-top_left_y);
		          col = x-top_left_x;
		          if (heart_color_data != green_screen) begin
		              heart_on = 1;
				      rgb_out = heart_color_data;
				    end
				  
			 end
	   end
	end
	
endmodule
