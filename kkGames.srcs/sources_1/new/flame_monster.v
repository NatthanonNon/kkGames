`timescale 1ns / 1ps

module flame_monster(
        input wire clk,                    // input clock signal for synchronous ROMs
        input wire video_on,               // input from vga_sync signaling when video signal is on
        input wire [9:0] x, y,             // current pixel coordinates from vga_sync circuit
        output reg [11:0] rgb_out,         // output rgb signal for current pixel
        output reg monster_on            // output signal asserted when vga x/y pixel is within platform location in display area
    );
    reg [7:0] row ;
    
    /*reg [7:0] row;*/
	reg [5:0] col ;
	/*assign row = x;
	assign col = y;*/
	wire [11:0] flame_monster_color_data;
	
	reg [11:0] green_screen = 12'b111111111111;
	
	
	//assign monster_on  = (x >= 136 && x < 200 && y >= 64 && y < 164 && rgb_out != 12'b011011011110) ? 1 : 0;
	
	//flame1 flame (.clk(clk), .row(row), .col(col), .color_data(flame_monster_color_data));
	
	flame_monster_rom flame_monster (.clk(clk), .row(row), .col(col), .color_data(flame_monster_color_data));
	//reg [7:0][0:3] mem  = {1,2,3,3,2,1};
	integer form = 0;
	integer change = 0;
	parameter top_left_x = 300;
	parameter top_left_y = 160;
	parameter bot_right_x = top_left_x + 40;
	parameter bot_right_y = top_left_y + 63;
    always @*
		begin
		monster_on = 0;
		row = 0;
		col = 0;
		rgb_out = 12'h000;
		
		if(video_on)begin
		      if ((x>=top_left_x && x<bot_right_x) && (y>=top_left_y && y<bot_right_y)) begin
		          row = (63*form)+(y-top_left_y);
		          col = x-top_left_x;
		          if (flame_monster_color_data != green_screen) begin
		              monster_on = 1;
				      rgb_out = flame_monster_color_data;
				    end
				  
			 end
			 
			 if (x == 639 && y == 479) begin
			     change = (change+1) %65;
			     if (change == 0) begin
			         form = (form +1) %3;
			     end
			 end
			 
	   
	       end
	   end
		      
endmodule
