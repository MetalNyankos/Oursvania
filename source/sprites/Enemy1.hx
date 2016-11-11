package sprites;

import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.FlxObject;

/**
 * ...
 * @author Maximiliano Viñas Craba
 */
class Enemy1 extends FlxSprite
{

	private var patternTimer : Int = 0;
	private var patternCounter : Int = 0;
	private var up : Bool = false;
	private var movementSpeed:Float = 1.0;
	
	public function new(?X:Float=0, ?Y:Float=0) 
	{		
		super(X, Y);	
		makeGraphic(16, 16, 0xFF804048);
	}
	
	override public function update(elapsed:Float):Void 
	{
		super.update(elapsed);
		Movement();
	}
	
	public function Movement():Void
	{
		if (patternTimer % 32 == 0)
		{
			up = (up) ? false : true;
			patternCounter++;
			
			if (patternCounter == 4)
			{
				movementSpeed *= -1;
				patternCounter = 0;
			}
		}
		if (up) 
		{
			this.y++;
		}
		else 
		{
			this.y--;
		}
		
		this.x -= movementSpeed;
		patternTimer++;		
	}	
}