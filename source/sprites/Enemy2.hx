package sprites;

import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.FlxG;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.util.FlxTimer;
import sprites.Projectile;

/**
 * ...
 * @author Maximiliano Viñas Craba
 */

 class Enemy2 extends FlxSprite
{

	public var projectiles:FlxTypedGroup<Projectile>;
	public var pointValue:Int = 400;
	private var firingTimer:FlxTimer;
	
	public function new(?X:Float=0, ?Y:Float=0, enemyProjectiles:FlxTypedGroup<Projectile>) 
	{		
		super(X, Y);	
		makeGraphic(16, 32, 0xFF804000);
		projectiles = enemyProjectiles;
		firingTimer = new FlxTimer();
		firingTimer.start(2, Fire, 0);
		acceleration.y = Reg.gravity;
	}	
	
	public function Fire(Timer:FlxTimer):Void
	{
		if (alive)
		{
			var highProjectile = new Projectile(this.x + 8, this.y + 8, 100);
			var lowProjectile = new Projectile(this.x + 8, this.y + 16, -100);
			projectiles.add(highProjectile);
			projectiles.add(lowProjectile);
		}
	}
}