package ;

import openfl.Assets;
import flash.geom.Rectangle;
import flash.net.SharedObject;
import org.flixel.FlxButton;
import org.flixel.FlxG;
import org.flixel.FlxGroup;
import org.flixel.FlxPath;
import org.flixel.FlxSave;
import org.flixel.FlxSprite;
import org.flixel.FlxState;
import org.flixel.FlxText;
import org.flixel.FlxTilemap;
import org.flixel.util.FlxMath;
import org.flixel.util.FlxPoint;

/**
 * ...
 * @author Stephen Roantree
 */
class GameState extends FlxState
{
	private var _map:FlxTilemap;
	private var _sprite:FlxSprite;
	private var _handContainer:HandContainer;
	
	private var _lastMouseX:Float;
	private var _lastMouseY:Float;
	
	private var _player1:PlayerStatus;
	private var _player2:PlayerStatus;
	
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
		
		_player1 = new PlayerStatus(1);
		_player2 = new PlayerStatus(2);
		
		var tmap:TiledMap = new TiledMap("assets/maps/level.tmx");
		add(tmap);
		
		var sheet:SpriteSheet = new SpriteSheet("assets/spritesheets/pawn.xml", "static");
		sheet.x = 85;
		sheet.y = 25;
		tmap.tileLayers.get("Walls").add(sheet);
		
		var sheet2:SpriteSheet = new SpriteSheet("assets/spritesheets/pawn.xml", "static");
		sheet2.x = 85;
		sheet2.y = 285;
		tmap.tileLayers.get("Walls").add(sheet2);
		
		_handContainer = new HandContainer(new FlxPoint(640, 800));
		_handContainer.layoutHand(_player1.Hand);
		add(_handContainer);
		
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
		
		handleMapDrag();
	}
	
	private function handleMapDrag():Void {
		if (FlxG.mouse.justPressed()) {
			_lastMouseX = FlxG.mouse.screenX;
			_lastMouseY = FlxG.mouse.screenY;
		} else if (FlxG.mouse.pressed()) {
			FlxG.camera.scroll.x += _lastMouseX - FlxG.mouse.screenX;
			FlxG.camera.scroll.y += _lastMouseY - FlxG.mouse.screenY;
			_lastMouseX = FlxG.mouse.screenX;
			_lastMouseY = FlxG.mouse.screenY;
		}
	}
	
}