package ;

import org.flixel.FlxGroup;
import org.flixel.util.FlxPoint;
import org.flixel.util.FlxPoint;

/**
 * ...
 * @author Stephen Roantree
 */
class HandContainer extends FlxGroup
{
	private var _bottomCenter:FlxPoint;
	
	public function new(bottomCenter:FlxPoint) {
		super();
		_bottomCenter = bottomCenter;
	}
	
	public function layoutHand(hand:Array<Card>) {
		var spacing = 20;
		var totalWidth = (hand.length * (Card.GetCardWidth() + spacing)) - spacing;
		
		var x = _bottomCenter.x - (totalWidth / 2.0);
		this.clear();
		for (card in hand) {
			card.x = x;
			card.y = _bottomCenter.y - Card.GetCardHeight();
			
			x += Card.GetCardWidth() + spacing;
			add(card);
		}
	}
	
}