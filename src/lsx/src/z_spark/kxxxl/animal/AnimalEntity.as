package z_spark.kxxxl.animal
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	
	import z_spark.batata.res.Res;
	import z_spark.batata.res.SubBitmapData;
	import z_spark.kxxxlcore.GameSize;
	import z_spark.kxxxlcore.IEntity;
	
	public class AnimalEntity extends Sprite implements IEntity
	{
		protected var m_skin:Bitmap;
		public function AnimalEntity()
		{
			super();
			
			m_skin=new Bitmap();
			addChild(m_skin);
		}
		
		public function setSkin(skin:String):void{
			var bmpd:SubBitmapData=Res.getSubBitmapData(skin);
			m_skin.bitmapData=bmpd;
			m_skin.x=-bmpd.width>>1;
			m_skin.y=-bmpd.height>>1;
			
//			m_skin.scaleX=m_skin.scaleY=MConst.s_gridw/m_skin.width;
			
		}
		
		public function get index():int{
			return int(y/GameSize.s_gridh)*GameSize.s_cols+int(x/GameSize.s_gridw);
		}
		
		public function destroy():void{
			Res.dispose(m_skin.bitmapData as SubBitmapData);
			CONFIG::DEBUG{
				graphics.clear();
			};
		}
		
		private var m_occupiedIndex:int=-1;
		public function get occupiedIndex():int{return m_occupiedIndex;}
		public function set occupiedIndex(value:int):void{m_occupiedIndex=value;}
	}
}