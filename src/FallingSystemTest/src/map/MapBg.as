package map
{
	import flash.display.Sprite;
	
	import z_spark.kxxxlcore.GameSize;
	
	public class MapBg extends Sprite
	{
		public function MapBg()
		{
			super();
			
			graphics.beginFill(0x888888);
			
			for (var i:int=0;i<GameSize.s_rows;i++){
				for (var j:int=0;j<GameSize.s_rows;j++){
					graphics.drawRect(j*GameSize.s_gridw+1,i*GameSize.s_gridh+1,GameSize.s_gridw-2,GameSize.s_gridh-2);
					
				}
			}
			
			graphics.endFill();
		}
	}
}