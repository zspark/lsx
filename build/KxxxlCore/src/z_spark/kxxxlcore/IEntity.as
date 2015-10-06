package z_spark.kxxxlcore
{
	import flash.events.IEventDispatcher;

	public interface IEntity extends IEventDispatcher
	{
		
		function get x():Number;
		function set x(value:Number):void;
		function get y():Number;
		function set y(value:Number):void;
		function get occupiedIndex():int;
		function set occupiedIndex(value:int):void;
		function get index():int;
		
		function destroy():void;
		
	}
}