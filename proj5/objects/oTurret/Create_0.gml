attack_cooldown = 0;
turretLives = 3;

bulletSpiralCount = 18; // Amount of bullets to be spawned
bulletSpiralIterator = 0; // Iterator used for spawning bullets
bulletSpiralInterval = 3*game_get_speed(gamespeed_fps); // Spawn 8 bullets/sec
bulletSpiralSpeed = 1; // Speed of the bullet