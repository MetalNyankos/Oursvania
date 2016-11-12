package sprites;

import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.FlxG;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.util.FlxTimer;
import flixel.util.FlxColor;
import sprites.Projectile;

/**
 * @author Maximiliano Viñas Craba
 */
class Enemy4 extends FlxSprite
{
	public var projectiles:FlxTypedGroup<Projectile>;
	private var patterTimer:Int = 0;
	private var stepsCounter:Int = 0;
	public var shield:Bool = true;
	
	public function new(?X:Float=0, ?Y:Float=0, enemyProjectiles:FlxTypedGroup<Projectile>) 
	{
		super(X, Y);
		makeGraphic(16, 32, 0xFF0000FF);
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
		if (patterTimer == 120)
		{
			shield = false;
			var projectile = new Projectile(this.x + 8, this.y + 8, -100);
			projectiles.add(projectile);
			
		}
		
		if (patterTimer == 180)
		{
			shield = true;
			patterTimer = 0;
		}
		
		patterTimer++;
	}
}