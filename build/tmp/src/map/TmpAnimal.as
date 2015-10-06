package map
{
	import flash.display.Sprite;
	import flash.text.TextField;
	
	import z_spark.fallingsystem.FConst;

	public class TmpAnimal extends Sprite
	{
		public function TmpAnimal(i:int)
		{
			super();
			
			var row:uint=int(i/20);
			var color:uint=0xFFFFFF-row*10;
			
			graphics.beginFill(color);
			var size:uint=FConst.s_gridw*.5-2;
			graphics.drawRect(-size,-size,size*2,size*2);
			graphics.endFill();
				
			var tf:TextField=new TextField();
			tf.width=30;
			tf.height=30;
			tf.mouseEnabled=false;
			tf.text=i+"";
			tf.multiline=false;
			tf.x=-size;
			tf.y=-size;
			
			addChild(tf);
			
		}
		
		
	}
}