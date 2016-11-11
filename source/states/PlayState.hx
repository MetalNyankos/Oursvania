package states;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.math.FlxMath;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.addons.editors.ogmo.FlxOgmoLoader;
import flixel.tile.FlxTilemap;
import flixel.util.FlxTimer;
import flixel.FlxObject;
import sprites.Enemy1;
import sprites.Enemy2;
import sprites.Enemy3;
import sprites.Enemy4;
import sprites.Boss;
import sprites.Player;
import sprites.Projectile;
import sprites.Spikes;

class PlayState extends FlxState
{
	public var enemyProjectiles:FlxTypedGroup<Projectile>;
	private var mapTiles:FlxTilemap;
	public var enemiesType1:FlxTypedGroup<Enemy1>;
	public var enemiesType2:FlxTypedGroup<Enemy2>;
	public var enemiesType3:FlxTypedGroup<Enemy3>;
	public var enemiesType4:FlxTypedGroup<Enemy4>;
	public var spikes:FlxTypedGroup<Spikes>;
	public var screenPositionX:Float = 0;
	private var player:Player;
	public var boss:Boss;
	//public var screenSpeed:Float = 1;
	//public var scroll:Bool = true;
	private var turretFireTimer:FlxTimer;

	
	override public function create():Void
	{
		super.create();
			
		var loader:FlxOgmoLoader = new FlxOgmoLoader(AssetPaths.LevelJuego3__oel);
		mapTiles = loader.loadTilemap(AssetPaths.Piso1__png , 16, 16, "Pisos");
		add(mapTiles);
		
		spikes = new FlxTypedGroup<Spikes>();
		add(spikes);
		
		enemyProjectiles = new FlxTypedGroup<Projectile>();		
		add(enemyProjectiles);
		
		enemiesType1 = new FlxTypedGroup<Enemy1>();
		add(enemiesType1);
		
		enemiesType2 = new FlxTypedGroup<Enemy2>();
		add(enemiesType2);
		
		enemiesType3 = new FlxTypedGroup<Enemy3>();
		add(enemiesType3);
		
		enemiesType4 = new FlxTypedGroup<Enemy4>();
		add(enemiesType4);
		
		loader.loadEntities(drawEntities, "entities");
		
		FlxG.camera.setScrollBounds(0, mapTiles.width, 0, mapTiles.height);
		FlxG.camera.follow(player);
		//FlxG.camera.scroll = new FlxPoint(player.x,player.y);
		//scroll = true;
		
		mapTiles.setTileProperties(1, FlxObject.ANY);
		
		FlxG.worldBounds.set(0, 0, mapTiles.width, mapTiles.height);
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		
		FlxG.collide(mapTiles, player);
		FlxG.collide(mapTiles, enemiesType1);
		FlxG.collide(mapTiles, enemiesType2);
		FlxG.collide(mapTiles, enemiesType3);
		FlxG.collide(mapTiles, enemiesType4);
		FlxG.collide(mapTiles, enemyProjectiles);
		FlxG.collide(mapTiles, boss);
		ActivateEnemies();
		Collisions();
		
		for (projectile in enemyProjectiles)
		{
			if (projectile.isTouching(FlxObject.ANY))
			{
				enemyProjectiles.remove(projectile);
				projectile.destroy();
			}
		}
	}
	
	private function Collisions():Void
	{	

		FlxG.overlap(player, enemiesType1, null, CollsionHandler);
		FlxG.overlap(player, enemiesType2, null, CollsionHandler);
		FlxG.overlap(player, enemiesType3, null, CollsionHandler);
		FlxG.overlap(player, enemiesType4, null, CollsionHandler);
		FlxG.overlap(player, enemiesType4, null, CollsionHandler);
		FlxG.overlap(player, spikes, null, CollsionHandler);
		FlxG.overlap(player, enemyProjectiles, null, CollsionHandler);

		if (player.sword.alive)
		{
			SwordCollisions();
		}
	}
	
	private function SwordCollisions():Void
	{
		
		for (enemy1 in enemiesType1)
		{
			if (FlxG.pixelPerfectOverlap(player.sword, enemy1))
			{
				enemiesType1.remove(enemy1);
				enemy1.kill();
			}
		}
			
		for (enemy2 in enemiesType2)
		{
			if (FlxG.pixelPerfectOverlap(player.sword, enemy2))
			{
				enemiesType2.remove(enemy2);
				enemy2.kill();
			}
		}
		
		for (enemy3 in enemiesType3)
		{
			if (FlxG.pixelPerfectOverlap(player.sword, enemy3))
			{
				enemiesType3.remove(enemy3);
				enemy3.kill();
			}
		}
		
		for (enemy4 in enemiesType4)
		{
			if (FlxG.pixelPerfectOverlap(player.sword, enemy4))
			{
				enemiesType4.remove(enemy4);
				enemy4.kill();
			}
		}
		
		for (enemyProjectile in enemyProjectiles)
		{
			if (FlxG.pixelPerfectOverlap(player.sword, enemyProjectile))
			{
				enemyProjectiles.remove(enemyProjectile);
				enemyProjectile.destroy();
			}
		}
	}
	
