dm.richochetProb += 0.05;
dm.highestLevel += 1;


if (instance_number(oTracker) > 0 || instance_number(oTurret) > 0
	|| instance_number(oTrackShooter) > 0) {
	
	if ((currLevel + 1) mod 5 == 0) {
		room_goto(rmGetUpgade);
	}
	else {
		dm.currLevel += 1;
		dm.GenerateNewDungeon();
		instance_destroy();
	}
}	