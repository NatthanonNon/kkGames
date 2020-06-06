`timescale 1ns / 1ps

module fire_spirit(
        input wire clk,                    // input clock signal for synchronous ROMs
        input wire video_on,               // input from vga_sync signaling when video signal is on
        input wire [9:0] x, y,             // current pixel coordinates from vga_sync circuit
        output reg [11:0] rgb_out,         // output rgb signal for current pixel
        output reg spirit_on            // output signal asserted when vga x/y pixel is within platform location in display area
    );
    reg [7:0] row ;
    
    /*reg [7:0] row;*/
	reg [5:0] col ;
	/*assign row = x;
	assign col = y;*/
	wire [11:0] fire_spirit_color_data;
	
	reg [11:0] green_screen = 12'b111111111111;
	
	fire_spirit_rom fire_spirit (.clk(clk), .row(row), .col(col), .color_data(fire_spirit_color_data));
	
	//reg [7:0][0:21] mem  = {1,2,3,4,5,6,7,8,9,10,11,11,10,9,8,7,6,5,4,3,2,1};
	
	integer form = 0; //animationframe
	integer change = 0;
	parameter top_left_x = 285;
	parameter top_left_y = 130;
	parameter bot_right_x = top_left_x + 58;
	parameter bot_right_y = top_left_y + 80;
    always @*
		begin
		spirit_on = 0;
		row = 0;
		col = 0;
		rgb_out = 12'h000;
		
		if(video_on)begin
		      if ((x>=top_left_x && x<bot_right_x) && (y>=top_left_y && y<bot_right_y)) begin
		          row = (80*form)+(y-top_left_y);
		          col = x-top_left_x;
		          if (fire_spirit_color_data != green_screen) begin
		              spirit_on = 1;
				      rgb_out = fire_spirit_color_data;
				    end
				  
			 end
			 
			 if (x == 639 && y == 479) begin
			     change = (change+1) %50;
			     if (change == 0) begin
			         form = (form +1) %9;
			     end
			 end
			 
	   
	       end
	   end
	
endmodule
