package sprites;

import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.util.FlxTimer;
import flixel.group.FlxGroup.FlxTypedGroup;
import sprites.Sword;
import sprites.Projectile;

/**
 * ...
 * @author ...
 */
class Player extends FlxSprite
{	
	public var sword:Sword;
	private var swordDelay:FlxTimer;
	private var jumping:Bool = false;
	private var falling:Bool = true;
	private var wallJump:Int = 0;
	private var wallJumpImpulseTime:Float = 0;
	private var jumpingTime:FlxTimer;
	private var wallGrabbed:Bool = false;
	private var wallGrabTime:Float = 0;
	private var playerVelX:Float = Reg.playerVelX;
	private var normalSprite:FlxSprite;
	public var projectiles:FlxTypedGroup<Projectile>;
	private var ammo:Int = 0;
	private var projectileSpeed:Int = 100;

	public function new(?X:Float=0, ?Y:Float=0, playerProjectiles:FlxTypedGroup<Projectile>) 
	{
		super(X, Y);
		
		makeGraphic(16, 16);
		
		sword = new Sword(0, 0);
		FlxG.state.add(sword);
		sword.kill();
		
		jumpingTime = new FlxTimer();
		
		acceleration.y = Reg.gravity;
		
		projectiles = playerProjectiles;
		
		ammo = 5;
		
		normalSprite = new FlxSprite();
		normalSprite.loadGraphic(AssetPaths.Player_Walking_Plasma_Gun__png, true, 19, 32);
		normalSprite.animation.add("walking", [1, 2, 3, 4, 5], 30, true);
		normalSprite.animation.add("idle", [1], 0, false);
		
		this.loadGraphicFromSprite(normalSprite);
	}
	
	override public function update(elapsed:Float):Void
	{	
		JumpControl();
		
		Controls();
		
		if (wallGrabbed)
		{
			wallGrabTime += elapsed;
		}
		
		if (wallGrabTime >= Reg.wallJumpAssist)
		{
			wallGrabTime = 0;
			wallGrabbed = false;
		}
		
		if (wallJump != 0 && jumping)
		{
			wallJumpImpulseTime += elapsed;
			playerVelX += 100;
		}
		
		super.update(elapsed);
		
		if (!this.flipX)
		{
			sword.x = x + width;
			sword.y = y;
		}
		else
		{
			sword.x = x - sword.width;
			sword.y = y;
		}
	}
	
	private function WallJump():Void
	{
		if ((FlxG.keys.pressed.A || FlxG.keys.pressed.D) && !isTouching(FlxObject.FLOOR))
		{
			if (isTouching(FlxObject.WALL) && !jumping)
			{
				velocity.y = 5;
				
				wallGrabbed = true;
				
				if (isTouching(FlxObject.LEFT))
				{
					wallJump = 1;
					//wallJumpImpulse = Reg.wallJumpImpulse;
				}
				else if (isTouching(FlxObject.RIGHT))
				{
					wallJump = -1;
					//wallJumpImpulse = -Reg.wallJumpImpulse;
				}
			}
		}
		
		if (wallGrabbed || (wallGrabTime < Reg.wallJumpAssist && wallGrabTime > 0))
		{
			falling = true;
			
			jumpingTime.cancel();
				
			if (FlxG.keys.justPressed.K)
			{
				//wallJumpImpulse = Reg.wallJumpImpulse;
				wallGrabbed = false;
				wallGrabTime = 0;
				jumpingTime.start(Reg.jumpingDelay, StopJumping, 1);
				jumping = true;
				falling = false;
			}
			
		}
		
	}
	
	private function JumpControl():Void
	{
		if (isTouching(FlxObject.FLOOR))
		{
			jumping = false;
			falling = false;
			jumpingTime.cancel();
			wallGrabbed = false;
			wallJump = 0;
			wallGrabTime = 0;
			playerVelX = Reg.playerVelX;
			
			this.loadGraphicFromSprite(normalSprite);
			
			if (this.acceleration.x == 0)
			{
				this.animation.play("idle");
			}
		}
		else
		{
			acceleration.y = Reg.gravity;
			if (!jumping)
			{
				falling = true;
			}
		}
		
		if (isTouching(FlxObject.CEILING))
		{
			falling = true;
			Reg.gravity = 1000;
		}
	}
	
	private function Controls():Void
	{
		if (acceleration.x != 0)
		{
			acceleration.x = 0;
		}
		if (velocity.x < 0)
		{
			velocity.x += -(velocity.x) / 10;
		}
		else if (velocity.x > 0)
		{
			velocity.x -= velocity.x / 10;
		}
		
		if (FlxG.keys.pressed.D)
		{
			acceleration.x = playerVelX;
			this.animation.play("walking");
			this.flipX = false;
			sword.flipX = false;
			
			if (projectileSpeed < 0)
			{
				projectileSpeed *= -1;
			}
			//velocity.x = Reg.playerVelX;
		}
		if (FlxG.keys.pressed.A)
		{
			acceleration.x = -playerVelX;
			this.animation.play("walking");
			this.flipX = true;
			sword.flipX = true;
			
			if (projectileSpeed > 0)
			{
				projectileSpeed *= -1;
			}
			//velocity.x = -Reg.playerVelX;
		}
		if (FlxG.keys.justPressed.Z)
		{
			Shoot();
		}
		if (FlxG.keys.justPressed.K && !jumping && !falling)
		{
			jumpingTime.start(Reg.jumpingDelay, StopJumping, 1);
			jumping = true;
		}
		
		WallJump();
		
		if (jumping)
		{
			Jump();
		}
		
		if (FlxG.keys.justPressed.J)
		{
			Attack();
		}
	}
	
	private function Shoot():Void
	{
		if (ammo > 0)
		{
			var projectile = new Projectile(this.x + 8, this.y + 8, projectileSpeed);
			projectiles.add(projectile);
			ammo--;
		}
	}
	
	private function Jump():Void
	{
		if (FlxG.keys.pressed.K && !falling)
		{
			Reg.gravity = 0;
			velocity.y = -300;
			if (wallJump > 0)
			{
				//Reg.gravity = 0;
				//velocity.y = -300;
				acceleration.x = Reg.wallJumpImpulse;
				wallJump = 0;
				//velocity.x = 1000;
				//acceleration.x = Reg.wallJumpImpulse;
			}
			if (wallJump < 0)
			{
				//Reg.gravity = 0;
				//velocity.y = -300;
				acceleration.x = -Reg.wallJumpImpulse;
				wallJump = 0;
				//velocity.x = -1000;
				//acceleration.x = -Reg.wallJumpImpulse;
			}
		}
		
		else
		{
			//playerVelX = 0;
			velocity.y /= 4;
			jumping = false;
			falling = true;
			Reg.gravity = 1000;
		}
	}
	
	private function Attack():Void
	{
		swordDelay = new FlxTimer();
		sword.revive();
		sword.animation.play("normal");
		swordDelay.start(0.1, KillSword, 1);
	}
	
	private function KillSword(swordDelay:FlxTimer):Void
	{
		sword.animation.finish();
		sword.kill();
		swordDelay.destroy();
	}
	
	public function Damage():Void
	{
		trace("ouch");
	}
	
	private function StopJumping(timer:FlxTimer):Void
	{
		//playerVelX = 0;
		wallJumpImpulseTime = 0;
		//wallJump = 0;
		playerVelX = Reg.playerVelX;
		wallJump = 0;
		falling = true;
	}
}