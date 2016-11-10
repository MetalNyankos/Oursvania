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
class Enemy3 extends FlxSprite
{
	public var projectiles:FlxTypedGroup<Projectile>;
	private var patterTimer:Int = 0;
	private var stepsCounter:Int = 0;
	
	public function new(?X:Float=0, ?Y:Float=0, enemyProjectiles:FlxTypedGroup<Projectile>) 
	{
		super(X, Y);
		makeGraphic(16, 32, 0xFF00FF00);
		projectiles = enemyProjectiles;
		acceleration.y = Reg.gravity;
	}
	
	override public function update(elapsed:Float):Void 
	{
		super.update(elapsed);
		Movement();
	}
	
	public function Movement():Void
	{
		if (patterTimer == 60)
		{
			this.x -= 10;
			patterTimer = 0;
			stepsCounter++;
		}
		
		if (stepsCounter == 3)
		{
			var projectile = new Projectile(this.x + 8, this.y + 8, -100);
			projectiles.add(projectile);
			stepsCounter = 0;
		}
		patterTimer++;
	}
}