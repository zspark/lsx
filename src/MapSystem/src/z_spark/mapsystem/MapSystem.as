package z_spark.mapsystem
{
	import flash.display.Bitmap;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.MouseEvent;
	import flash.utils.Dictionary;
	
	import z_spark.batata.res.Res;
	import z_spark.core.debug.logger.Logger;
	import z_spark.kxxxlcore.ExchangeStatus;
	import z_spark.kxxxlcore.GameSize;
	
	final public class MapSystem
	{
		CONFIG::DEBUG{
			private static var s_log:Logger=Logger.getLog("MapSystem");
			public static var s_ins:MapSystem;
			public function get blockMap():Array{return m_blockMap;}
			public function get map():Array{return m_map;}
			private var m_tileClickCB:Function;
			private var m_debugger:MapSystemDebugger;
			
			private function onTileClick(event:MouseEvent):void
			{
				if(m_tileClickCB){
					var tile:MapTile=event.currentTarget as MapTile;
					if(tile){
						tile.chosen=!tile.chosen;
						if(tile.chosen)tile.drawWith(0x22aa33);
						else 
							tile.drawWith(MapTile.DEFAULT_COLOR);
						m_tileClickCB(tile);
					}
				}
			}
			
			public function set tileClickCB(value:Function):void{m_tileClickCB = value;}
			
			public function startDebug(stage:Stage,debugLayer:Sprite):void{
				m_debugger=new MapSystemDebugger(stage,debugLayer);
			}
			
		};
		
		private var m_gridMap:Array=[];
		private var m_blockMap:Array;
		private var m_fenceMap:Dictionary;
		private var m_map:Array;
		private var m_iSys:IIntegrationSys_MS;
		private var m_blockLayer:DisplayObjectContainer;
		private var m_mapLayer:DisplayObjectContainer;
		private var m_animalLayer:DisplayObjectContainer;
		private var m_filterArr:Array;
		
		public function MapSystem(){CONFIG::DEBUG{s_ins=this;}}
		
		public function init(map:Array,blockMap:Array,isys:IIntegrationSys_MS,mapLayer:DisplayObjectContainer,blockLayer:Sprite,animalLayer:Sprite):void{
			m_map=map;
			m_blockMap=blockMap;
			m_iSys = isys;
			m_mapLayer=mapLayer;
			m_blockLayer=blockLayer;
			m_animalLayer=animalLayer;
			m_fenceMap=new Dictionary();
		}
		
		/**
		 * 绘制地形形状，背景图，遮罩动物层； 
		 * @param gridArr
		 * @param startArr
		 * @param animalLayer
		 * 
		 */
		public function setData(gridArr:Array,startArr:Array):void{
			CONFIG::DEBUG{
				s_log.info("::setData()\ngridArr:"+gridArr+"\nstartArr:"+startArr);
			};
			m_filterArr=startArr.concat();
			var mask:Sprite=new Sprite();
			m_gridMap.length=0;
			for (var i:int=0;i<gridArr.length;i++){
				for (var j:int=0;j<gridArr[i].length;j++){
					var index:int=gridArr[i][j];
					if(startArr.indexOf(index)>=0)continue;
					
					var row:int=int(index/GameSize.s_cols);
					var col:int=index%GameSize.s_cols;
					var tile:MapTile=new MapTile(index);
					tile.x=col*GameSize.s_gridw;tile.y=row*GameSize.s_gridh;
					CONFIG::DEBUG{
						tile.addEventListener(MouseEvent.CLICK,onTileClick);
					};
					m_mapLayer.addChild(tile);
					m_gridMap[index]=tile;
					
					var bg:Bitmap=Res.getBitmap("tile");
					bg.x=col*GameSize.s_gridw;bg.y=row*GameSize.s_gridh;
					mask.addChild(bg);
				}
			}
//			CONFIG::DEBUG{ return;};
			m_animalLayer.mask=mask;
		}
		
		/**
		 *尝试消除地形上的障碍物，比如雪、冰、病毒等 
		 * @param arr
		 * 
		 */
		public function disappear(arr:Array):Array{
			var bArr:Array=[];
			for each(var index:int in arr){
				
				//消除的格子周围需要检测;
				check(index,bArr,false);
				if(m_map[index]==null)continue;
				if(arr.indexOf(index+1)<0 && isSameRow(index,index+1))check(index+1,bArr);
				if(arr.indexOf(index-1)<0 && isSameRow(index,index-1))check(index-1,bArr);
				if(arr.indexOf(index+GameSize.s_cols)<0)check(index+GameSize.s_cols,bArr);
				if(arr.indexOf(index-GameSize.s_cols)<0)check(index-GameSize.s_cols,bArr);
			}
			
			return bArr;
		}
		
		private function check(index:int,bArr:Array,isAround:Boolean=true):void{
			if(m_filterArr.indexOf(index)>=0)return;
			
			var b:IBlockEntity=getBlockEntity(index);
			if(b){
				if(isAround==false || b.isOcupier){
					var result:Boolean=b.tryEliminate(index);
					if(result){
						b.destroy();
						m_blockLayer.removeChild(b as Sprite);
						m_blockMap[index]=null;
						if(b.isOcupier)bArr.push(index);
					}
					
				}
			}
		}
		
		private function getBlockEntity(index:int):IBlockEntity{
			if(index<0 || index>=GameSize.s_cols*GameSize.s_rows)return null;
			return m_blockMap[index];
		}
		
		/**
		 * 创建地图阻挡物，雪地，冰块，鸡蛋，章鱼，草笼等；
		 * @param value
		 * @param type	TypeConst类型；
		 * 
		 */
		public function  createBlock(value:Array,type:uint):void{
			switch(type)
			{
				case BlockTypeConst.BUBBLE:
				{
					createBlock_(value,type);
					break;
				}
				case BlockTypeConst.ICE:
				{
					createBlock_(value,type);
					m_iSys.freeze(value);
					break;
				}
				case BlockTypeConst.EGG:
				{
					createBlock_(value,type);
					m_iSys.freeze(value);
					break;
				}
				case BlockTypeConst.FENCE_LR:
				case BlockTypeConst.FENCE_UD:
				{
					for (var i:int=0;i<value.length;i+=2){
						var indexA:int=value[i];
						var dis:IBlockEntity=m_iSys.createNewBlock(indexA,type);
						var indexB:int=value[i+1];
						m_fenceMap[indexA+'_'+indexB]=dis;
						m_fenceMap[indexB+"_"+indexA]=dis;
						
						if(isSameRow(indexA,indexB)){
							dis.type=BlockTypeConst.FENCE_UD;
						}else{
							dis.type=BlockTypeConst.FENCE_LR;
						}
						
						dis.x+=(indexB%GameSize.s_cols)*GameSize.s_gridw+GameSize.s_gridw*.5;
						dis.x/=2;
						dis.y+=int(indexB/GameSize.s_cols)*GameSize.s_gridh+GameSize.s_gridh*.5;
						dis.y/=2;
						
					}
					trace();
					break;
				}
				default:
				{
					break;
				}
			}
		}
		
		private function createBlock_(value:Array,type:uint):void{
			for (var i:int=0;i<value.length;i++){
				var index:int=value[i];
				var dis:IBlockEntity=m_iSys.createNewBlock(index,type);
				m_blockMap[index]=dis;
			}
		}
		
		public function canExchange(indexA:int, indexB:int):int
		{
			CONFIG::DEBUG{
				s_log.info("::canExchange(),"+indexA+"|"+indexB);
			};
			if(m_filterArr.indexOf(indexA)>=0)return ExchangeStatus.STAND_STILL;
			if(m_filterArr.indexOf(indexB)>=0)return ExchangeStatus.STAND_STILL;
			if(m_fenceMap[indexA+'_'+indexB]!=null)return ExchangeStatus.SLIGHTLY;
			return ExchangeStatus.EXCHANGE;
		}
		
		public function clean():void{
			for each(var tile:MapTile in m_gridMap){
				CONFIG::DEBUG{
					tile.removeEventListener(MouseEvent.CLICK,onTileClick);
				};
				tile.destroy();
				m_mapLayer.removeChild(tile);
			}
			m_gridMap.length=0;
			
			for each(var entity:IBlockEntity in m_fenceMap){
				if((entity as Sprite).parent==m_blockLayer){
					m_blockLayer.removeChild(entity as Sprite);
					entity.destroy();
				}
			}
			m_fenceMap=new Dictionary();
		}
		
		private function isSameRow(indexA:int,indexB:int):Boolean{
			return int(indexA/GameSize.s_cols)==int(indexB/GameSize.s_cols);
		}
		
	}
}