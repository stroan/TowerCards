package ;

import openfl.Assets;
import flash.geom.Rectangle;
import flash.net.SharedObject;
import org.flixel.FlxButton;
import org.flixel.FlxG;
import org.flixel.FlxPath;
import org.flixel.FlxSave;
import org.flixel.FlxSprite;
import org.flixel.FlxState;
import org.flixel.FlxText;
import org.flixel.FlxTilemap;
import org.flixel.util.FlxMath;

/**
 * ...
 * @author Stephen Roantree
 */
class GameState extends FlxState
{
	private var _map:FlxTilemap;
	private var _sprite:FlxSprite;
	
	/**
	 * Function that is called up when to state is created to set it up. 
	 */
	override public function create():Void
	{
		// Set a background color
		FlxG.bgColor = 0xff131c1b;
		// Show the mouse (in case it hasn't been disabled)
		#if !FLX_NO_MOUSE
		FlxG.mouse.show();
		#end
		
		var tmap:TiledMap = new TiledMap("assets/maps/level.tmx");
		add(tmap);
		
		
		trace(tmap.tileLayers["Ground"].pathfind(21, 3, 1, 8));
		
		var sheet:SpriteSheet = new SpriteSheet("assets/spritesheets/pawn.xml", "static");
		sheet.x = 85;
		sheet.y = 25;
		tmap.tileLayers.get("Walls").add(sheet);
		
		
		var sheet2:SpriteSheet = new SpriteSheet("assets/spritesheets/pawn.xml", "static");
		sheet2.x = 85;
		sheet2.y = 285;
		tmap.tileLayers.get("Walls").add(sheet2);
		
		super.create();
	}
	
	/**
	 * Function that is called when this state is destroyed - you might want to 
	 * consider setting all objects this state uses to null to help garbage collection.
	 */
	override public function destroy():Void
	{
		super.destroy();
	}

	/**
	 * Function that is called once every frame.
	 */
	override public function update():Void
	{
		super.update();
	}	
	
}