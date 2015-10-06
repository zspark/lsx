package z_spark.eliminatesystem
{
	import flash.display.Sprite;
	import flash.display.Stage;
	
	import z_spark.attractionsystem.EffectNameConst;
	import z_spark.attractionsystem.Effector;
	import z_spark.core.debug.logger.Logger;

	public class EliminateSystem
	{
		CONFIG::DEBUG{
			private static var s_log:Logger=Logger.getLog("EliminateSystem");
			public static var s_ins:EliminateSystem;
			public function get map():Array{return m_map;}
			public function get exchange():Exchange{return m_exchange;}
			private var m_debugger:EliminatedSystemDebugger;
			
			public function startDebug(stage:Stage,debugLayer:Sprite):void{
				m_debugger=new EliminatedSystemDebugger(stage,debugLayer);
			}
			
		};
		
		private var m_map:Array;
		private var m_dragControl:DragControl;
		private var m_iSys:IIntegrationSys_ES;
		private var m_exchange:Exchange;
		private var m_stage:Stage;
		
		public function EliminateSystem()
		{
			m_dragControl=new DragControl();
			CONFIG::DEBUG{s_ins=this;};
		}
		
		public function init(s:Stage,map:Array,ms:IIntegrationSys_ES):void{
			m_stage=s;
			m_map=map;
			m_iSys=ms;
			m_exchange=new Exchange(endFirstExchange,endSecondExchange);
			m_dragControl.init(s,map,ms,m_exchange);
			
			EliminateCheck3.init(m_map,tryGenNewEffectAnimal);
		}
		
		/**
		 * 设置过滤数组，数组中的索引不存在消除检测；也不会存在于最后的消除列表中；
		 * @param arr
		 * 
		 */
		public function set filterArr(arr:Array):void{EliminateCheck3.filterArr=arr;}
		public function add(entity:IEliminateEntity):void{m_dragControl.add(entity);}
		public function remove(entity:IEliminateEntity):void{m_dragControl.remove(entity);}
		public function set dragDelay(value:Number):void{m_dragControl.delay=value;}
		public function get randomColor():uint{
			return ColorConst.TOTAL[int(Math.random()*ColorConst.TOTAL.length)];
		}
		
		public function check(arr:Array):void{
			var eArr:Array=[];var sEntities:Array=[];
			EliminateCheck3.checkArray(arr,eArr,sEntities);
			afterCheck(eArr,sEntities,false,true);
		}
		
		/**
		 * 玩家拖动2个动物成功切换位置后；
		 * 由DragControl回调； 
		 * 
		 */
		private function endFirstExchange():void{
			var eArr:Array=[];var sEntities:Array=[];
			var result:int=EliminateCheck3.handleCombine(m_exchange.indexA,m_exchange.indexB,eArr,sEntities);
			if(result>=HandleResult.SUPER_NORMAL){
				CONFIG::DEBUG{
					s_log.info("::endFirstExchange(),//魔力鸟参与的组合消除,result="+result);
				};
				new CombineEliminate(m_map,m_iSys,m_dragControl,eArr,sEntities,result);
			}else if(result==HandleResult.OTHER_COMBINE){
				CONFIG::DEBUG{
					s_log.info("::endFirstExchange(),//没有魔力鸟参与的组合消除,result="+result);
				};
				afterCheck(eArr,sEntities,true,false);
			}else{
				CONFIG::DEBUG{
					s_log.info("::endFirstExchange(),//普通消除,result="+result);
				};
				EliminateCheck3.handleNormal(m_exchange.indexA,m_exchange.indexB,eArr,sEntities);
				afterCheck(eArr,sEntities,true,true);
			}
		}
		
		/**
		 * 第一次成功切换位置后，经检测不构成消除，
		 * 由DragControl将位置复原后，回调该函数；
		 */
		private function endSecondExchange():void
		{
			m_dragControl.locked=false;
		}
		
		private function afterCheck(eArr:Array,sEntities:Array,recover:Boolean,playSound:Boolean):void{
			if(eArr.length>=3){
				trace("可以消除;");
				var n:int=0;
				while(n<sEntities.length){
					var e:IEliminateEntity=sEntities[n];
					EliminateCheck3.pushSpecial(e.index,eArr,sEntities);
					n++;
				}
				
				for each(var idx:int in eArr){
					var entity:IEliminateEntity=m_map[idx];
					if(entity){
						Effector.getEliminateEffect(EffectNameConst.EFT_ANIMAL_ELIMINATE,idx,true);
						m_dragControl.remove(entity);
					}
				}
				
				m_iSys.dispatchDisappearIndexes(eArr,Boolean);
				m_dragControl.locked=false;
			}else{
				trace("不可以消除！");
				if(recover)	m_dragControl.recover();
			}
			
		}
		
		private function tryGenNewEffectAnimal_(index:int,arr:Array,toType:int):int{
			var entity:IEliminateEntity=m_map[index];
			if(entity.type==TypeConst.NORMAL){
				entity.type=toType;
				return index;
			}else{
				var i:int=0;
				while(i<arr.length){
					entity=m_map[arr[i]];
					if(entity.type==TypeConst.NORMAL)break;
					i++;
				}
				
				if(i>=arr.length){
					//not found corrent animal;
					return -999;
				}else{
					entity.type=toType;
					return arr[i];
				}
			}
		}
		
		private function tryGenNewEffectAnimal(rowEliminateArr:Array,colEliminateArr:Array,index:int):int{
			var rowCount:uint=rowEliminateArr.length;
			var colCount:uint=colEliminateArr.length;
			var entity:IEliminateEntity=m_map[index];
			var isTartgetNormal:Boolean=entity.type==TypeConst.NORMAL;
			
			//移动的动物不是普通动物的话，需要随机选取一个rowEliminateArr或者colEliminatedArr中的索引
			//作为新的特效动物的位置；
			var result:int=-999;
			if(rowCount>=5){
				result=tryGenNewEffectAnimal_(index,rowEliminateArr,TypeConst.SUPER);
				Effector.playSound("sound_create_color");
			}else if( colCount>=5){
				result=tryGenNewEffectAnimal_(index,colEliminateArr,TypeConst.SUPER);
				Effector.playSound("sound_create_color");
			}else{
				if(rowCount==4){
					if(colCount>=3){
						result=tryGenNewEffectAnimal_(index,colEliminateArr.concat(rowEliminateArr),TypeConst.BOOM);
						Effector.playSound("sound_create_wrap");
					}else{
						result=tryGenNewEffectAnimal_(index,rowEliminateArr,TypeConst.LINE_UD);
						Effector.playSound("sound_create_strip");
					}
				}else if(colCount==4){
					if(rowCount>=3){
						result=tryGenNewEffectAnimal_(index,colEliminateArr.concat(rowEliminateArr),TypeConst.BOOM);
						Effector.playSound("sound_create_wrap");
					}else{
						result=tryGenNewEffectAnimal_(index,colEliminateArr,TypeConst.LINE_LR);
						Effector.playSound("sound_create_strip");
					}
				}else if(colCount==3 && rowCount==3){
					result=tryGenNewEffectAnimal_(index,colEliminateArr.concat(rowEliminateArr),TypeConst.BOOM);
					Effector.playSound("sound_create_wrap");
				}
			}
			return result;
		}
		
		public function clean():void{
			m_exchange.clear();
			for each(var entity:IEliminateEntity in m_map){
				if(entity){
					m_dragControl.remove(entity);
				}
			}
		}
	}
}