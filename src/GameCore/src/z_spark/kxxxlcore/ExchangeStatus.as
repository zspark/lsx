package z_spark.kxxxlcore
{
	public final class ExchangeStatus
	{
		/**
		 *表示系统不允许交换，并且试图交换的2个动物必须原地不动； 
		 */
		public static const STAND_STILL:int=1;
		/**
		 *表示系统不允许交换， 但稍微向对方滑动一定距离后返回原地；
		 */
		public static const SLIGHTLY:int=2;
		/**
		 *表示系统允许交换。 
		 */
		public static const EXCHANGE:int=3;
	}
}