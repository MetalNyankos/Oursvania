package sprites;

import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;

/**
 * @author Maximiliano Viñas Craba
 */
class Sword extends FlxSprite
{

	public function new(?X:Float=0, ?Y:Float=0, ?SimpleGraphic:FlxGraphicAsset) 
	{
		super(X, Y, SimpleGraphic);
		this.loadGraphic(AssetPaths.Sword_Attack__png, true, 17, 17);
		this.animation.add("normal", [10, 9, 8, 7, 6, 5, 4, 3, 2, 1], 50, false);
	}
	
}