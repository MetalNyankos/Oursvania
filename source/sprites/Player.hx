package sprites;

import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.util.FlxTimer;

/**
 * ...
 * @author ...
 */
class Player extends FlxSprite
{	
	private var sword:FlxSprite;
	private var swordDelay:FlxTimer;
	private var jumping:Bool = false;
	private var falling:Bool = true;
	private var jumpedYpos:Float;

	public function new(?X:Float=0, ?Y:Float=0, ?SimpleGraphic:FlxGraphicAsset) 
	{
		super(X, Y, SimpleGraphic);
		
		makeGraphic(32, 32);
		
		sword = new FlxSprite(0, 0);
		sword.makeGraphic(32, 10);
		//sword.acceleration.y = 1000;
		FlxG.state.add(sword);
		sword.kill();
		
		swordDelay = new FlxTimer();
		
		acceleration.y = Reg.gravity;
	}
	
	override public function update(elapsed:Float):Void
	{	
		JumpControl();
		
		Controls();
		
		sword.x = x + width;
		sword.y = y;
		
		if (y > FlxG.height)
		{
			y = 0;
			x = 0;
		}
		
		super.update(elapsed);
	}
	
	private function JumpControl():Void
	{
		if (isTouching(FlxObject.FLOOR))
		{
			jumping = false;
			falling = false;
		}
		else
		{
			acceleration.y = Reg.gravity;
			if (!jumping)
			{
				falling = true;
			}
		}
	}
	
	private function Controls():Void
	{
		velocity.x = 0;
		
		if (FlxG.keys.pressed.D)
		{
			velocity.x = 200;
		}
		if (FlxG.keys.pressed.A)
		{
			velocity.x = -200;
		}
		if (FlxG.keys.justPressed.W && !jumping && !falling)
		{
			velocity.y = -400;
			jumpedYpos = y;
			jumping = true;
		}
		
		if (jumping)
		{
			Jump();
		}
		
		if (FlxG.keys.justPressed.K)
		{
			Attack();
		}
	}
	
	private function Jump():Void
	{
		if (FlxG.keys.pressed.W && !falling)
		{
			Reg.gravity = 0;
			
			if (y <= jumpedYpos - 150)
			{
				falling = true;
			}
		}
		else
		{
			velocity.y /= 4;
			jumping = false;
			falling = true;
			Reg.gravity = 1000;
		}
	}
	
	private function Attack():Void
	{
		sword.revive();
		swordDelay.start(0.2, KillSword, 1);
	}
	
	private function KillSword(swordDelay:FlxTimer):Void
	{
		sword.kill();
	}
}