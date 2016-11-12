package sprites;

import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.util.FlxTimer;
/**
 * ...
 * @author Maximiliano Viñas Craba
 */
class Barrier extends FlxSprite
{
	private var toggleTimer:FlxTimer;
	public function new(?X:Float=0, ?Y:Float=0, ?SimpleGraphic:FlxGraphicAsset) 
	{
		super(X, Y, SimpleGraphic);
		makeGraphic(8, 30, 0xFF45FF12);
		toggleTimer = new FlxTimer();
		toggleTimer.start(2, toggleBarrier, 0);
	}
	
	private function toggleBarrier(Timer:FlxTimer)
	{
		if (alive)
		{
			kill();
		}
		else
		{
			revive();
		}
	}
	
}