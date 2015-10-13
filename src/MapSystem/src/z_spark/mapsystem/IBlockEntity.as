package z_spark.mapsystem
{
	public interface IBlockEntity
	{
		function tryEliminate(index:int):Boolean;
		function destroy():void;
		
		function get isOcupier():Boolean;
		function get type():int;
		function set type(value:int):void;
			
		function get x():Number;
		function set x(value:Number):void;
		function get y():Number;
		function set y(value:Number):void;
		
	}
}