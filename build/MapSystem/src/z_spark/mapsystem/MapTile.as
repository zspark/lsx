package z_spark.mapsystem
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.text.TextField;
	
	import z_spark.batata.res.Res;
	import z_spark.batata.res.SubBitmapData;
	import z_spark.kxxxlcore.GameSize;
	
	
	public class MapTile extends Sprite
	{
		public static const DEFAULT_COLOR:uint=0x888888;
		public var index:int;
		public var chosen:Boolean=false;
		
		private var m_bg:Bitmap;
		
		
		public function MapTile(i:int)
		{
			super();
			
			const size:uint=GameSize.s_gridw;
			
			m_bg=Res.getBitmap("tile");
			addChild(m_bg);
			
			CONFIG::DEBUG{
//				drawWith(DEFAULT_COLOR);
				
				var tf:TextField=new TextField();
				tf.width=size;
				tf.height=size;
				tf.mouseEnabled=false;
				tf.text=i+"";
				tf.multiline=false;
				addChild(tf);
			};
			
			index=i;
		}
		
		public function get row():int{return int(index/GameSize.s_cols);}
		public function get col():int{return index%GameSize.s_cols;}
		
		CONFIG::DEBUG
		public function drawWith(color:uint):void{
			const size:uint=GameSize.s_gridw;
			graphics.clear();
			graphics.beginFill(color);
			graphics.drawRect(1,1,size-2,size-2);
			graphics.endFill();
		}
		
		public function destroy():void{
			CONFIG::DEBUG{
				graphics.clear();
			};
			
			Res.dispose(m_bg.bitmapData as SubBitmapData);
		}
	}
}