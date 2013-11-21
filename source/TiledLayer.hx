package ;

import org.flixel.FlxGroup;
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
}