/// @description Insert description here
// You can write your code in this editor
controller_left_pressed = keyboard_check_pressed(ord("A"));
controller_right_pressed = keyboard_check_pressed(ord("D"));
controller_up_pressed = keyboard_check_pressed(ord("W"));
controller_down_pressed = keyboard_check_pressed(ord("S"));
controller_jump_pressed = keyboard_check_pressed(vk_space);
controller_left_check = keyboard_check(ord("A"));
controller_right_check = keyboard_check(ord("D"));
controller_up_check = keyboard_check(ord("W"));
controller_down_check = keyboard_check(ord("S"));
controller_jump_check = keyboard_check(vk_space);
controller_x_axis_check = controller_right_check - controller_left_check;
controller_y_axis_check = controller_down_check - controller_up_check;

if(fixes.can_move && controller_x_axis_check != 0){
	xvel = clamp(xvel + accel * sign(controller_x_axis_check), -maxxvel, maxxvel);
} else {
	//Decelerate
	if(xvel > 0){
		xvel = max(0, xvel - decel);
	} else {
		xvel = min(0, xvel + decel);
	}
}

switch(cur_action){
	case actions.no_action:
		state = "No action";
		fixes.can_gravity = true;
		fixes.can_move = true;
		fixes.can_ladder_collide = true;
		if(place_meeting(x, y, o_lab_chute)){
			cur_action = actions.chute;
			cur_action_timeup = 0;
			state_sub = 0;
			break;
		}
		if(place_meeting(x, y, o_lab_tunnel)){
			cur_action = actions.tunnel_enter;
			cur_action_timeup = 0;
			break;
		}
		if(abs(xvel) > .5 && !place_meeting(x + xvel, y, o_lab_wall)){	
			if(cur_action_timeup % 30 == 0){
				play_sfx(sfx_lab_walk1);
			} else if (cur_action_timeup % 30 == 20){
				play_sfx(sfx_lab_walk2);
			}
			cur_action_timeup++;
		} else {
			cur_action_timeup = 0;
		}
		
		//Ladder check
		var _ladder;
		if(grounded && controller_y_axis_check > 0)
			_ladder = collision_point(x, y + 2, o_lab_ladder, false, false);
		else
			_ladder = collision_point(x, y, o_lab_ladder, false, false);
		var _ladder2 = _ladder;
		if(_ladder != noone && ((grounded && controller_y_axis_check > 0) || controller_y_axis_check < 0)){
			ladder_enter_dir = controller_y_axis_check;
			cur_action = actions.ladder_enter;
			cur_action_timeup = 0;
		}
		break;
	case actions.tunnel_enter:
		state = "Tunnel enter";
		fixes.can_move = false;
		if(cur_action_timeup >= STATE_TUNNEL_ENTER_MAX){
			cur_action = actions.in_tunnel;
			cur_action_timeup = 0;
			break;
		}
		if(cur_action_timeup == 0){
			play_sfx(sfx_lab_tunnel_in);
		}
		if(!collision_point(x+45*-sign(image_xscale),y, o_lab_tunnel, false, false)){
			xvel = 2.5*sign(image_xscale);
		}
		cur_action_timeup++;
		break;
	case actions.in_tunnel:
		fixes.can_move = true;
		if(!collision_point(x+45/2*sign(image_xscale),y, o_lab_tunnel, false, false)){
			cur_action = actions.tunnel_exit;
			cur_action_timeup = 0;
			break;
		}
		if(abs(xvel) > .5 && !place_meeting(x + xvel, y, o_lab_wall)){	
			if(cur_action_timeup % 12 == 0){
				play_sfx(sfx_lab_crawl1);
			} else if (cur_action_timeup % 12 == 6){
				play_sfx(sfx_lab_crawl2);
			}
			cur_action_timeup++;
		} else {
			cur_action_timeup = 0;
		}
		break;
	case actions.tunnel_exit:
		fixes.can_move = false;
		if(cur_action_timeup == 0){
			play_sfx(sfx_lab_tunnel_out);
		}
		if(cur_action_timeup >= STATE_TUNNEL_EXIT_MAX){
			cur_action = actions.no_action;
			cur_action_timeup = 0;
			break;
		}
		
		if(collision_point(x+55*-sign(image_xscale),y, o_lab_tunnel, false, false)){
			xvel = 2.5*sign(image_xscale);
		}
		cur_action_timeup++;
		break;
	case actions.ladder_enter:
		state = "Ladder enter";
		fixes.can_move = false;
		fixes.can_ladder_collide = false;
		fixes.can_gravity = false;
		var _ladder = collision_line(x, y, x, y + 2, o_lab_ladder, false, false);
		var _ladder2 = collision_point(x, y-60, o_lab_ladder, false, false);
		if(_ladder == noone){
			cur_action = actions.no_action;
			cur_action_timeup = 0;
			break;
		}
		xvel = 0;
		x = _ladder.x + _ladder.sprite_width/2;
		yvel = 5 * ladder_enter_dir;
		
		if(cur_action_timeup == 0){
			play_sfx(sfx_lab_tunnel_out);
		}
		if(cur_action_timeup >= STATE_LADDER_ENTER_MAX){
			cur_action = actions.on_ladder;
			cur_action_timeup = 0;
			break;
		}
		if(_ladder2 == noone) _ladder2 = _ladder;
		if(((y - _ladder2.y ) % 50 > 25) != ((y+yvel - _ladder2.y ) % 50 > 25)){
			if((y - _ladder2.y ) % 50 > 25){
				if(_ladder2.type == 0)
					play_sfx(sfx_lab_hole_1);
				else
					play_sfx(sfx_lab_ladder_1);
			} else {
				if(_ladder2.type == 0)
					play_sfx(sfx_lab_hole_2);
				else
					play_sfx(sfx_lab_ladder_2);
			}
		}
		
		if(collision_point(x+55*-sign(image_xscale),y, o_lab_tunnel, false, false)){
			xvel = 2.5*sign(image_xscale);
		}
		cur_action_timeup++;
		break;
	case actions.on_ladder:
		state = "On ladder";
		fixes.can_move = false;
		fixes.can_ladder_collide = false;
		fixes.can_gravity = false;
		var _ladder = collision_line(x, y, x, y + 2, o_lab_ladder, false, false);
		var _ladder2 = collision_point(x, y-60, o_lab_ladder, false, false);
		if(_ladder == noone){
			cur_action = actions.no_action;
			cur_action_timeup = 0;
			break;
		}
		if(_ladder2 == noone) _ladder2 = _ladder;
		if(controller_y_axis_check > 0 && place_meeting(x, y+1, o_lab_wall)){
			cur_action = actions.no_action;
		}
		if(((y - _ladder2.y ) % 50 > 25) != ((y+yvel - _ladder2.y ) % 50 > 25)){
			if((y - _ladder2.y ) % 50 > 25){
				if(_ladder2.type == 0)
					play_sfx(sfx_lab_hole_1);
				else
					play_sfx(sfx_lab_ladder_1);
			} else {
				if(_ladder2.type == 0)
					play_sfx(sfx_lab_hole_2);
				else
					play_sfx(sfx_lab_ladder_2);
			}
		}
		x = _ladder.x + _ladder.sprite_width/2;
		if(controller_y_axis_check >= 0 || position_meeting(x, y-90, o_lab_ladder)){
			yvel = sign(controller_y_axis_check) * LAB_LADDER_CLIMB_SPEED;
		} else {
			yvel = 0;
			cur_action = actions.ladder_exit;
			cur_action_timeup = 0;
		}
		if(!position_meeting(x, y + yvel, o_lab_ladder)){
			while(position_meeting(x, y, o_lab_ladder) && !place_meeting(x, y + sign(yvel), o_lab_wall)){
				y+=sign(yvel);
			}
			yvel = 0;
			cur_action = actions.no_action;
			break;
		}
		cur_action_timeup++;
		break;
	case actions.ladder_exit:
		state = "Ladder exit";
		fixes.can_move = false;
		fixes.can_ladder_collide = false;
		fixes.can_gravity = false;
		var _ladder = collision_line(x, y, x, y + 2, o_lab_ladder, false, false);
		var _ladder2 = collision_point(x, y-60, o_lab_ladder, false, false);
		if(_ladder == noone){
			cur_action = actions.no_action;
			cur_action_timeup = 0;
			break;
		}
		xvel = 0;
		x = _ladder.x + _ladder.sprite_width/2;
		yvel = -2;
		if(_ladder2 == noone) _ladder2 = _ladder;
		if(((y - _ladder2.y) % 50 > 25) != ((y+yvel - _ladder2.y) % 50 > 25)){
			if((y - _ladder2.y ) % 50 > 25){
				if(_ladder2.type == 0)
					play_sfx(sfx_lab_hole_1);
				else
					play_sfx(sfx_lab_ladder_1);
			} else {
				if(_ladder2.type == 0)
					play_sfx(sfx_lab_hole_2);
				else
					play_sfx(sfx_lab_ladder_2);
			}
		}

		yvel = -LAB_LADDER_CLIMB_SPEED;

		if(!position_meeting(x, y + yvel, o_lab_ladder)){
			while(position_meeting(x, y, o_lab_ladder) && !place_meeting(x, y + sign(yvel), o_lab_wall)){
				y+=sign(yvel);
			}
			yvel = 0;
			cur_action = actions.no_action;
			cur_action_timeup = 0;
			break;
		}
		if(collision_point(x+55*-sign(image_xscale),y, o_lab_tunnel, false, false)){
			xvel = 2.5*sign(image_xscale);
		}
		cur_action_timeup++;
		break;
	case actions.chute:
		state = "Chute";
		fixes.can_move = false;
		fixes.can_ladder_collide = false;

		xvel = 0;
		if(state_sub == 0){
			state_temp_0 = x;
			state_temp_1 = y+60;
			yvel = -4;
			fixes.can_gravity = true;
			state_sub = 1;
		}
		if(state_sub == 1 && y >= state_temp_1){
			state_sub = 2;
		}
		
		if(state_sub == 2 && cur_action_timeup< 31){
			fixes.can_physics = false;
			yvel = 0;
			x = lerp(state_temp_0, 4340, (cur_action_timeup-1)/30);
			y = lerp(state_temp_1, 2350, (cur_action_timeup-1)/30);
			cur_action_timeup++;
		}
		if(cur_action_timeup >= 31 && cur_action_timeup< 61){
			yvel = 0;
			x = lerp(4340, 4840, (cur_action_timeup-31)/30);
			y = lerp(2350, 2650, (cur_action_timeup-31)/30);
			cur_action_timeup++;
		}
		if(cur_action_timeup >= 61 && cur_action_timeup < 90){
			fixes.can_physics = true;
			cur_action_timeup++;
		}
		if(cur_action_timeup >= 90){
			cur_action_timeup = 0;
			cur_action = actions.no_action;
		}
		break;
}

