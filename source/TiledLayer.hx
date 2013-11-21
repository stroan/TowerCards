package ;

import org.flixel.FlxBasic;
import org.flixel.FlxGroup;
import org.flixel.FlxObject;
import org.flixel.FlxSprite;

/**
 * ...
 * @author Stephen Roantree
 */
class TiledLayer extends FlxGroup
{
	private var _tileWidth:Int;
	private var _tileHeight:Int;
	
	public function new(tileWidth:Int, tileHeight:Int) {
		super();
		
		this._tileWidth = tileWidth;
		this._tileHeight = tileHeight;
	}
	
	public function addStaticTile(x:Int, y:Int, sprite:FlxSprite) {
		sprite.x = x * _tileWidth;
		sprite.y = y * _tileHeight - (sprite.height - _tileHeight);
		this.add(sprite);
	}
	
	public override function update() {
		this.sort();
	}
	
	public override function sortHandler(basic1:FlxBasic, basic2:FlxBasic) {
		var obj1:FlxObject = cast(basic1);
		var obj2:FlxObject = cast(basic2);
		
		if (obj1 == null || obj2 == null) {
			return 0;
		}
		
		var bottom1 = obj1.y + obj1.height;
		var bottom2 = obj2.y + obj2.height;
		
		if (bottom1 < bottom2) {
			return -1;
		} else if (bottom1 > bottom2) {
			return 1;
		} else {
			return 0;
		}
	}
}