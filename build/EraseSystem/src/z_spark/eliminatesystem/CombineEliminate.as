package z_spark.eliminatesystem
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.utils.setTimeout;
	
	import z_spark.attractionsystem.EffectNameConst;
	import z_spark.attractionsystem.Effector;
	

	internal final class CombineEliminate
	{
		private static const m_step:uint=22;
		private var m_specialEntities:Array=[];
		private var m_cur:uint=0;
		private var m_iSys:IIntegrationSys_ES;
		private var m_dragControl:DragControl;
		private var m_map:Array;
		private var m_eArr:Array;
		private var toType:int;
		private var m_trigger:Sprite;
		
		public function CombineEliminate(map:Array,iSys:IIntegrationSys_ES,dragCtrl:DragControl
										 ,eArr:Array,sEntities:Array,result:int)
		{
			m_map=map;
			m_iSys=iSys;			
			m_dragControl=dragCtrl;
			m_dragControl.locked=true;
			
			toType=result-TypeConst.SUPER;
			if(toType==TypeConst.NORMAL){
				//如果是魔力鸟与普通的动物组合消除的话（就是清除掉与该普通动物颜色相同的所有动物），
				//不会触发任何其他特效，等待魔力鸟漩涡动画播放完毕，直接清除；
				m_eArr=eArr;
			}else{
				for each(var index :int in eArr){
					var entity:IEliminateEntity=m_map[index];
					if(entity){
						m_dragControl.remove(entity);
						//TODO:播放动画，让魔力鸟将其他普通鸟变成特效鸟；
						if(result==HandleResult.SUPER_LINE)entity.type=Math.random()>.5?TypeConst.LINE_LR:TypeConst.LINE_UD;
						else  entity.type=toType;
						m_specialEntities.push(entity);
					}
				}
			}
			setTimeout(eliminateStart,1500);
		}
		
		private function eliminateStart():void
		{
			if(toType==TypeConst.NORMAL){
				for each(var idx:int in m_eArr){
					var entity:IEliminateEntity=m_map[idx];
					destroyEntity(entity,idx);
				}
				m_iSys.dispatchDisappearIndexes(m_eArr,false);
				destroy();
			}else{
				m_trigger=new Sprite();
				m_trigger.addEventListener(Event.ENTER_FRAME,onE);
			}
		}
		
		private function onE(event:Event):void
		{
			m_cur++;
			if(m_cur%m_step==0){
				var entity:IEliminateEntity=getEntity();
				if(entity){
					var eArr:Array=[],sEntities:Array=[entity];
					var n:int=0;
					while(n<sEntities.length){
						var e:IEliminateEntity=sEntities[n];
						EliminateCheck3.pushSpecial(e.index,eArr,sEntities);
						
						var i:int=m_specialEntities.indexOf(e);
						if(i>=0)m_specialEntities.splice(i,1);
						n++;
					}
					
					for each(var idx:int in eArr){
						entity=m_map[idx];
						destroyEntity(entity,idx);
					}
					
					m_iSys.dispatchDisappearIndexes(eArr,false);
					
				}
				if(m_specialEntities.length==0){
					destroy();
				}
			}
		}
		
		private function destroyEntity(entity:IEliminateEntity,index:int):void{
			if(entity==null)return;
			Effector.getEliminateEffect(EffectNameConst.EFT_ANIMAL_ELIMINATE,index,true);
			m_dragControl.remove(entity);
		}
		
		private function getEntity():IEliminateEntity{
			for each(var entity:IEliminateEntity in m_specialEntities){
				if(m_map.indexOf(entity)>=0){
					return entity;
				}else{
					if(m_map[entity.index]!=null){
						var i:int=m_specialEntities.indexOf(entity);
						if(i>=0)m_specialEntities.splice(i,1);
					}
				}
			}
			return null;
		}
		
		private function destroy():void{
			if(m_trigger)m_trigger.removeEventListener(Event.ENTER_FRAME,onE);
			m_map=null;
			m_iSys=null;			
			m_dragControl.locked=false;
			m_dragControl=null;
		}
		
	}
}