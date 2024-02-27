if ((obj_player.x - self.x) > ENEM_DISTANCE || (obj_player.y - self.y) > ENEM_DISTANCE) {
	alarm[0] = 1; // Start spawning bullets the next step;
}