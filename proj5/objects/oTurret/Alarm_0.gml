var _inst = instance_create_layer(x,y,"Instances", oEnemBullet);
_inst.direction = (360/bulletSpiralCount) * bulletSpiralIterator;
_inst.speed = bulletSpiralSpeed;

alarm[0] = bulletSpiralInterval; // Get ready to (potentially) spawn the next bullet
bulletSpiralIterator++; // Increment the iterator
