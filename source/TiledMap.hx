package ;

import openfl.Assets;
import Xml;

/**
 * ...
 * @author Stephen Roantree
 */
class TiledMap
{
	public var layerCSVs:Map<String, String>;
	
	public function new(mapLocation:String) 
	{
		layerCSVs = new Map<String, String>();
		var xml = Xml.parse(Assets.getText(mapLocation));
		
		for (layer in xml.firstElement().elementsNamed("layer")) {
			var contents:String = layer.firstElement().firstChild().toString();
			var newContents = "";
			for (line in contents.split("\n")) {
				var len = line.length;
				if (line.charAt(len - 1) == ",") {
					len--;
				}
				newContents += line.substr(0, len) + "\n";
			}
			layerCSVs[layer.get("name")] = newContents;
			trace(layerCSVs[layer.get("name")]);
		}
	}
	
}