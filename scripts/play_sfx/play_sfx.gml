// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function play_sfx(sound){
	audio_stop_sound(sound);
	audio_play_sound(sound, 100, false);
}