package sprites;

import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;

/**
 * ...
 * @author Maximiliano Viñas Craba
 */
class Enemy1 extends FlxSprite
{

	private var patterTimer : Int = 0;
	private var up : Bool = false;
	public var pointValue:Int = 300;
	
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
		if (patterTimer % 32 == 0)
		{
			up = (up) ? false : true;
		}
		if (up) 
		{
			this.y++;
		}
		else 
		{
			this.y--;
		}
		this.x-= 0.5;
		patterTimer++;
	}	
}