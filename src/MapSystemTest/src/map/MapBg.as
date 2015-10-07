package map
{
	import flash.display.Sprite;
	
	import z_spark.mapsystem.MConst;
	
	public class MapBg extends Sprite
	{
		public function MapBg()
		{
			super();
			
			graphics.beginFill(0x888888);
			
			for (var i:int=0;i<MConst.s_rows;i++){
				for (var j:int=0;j<MConst.s_rows;j++){
					graphics.drawRect(j*MConst.s_gridw+1,i*MConst.s_gridh+1,MConst.s_gridw-2,MConst.s_gridh-2);
					
				}
			}
			
			graphics.endFill();
		}
	}
}