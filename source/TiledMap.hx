package ;

import openfl.Assets;
import openfl.display.Tilesheet;
import org.flixel.FlxGroup;
import org.flixel.FlxSprite;
import org.flixel.util.FlxPoint;
import Xml;

/**
 * ...
 * @author Stephen Roantree
 */
typedef Tileset = { imagePath : String, width : Int, height : Int, firstGid : Int };

class TiledMap extends FlxGroup
{
	public var layerCSVs:Map<String, String>;
	
	public function new(mapLocation:String) 
	{
		super();
		
		layerCSVs = new Map<String, String>();
		
		var tilesets = new Array<Tileset>();
		var xml = Xml.parse(Assets.getText(mapLocation));
		var root = xml.firstElement();
		
		var tileWidth = Std.parseInt(root.get("tilewidth"));
		var tileHeight = Std.parseInt(root.get("tileheight"));
		var width = Std.parseInt(root.get("width"));
		var height = Std.parseInt(root.get("height"));
		
		for (node in root.elements()) {
			if (node.nodeName == "tileset") {
				tilesets.push({ imagePath : appendPath(mapLocation, node.firstElement().get("source")),
								 width : Std.parseInt(node.get("tilewidth")),
								 height : Std.parseInt(node.get("tileheight")),
								 firstGid : Std.parseInt(node.get("firstgid")) } );
			} else if (node.nodeName == "layer") {
				var layerGroup = new TiledLayer(tileWidth, tileHeight);
				var data = node.firstElement().firstChild().toString();
				var rows = data.split("\n");
				var y : Int = 0;
				for (row in rows) {					
					var cols = row.split(",");
					if (cols.length < width) {
						continue;
					}
					for (x in 0...width) {
						var tileId = Std.parseInt(cols[x]);
						if (tileId == 0) {
							continue;
						}
						
						var tileset:Tileset = null;
						for (tset in tilesets) {
							if (tileId >= tset.firstGid) {
								tileset = tset;
								continue;
							}
						}
						tileId -= tileset.firstGid + 1;
						
						var tileSprite = new FlxSprite();
						tileSprite.loadGraphic(tileset.imagePath, false, false, tileset.width,
												tileset.height);
						tileSprite.frame = tileId;
						layerGroup.addStaticTile(x, y, tileSprite);
					}
					y++;
				}
				add(layerGroup);
			}
		}		
	}
	
	private function appendPath(path1:String, path2:String) {
		var path1Parts:Array<String> = path1.split("/");
		var path2Parts:Array<String> = path2.split("/");
		
		path1Parts.pop();
		for (part in path2Parts) {
			if (part == ".") {
				continue;
			} else if (part == "..") {
				path1Parts.pop();
			} else {
				path1Parts.push(part);
			}
		}
		
		return path1Parts.join("/");
	}
}