package
{
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	
	import z_spark.attractionsystem.Effector;
	import z_spark.batata.res.Res;
	import z_spark.core.debug.DBGStats;
	import z_spark.core.utils.StageUtil;
	import z_spark.eliminatesystem.ColorConst;
	import z_spark.eliminatesystem.EConst;
	import z_spark.eliminatesystem.EliminateSystem;
	import z_spark.eliminatesystem.IEliminateEntity;
	import z_spark.eliminatesystem.TypeConst;
	
	[SWF(frameRate=6o, width=1024, height=600)]
	public class EliminateSystemTest extends Sprite
	{
		private var m_intersection:Intersection;
		private var m_sys:EliminateSystem;
		private var m_layer:Sprite;
		public function EliminateSystemTest()
		{
			stage.align=StageAlign.TOP_LEFT;
			stage.scaleMode=StageScaleMode.NO_SCALE;
			stage.color=0x000000;
			stage.frameRate=60;
			
			var fps:DBGStats=new DBGStats();
			fps.x=stage.stageWidth-60;
			addChild(fps);
			
			////////////////////////////////////////////
			Res.init("zh_CN/",true,5);
			var res:Res=new Res();
			res.appendCfg("config.tpf");
			res.addEventListener(Event.COMPLETE,onResLoaded);
			StageUtil.stage=stage;
			
		}
		
		private function onResLoaded(event:Event):void
		{
			m_layer=new Sprite();
			addChild(m_layer);
			
			var eftLayer:Sprite=new Sprite();
			addChild(eftLayer);
			Effector.init(eftLayer);
			
			var debugLayer:Sprite=new Sprite();
			addChild(debugLayer);
			
			m_intersection=new Intersection();
			m_intersection.m_layer=m_layer;
			m_sys=new EliminateSystem();
			m_sys.startDebug(stage,debugLayer);
			m_sys.init(stage,m_intersection.map,m_intersection);
			
			for (var i:int=0;i<EConst.s_cols*EConst.s_rows;i++){
				
				//				if(Math.random()>.95)continue;
				
				var a:EAnimal=new EAnimal(i);
				a.x=(i%EConst.s_cols)*EConst.s_gridw+15;
				a.y=(int(i/EConst.s_cols)*EConst.s_gridh)+15;
				a.color=ColorConst.TOTAL[int(Math.random()*ColorConst.TOTAL.length)];
				a.type=1;//TypeConst.TOTAL[int(Math.random()*TypeConst.TOTAL.length)];
				//				if(Math.random()>.9){
				//					a.type=TypeConst.SUPER;
				//					a.color=ColorConst.ALL;
				//				}
				m_layer.addChild(a);
				
				m_sys.add(a);
				m_intersection.map[i]=a;
			}
			
			var e:IEliminateEntity=m_intersection.createNewEffectAnimal(20,ColorConst.BLUE,TypeConst.SUPER);
			e.x=500;
			e.y=20;
		}
			
			
		
	}
}