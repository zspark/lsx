package z_spark.fallingsystem
{
	import z_spark.kxxxlcore.IEntity;

	public interface IFallingEntity extends IEntity
	{
		
		function get spdy():Number;
		function set spdy(value:Number):void;
		function get spdx():Number;
		function set spdx(value:Number):void;
		
		function get finishX():int;
		function set finishX(value:int):void;
		function get finishY():int;
		function set finishY(value:int):void;
		
	}
}