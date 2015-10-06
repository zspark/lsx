package
{
	import flash.display.Sprite;
	
	import z_spark.attractionsystem.AConst;
	
	public class MapBg extends Sprite
	{
		public function MapBg()
		{
			super();
			
			graphics.beginFill(0x888888);
			
			for (var i:int=0;i<AConst.s_rows;i++){
				for (var j:int=0;j<AConst.s_rows;j++){
					graphics.drawRect(j*AConst.s_gridw+1,i*AConst.s_gridh+1,AConst.s_gridw-2,AConst.s_gridh-2);
					
				}
			}
			
			graphics.endFill();
		}
	}
}