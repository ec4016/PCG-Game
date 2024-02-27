if (place_meeting(x+4, y, [oTracker, oTurret])) {
	instance_destroy();
}


if (RICHOCHET) {
	if (place_meeting(x+4, y, [obj_wall])) {
		bouncesLeft -= 1;
	}


	if (bouncesLeft <= 0) {
	    instance_destroy();
	}
	else {
			move_bounce_solid(true);
	}
}

else {
	if (place_meeting(x+4, y, [obj_wall])) {
		instance_destroy();
	}
}

//if (x > room_width) {
//    instance_destroy();
//}


