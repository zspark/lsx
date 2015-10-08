package z_spark.kxxxl.game
{
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.utils.getTimer;
	import flash.utils.setTimeout;
	
	import z_spark.attractionsystem.AConst;
	import z_spark.attractionsystem.Effector;
	import z_spark.eliminatesystem.EliminateSystem;
	import z_spark.eliminatesystem.IEliminateEntity;
	import z_spark.eliminatesystem.IIntegrationSys_ES;
	import z_spark.fallingsystem.FallingSystem;
	import z_spark.fallingsystem.IFallingEntity;
	import z_spark.fallingsystem.IIntegrationSys_FS;
	import z_spark.kxxxl.animal.Animal;
	import z_spark.kxxxl.animal.AnimalEntity;
	import z_spark.kxxxl.block.BlockEntity;
	import z_spark.kxxxl.block.Factory;
	import z_spark.kxxxlcore.GameSize;
	import z_spark.mapsystem.IBlockEntity;
	import z_spark.mapsystem.IIntegrationSys_MS;
	import z_spark.mapsystem.MapSystem;
	
	public class Intersection implements IIntegrationSys_ES,IIntegrationSys_FS,IIntegrationSys_MS
	{
		private var m_mapSys:MapSystem;
		private var m_fallingSys:FallingSystem;
		private var m_eliminateSys:EliminateSystem;
		private var m_map:Array;
		private var m_blockMap:Array;
		private var m_mapLayer:Sprite;
		private var m_blockLayer:Sprite;
		private var m_effectLayer:Sprite;
		
		private var m_timeoutCount:int=0;
		private var m_eliminateSoundLevel:uint=1;
		
		private var m_animalLayer:Sprite;
		public function Intersection(rows:int,cols:int,w:int,h:int)
		{
			GameSize.s_cols=cols;GameSize.s_rows=rows;
			GameSize.s_gridh=h;GameSize.s_gridw=w;
			AConst.s_cols=cols;AConst.s_rows=rows;
			AConst.s_gridh=h;AConst.s_gridw=w;
			m_map=new Array(cols*rows);
			m_blockMap=new Array(cols*rows);
			BlockEntity.s_map=m_map;
		}
		
		public function get mapLayer():Sprite{return m_mapLayer;}
		public function get blockLayer():Sprite{return m_blockLayer;}
		public function get animalLayer():Sprite{return m_animalLayer;}
		public function get mapSys():MapSystem{return m_mapSys;}
		public function get fallingSys():FallingSystem{return m_fallingSys;}
		public function get eliminateSys():EliminateSystem{return m_eliminateSys;}

		public function initLayer(ml:Sprite,bl:Sprite,al:Sprite,el:Sprite):void{
			m_mapLayer=ml;
			m_animalLayer=al;
			m_blockLayer=bl;
			m_effectLayer=el;
		}
		
		public function initSystem(stage:Stage):void{
			m_mapSys=new MapSystem();
			m_mapSys.init(m_map,m_blockMap,this,m_mapLayer,m_blockLayer,m_animalLayer);
			
			m_fallingSys=new FallingSystem();
			m_fallingSys.init(stage,m_map,this);
			
			m_eliminateSys=new EliminateSystem();
			m_eliminateSys.init(stage,m_map,this);
			
			Effector.init(m_effectLayer);
		}
		
		public function createInitAnimal(index:int):void{
			m_map[index]=createNewAnimal(index);
		}
		
		public function createNewAnimal(index:int):IFallingEntity
		{
			if(m_map[index]!=null){
				trace();
			}
			var a:Animal=new Animal();
			m_animalLayer.addChild(a as Sprite);
			a.color=m_eliminateSys.randomColor;
			m_fallingSys.setPosition(a,index);
			m_eliminateSys.add(a);
			
			return a; 
		}
		
		public function createNewBlock(index:int,type:uint):IBlockEntity
		{
			var b:IBlockEntity=Factory.createBlock(type);
			b.x=(index%GameSize.s_cols)*GameSize.s_gridw+GameSize.s_gridw*.5;
			b.y=int(index/GameSize.s_cols)*GameSize.s_gridh+GameSize.s_gridh*.5;
			m_blockLayer.addChild(b as Sprite);
			return b;
		}
		
		//////////////////////////////////////////////////////////////
		private var m_lastPlayedTime:uint;
		public function standBy(arr:Array):void
		{
			arr.sort(Array.NUMERIC);
			trace("stady by:"+arr);
			var nowTime:uint=getTimer();
			if(nowTime-m_lastPlayedTime>200){
				Effector.playSound("sound_Drop");
				m_lastPlayedTime=nowTime;
			}
			m_eliminateSys.check(arr);
			
		}
		
		public function fallingOver():void
		{
			if(m_timeoutCount<=0){
				if(m_eliminateSoundLevel>=11)Effector.playSound("sound_contnuousMatch_11");//unbelievable
				else if(m_eliminateSoundLevel>=9)Effector.playSound("sound_contnuousMatch_9");//amazing
				else if(m_eliminateSoundLevel>=7)Effector.playSound("sound_contnuousMatch_7");//excellent
				else if(m_eliminateSoundLevel>=5)Effector.playSound("sound_contnuousMatch_5");//great
				else if(m_eliminateSoundLevel>=3)Effector.playSound("sound_contnuousMatch_3");//good
				m_eliminateSoundLevel=0;
			}
		}
		
		public function canExchange(indexA:int, indexB:int):int
		{
			return m_mapSys.canExchange(indexA,indexB);
		}
		
		public function dispatchDisappearIndexes(disappearIndexes:Array,playSound:Boolean):void
		{
			var arr:Array=disappearIndexes.concat();
			var bArr:Array=m_mapSys.disappear(arr);
			if(bArr.length>0){
				m_fallingSys.meltNodes(bArr);
			}
			
			for each(var idx:int in arr){
				var entity:IEliminateEntity=m_map[idx];
				if(entity){
					m_animalLayer.removeChild(entity as Sprite);
					m_map[idx]=null;
				}
			}
			
			m_eliminateSoundLevel++;
			if(playSound){
				if(m_eliminateSoundLevel>8){
					Effector.playSound("sound_eliminate_8");
				}else
					Effector.playSound("sound_eliminate_"+m_eliminateSoundLevel);
			}
			
			arr=arr.concat(bArr);
			setTimeout(noticeToFsys,250,arr);
//			noticeToFsys(arr);
			m_timeoutCount++;
		}
		
		private function noticeToFsys(arr:Array):void{
			m_timeoutCount--;
			m_fallingSys.disappear(arr);
		}
		
		
		//////////////////////////////////////////////////////////////
		public function freeze(arr:Array):void
		{
			m_fallingSys.freezeNodes(arr);
		}
		
		public function melt(arr:Array):void
		{
			// TODO Auto Generated method stub
			m_fallingSys.meltNodes(arr);
		}
		
		public function clean():void{
			m_fallingSys.clean();
			m_mapSys.clean();
			m_eliminateSys.clean();
			
			for each(var entity:AnimalEntity in m_map){
				if(entity){
					entity.destroy();
					m_animalLayer.removeChild(entity);
				}
			}
			m_map.length=0;
			
			for each(var bEntity:BlockEntity in m_blockMap){
				if(bEntity==null)continue;
				bEntity.destroy();
				m_blockLayer.removeChild(bEntity);
			}
			m_blockMap.length=0;
		}
		
	}
}