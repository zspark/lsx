package z_spark.kxxxl.block
{
	import z_spark.attractionsystem.EffectNameConst;
	import z_spark.attractionsystem.Effector;
	import z_spark.mapsystem.BlockTypeConst;

	public class Ice extends BlockEntity
	{
		private static const EFFECT_NAME:Array=[
			EffectNameConst.EFT_ICE_1_DESTROY,EffectNameConst.EFT_ICE_2_DESTROY
			,EffectNameConst.EFT_ICE_2_DESTROY
		]
		
		public static const LEVEL_0:int=0;//no block
		public static const LEVEL_1:int=1;
		public static const LEVEL_2:int=2;
		public static const LEVEL_3:int=3;
		public static const LEVEL_4:int=4;
		
		private var m_level:uint=LEVEL_1;
		public function Ice()
		{
			super();
			m_type=BlockTypeConst.ICE;
			CONFIG::DEBUG{tf.text=m_type+"";};
			m_isOcupier=true;
			
		}
		
		public function get level():uint
		{
			return m_level;
		}

		public function set level(value:uint):void
		{
			m_level = value;
			CONFIG::DEBUG{tf.text=m_type+","+m_level;};
			
			var skin:String='';
			if(m_level==LEVEL_1)skin="snow_1";
			else if(m_level==LEVEL_2)skin="snow_2";
			else if(m_level==LEVEL_3)skin="snow_2";
			else if(m_level==LEVEL_4)skin="snow_2";
			
			if(skin)setSkin(skin);
		}
		
		override public function tryEliminate(index:int):Boolean{
			m_level--;
			level=m_level;
			
			Effector.getDestroyEffect(EFFECT_NAME[m_level],index,true,1);
			Effector.playSound("sound_ice_break");
			
			return m_level<=0;
		}

	}
}