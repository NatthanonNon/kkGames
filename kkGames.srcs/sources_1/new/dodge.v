`timescale 1ns / 1ps

module dodge(
    input clk,
    input wire video_dodge_on,
    input this_state,
    input [7:0] keyboard,
    input wire [9:0] x, y,
    output reg [11:0] rgb_out,
    output reg dodge_on
    );
    wire [11:0]  heart_rgb,platforms_rgb,monster_rgb, home_rgb,spirit_rgb,bullet_1_rgb,bullet_2_rgb,hp_rgb;
    wire heart_on,platforms_on,monster_on, home_on,spirit_on,bullet_1_on,bullet_2_on,hp_on;
    
    wire [9:0] heart_x,heart_y;
    wire collision_1,collision_2;
    
    wire [11:0] bullet_3_rgb;
    wire bullet_3_on, collision_3;
    
    frame frame_unit 
    (
        .clk(clk), 
        .video_on(video_dodge_on), 
        .x(x), .y(y), 
        .rgb_out(platforms_rgb),
	    .platforms_on(platforms_on)
    );
	                      
	flame_monster flame_monster_unit 
	(
	   .clk(clk), 
	   .video_on(video_dodge_on), 
	   .x(x), 
	   .y(y), 
	   .rgb_out(monster_rgb),
	   .monster_on(monster_on)
    );
	                      
    heart heart_unit 
    (
        .clk(clk),
        .keyboard(keyboard),
        .video_on(video_dodge_on), 
        .x(x), 
        .y(y), 
        .rgb_out(heart_rgb),
        .heart_on(heart_on),
        .heart_x(heart_x),
        .heart_y(heart_y)
    );
	                      
	bullet bullet_unit_1 
	(
	   .clk(clk), 
	   .video_on(video_dodge_on), 
	   .x(x), 
	   .y(y),
	   .heart_x(heart_x),
	   .heart_y(heart_y),
	   .rgb_out(bullet_1_rgb),
	   .collision(collision_1),
	   .bullet_on(bullet_1_on)
    );
    
    defparam bullet_unit_1.t_l_x = 110;
	defparam bullet_unit_1.t_l_y = 344;
	defparam bullet_unit_1.pattern = 0;
	                      
	bullet bullet_unit_2 
	(
	   .clk(clk), 
	   .video_on(video_dodge_on), 
	   .x(x), 
	   .y(y),
	   .heart_x(heart_x),
	   .heart_y(heart_y),
	   .rgb_out(bullet_2_rgb),
	   .collision(collision_2),
	   .bullet_on(bullet_2_on)
    );
    
    defparam bullet_unit_2.t_l_x = 320;
	defparam bullet_unit_2.t_l_y = 255;
	defparam bullet_unit_2.pattern = 1;
	
	bullet bullet_unit_3 
	(
	   .clk(clk), 
	   .video_on(video_dodge_on), 
	   .x(x), 
	   .y(y),
	   .heart_x(heart_x),
	   .heart_y(heart_y),
	   .rgb_out(bullet_3_rgb),
	   .collision(collision_3),
	   .bullet_on(bullet_3_on)
    );
    
    defparam bullet_unit_3.t_l_x = 320;
	defparam bullet_unit_3.t_l_y = 344;
	defparam bullet_unit_3.pattern = 2;
    
            
	wire is_collision =  collision_1 | collision_2 | collision_3;
	hp_bar hp_bar_unit 
	(
	   .clk(clk), 
	   .video_on(video_dodge_on), 
	   .x(x), 
	   .y(y),
	   .collision(is_collision),
	   .rgb_out(hp_rgb),
	   .hp_on(hp_on)
    );
	
	always @*
		begin
		if (~video_dodge_on)
			rgb_out = 12'b0;
			
		else if(heart_on) begin
               rgb_out = heart_rgb;
               dodge_on = 1;
        end
        
	    else if(monster_on) begin
               rgb_out = monster_rgb;
               dodge_on = 1;
        end       
	    else if(platforms_on)begin
               rgb_out = platforms_rgb;
               dodge_on = 1;
        end
        else if(bullet_1_on)begin
               rgb_out = bullet_1_rgb;
               dodge_on = 1;
        end
        else if(bullet_2_on)begin
               rgb_out = bullet_2_rgb;
               dodge_on = 1;
        end
          else if(bullet_3_on)begin
            rgb_out = bullet_3_rgb;
            dodge_on = 1;
        end
        else if(hp_on)begin
               rgb_out = hp_rgb;
               dodge_on = 1;
        end
	    else
               rgb_out = 12'b0;
		end
endmodule
