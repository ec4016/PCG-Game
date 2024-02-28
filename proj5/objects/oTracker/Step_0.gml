//var test = (point_distance(obj_player.x, obj_player.y, x, y));
//show_debug_message(string(test));
if (point_distance(obj_player.x, obj_player.y, x, y) < ENEM_DISTANCE) {
	show_debug_message("close to tracker");
	self.image_angle = point_direction(x, y, obj_player.x, obj_player.y);
	move_towards_point(obj_player.x, obj_player.y, trackerSpeed);
	//track();
}
else {
	speed = 0;
}

if (trackerLives <= 0) {
	chance = random(100);
	if (chance <= global.dropRate && dm.currLevel > 10) {
		powerup = instance_create_layer(x, y, "Instances", choose(oRichochet, oBomb));
	}
	instance_destroy();
}