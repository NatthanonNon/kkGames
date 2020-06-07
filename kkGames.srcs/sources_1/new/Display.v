`timescale 1ns / 1ps
module Display(
		input wire clk,
		input [7:0] keyboard,
		input wire [11:0] sw,
		output wire Hsync, Vsync,
		output wire [3:0] vgaRed,vgaGreen,vgaBlue
		
	);
	wire [9:0] x, y;                                              // location of VGA pixel
	wire video_on, pixel_tick;                                    // route VGA signals
	reg [11:0] rgb_reg, rgb_next;                                 // RGB data register to route out to VGA DAC
	//wire [9:0] heart_x, heart_y;                                          // vector to route yoshi's x/y location
	
	wire [11:0] heart_rgb, platforms_rgb, monster_rgb, spirit_rgb;
	wire [11:0] home_rgb, dodge_rgb, fight_rgb;
	
	wire heart_on, platforms_on, monster_on, spirit_on;
	wire home_on, dodge_on, fight_on;
	
	vga_sync vsync_unit 
	(
	   .clk(clk), 
	   .Hsync(Hsync), 
	   .Vsync(Vsync),
       .video_on(video_on), 
       .p_tick(pixel_tick), 
       .x(x), 
       .y(y)
    );
    
	//wire state;
	wire video_home_on,video_dodge_on, video_fight_on;

	
	game_state_machine FSM 
	(
	   .clk(clk),
	   .keyboard(keyboard), 
	   .home_on(home_on),
	   .dodge_on(dodge_on),
	   .video_home_on(video_home_on),
	   .video_dodge_on(video_dodge_on)
    );
	

	
	/*home home_unit (.clk(clk), .video_on(video_on), .x(x), .y(y), .rgb_out(home_rgb),
	                      .home_on(home_on));*/
	/*
	frame frame_unit (.clk(clk), .video_on(video_on), .x(x), .y(y), .rgb_out(platforms_rgb),
	                      .platforms_on(platforms_on));
	flame_monster flame_monster_unit (.clk(clk), .video_on(video_on), .x(x), .y(y), .rgb_out(monster_rgb),
	                      .monster_on(monster_on));
    heart heart_unit (.clk(clk),.btnU(btnU),.btnL(btnL),.btnR(btnR),.btnD(btnD),.video_on(video_on), .x(x), .y(y), .rgb_out(heart_rgb),
	                      .heart_on(heart_on));*/
	/*fire_spirit fire_spirit_unit (.clk(clk), .video_on(video_on), .x(x), .y(y), .rgb_out(spirit_rgb),
	                      .spirit_on(spirit_on));*/
	home home_screen 
	(
	   .clk(clk),
	   .video_home_on(video_home_on), 
	   .x(x), 
	   .y(y), 
	   .rgb_out(home_rgb),
	   .home_on(home_on)
    );
    
	dodge dodge_screen 
	(
	   .clk(clk),
	   .keyboard(keyboard),
	   .video_dodge_on(video_dodge_on), 
	   .x(x), 
	   .y(y), 
	   .rgb_out(dodge_rgb),
	   .dodge_on(dodge_on)
    );
    
    fight fight_screen 
	(
	   .clk(clk),
	   .keyboard(keyboard),
	   .video_fight_on(video_fight_on), 
	   .x(x), 
	   .y(y), 
	   .rgb_out(fight_rgb),
	   .fight_on(fight_on)
    );
    
	always @*
		begin
        	if (~video_on)
			rgb_next = 12'b0; // black
			/*
			else if (state == 0) begin
			         led1 = 1;
			         if (home_on) begin
			             rgb_next = home_rgb;
			         end
			     end
			else if (state == 1) begin
			         led2 =1;
			         if (monster_on) begin
			             rgb_next = monster_rgb;
			         end
			         else if (platforms_on) begin
			              rgb_next = platforms_rgb;
			         end
			 end
			 */
			 
			 else if (video_home_on)
			         rgb_next = home_rgb;
			
			/*
            else if(spirit_on)
                	rgb_next = spirit_rgb;*/
                	/*
            else if(heart_on)
                	rgb_next = heart_rgb;
	        else if(monster_on)
                	rgb_next = monster_rgb;
	        else if(platforms_on)
                	rgb_next = platforms_rgb;*/
             
            else if (video_dodge_on)
	               rgb_next = dodge_rgb;
	       else
                	rgb_next = 12'b0;
         end
    
    always @(posedge clk)
		if (pixel_tick)
			rgb_reg <= rgb_next;
	assign {vgaRed,vgaGreen,vgaBlue} = rgb_reg;
		
	/*
	// register for Basys 2 8-bit RGB DAC 
	
	
	// video status output from vga_sync to tell when to route out rgb signal to DAC
	

        // instantiate vga_sync
        vga_sync vga_sync_unit (.clk(clk), .hsync(Hsync), .vsync(Vsync),
                                .video_on(video_on), .p_tick(), .x(), .y());
   
        // rgb buffer
        always @(posedge clk)
        
            rgb_reg <= sw;
        
        // output
        assign {vgaRed,vgaGreen,vgaBlue} = (video_on) ? rgb_reg : 12'b0;*/
endmodule