if(fixes.can_gravity){
	yvel = clamp(yvel + grav, -maxyvel, maxyvel);
}
grounded = false;

if(fixes.can_physics){
	if(place_meeting(x + xvel, y, o_lab_wall)){
		while(!place_meeting(x + sign(xvel), y, o_lab_wall)){
			x += sign(xvel);
		}
		xvel = 0;
	}
	x+= xvel;
	if(place_meeting(x, y + yvel, o_lab_wall)){
		while(!place_meeting(x, y + sign(yvel), o_lab_wall)){
			y += sign(yvel);
		}
		if(sign(yvel) >= 0){
			grounded = true;
		}
		yvel = 0;
	}
	var _hole = instance_place(x, y + sign(yvel), o_lab_hole);
	if(_hole != noone and _hole.collidable){
		while(!place_meeting(x, y + sign(yvel), o_lab_hole)){
			y += sign(yvel);
		}
		if(sign(yvel) >= 0){
			grounded = true;
		}
		yvel = 0;
	}
	if(fixes.can_ladder_collide && !place_meeting(x, y, o_lab_ladder) && place_meeting(x, y + yvel, o_lab_ladder)){
		while(!place_meeting(x, y + sign(yvel), o_lab_ladder)){
			y += sign(yvel);
		}
		if(sign(yvel) >= 0){
			grounded = true;
		}
		yvel = 0;
	}
	y+= yvel;
}




