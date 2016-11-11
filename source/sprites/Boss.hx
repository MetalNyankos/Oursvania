package sprites;

import flixel.FlxSprite;
import flixel.math.FlxRandom;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.FlxG;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.util.FlxTimer;
import flixel.math.FlxMath;
import flixel.FlxObject;
import flixel.tweens.FlxTween;
import flixel.math.FlxVelocity;
import sprites.Projectile;

/**
 * @author Maximiliano Viñas Craba
 */
class Boss extends FlxSprite
{	
	private var state:Int = 0; //0 : Idle / 1 - 3 : Patron / 4 : Patron en curso
	public var projectiles:FlxTypedGroup<Projectile>;
	private var stateTimer:FlxTimer;
	private var firingTimer:FlxTimer;
	public var pattern2:FlxTween;
	public var pattern3:FlxTween;
	private var pattern2Counter:Int = 0;
	private var pattern3Counter:Int = 0;
	private var hp:Int = 100;


	public function new(?X:Float=0, ?Y:Float=0, enemyProjectiles:FlxTypedGroup<Projectile>) 
	{		
		super(X, Y);	
		makeGraphic(32, 32, 0xFF804048);
		
		projectiles = enemyProjectiles;
		//acceleration.y = Reg.gravity;
		stateTimer = new FlxTimer();
		firingTimer = new FlxTimer();
		
		stateTimer.start(3, ChangeState, 0);
		
		pattern2 = FlxTween.tween(this, { x: X - 200, y: Y}, 0.5, 
		{ type : FlxTween.PINGPONG, onComplete: CompletePattern2, loopDelay: 1});
		pattern2.active = false;
				
		pattern3 = FlxTween.cubicMotion(this, this.x, this.y, this.x - 60, this.y - 80,
			this.x - 120, this.y - 120 , this.x - 180, this.y, 1,
			{ type : FlxTween.PINGPONG, onComplete: CompletePattern3, loopDelay: 1});
		
		pattern3.active = false;
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
				Pattern3();
				state = 4;
		}	
		
	}
	
	private function CompletePattern2(tween:FlxTween):Void
	{
		pattern2Counter++;
		if (pattern2Counter == 2)
		{
			pattern2.active = false;
			state = 0;
			pattern2Counter = 0;
		}
	}
	
	private function CompletePattern3(tween:FlxTween):Void
	{
		pattern3Counter++;
		if (pattern3Counter == 4)
		{
			pattern3.active = false;
			state = 0;
			pattern3Counter = 0;
		}
	}
	
	private function Pattern3():Void
	{
		pattern3.active = true;
	}
	
	private function Pattern2():Void
	{
		pattern2.active = true;	
	}
	
	private function Pattern1():Void
	{
		firingTimer.start(0.5, Pattern1Fire, 3);
	}
	
	private function Pattern1Fire(Timer:FlxTimer):Void
	{
		var projectile = new Projectile(this.x + 8, this.y + 8, -100);
		projectiles.add(projectile);
		
		if (firingTimer.finished)
		{
			state = 0;
		}
	}
	
	private function ChangeState(Timer:FlxTimer):Void
	{
		if (state == 0)
		{
			var r:FlxRandom = new FlxRandom();
			state = r.int(1, 3);
			trace("Estado actual : " + state);
		}
	}
	
	public function Damage(damagePoints:Int):Void
	{
		hp -= damagePoints;
		if (hp <= 0)
		{
			kill();
		}
	}
}