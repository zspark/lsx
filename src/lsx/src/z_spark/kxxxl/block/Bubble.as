package z_spark.kxxxl.block
{
	import z_spark.attractionsystem.EffectNameConst;
	import z_spark.attractionsystem.Effector;
	import z_spark.mapsystem.BlockTypeConst;

	public class Bubble extends BlockEntity
	{
		
		public function Bubble()
		{
			super();
			m_type=BlockTypeConst.BUBBLE;
			tf.text=m_type+"";
			m_isOcupier=false;
			
			setSkin("bubble_3");
		}
		
		/**
		 * 气泡消除的前提是必须要有动物占据； 
		 * @return 
		 * 
		 */
		override public function tryEliminate(index:int):Boolean
		{
			if(s_map[convertToIndex()]!=null){
				Effector.getDestroyEffect(EffectNameConst.EFT_BUBBLE_DESTROY,index,true,1);
				Effector.playSound("sound_ice_break");
				return true;
			}
			return false;
		}
		
		

	}
}