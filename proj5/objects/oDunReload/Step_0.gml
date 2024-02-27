if (!place_meeting(x+4, y, [obj_player])) {
	GenerateNewDungeon();
	instance_destroy();
}