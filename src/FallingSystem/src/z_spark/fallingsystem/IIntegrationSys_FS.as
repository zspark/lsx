package z_spark.fallingsystem
{

	public interface IIntegrationSys_FS
	{
		
		/**
		 * 让整合系统创建一个新的动物，添加到显示列表，并放置到index所指的位置，其他不用理会； 
		 * 新的动物肯定是普通动物；颜色随机；
		 * @return 
		 * 
		 */
		function createNewAnimal(index:int):IFallingEntity;
		
		/**
		 *自动下落过程中，当有动物不能再下落的时候，就会调用该接口，希望消除系统进行检测； 
		 * @param index
		 * 
		 */
		function standBy(arr:Array):void;
		
		function fallingOver():void;
	}
}