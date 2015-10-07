package z_spark.fallingsystem
{
	/**
	 * 断开节点优先级常数； 
	 * @author z_Spark
	 * 
	 */
	public class FPriority
	{
		/**
		 * 断开、连接自己通向父节点的连接； 
		 */
		public static const SELF:uint=0x1;
		/**
		 *断开、连接父节点通向自己的连接； 
		 */
		public static const ELDER:uint=0x2;
		/**
		 * 断开、连接自己与父节点的互相连接； 
		 */
		public static const ALL:uint=0x4;
	}
}