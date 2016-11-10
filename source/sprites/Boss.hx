package sprites;

import flixel.FlxSprite;
import flixel.math.FlxRandom;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.FlxG;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.util.FlxTimer;
import flixel.math.FlxMath;
import flixel.FlxObject;
import sprites.Projectile;

/**
 * ...
 * @author Maximiliano Viñas Craba
 */
class Boss extends FlxSprite
{	
	private var state:Int = 0; //0 : Idle / 1 - 3 : Patron / 4 : Patron en curso
	public var projectiles:FlxTypedGroup<Projectile>;
	private var stateTimer:FlxTimer;
	private var firingTimer:FlxTimer;


	public function new(?X:Float=0, ?Y:Float=0, enemyProjectiles:FlxTypedGroup<Projectile>) 
	{		
		super(X, Y);	
		makeGraphic(32, 32, 0xFF804048);
		projectiles = enemyProjectiles;
		acceleration.y = Reg.gravity;
		stateTimer = new FlxTimer();
		firingTimer = new FlxTimer();
		stateTimer.start(3, ChangeState, 0);
	}
	
	override public function update(elapsed:Float):Void 
	{
		super.update(elapsed);
		switch(state)
		{
			case 1:
				Pattern1();
				state = 4;
			case 2:
				Pattern2();
				state = 4;
			case 3:
				
		}
		
	}
	
	private function Pattern2():Void
	{
		var bounceCounter:Int = 0;
		velocity.x = -200;
		
		while (velocity.x < 0)
		{
			velocity.x += 0.001;
		}
		
		velocity.x = 200;
		
	}
	
	private function Pattern1():Void
	{
		firingTimer.start(0.5, Pattern1Fire, 3);
	}
	
	private function Pattern1Fire(Timer:FlxTimer):Void
	{
		var projectile = new Projectile(this.x + 8, this.y + 8, -100);
		projectiles.add(projectile);
	}
	
	private function ChangeState(Timer:FlxTimer):Void
	{
		if (state == 0)
		{
			var r:FlxRandom = new FlxRandom();
			//state = r.int(1, 3);
			state = 2;
			trace("Estado actual : " + state);
		}
	}
}