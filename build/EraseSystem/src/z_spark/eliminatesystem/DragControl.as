package z_spark.eliminatesystem
{
	import com.greensock.TweenLite;
	
	import flash.display.Stage;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.utils.setTimeout;
	
	import z_spark.attractionsystem.Effector;
	import z_spark.core.debug.logger.Logger;
	import z_spark.kxxxlcore.GameSize;

	final internal class DragControl
	{
		CONFIG::DEBUG{
			private static var s_log:Logger=Logger.getLog("DragControl");
		};
		
		private const MAX_DIS:uint=30;
		private var m_delay:Number=.3;
		
		private var m_MS:IIntegrationSys_ES;
		private var m_stage:Stage;
		private var m_addedEntities:Array;
		private var m_map:Array;
		private var m_exchange:Exchange;
		private var m_locked:Boolean=false;
		
		public function DragControl(){
			m_addedEntities=[];
		}
		
		public function set locked(value:Boolean):void{m_locked = value;}
		public function set delay(value:Number):void{m_delay = value;}

		public function init(s:Stage,map:Array,ms:IIntegrationSys_ES,exchange:Exchange):void{
			m_stage=s;
			m_map=map;
			m_MS=ms;
			m_exchange=exchange;
		}
		
		public function add(entity:IEliminateEntity):void
		{
			if(entity==null)return;
			if(m_addedEntities.indexOf(entity)>=0)return;
			m_addedEntities.push(entity);
			entity.addEventListener(MouseEvent.MOUSE_DOWN,onMDown);
		}
		
		public function remove(entity:IEliminateEntity):void{
			if(entity==null)return;
			var index:int=m_addedEntities.indexOf(entity);
			if(index<0)return;
			m_addedEntities.splice(index,1);
			entity.removeEventListener(MouseEvent.MOUSE_DOWN,onMDown);
		}
		
		private function onMDown(event:MouseEvent):void
		{
			if(m_locked)return;
			trace("onMDown");
			
			var entity:IEliminateEntity=event.currentTarget as IEliminateEntity;
			if(entity){
				m_stage.addEventListener(MouseEvent.MOUSE_MOVE,onMMove);
				m_stage.addEventListener(MouseEvent.MOUSE_UP,onMUp);
				m_exchange.startPos.x=event.stageX;
				m_exchange.startPos.y=event.stageY;
				m_exchange.indexA=m_map.indexOf(entity);
				m_exchange.entityA=entity;
			}
		}
		
		private function onMUp(event:MouseEvent):void
		{
			trace("onMUp");
			if(m_exchange.entityA){
				m_stage.removeEventListener(MouseEvent.MOUSE_MOVE,onMMove);
				m_stage.removeEventListener(MouseEvent.MOUSE_UP,onMUp);
				
			}
		}
		
		private function onMMove(event:MouseEvent):void
		{
			var deltaX:Number=event.stageX-m_exchange.startPos.x;
			var deltaY:Number=event.stageY-m_exchange.startPos.y;
			var sqrDis:Number=deltaX*deltaX+deltaY*deltaY;
			if(sqrDis>MAX_DIS*MAX_DIS){
				CONFIG::DEBUG{
					s_log.info("::onMMove(),超过一定距离后，触发检测;");
				};
				if(Math.abs(deltaX)>Math.abs(deltaY)){
					m_exchange.dir=deltaX>0?DirConst.DIR_RIGHT:DirConst.DIR_LEFT;
				}else{
					m_exchange.dir=deltaY>0?DirConst.DIR_DOWN:DirConst.DIR_UP;
				}
				getAnotherEntity(m_exchange);
				if(m_exchange.entityB)check();
				
				onMUp(event);
			}
			
		}
		
		private function getAnotherEntity(exchange:Exchange):void{
			var index:int=exchange.indexA;
			var row:int=int(index/GameSize.s_cols);
			var col:int=index%GameSize.s_cols;
			switch(exchange.dir)
			{
				case DirConst.DIR_DOWN:
				{
					if(row+1<GameSize.s_rows){
						exchange.entityB=m_map[(row+1)*GameSize.s_cols+col];
					}
					break;
				}
				case DirConst.DIR_UP:
				{
					if(row-1>=0){
						exchange.entityB=m_map[(row-1)*GameSize.s_cols+col];
					}
					break;
				}
				case DirConst.DIR_LEFT:
				{
					if(col-1>=0){
						exchange.entityB=m_map[row*GameSize.s_cols+col-1];
					}
					break;
				}
				case DirConst.DIR_RIGHT:
				{
					if(col+1<GameSize.s_cols){
						exchange.entityB=m_map[row*GameSize.s_cols+col+1];
					}
					break;
				}
				default:
				{
					break;
				}
			}
			
			if(exchange.entityB)exchange.indexB=m_map.indexOf(exchange.entityB);
		}
		
		private function check():void
		{
			CONFIG::DEBUG{
				s_log.info("::check(),ExChange保存的entity 的索引为："+m_exchange.toString());
			};
			var flag:Boolean=m_MS.canExchange(m_exchange.indexA,m_exchange.indexB);
			if(flag){
				m_locked=true;
				//地形上不对这两个动物限制，先交换其位置，然后计算消除；
				changePosition();
				setTimeout(m_exchange.firstCall,m_delay*1000);
				m_exchange.clearEffect();
			}
			
		}
		
		private function changePosition():void
		{
			var tmpA:IEliminateEntity=m_map[m_exchange.indexA];
			var tmpB:IEliminateEntity=m_map[m_exchange.indexB];
			m_map[m_exchange.indexA]=tmpB;
			m_map[m_exchange.indexB]=tmpA;

			var oA:int=tmpA.occupiedIndex;
			tmpA.occupiedIndex=tmpB.occupiedIndex;
			tmpB.occupiedIndex=oA;
			
			var tmpAPos:Point=new Point(tmpA.x,tmpA.y);
			TweenLite.to(tmpA, m_delay, {x:tmpB.x, y:tmpB.y});
			TweenLite.to(tmpB, m_delay, {x:tmpAPos.x, y:tmpAPos.y});
			
			Effector.playSound("sound_swap");
		}
		
		public function recover():void{
			changePosition();
			setTimeout(m_exchange.secondCall,m_delay*1000);
		}
		
	}
}