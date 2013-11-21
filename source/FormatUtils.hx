package ;

/**
 * ...
 * @author Stephen Roantree
 */
class FormatUtils
{
	public static function concatPaths(path1:String, path2:String):String {
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