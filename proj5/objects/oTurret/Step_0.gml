if (point_distance(obj_player.x, obj_player.y, x, y) < ENEM_DISTANCE) {
	//alarm[0] = 1; // Start spawning bullets the next step;
	shoot();
}

function shoot() {
	var _inst = instance_create_layer(x,y,"Instances", oEnemBullet);
	_inst.direction = (360/bulletSpiralCount) * bulletSpiralIterator;
	_inst.speed = bulletSpiralSpeed;

	//shoot(); // Get ready to (potentially) spawn the next bullet
	bulletSpiralIterator++; // Increment the iterator
}

if (turretLives <= 0) {
	chance = random(100);
	if (chance <= global.dropRate && dm.currLevel > 10) {
		powerup = instance_create_layer(x, y, "Instances", choose(oRichochet, oBomb));
	}
	instance_destroy();
}