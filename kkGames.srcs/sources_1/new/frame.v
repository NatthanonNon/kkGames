`timescale 1ns / 1ps

module frame(
        input wire clk,                    // input clock signal for synchronous ROMs
        input wire video_on,               // input from vga_sync signaling when video signal is on
        input wire [9:0] x, y,             // current pixel coordinates from vga_sync circuit
        output reg [11:0] rgb_out,         // output rgb signal for current pixel
        output reg platforms_on            // output signal asserted when vga x/y pixel is within platform location in display area
    );
    // registers to index roms
	reg [3:0] row;
	reg [2:0] col;
	// output vectors from block
    wire [11:0] walls_color_data;
    
    reg [11:0] green_screen = 12'b011011011110;
    
    white_block_rom white_block (.clk(clk), .row(row), .col(col), .color_data(walls_color_data));
    always @*
		begin
		platforms_on = 0;
		row = 0;
		col = 0;
		rgb_out = 12'h000;
		if(video_on)begin
		      //top row 
		      if((x >=96 && x<544) && (y>=244 && y<252)) begin
		          row = y;
		          col = x;
		          if (walls_color_data != green_screen) begin
		              platforms_on = 1;
				      rgb_out = walls_color_data;
				    end
				  
			 end
			
			 //left
			 if((x>=96 && x<104) && (y>=244 && y<444)) begin
			     row = y;
		          col = x;
		          if (walls_color_data != green_screen) begin
		              platforms_on = 1;
				      rgb_out = walls_color_data;
				    end
			 end
			 
			 
			 //right
			 if ((x>=536&& x<544) && (y>=244 && y<444)) begin
			     row = y;
		         col = x;
		          if (walls_color_data != green_screen) begin
		              platforms_on = 1;
				      rgb_out = walls_color_data;
				    end
			 end
			 
			 //bot
			 if ((x >=96 && x<544) && (y>=436 && y<444))begin
			     row = y;
		         col = x;
		          if (walls_color_data != green_screen) begin
		              platforms_on = 1;
				      rgb_out = walls_color_data;
				    end
			 end
	  end
	  end
endmodule
