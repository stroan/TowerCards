package ;

import org.flixel.FlxSprite;
import org.flixel.FlxButton;
import org.flixel.util.FlxPoint;

/**
 * ...
 * @author Stephen Roantree
 */
class Card extends FlxButton
{
	public function new() 
	{
		super(0, 0, null, onClick);
		
		this.makeGraphic(75, 125, 0xFFFF0000, true);
		this.scrollFactor = new FlxPoint(0, 0);
	}
	
	public function onClick() {
		trace("Hello");
	}
	
	public static function GetCardWidth():Int {
		return 75;
	}
	
	public static function GetCardHeight():Int {
		return 125;
	}
}