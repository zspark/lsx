package z_spark.eliminatesystem
{
	import flash.geom.Point;
	
	import z_spark.attractionsystem.EffectNameConst;
	import z_spark.attractionsystem.Effector;
	import z_spark.batata.ui.Movie;

	internal final class Exchange
	{
		internal var startPos:Point=new Point();
		internal var dir:uint;
		internal var dis:Number;
		
		internal var indexA:int;
		internal var indexB:int;
		private var m_entityA:IEliminateEntity;
		internal var entityB:IEliminateEntity;
		private var m_selectMovie:Movie;

		public function get entityA():IEliminateEntity
		{
			return m_entityA;
		}

		public function set entityA(value:IEliminateEntity):void
		{
			if(m_entityA && m_entityA !=value){
				m_entityA.select=false;
				if(m_selectMovie)Effector.deleteEffectIns(m_selectMovie);
			}
			m_entityA = value;
			m_entityA.select=true;
			m_selectMovie=Effector.getSelectEffect(EffectNameConst.EFT_SELECT,indexA,true);
			m_selectMovie.mouseEnabled=false;
			m_selectMovie.mouseChildren=false;
			
		}

		internal function get secondCall():Function{return m_secondCall;}
		internal function get firstCall():Function{return m_firstCall;}

		private var m_firstCall:Function;
		private var m_secondCall:Function;
		
		public function Exchange(firstFn:Function,secondFn:Function){
			m_firstCall=firstFn;
			m_secondCall=secondFn;
		}
		
		internal function clear():void{
			m_entityA=entityB=null;
			indexA=indexB=-1;
			clearEffect();
		}
		
		internal function clearEffect():void{
			if(m_selectMovie){
				if(m_selectMovie)Effector.deleteEffectIns(m_selectMovie);
			}
		}
		
		internal function toString():String{
			return "["+indexA+","+indexB+"]";
		}
	}
}