package z_spark.eliminatesystem
{
	import flash.display.Sprite;
	

	public interface IIntegrationSys_ES
	{
		/**
		 * 返回“从地形上说”两个动物之间能否交换，比如中间有篱笆墙，或者一个动物被草笼捆住等
		 * 就返回false；
		 * 至于两个动物交换后能不能构成消除是由消除系统判断； 
		 * 
		 * 该逻辑捎带检测试图交换的2个entity是否包含开始节点，有的话返回false；
		 * @param indexA
		 * @param indexB
		 * @return 返回值参考ExchangeStatus常量；
		 * 
		 */
		function canExchange(indexA:int,indexB:int):int;
		
		/**
		 * 向外提交将要消除的动物在map中的index数组；
		 * 用于地图系统判断地形的改变：比如雪、冰块的消除，病毒的消灭，霉云的消灭等；
		 * 用于掉落系统开始补给新的动物；
		 * @param allIndexes
		 * 
		 */
		function dispatchDisappearIndexes(allIndexes:Array,playSound:Boolean):void;
		
		function get animalLayer():Sprite;
		
	}
}