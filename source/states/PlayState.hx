package states;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.math.FlxMath;
import sprites.Player;

class PlayState extends FlxState
{
	private var platform:FlxSprite;
	private var player:Player;
	
	override public function create():Void
	{
		super.create();
		
		platform = new FlxSprite(0, 230);
		platform.makeGraphic(100, 16);
		platform.immovable = true;
		
		player = new Player(0, 0);
		
		add(platform);
		add(player);
		
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		
		FlxG.collide(platform, player);
	}
}
