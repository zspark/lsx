package z_spark.kxxxl.block
{
	import z_spark.mapsystem.BlockTypeConst;

	public class Fence extends BlockEntity
	{
		
		public function Fence()
		{
			super();
			tf.text=m_type+"";
			m_isOcupier=false;
		}
		
		override public function set type(value:int):void{
			m_type=value;
			if(value==BlockTypeConst.FENCE_UD){
				setSkin("rope_ud");
			}else{
				setSkin("rope_1");
			}
		}

	}
}