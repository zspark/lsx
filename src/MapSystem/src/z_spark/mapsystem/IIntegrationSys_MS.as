package z_spark.mapsystem
{
	
	
	public interface IIntegrationSys_MS
	{
		function freeze(arr:Array):void;
		function melt(arr:Array):void;
		
		function createNewBlock(index:int,type:uint):IBlockEntity;
	}
}