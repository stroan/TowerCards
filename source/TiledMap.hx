package ;

import openfl.Assets;
import openfl.display.Tilesheet;
import org.flixel.FlxGroup;
import org.flixel.FlxSprite;
import org.flixel.util.FlxPoint;
import org.flixel.util.FlxRect;
import Xml;

/**
 * ...
 * @author Stephen Roantree
 */
typedef Tileset = { imagePath : String, width : Int, height : Int, firstGid : Int };
typedef Tilerect = { x : Int, y : Int, w : Int, h : Int }; 

class TiledMap extends FlxGroup
{
	var mapWidth:Int;
	var mapHeight:Int;
	
	public var tileLayers:Map<String, TiledLayer>;
	public var objectLayers:Map < String, Map < String, Tilerect >>;
	
	public function new(mapLocation:String) 
	{
		super();
		
		tileLayers = new Map<String, TiledLayer>();
		objectLayers = new Map < String, Map < String, Tilerect >>();
		
		var tilesets = new Array<Tileset>();
		var xml = Xml.parse(Assets.getText(mapLocation));
		var root = xml.firstElement();
		
		var tileWidth = Std.parseInt(root.get("tilewidth"));
		var tileHeight = Std.parseInt(root.get("tileheight"));
		var width = Std.parseInt(root.get("width"));
		var height = Std.parseInt(root.get("height"));
		
		mapHeight = height;
		mapWidth = width;
		
		for (node in root.elements()) {
			if (node.nodeName == "tileset") {
				tilesets.push({ imagePath : FormatUtils.concatPaths(mapLocation, node.firstElement().get("source")),
								 width : Std.parseInt(node.get("tilewidth")),
								 height : Std.parseInt(node.get("tileheight")),
								 firstGid : Std.parseInt(node.get("firstgid")) } );
			} else if (node.nodeName == "layer") {
				var name = node.get("name");
				var layerGroup = new TiledLayer(width, height, tileWidth, tileHeight);
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
			} else if (node.nodeName == "objectgroup") {
				var groupName = node.get("name");
				var rects = new Map<String, Tilerect>();
				for (objectNode in node.elements()) {
					var objectName = objectNode.get("name") + "." + objectNode.get("type");
					var ox = Std.parseInt(objectNode.get("x"));
					var oy = Std.parseInt(objectNode.get("y"));
					var ow = Std.parseInt(objectNode.get("width"));
					var oh = Std.parseInt(objectNode.get("height"));
					
					var tx:Int = Math.floor(ox / tileWidth);
					var ty = Math.floor(oy / tileHeight);
					var tw = Math.ceil(ow / tileWidth);
					var th = Math.ceil(oh / tileHeight);
					
					rects.set(objectName, { x : tx, y : ty, w : tw, h : th } );
				}
				objectLayers.set(groupName, rects);
			}
		}
	}
}