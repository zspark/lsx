package z_spark.kxxxl.block
{
	import z_spark.mapsystem.BlockTypeConst;
	import z_spark.mapsystem.IBlockEntity;

	public class Factory
	{
		
		public static function createBlock(type:uint):IBlockEntity{
			var e:IBlockEntity;
			switch(type)
			{
				case BlockTypeConst.EGG:
				{
					
					break;
				}
				case BlockTypeConst.ICE:
				{
					e=new Ice();
					(e as Ice).level=int(Math.random()*3)+1;
					break;
				}	
				case BlockTypeConst.BUBBLE:
				{
					e=new Bubble();
					break;
				}
				default:
				{
					break;
				}
			}
			
			return e;
		}
	}
}