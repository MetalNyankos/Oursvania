package sprites;

import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.math.FlxVelocity;
import flixel.math.FlxPoint;
import flixel.group.FlxGroup.FlxTypedGroup;

/**
 * ...
 * @author Maximiliano Viñas Craba
 */
class Projectile extends FlxSprite
{	
	public var projectiles:FlxTypedGroup<Projectile>;

	public function new(?X:Float=0, ?Y:Float=0, Velocity:Int, ?YVelocity:Int) 
	{
		super(X, Y);
		makeGraphic(5, 5);
		velocity.x = Velocity; 
		if (YVelocity != null)
		{
			velocity.y = YVelocity; 
		}
	}
	
	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
	}
}