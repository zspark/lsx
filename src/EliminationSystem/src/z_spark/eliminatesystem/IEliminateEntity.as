package z_spark.eliminatesystem
{
	import flash.events.IEventDispatcher;

	public interface IEliminateEntity extends IEventDispatcher
	{
		function get type():uint;
		function set type(value:uint):void;
		function get color():uint;
		function set color(value:uint):void;
		
		function set select(value:Boolean):void;
		function get select():Boolean;
		
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