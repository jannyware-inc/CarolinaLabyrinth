/// @description Insert description here
// You can write your code in this editor
clicked = false;
if(position_meeting(mouse_x, mouse_y, id)){
	global.clickable = true;
	image_index = unpressed_index + pressed_offset;
	if(mouse_check_button_pressed(mb_left)){
		clicked = true;
	}
} else {
	image_index = unpressed_index;
}
