package z_spark.fallingsystem
{
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	
	import z_spark.kxxxlcore.Assert;
	import z_spark.kxxxlcore.GameSize;
	
	CONFIG::DEBUG{
		import flash.display.Sprite;
		import z_spark.core.debug.logger.Logger;
	};

	public class FallingSystem
	{
		CONFIG::DEBUG{
			private static var s_log:Logger=Logger.getLog("FallingSystem");
			public static var s_ins:FallingSystem;
			private var m_fdebugger:FallingSystemDebugger;
			public var m_updateFn:Function=update;
			
			public function startDebug(debugLayer:Sprite):void{
				m_fdebugger=new FallingSystemDebugger(m_stage,debugLayer);
			}
			
			public function get startSpeed():Number{return m_startSpeed;}
			public function set startSpeed(value:Number):void{m_startSpeed=value;}
		};
		
		private static const MAX_SPEED:Number=15.0;
		private var m_standByArr:Array=[];
		private var m_trigger:Sprite;
		private var m_nodeCtrl:NodeController;
		private var m_startSpeed:Number=6.0;
		private var m_acc:Number=.2;
		private var m_iSys:IIntegrationSys_FS;
		private var m_fallingEntities:Vector.<IFallingEntity>;
		private var m_map:Array;
		private var m_stage:Stage;
		
		public function FallingSystem()
		{
			m_fallingEntities=new Vector.<IFallingEntity>();
			m_nodeCtrl=new NodeController();
			m_trigger=new Sprite();
			CONFIG::DEBUG{s_ins=this;}
		}
		
		public function init(stage:Stage,map:Array,value:IIntegrationSys_FS):void{
			m_stage=stage;
			m_map=map;
			m_iSys=value;
			m_nodeCtrl.init(map);
		}
		
		public function setData(roadArr:Array,startArr:Array):void{
			m_nodeCtrl.setData(roadArr,startArr);
		}
		
		public function refreshRelation():void{
		}
		
		/**
		 * 根据index找到唯一node的中心点，刷新指定IFallingEntity的位置 
		 * @param entity
		 * @param index
		 * 
		 */
		public function setPosition(entity:IFallingEntity,index:int):Node{
			var node:Node=m_nodeCtrl.getNode(index);
			if(node==null){
				CONFIG::DEBUG{
					s_log.info("::setPosition(),"+index+"所在节点（Node）不存在!");
				};
				return null;
			}
			entity.x=getCenterX(node);
			entity.y=getCenterY(node);
			node.isOccupied=true;
			entity.occupiedIndex=index;
			return node;
		}
		
		/**
		 * 逻辑会改变参数 
		 * @param disappearArr
		 * 
		 */
		public function disappear(disappearArr:Array):void{
			if(disappearArr.length<=0)return;
			CONFIG::DEBUG{
				s_log.info("::disappear():going to disappear indexes:"+disappearArr);
				s_log.info("::disappear(),start m_fallingEntities length:"+m_fallingEntities.length);
			};
			
			while(disappearArr.length>0){
				var dIndex:int=disappearArr.pop();
				if(m_map[dIndex]!=null)continue;
				if(m_nodeCtrl.isFrozenNode(dIndex))continue;
				var node:Node=m_nodeCtrl.getNode(dIndex);
				if(node==null)continue;
				
				node.isOccupied=false;
				var fnode:Node=node.elderNode;
				while(fnode){
					fnode.supplyNodes[node.relationToElderNode]=node;
					var entity:IFallingEntity=m_map[fnode.index];
					if(entity){
						initFallingStatus(entity,fnode);
						m_map[fnode.index]=null;
					}
					node=fnode;
					fnode=fnode.elderNode;
				}
			}
			
			CONFIG::DEBUG{
				if(m_fdebugger.paused){
					return;
				}
			};
			if(!m_trigger.hasEventListener(Event.ENTER_FRAME))m_trigger.addEventListener(Event.ENTER_FRAME,update);
				
		}
		
		/**
		 * 推入update列表，并定位到node所在的位置； 
		 * no init speed;
		 * @param entity
		 * @param node
		 * 
		 */
		private function initFallingStatus(entity:IFallingEntity,node:Node):void{
			if(m_fallingEntities.indexOf(entity)>=0){
				trace();
				return;
			}
			
			m_fallingEntities.push(entity);
			entity.spdy=m_startSpeed;
			entity.spdx=0;
			entity.finishY=getCenterY(node);
			entity.finishX=getCenterX(node);
		}
		
		private function update(evt:Event):void{
			m_standByArr.length=0;
			var copy:Vector.<IFallingEntity>=m_fallingEntities.concat();
			for (var i:int=0;i<copy.length;i++){
				var entity:IFallingEntity=copy[i];
				CONFIG::DEBUG{
					Assert.AssertTrue(m_map.indexOf(entity)<0);
				};
				
				if(entity.spdx>0){
					entity.spdx+=m_acc;
					if(entity.spdx>MAX_SPEED)entity.spdx=MAX_SPEED;
				}else if(entity.spdx<0){
					entity.spdx-=m_acc;
					if(entity.spdx<-MAX_SPEED)entity.spdx=-MAX_SPEED;
				}
				entity.spdy+=m_acc;
				if(entity.spdy>MAX_SPEED)entity.spdy=MAX_SPEED;
				entity.x+=entity.spdx;
				entity.y+=entity.spdy;
				if(entity.y>=entity.finishY){
					var index:int=entity.index;
					//到达阶段性目的地;
//					CONFIG::DEBUG{
//						Assert.AssertTrue(m_map[index]==null);
//					};
					var node:Node=m_nodeCtrl.getNode(index);
					var fnode:Node=node.elderNode;
					if(fnode && m_nodeCtrl.isRootNode(fnode.index)){
						if(!fnode.isOccupied){
							//创建新的entity；
							var newCmp:IFallingEntity=m_iSys.createNewAnimal(fnode.index);
							initFallingStatus(newCmp,fnode);
						}
					}
					
					var cnode:Node=node.getNextSupplyNodeWithPriority();
					if(cnode){
						//check wheather can falling down before others
						if(cnode.isOccupied){
							//occupied by some one,just wait untill next frame;
							entity.x-=entity.spdx;
							entity.y-=entity.spdy;
							continue;
						}else{
							node.isOccupied=false;
							cnode.isOccupied=true;
							entity.occupiedIndex=cnode.index;
							setNewMotivationState(node,cnode,entity,entity.y-entity.finishY);
						}
					}else{
						//不能继续下落；
						
						entity.y=entity.finishY;
						entity.x=entity.finishX;
						
						m_fallingEntities.splice(m_fallingEntities.indexOf(entity),1);
						if(fnode)fnode.supplyNodes[node.relationToElderNode]=null;
						
						m_map[index]=entity;
						m_standByArr.push(index);
					}
				}
			}
			if(m_standByArr.length!=0)m_iSys.standBy(m_standByArr);
			
			if(m_fallingEntities.length<=0){
				CONFIG::DEBUG{
					s_log.info("fallingEntities.length==0.");
				};
				if(m_trigger.hasEventListener(Event.ENTER_FRAME))m_trigger.removeEventListener(Event.ENTER_FRAME,update);
				var connArr:Array=m_nodeCtrl.tryConnToElder();
				if(connArr.length!=0)disappear(connArr);
				else m_iSys.fallingOver();
			}
		}
		
		private function setNewMotivationState(fnode:Node,node:Node,entity:IFallingEntity,overDis:Number):void{
			
			entity.finishY=getCenterY(node);
			entity.finishX=getCenterX(node);
			
			if(fnode.deep!=node.deep-1){
				entity.x=entity.finishX;
				entity.y=entity.finishY-GameSize.s_gridh+overDis;
				entity.spdx=0;
			}else{
				
				if(node.relationToElderNode==Relation.SON){
					entity.spdx=0;
					entity.x=entity.finishX;
				}else if(node.relationToElderNode==Relation.LEFT_NEPHEW){
					entity.spdx=-entity.spdy;
					entity.x=getCenterX(fnode)-overDis;
				}else if(node.relationToElderNode==Relation.RIGHT_NEPHEW){
					entity.spdx=entity.spdy;
					entity.x=getCenterX(fnode)+overDis;
				}else{
					Assert.AssertTrue(false);
				}
			}
		}
		
		private function getCenterY(node:Node):int{return node.row*GameSize.s_gridh+GameSize.s_gridh*.5;}
		private function getCenterX(node:Node):int{return node.col*GameSize.s_gridw+GameSize.s_gridw*.5;}
		
		public function meltNodes(arr:Array):void{
			m_nodeCtrl.meltNodes(arr);
		}
		
		public function freezeNodes(arr:Array):void{
			m_nodeCtrl.freezeNodes(arr);
		}
		
		/**
		 *清除掉落系统中所有的缓存数据； 
		 * 
		 */
		public function clean():void{
			if(m_trigger.hasEventListener(Event.ENTER_FRAME))m_trigger.removeEventListener(Event.ENTER_FRAME,update);
			while(m_fallingEntities.length>0){
				var entity:Sprite=m_fallingEntities.pop() as Sprite;
				if(entity.parent)entity.parent.removeChild(entity);
				(entity as IFallingEntity).destroy();
			}
			
			m_fallingEntities.length=0;
			m_nodeCtrl.clean();
		}
	}
}