draw_offset_x = 0;
draw_offset_y = 0;
image_xscale= sign(image_xscale) * 1;
image_yscale= sign(image_yscale) * 1;
if(cur_action == actions.no_action){
	sprite_index = s_lab_carolina_walk;
	if(xvel != 0){
		image_xscale = sign(xvel);
	}
	if(abs(xvel) > .5){
		image_index += .25;
	} else {
		
	}
} else if(cur_action == actions.tunnel_enter){
	image_xscale= sign(image_xscale) * .9;
	image_yscale= sign(image_yscale) *.9;
	sprite_index = s_lab_carolina_tunnel_enter;
	image_index = min(4, cur_action_timeup/STATE_TUNNEL_ENTER_MAX * 5);
} else if(cur_action == actions.tunnel_exit){
	sprite_index = s_lab_carolina_tunnel_exit;
	image_index = min(3, cur_action_timeup/STATE_TUNNEL_EXIT_MAX * 4);
} else if(cur_action == actions.in_tunnel){
	draw_offset_y = -42;
	draw_offset_x = sign(image_xscale) * 8;
	if(xvel != 0){
		image_xscale = sign(xvel);
	}
	sprite_index = s_lab_carolina_crawl;
	image_xscale= sign(image_xscale) * .9;
	image_yscale= sign(image_yscale) *.9;
	
	if(abs(xvel) > .5){
		image_index += .25;
	} else {
		
	}
} else if(cur_action == actions.ladder_enter){
	sprite_index = s_lab_carolina_ladder;
	if(_ladder2.type == 1) sprite_index = s_lab_carolina_small_ladder;
	
	if(abs(yvel) > .5){
		image_index = (y - _ladder2.y) % 50 > (50/2);
	}	
} else if(cur_action == actions.on_ladder){
	sprite_index = s_lab_carolina_ladder;
	if(_ladder2.type == 1) sprite_index = s_lab_carolina_small_ladder;
	
	if(abs(yvel) > .5){
		image_index = (y - _ladder2.y ) % 50 > (50/2);
	}
} else if(cur_action == actions.ladder_exit){
	sprite_index = s_lab_carolina_tunnel_enter;
	image_index = min(4, cur_action_timeup/20 * 5);
	draw_offset_x = sign(image_xscale) * 20;
} else if(cur_action == actions.chute){
	sprite_index = s_lab_carolina_chute;
	if(cur_action_timeup == 0){
		image_index = 0;
	} else {
		image_index = 1;
	}

}
