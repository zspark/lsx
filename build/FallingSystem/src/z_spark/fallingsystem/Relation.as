package z_spark.fallingsystem
{
	public class Relation
	{
		public static const MAX_CHILDREN:uint=3;
		
		//这三个常量的值不能随意变动，
		//1、它表示选择父节点的优先级，越小越优先；
		//2、他表示孩子节点在数组中的索引编号；
		//3、为了优化性能，部分程序硬编码为0、1、2，查看FTree的InsertNode逻辑；
		public static const SON:uint=0;
		public static const LEFT_NEPHEW:uint=1;
		public static const RIGHT_NEPHEW:uint=2;
	}
}