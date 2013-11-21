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
	public var tileLayers:Map<String, TiledLayer>;
	
	public function new(mapLocation:String) 
	{
		super();
		
		tileLayers = new Map<String, TiledLayer>();
		
		var tilesets = new Array<Tileset>();
		var xml = Xml.parse(Assets.getText(mapLocation));
		var root = xml.firstElement();
		
		var tileWidth = Std.parseInt(root.get("tilewidth"));
		var tileHeight = Std.parseInt(root.get("tileheight"));
		var width = Std.parseInt(root.get("width"));
		var height = Std.parseInt(root.get("height"));
		
		for (node in root.elements()) {
			if (node.nodeName == "tileset") {
				tilesets.push({ imagePath : FormatUtils.concatPaths(mapLocation, node.firstElement().get("source")),
								 width : Std.parseInt(node.get("tilewidth")),
								 height : Std.parseInt(node.get("tileheight")),
								 firstGid : Std.parseInt(node.get("firstgid")) } );
			} else if (node.nodeName == "layer") {
				var name = node.get("name");
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
				tileLayers.set(name, layerGroup);
			}
		}		
	}
}