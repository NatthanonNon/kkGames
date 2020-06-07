`timescale 1ns / 1ps

module Attack(
    input clk,
    input wire video_attack_on,
    input [7:0] keyboard,
    input wire [9:0] x, y,
    output reg [11:0] rgb_out,
    output reg attack_on
    );
    
    wire [11:0] frame_rgb, monster_rgb, spirit_rgb;
    wire frame_on, monster_on, spirit_on;
    
    wire [11:0]hp_hero_rgb, hp_monster_rgb;
    wire hp_monster_on, hp_hero_on;
    
    wire [11:0] dodge_rgb, fight_rgb;
    wire dodge_on, fight_on;
    
    wire video_dodge_on, video_fight_on;
    
    
    attack_state_machine atk_FSM 
	(
	   .clk(clk),
	   .keyboard(keyboard), 
	   .fight_on(fight_on),
	   .dodge_on(dodge_on),
	   .video_fight_on(video_fight_on),
	   .video_dodge_on(video_dodge_on)
    );
    
    
    flame_monster flame_monster_unit 
	(
	   .clk(clk), 
	   .video_on(video_attack_on), 
	   .x(x), 
	   .y(y), 
	   .rgb_out(monster_rgb),
	   .monster_on(monster_on)
    );
    
    frame frame_unit 
    (
        .clk(clk), 
        .video_on(video_attack_on), 
        .x(x), 
        .y(y), 
        .rgb_out(frame_rgb),
	    .platforms_on(frame_on)
    );
    
    wire damage_taken_hero, damage_taken_monster;
                                         	
	hp_bar hp_bar_unit_hero 
	(
	   .clk(clk), 
	   .video_on(video_attack_on), 
	   .x(x), 
	   .y(y),
	   .collision(damage_taken_hero),
	   .rgb_out(hp_hero_rgb),
	   .hp_on(hp_hero_on)
    );
    
    defparam hp_bar_unit_hero.color = 0;
    defparam hp_bar_unit_hero.top_left_y = 460;
    
    hp_bar hp_bar_unit_monster
	(
	   .clk(clk), 
	   .video_on(video_attack_on), 
	   .x(x), 
	   .y(y),
	   .collision(damage_taken_monster),
	   .rgb_out(hp_monster_rgb),
	   .hp_on(hp_monster_on)
    );
    
    defparam hp_bar_unit_monster.max_hp = 60;
	
	defparam hp_bar_unit_monster.color = 1;
	
//	integer move = 0;
//	always @ (posedge clk) begin
//	       move = (move + 1) % 2500000;
//	end
	
//	always@(posedge clk) 
//	begin
//	   if (move == 0)
//	       damage_taken_monster = 1;
//	   else 
//	       damage_taken_monster = 0;
//	end
	
	dodge dodge_screen 
	(
	   .clk(clk),
	   .video_dodge_on(video_dodge_on), 
	   .keyboard(keyboard),
	   .x(x), 
	   .y(y), 
	   .rgb_out(dodge_rgb),
	   .dodge_on(dodge_on)
    );
    
    fight fight_screen 
	(
	   .clk(clk),
	   .video_fight_on(video_fight_on), 
	   .keyboard(keyboard),
	   .x(x), 
	   .y(y), 
	   .rgb_out(fight_rgb),
	   .fight_on(fight_on)
    );
	
	always @*
		begin
		  if (~video_attack_on)
		      begin
		          rgb_out = 12'b0;
		      end
		  else if(monster_on) 
		      begin
                rgb_out = monster_rgb;
                attack_on = 1;
              end     
          else if(frame_on)
              begin
                rgb_out = frame_rgb;
                attack_on = 1;
              end
          else if(hp_hero_on)
              begin
                rgb_out = hp_hero_rgb;
                attack_on = 1;
              end
          else if(hp_monster_on)
              begin
                rgb_out = hp_monster_rgb;
                attack_on = 1;
              end
          else if(hp_monster_on)
              begin
                rgb_out = hp_monster_rgb;
                attack_on = 1;
              end       
          else if(fight_on)
              begin
                rgb_out = fight_rgb;
                attack_on = 1;
              end   
          else if(dodge_on)
              begin
                rgb_out = dodge_rgb;
                attack_on = 1;
              end
	      else
               rgb_out = 12'b0;
		end
endmodule
