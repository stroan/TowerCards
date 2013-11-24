package ;

import org.flixel.FlxBasic;
import org.flixel.FlxGroup;
import org.flixel.FlxObject;
import org.flixel.FlxSprite;

/**
 * ...
 * @author Stephen Roantree
 */

typedef PathPoint = {x:Int, y:Int}
 
class TiledLayer extends FlxGroup
{
	private var _width:Int;
	private var _height:Int;
	private var _tileWidth:Int;
	private var _tileHeight:Int;
	
	private var _staticTiles:Array<Array<Bool>>;
	
	public function new(width:Int, height:Int, tileWidth:Int, tileHeight:Int) {
		super();
		
		this._width = width;
		this._height = height;
		this._tileWidth = tileWidth;
		this._tileHeight = tileHeight;
		
		this._staticTiles = new Array<Array<Bool>>();
		for (y in 0..._height) {
			var row = new Array<Bool>();
			for (x in 0..._width) {
				row.push(false);
			}
			this._staticTiles.push(row);
		}
	}
	
	public function addStaticTile(x:Int, y:Int, sprite:FlxSprite) {
		sprite.x = x * _tileWidth;
		sprite.y = y * _tileHeight - (sprite.height - _tileHeight);
		_staticTiles[y][x] = true;
		this.add(sprite);
	}
	
	public override function update() {
		this.sort();
	}
	
	public override function sortHandler(basic1:FlxBasic, basic2:FlxBasic) {
		var obj1:FlxObject = cast(basic1);
		var obj2:FlxObject = cast(basic2);
		
		if (obj1 == null || obj2 == null) {
			return 0;
		}
		
		var bottom1 = obj1.y + obj1.height;
		var bottom2 = obj2.y + obj2.height;
		
		if (bottom1 < bottom2) {
			return -1;
		} else if (bottom1 > bottom2) {
			return 1;
		} else {
			return 0;
		}
	}
	
	public function pathfind(startX:Int, startY:Int, endX:Int, endY:Int):List<PathPoint> {
		var boundary = new Array<Array<PathPoint>>();
		var touchedPoints = new Map<String, Int>();
		
		var firstPoint = new Array<PathPoint>();
		firstPoint.push( { x: startX, y: startY } );
		boundary.push( firstPoint );
		
		var endPoint = { x: endX, y: endY };
		
		function distanceSquares(p:PathPoint):Int {
			var dx = p.x - endX;
			var dy = p.y - endY;
			return (dx * dx) + (dy * dy);
		}
		
		function sortFunction(p1:Array<PathPoint>, p2:Array<PathPoint>):Int {
			var d1 = distanceSquares(p1[0]);
			var d2 = distanceSquares(p2[0]);
			if (d1 == d2) {
				return 0;
			} else if (d1 > d2) {
				return 1;
			}
			return -1;
		}
		
		function pointEq(p1:PathPoint, p2:PathPoint) {
			return p1.x == p2.x && p1.y == p2.y;
		}
		
		function pointName(p:PathPoint):String {
			return p.x + "," + p.y;
		}
		
		while (boundary.length > 0 && !pointEq(boundary[0][0], endPoint)) {
			var head = boundary.shift();
			
			var top:PathPoint = head[0];
			var nextTops = new List<PathPoint>();
			nextTops.push( { x : top.x + 1, y : top.y } );
			nextTops.push( { x : top.x - 1, y : top.y } );
			nextTops.push( { x : top.x, y : top.y + 1 } );
			nextTops.push( { x : top.x, y : top.y - 1 } );			
			
			for (next in nextTops) {
				if (_staticTiles[next.y][next.x] && !touchedPoints.exists(pointName(next))) {
					var newPath = new Array<PathPoint>();
					for (point in head) {
						newPath.push(point);
					}
					newPath.unshift(next);
					boundary.push(newPath);
					touchedPoints.set(pointName(next), 0);
				}
			}
			boundary.sort(sortFunction);
		}
		
		if (boundary.length > 0) {
			var path = boundary[0];
			var l = new List<PathPoint>();
			for (p in path) {
				l.push(p);
			}
			return l;
		} else {
			return null;
		}
	}
}