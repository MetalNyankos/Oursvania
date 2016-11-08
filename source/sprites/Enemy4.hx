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
class Enemy4 extends FlxSprite
{
	public var projectiles:FlxTypedGroup<Projectile>;
	private var patterTimer:Int = 0;
	private var stepsCounter:Int = 0;
	private var shield:FlxSprite;
	
	public function new(?X:Float=0, ?Y:Float=0, enemyProjectiles:FlxTypedGroup<Projectile>) 
	{
		super(X, Y);
		makeGraphic(16, 32, 0xFF0000FF);
		projectiles = enemyProjectiles;
		shield = new FlxSprite(this.x - 10, this.y);
		shield.makeGraphic(5, 32, 0xFF00FFFF);
		FlxG.state.add(shield);
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
			shield.kill();
			var projectile = new Projectile(this.x + 8, this.y + 8, -100);
			projectiles.add(projectile);
			
		}
		
		if (patterTimer == 180)
		{
			shield.revive();
			patterTimer = 0;
		}
		
		patterTimer++;
	}
}