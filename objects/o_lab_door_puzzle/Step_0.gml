for(i = 0; i < array_length(buttons_sequence); i++){
	if(buttons_sequence[i].clicked){
		if(i == sequence_index){
			//Increment the counter
			sequence_index++;
			switch(i % 4){
				case 0: play_sfx(sfx_lab_beep_1); break;
				case 1: play_sfx(sfx_lab_beep_2); break;
				case 2: play_sfx(sfx_lab_beep_3); break;
				case 3: play_sfx(sfx_lab_beep_4); break;
			}
		} else {
			//Reset
			if(i == 0){ //Edge case if first button is incorrectly pressed
				sequence_index = 1
				play_sfx(sfx_lab_beep_1);
			} else {
				sequence_index = 0;
			}
		}
	}
}

if(sequence_index == array_length(buttons_sequence)){
	//Puzzle is solved
	if(door!=noone){
		door.visible = false;
	}
	door_open.visible = true;
} else {
	if(door!=noone){
		door.visible = true;
	}
	door_open.visible = false;
}
