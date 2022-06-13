enum actions {
	no_action,
	jump,
	tunnel_enter,
	tunnel_exit,
	in_tunnel,
	ladder_enter,
	ladder_exit,
	on_ladder,
	chute,
}
cur_action = actions.no_action;
cur_action_timeup = 0;
state_sub = 0;
state_temp_0 = 0;
state_temp_1 = 0;
state_temp_2 = 0;

fixes = {
	can_move: true,
	can_physics: true,
	can_ladder_collide: true,
	can_gravity: false,
}

maxyvel = 16;
maxxvel = 7;
accel = 2;
decel = .75;

grounded = false;
xvel = 0;
yvel = 0;
grav = .45;
jumpvel = -20;

ladder_enter_dir = 0;
#macro LAB_LADDER_CLIMB_SPEED 7

#macro STATE_TUNNEL_ENTER_MAX 45
#macro STATE_TUNNEL_EXIT_MAX 45
#macro STATE_LADDER_ENTER_MAX 15

draw_offset_x = 0;
draw_offset_y = 0;

state = "";
