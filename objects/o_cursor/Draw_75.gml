/// @description Insert description here
// You can write your code in this editor
if(global.clickable){
	draw_sprite(s_cursor_click, 0, device_mouse_x_to_gui(0), device_mouse_y_to_gui(0));
} else {
	draw_sprite(s_cursor_default, 0, device_mouse_x_to_gui(0), device_mouse_y_to_gui(0));
}
global.clickable = false;
