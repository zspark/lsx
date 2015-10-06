package map
{
	import flash.display.Sprite;
	
	import z_spark.fallingsystem.FConst;
	
	public class MapBg extends Sprite
	{
		public function MapBg()
		{
			super();
			
			graphics.beginFill(0x888888);
			
			for (var i:int=0;i<FConst.s_rows;i++){
				for (var j:int=0;j<FConst.s_rows;j++){
					graphics.drawRect(j*FConst.s_gridw+1,i*FConst.s_gridh+1,FConst.s_gridw-2,FConst.s_gridh-2);
					
				}
			}
			
			graphics.endFill();
		}
	}
}