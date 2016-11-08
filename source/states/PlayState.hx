package states;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.math.FlxMath;
import flixel.group.FlxGroup.FlxTypedGroup;
import sprites.Enemy1;
import sprites.Enemy2;
import sprites.Enemy3;
import sprites.Enemy4;
import sprites.Player;
import sprites.Projectile;

class PlayState extends FlxState
{
	private var platform:FlxSprite;
	private var player:Player;
	private var enemy1:Enemy1;
	private var enemy2:Enemy2;
	private var enemy3:Enemy3;
	private var enemy4:Enemy4;
	public var enemyProjectiles:FlxTypedGroup<Projectile>;

	
	override public function create():Void
	{
		super.create();
		
		enemyProjectiles = new FlxTypedGroup<Projectile>();		
		add(enemyProjectiles);
		
		platform = new FlxSprite(0, 230);
		platform.makeGraphic(100, 16);
		platform.immovable = true;
		
		player = new Player(0, 0);
		
		enemy1 = new Enemy1(200, 10);
		enemy2 = new Enemy2(100, 70, enemyProjectiles);
		enemy3 = new Enemy3(200, 120, enemyProjectiles);
		enemy4 = new Enemy4(200, 200, enemyProjectiles);
		
		add(platform);
		add(player);
		add(enemy1);
		add(enemy2);
		add(enemy3);
		add(enemy4);
		
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		
		FlxG.collide(platform, player);
	}
}
