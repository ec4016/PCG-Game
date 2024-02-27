if (!place_meeting(x+4, y, [obj_wall])) {
	bouncesLeft -= 1;
}

if (!place_meeting(x+4, y, [oTracker, oTurret])) {
	instance_destroy();
}

if (bouncesLeft <= 0) {
    instance_destroy();
}
else {
    move_bounce_solid(true);
}


//if (x > room_width) {
//    instance_destroy();
//}


