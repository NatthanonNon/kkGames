`timescale 1ns / 1ps

module name(
        input wire clk,                    // input clock signal for synchronous ROMs
        input wire video_on,               // input from vga_sync signaling when video signal is on
        input wire [9:0] x, y,             // current pixel coordinates from vga_sync circuit
        output reg [11:0] rgb_out,         // output rgb signal for current pixel
        output reg name_on           // output signal asserted when vga x/y pixel is within platform location in display area
    );
    reg [4:0] name_row_1,name_row_2,name_row_3,name_row_4,name_row_5;
	reg [8:0] name_col_1,name_col_2,name_col_3,name_col_4,name_col_5;
	reg [4:0] id_row_1,id_row_2,id_row_3,id_row_4,id_row_5;
	reg [7:0] id_col_1,id_col_2,id_col_3,id_col_4,id_col_5;
	
	wire [11:0] name_1_color_data,id_1_color_data,name_2_color_data,id_2_color_data,name_3_color_data,id_3_color_data,name_4_color_data,id_4_color_data,name_5_color_data,id_5_color_data;
	
	reg [11:0] green_screen = 12'b011011011110;
	
	panupong_rom name_1 (.clk(clk), .row(name_row_1), .col(name_col_1), .color_data(name_1_color_data));
	panupong_id_rom id_1 (.clk(clk), .row(id_row_1), .col(id_col_1), .color_data(id_1_color_data));
    
    phum_rom name_2 (.clk(clk), .row(name_row_2), .col(name_col_2), .color_data(name_2_color_data));
	phum_id_rom id_2 (.clk(clk), .row(id_row_2), .col(id_col_2), .color_data(id_2_color_data));
    
    tolap_rom name_3 (.clk(clk), .row(name_row_3), .col(name_col_3), .color_data(name_3_color_data));
	tolap_id_rom id_3 (.clk(clk), .row(id_row_3), .col(id_col_3), .color_data(id_3_color_data));
    
    jaturit_rom name_4 (.clk(clk), .row(name_row_4), .col(name_col_4), .color_data(name_4_color_data));
	jaturit_id_rom id_4 (.clk(clk), .row(id_row_4), .col(id_col_4), .color_data(id_4_color_data));
	
	natthanon_rom name_5 (.clk(clk), .row(name_row_5), .col(name_col_5), .color_data(name_5_color_data));
	natthanon_id_rom id_5 (.clk(clk), .row(id_row_5), .col(id_col_5), .color_data(id_5_color_data));
    
	parameter top_left_x_name = 85;
	parameter top_left_y_name = 100;
	parameter bot_right_x_name = top_left_x_name + 300;
	parameter bot_right_y_name = top_left_y_name + 29;
	
	parameter top_left_x_id = bot_right_x_name + 26;
	parameter top_left_y_id = 100;
	parameter bot_right_x_id = top_left_x_id + 144;
	parameter bot_right_y_id = top_left_y_id + 29;
	
	//integer name_id_counter = 0;
	
    always @*
		begin
		name_on = 0;
		name_row_1 = 0;
		name_col_1 = 0;
		id_row_1 =0;
		id_col_1=0;
		rgb_out = 12'b111111111111;
		
		if(video_on)begin
		//-----------------1
		      if ((x>=top_left_x_name && x<bot_right_x_name) && (y>=top_left_y_name && y<bot_right_y_name)) begin
		          name_row_1 = y-top_left_y_name;
		          name_col_1 = x-top_left_x_name;
		          if (name_1_color_data != green_screen) begin
		              name_on = 1;
				      rgb_out = name_1_color_data;
				    end
				  
			 end
			 
			 else if ((x>=top_left_x_id && x<bot_right_x_id) && (y>=top_left_y_id && y<bot_right_y_id)) begin
		          id_row_1 = y-top_left_y_id;
		          id_col_1 = x-top_left_x_id;
		          if (id_1_color_data != green_screen) begin
		              name_on = 1;
				      rgb_out = id_1_color_data;
				    end
				  
			 end
		//---------------------2	 
			 
			 else if ((x>=top_left_x_name && x<bot_right_x_name) && (y>=bot_right_y_name+8 && y<bot_right_y_name+(8+29))) begin
		          name_row_2 = y-(bot_right_y_name+8);
		          name_col_2 = x-top_left_x_name;
		          if (name_2_color_data != green_screen) begin
		              name_on = 1;
				      rgb_out = name_2_color_data;
				    end
				  
			 end
			 
			 else if ((x>=top_left_x_id && x<bot_right_x_id) && (y>=bot_right_y_id+8 && y<bot_right_y_id+(8+29))) begin
		          id_row_2 = y-(bot_right_y_id+8);
		          id_col_2 = x-top_left_x_id;
		          if (id_2_color_data != green_screen) begin
		              name_on = 1;
				      rgb_out = id_2_color_data;
				    end
				  
			 end
			 //--------------------3
			else if ((x>=top_left_x_name && x<bot_right_x_name) && (y>=bot_right_y_name+8+(29+8) && y<bot_right_y_name+(8+29)*2)) begin
		          name_row_3 = y-(bot_right_y_name+8+(29+8));
		          name_col_3 = x-top_left_x_name;
		          if (name_3_color_data != green_screen) begin
		              name_on = 1;
				      rgb_out = name_3_color_data;
				    end
				  
			 end
			 
			 else if ((x>=top_left_x_id && x<bot_right_x_id) && (y>=bot_right_y_id+8+(29+8) && y<bot_right_y_id+(8+29)*2)) begin
		          id_row_3 = y-(bot_right_y_name+8+(29+8));
		          id_col_3 = x-top_left_x_id;
		          if (id_3_color_data != green_screen) begin
		              name_on = 1;
				      rgb_out = id_3_color_data;
				    end
				  
			 end
			 //------------------------4
			 else if ((x>=top_left_x_name && x<bot_right_x_name) && (y>=bot_right_y_name+8+(29+8)*2 && y<bot_right_y_name+(8+29)*3)) begin
		          name_row_4 = y-(bot_right_y_name+8+(29+8)*2);
		          name_col_4 = x-top_left_x_name;
		          if (name_4_color_data != green_screen) begin
		              name_on = 1;
				      rgb_out = name_4_color_data;
				    end
				  
			 end
			 
			 else if ((x>=top_left_x_id && x<bot_right_x_id) && (y>=bot_right_y_id+8+(29+8)*2 && y<bot_right_y_id+(8+29)*3)) begin
		          id_row_4 = y-(bot_right_y_name+8+(29+8)*2);
		          id_col_4 = x-top_left_x_id;
		          if (id_4_color_data != green_screen) begin
		              name_on = 1;
				      rgb_out = id_4_color_data;
				    end
				  
			 end
			 //-------------------------5
			 else if ((x>=top_left_x_name && x<bot_right_x_name) && (y>=bot_right_y_name+8+(29+8)*3 && y<bot_right_y_name+(8+29)*4)) begin
		          name_row_5 = y-(bot_right_y_name+8+(29+8)*3);
		          name_col_5 = x-top_left_x_name;
		          if (name_5_color_data != green_screen) begin
		              name_on = 1;
				      rgb_out = name_5_color_data;
				    end
				  
			 end
			 
			 else if ((x>=top_left_x_id && x<bot_right_x_id) && (y>=bot_right_y_id+8+(29+8)*3 && y<bot_right_y_id+(8+29)*4)) begin
		          id_row_5 = y-(bot_right_y_name+8+(29+8)*3);
		          id_col_5 = x-top_left_x_id;
		          if (id_5_color_data != green_screen) begin
		              name_on = 1;
				      rgb_out = id_5_color_data;
				    end
				  
			 end
			 
	       end
	       
	   end

endmodule
