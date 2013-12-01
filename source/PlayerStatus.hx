package ;

/**
 * ...
 * @author Stephen Roantree
 */
class PlayerStatus
{
	public var PlayerId:Int;
	public var Hand:Array<Card>;
	
	public function new(playerId:Int) 
	{
		PlayerId = playerId;
		
		Hand = new Array<Card>();
		Hand.push(new Card());
		Hand.push(new Card());
		Hand.push(new Card());
		Hand.push(new Card());
		Hand.push(new Card());
	}
	
	
}