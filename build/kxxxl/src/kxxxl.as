package
{
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageDisplayState;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	
	import z_spark.batata.res.Res;
	import z_spark.core.utils.StageUtil;
	import z_spark.kxxxl.game.Game;
	
	[SWF(frameRate=6o, width=800, height=800)]
	public class kxxxl extends Sprite
	{
		//演示地址：v1
		//http://www.zspark.net/content/swfs/kxxxl/kxxxl_release.swf
		
		
		public function kxxxl()
		{
			stage.align=StageAlign.TOP_LEFT;
			stage.scaleMode=StageScaleMode.NO_SCALE;
			stage.color=0x143961;
			stage.frameRate=60;
//			stage.displayState=StageDisplayState.FULL_SCREEN_INTERACTIVE;
			
			Res.init("zh_CN/",true,5);
			var res:Res=new Res();
			res.appendCfg("config.tpf");
			res.addEventListener(Event.COMPLETE,onResLoaded);
			StageUtil.stage=stage;
			
		}
		
		private function onResLoaded(event:Event):void
		{
			trace("game start");
			new Game(stage);
		}
	}
}