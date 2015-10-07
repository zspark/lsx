package
{
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.utils.setTimeout;
	
	import z_spark.attractionsystem.AConst;
	import z_spark.attractionsystem.EffectNameConst;
	import z_spark.attractionsystem.Effector;
	import z_spark.batata.res.Res;
	import z_spark.batata.ui.Movie;
	import z_spark.core.utils.StageUtil;
	
	public class EffectorTest extends Sprite
	{

		public function EffectorTest()
		{
			stage.scaleMode=StageScaleMode.NO_SCALE;
			stage.color=0x143961;
			stage.frameRate=60;
			
			Res.init("zh_CN/",true,5);
			var res:Res=new Res();
			res.appendCfg("config.tpf");
			res.addEventListener(Event.COMPLETE,onResLoaded);
			StageUtil.stage=stage;
			
			AConst.s_gridh=70;
			AConst.s_gridw=70;
			
			
			
			addChild(new MapBg());
			
			var layer:Sprite=new Sprite();
			addChild(layer);
			Effector.init(layer);
			
		}
		
		private function onResLoaded(event:Event):void
		{
			Effector.getSelectEffect(EffectNameConst.EFT_SELECT,1)
			var movie:Movie=Effector.getArrowEffect("up");
			movie.x=60;
			movie.y=60
			
			/*var bmpd:SubBitmapData=Effector.getBitmapData("whirlpool");
			addChild(new Bitmap(bmpd));*/
			
			
			Effector.playSound("sound_contnuousMatch_3");
			Effector.getEliminateEffect(EffectNameConst.EFT_ANIMAL_ELIMINATE,45,true,1000);
			Effector.getDestroyEffect(EffectNameConst.EFT_ICE_1_DESTROY,23,true,100);
			Effector.getDestroyEffect(EffectNameConst.EFT_ICE_2_DESTROY,24,true,1000);
			Effector.getDestroyEffect(EffectNameConst.EFT_BUBBLE_DESTROY,25,true,100);
			setTimeout(function():void{Effector.playSound("sound_eliminate_1");},1000);
			
			Effector.getGrowBigEffect(2,true,10000);
		}
	}
}