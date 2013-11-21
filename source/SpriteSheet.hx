package ;

import openfl.Assets;
import org.flixel.FlxSprite;
import org.flixel.util.FlxPoint;

/**
 * ...
 * @author Stephen Roantree
 */

typedef SpriteSheetDescription = { sourceImage:String, 
	tileWidth:Int, 
	tileHeight:Int,
	centerX:Int,
	centerY:Int,
	animations:Map<String, List<Int>> }

class SpriteSheet extends FlxSprite
{
	private static var sheetDescriptions:Map<String, SpriteSheetDescription> = new Map<String, SpriteSheetDescription>();

	private var description:SpriteSheetDescription;
	
	public function new(filename:String, animation:String) 
	{
		super();
		description = getSheetDescription(filename);
		this.loadGraphic(description.sourceImage, false, false, 
						description.tileWidth, description.tileHeight);
		this.frame = description.animations.get(animation).first();
	}
	
	private static function getSheetDescription(filename:String) {
		if (sheetDescriptions.exists(filename)) {
			return sheetDescriptions.get(filename);
		}
		
		var xml = Xml.parse(Assets.getText(filename));
		var root = xml.firstElement();
		
		var source = FormatUtils.concatPaths(filename, root.get("source"));
		var tileWidth = Std.parseInt(root.get("tilewidth"));
		var tileHeight = Std.parseInt(root.get("tileheight"));
		var centerX = Std.parseInt(root.get("centerx"));
		var centerY = Std.parseInt(root.get("centery"));
		
		var animationsNode = root.firstElement();
		var animations = new Map < String, List<Int> > ();
		for (animationNode in animationsNode.elements()) {
			var animation = new List<Int>();
			var name = animationNode.get("name");
			for (frame in animationNode.firstChild().toString().split(",")) {
				animation.push(Std.parseInt(frame));
			}
			animations.set(name, animation);
		}
		
		var description = { sourceImage : source,
							tileWidth : tileWidth,
							tileHeight : tileHeight,
							centerX: centerX,
							centerY: centerY,
							animations : animations };
		sheetDescriptions.set(filename, description);
		return description;
	}
}