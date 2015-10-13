package z_spark.kxxxl.block
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.text.TextField;
	
	import avmplus.getQualifiedClassName;
	
	import z_spark.attractionsystem.Effector;
	import z_spark.batata.res.Res;
	import z_spark.batata.res.SubBitmapData;
	import z_spark.kxxxlcore.GameSize;
	import z_spark.mapsystem.IBlockEntity;

	public class BlockEntity extends Sprite implements IBlockEntity
	{
		public static var s_map:Array;
		
		protected var m_skin:Bitmap;
		protected var m_type:int;
		/**
		 *是否占据格子位置，冰块就占据，玻璃不占据； 
		 */
		protected var m_isOcupier:Boolean;

		CONFIG::DEBUG{
			protected var tf:TextField;
		};
		
		public function BlockEntity()
		{
			
			if(getQualifiedClassName(this)=="z_spark.mapsystem.block::BlockBase"){
				throw "can not create abstract class";
			}
			
			m_skin=new Bitmap();
			addChild(m_skin);
			
			CONFIG::DEBUG{
				tf=new TextField();
				tf.width=GameSize.s_gridw;
				tf.height=GameSize.s_gridh;
				tf.mouseEnabled=false;
				tf.multiline=false;
				const size:uint=GameSize.s_gridw*.5;
				tf.x=-size;
				tf.y=-size;
				addChild(tf);
			};
			
		}
		
		public function get isOcupier():Boolean{return m_isOcupier;}
		public function get type():int{return m_type;}
		public function set type(value:int):void{m_type=value;}
		
		public function tryEliminate(index:int):Boolean{return false;}

		public function setSkin(resName:String):void{
			Res.dispose(m_skin.bitmapData as SubBitmapData);
			var bmpd:SubBitmapData=Effector.getBitmapData(resName);
			m_skin.bitmapData=bmpd;
			m_skin.x=-bmpd.width>>1;
			m_skin.y=-bmpd.height>>1;
		}
		
		public function destroy():void{
			CONFIG::DEBUG{graphics.clear();};
			Res.dispose(m_skin.bitmapData as SubBitmapData);
		}
		
		protected function convertToIndex():int{
			return int(y/GameSize.s_gridh)*GameSize.s_cols+int(x/GameSize.s_gridw);
		}
	}
}