	private function CollsionHandler(Sprite1:FlxObject, Sprite2:FlxObject):Bool
	{
		var sprite1ClassName:String = Type.getClassName(Type.getClass(Sprite1));
		var sprite2ClassName:String = Type.getClassName(Type.getClass(Sprite2));
		if (sprite1ClassName == "sprites.Player" &&
		(sprite2ClassName == "sprites.Enemy1" || sprite2ClassName == "sprites.Enemy2" ||
		sprite2ClassName == "sprites.Enemy3" || sprite2ClassName == "sprites.Enemy4" ||
		sprite2ClassName == "sprites.Spikes"))
		{
			player.Damage();
			return true;
		}
		
		if (sprite1ClassName == "sprites.Player" && sprite2ClassName == "sprites.Projectile")
		{			
			var projectile: Dynamic = cast(Sprite2, Projectile);
		
			enemyProjectiles.remove(projectile);
			player.Damage();				

			return true;
		}
		
		if (sprite1ClassName == "sprites.Sword" && sprite2ClassName == "sprites.Enemy1"){
			var enemy: Dynamic = cast(Sprite2, Enemy1);
			
			enemiesType1.remove(enemy);
			enemy.kill();
			return true;
		}
		
		if (sprite1ClassName == "sprites.Sword" && sprite2ClassName == "sprites.Enemy2"){
			var enemy: Dynamic = cast(Sprite2, Enemy2);
			
			enemiesType2.remove(enemy);
			enemy.kill();
			return true;
		}
		
		if (sprite1ClassName == "sprites.Sword" && sprite2ClassName == "sprites.Enemy3"){
			var enemy: Dynamic = cast(Sprite2, Enemy3);
			
			enemiesType3.remove(enemy);
			enemy.kill();
			return true;
		}

		if (sprite1ClassName == "sprites.Sword" && sprite2ClassName == "sprites.Enemy4"){
			var enemy: Dynamic = cast(Sprite2, Enemy4);
			
			enemiesType4.remove(enemy);
			enemy.kill();
			return true;
		}
		
		return false;
	}
	
	private function ActivateEnemies()
	{
		for (enemy in enemiesType1)
		{
			if (InCameraBounds(enemy))
			{
				enemy.revive();
			}
		}
		
		for (enemy in enemiesType2)
		{
			if (InCameraBounds(enemy))
			{
				enemy.revive();
			}
		}
		
		for (enemy in enemiesType3)
		{
			if (InCameraBounds(enemy))
			{
				enemy.revive();
			}
		}
		
		for (enemy in enemiesType4)
		{
			if (InCameraBounds(enemy))
			{
				enemy.revive();
			}
		}
		
		for (spike in spikes)
		{
			if (InCameraBounds(spike))
			{
				spike.revive();
			}
		}
		
		if (InCameraBounds(boss))
		{
			boss.revive();
		}
	}
	
	private function InCameraBounds(sprite:FlxSprite):Bool
	{
		var newScroll = FlxG.camera.scroll;

		if (sprite.x > newScroll.x + Reg.ScreenWidth + 16)
		{
			return false;
		}
		if (sprite.x < newScroll.x - 16)
		{
			return false;
		}
		if (sprite.y + sprite.height > newScroll.y + Reg.ScreenHeight)
		{
			return false;
		}
		if (sprite.y < newScroll.y)
		{
			return false;
		}
		return true;
	}
	
	private function drawEntities(entityName:String, entityData:Xml):Void
	{
		if (entityName == "Player")
		{
			var X:Float = Std.parseFloat(entityData.get("x"));
			var Y:Float = Std.parseFloat(entityData.get("y"));
			
			//playerBullets = new FlxTypedGroup<Bullet>();		
			//add(playerBullets);
			
			player = new Player(X, Y);
			add(player);
		}

		if (entityName == "Enemy1")
		{
			var X:Float = Std.parseFloat(entityData.get("x"));
			var Y:Float = Std.parseFloat(entityData.get("y"));
			
			var enemy:Enemy1;
			enemy = new Enemy1(X, Y);
			enemy.kill();
			enemiesType1.add(enemy);
		}
		
		if (entityName == "Enemy2")
		{
			var X:Float = Std.parseFloat(entityData.get("x"));
			var Y:Float = Std.parseFloat(entityData.get("y"));
			
			var enemy:Enemy2;
			enemy = new Enemy2(X, Y, enemyProjectiles);
			enemy.kill();
			enemiesType2.add(enemy);
		}
		
		if (entityName == "Enemy3")
		{
			var X:Float = Std.parseFloat(entityData.get("x"));
			var Y:Float = Std.parseFloat(entityData.get("y"));
			
			var enemy:Enemy3;
			enemy = new Enemy3(X, Y, enemyProjectiles);
			enemy.kill();
			enemiesType3.add(enemy);
		}
		
		if (entityName == "Enemy4")
		{
			var X:Float = Std.parseFloat(entityData.get("x"));
			var Y:Float = Std.parseFloat(entityData.get("y"));
			
			var enemy:Enemy4;
			enemy = new Enemy4(X, Y, enemyProjectiles);
			enemy.kill();
			enemiesType4.add(enemy);
		}
		
		if (entityName == "Boss")
		{
			var X:Float = Std.parseFloat(entityData.get("x"));
			var Y:Float = Std.parseFloat(entityData.get("y"));
			
			boss = new Boss(X, Y, enemyProjectiles);
			boss.kill();
			add(boss);
		}
		
		if (entityName == "Spikes")
		{
			var X:Float = Std.parseFloat(entityData.get("x"));
			var Y:Float = Std.parseFloat(entityData.get("y"));
			
			var spike:Spikes;
			spike = new Spikes(X, Y);
			spike.kill();
			spikes.add(spike);
		}
	}
}
