package z_spark.kxxxlcore
{
	public class Assert
	{
		public static function AssertTrue(expression:Boolean):void
		{
			if(!expression){
				throw "与真断言不符！";
			}
		}
		
		public static function AssertFalse(expression:Boolean):void
		{
			if(expression){
				throw "与假断言不符！";
			}
		}
	}
}