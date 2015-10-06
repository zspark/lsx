package z_spark.fallingsystem
{
	import flash.display.DisplayObject;
	
	import z_spark.core.debug.logger.Logger;

	/**
	 * 随机左右下落算法； 
	 * @author z_Spark
	 * 
	 */
	public class FallingSystem
	{
		CONFIG::DEBUG{
			private static var s_log:Logger=Logger.getLog("FallingSystem");
		};
		private static const CANNOT:uint=0x01;
		private static const CAN:uint=0x02;
		private static const UNKONW:uint=0x04;
		
		private static const LEFT:uint=1;
		private static const RIGHT:uint=2;
		private static var SPEED:uint=3;
		
		CONFIG::DEBUG
		public function set speed(value:uint):void{
			SPEED=value;
		}
		
		CONFIG::DEBUG
		public function get speed():uint{
			return SPEED;
		}
		
//		private static const UNCONTACT:int=-2;
//		private static const CONTACT:int=-1;
		private static const ANY:int=-9999;
//		private static const CONN_FATHER:uint=0x01;
//		private static const CONN_UNCLE_LEFT:uint=0x01;
//		private static const CONN_UNCLE_RIGHT:uint=0x01;
//		private static const CONN_ANDY:uint=0x01;
		
		CONFIG::DEBUG{
			private var m_fallingDebugVo:DebugFallingVO=new DebugFallingVO();
		};
		private var m_gridW:uint=30;
		private var m_gridH:uint=30;
		private var m_rows:uint=10;
		private var m_cols:uint=10;
		private var m_ocupyMap:Vector.<Vector.<FallComp>>;
		/**
		 * 连通图，矩阵形式表示；
		 * 里面的数据表示这个格子应该由哪个index来填充；
		 * 小于0的索引表示这是个最顶层格子；
		 */
		private var m_unContactMap:Vector.<Vector.<int>>;
		private var m_fallingCmps:Vector.<FallComp>;
		private var m_mapData:IMapData;
		
		
		public function FallingSystem(rows:uint,cols:uint,w:uint,h:uint)
		{			m_gridH=h;
			m_gridW=w;
			m_rows=rows;
			m_cols=cols;
			m_fallingCmps=new Vector.<FallComp>();
			m_ocupyMap=new Vector.<Vector.<FallComp>>(m_rows);
			m_unContactMap=new Vector.<Vector.<int>>(m_rows);
			for (var i:int=0;i<m_rows;i++){
				m_ocupyMap[i]=new Vector.<FallComp>(m_cols);
				m_unContactMap[i]=new Vector.<int>(m_cols);
				for (var j:int=0;j<m_cols;j++){
					m_unContactMap[i][j]=ANY
				}
			}
		
		
		public function set mapData(value:IMapData):void
		{
			m_mapData = value;
		}

		public function destruction():void{
			m_fallingCmps.length=0;
			m_unContactMap.length=0;
			m_ocupyMap.length=0;
		}
		
		CONFIG::DEBUG
		public function randomFill():void{
			var i:int=0;
			while(i<10){
				i++;
				var index:uint=int(Math.random()*m_rows*m_cols);
				m_ocupyMap[int(index/m_cols)][index%m_cols]=new FallComp();
				s_log.info(int(index/m_cols),index%m_cols);
			}
			
//			m_ocupyMap[5][5]=new FallComp();
		}
		
		public function fill(disobj:DisplayObject,isStatic:Boolean,isFalling:Boolean=false):void{
			var row:uint=int(disobj.y/m_gridH);
			var col:uint=int(disobj.x/m_gridW);
			var cmp:FallComp=new FallComp();
			cmp.disobj=disobj;
			cmp.x=col*m_gridW+m_gridW*.5;
			cmp.y=row*m_gridH+m_gridH*.5;
			cmp.disobj.x=cmp.x;
			cmp.disobj.y=cmp.y;
			cmp.isStatic=isStatic;
			m_ocupyMap[row][col]=cmp;
			
			var conn:int=m_mapData.getPreGridIndex(row,col);
			if(conn<0){
				conn=getConnectedUncleIndex(row,col);
			}
			
			m_unContactMap[row][col]=conn<0?ANY:conn;
			
			if(isFalling)pushToUpdate(cmp);
		}
		
		private function pushToUpdate(cmp:FallComp):void{
			m_fallingCmps.push(cmp);
			cmp.spdy=SPEED;
			var row:uint=int(cmp.y/m_gridH);
			var col:uint=int(cmp.x/m_gridW);
			cmp.finishY=calFinishY(row);
			cmp.spdx=0;
			m_ocupyMap[row][col]=cmp;
			cmp.readyToFall=true;
		}
		
		private function destructCmps(arr:Array):void{
			for each(var index:int in arr){
				var row:int=int(index/m_cols);
				 var col:int=index%m_cols;
				 var cmp:FallComp= m_ocupyMap[row][col];
				 if(cmp){
					if(m_fallingCmps.indexOf(cmp)>=0){
						m_fallingCmps.splice(m_fallingCmps.indexOf(cmp),1);
					}
				 	cmp.destruct();
					m_ocupyMap[row][col]=null;
				 }
			}
		}
		/**
		 *消除数组中的对象；
		 * 然后整体下落；
		 * 数组中以格子索引标记； 
		 * @param arr
		 * 
		 */
		public function disappear(arr:Array):void{
				
			//从小到大排序；
			arr.sort(Array.NUMERIC);
			CONFIG::DEBUG{
				m_fallingDebugVo.checkedGridIndexs.length=0;
				s_log.info("::disappear()",arr);
			};
			
			//将数组中对应的格子注销；
			destructCmps(arr);
			
			var startGrid:Boolean=false;
			var invovedIndexs:Array=[];
			
			while(arr.length>0){
				var index:int=arr.pop();
				invovedIndexs.push(index);
				CONFIG::DEBUG{
					m_fallingDebugVo.checkedGridIndexs.push(111111);
					m_fallingDebugVo.checkedGridIndexs.push(index);
					s_log.info("::disappear()",11111+' '+index);
				};
				var row:int=int(index/m_cols);
				var col:int=index%m_cols;
				
				if(!m_mapData.isMapGridExist(row,col)){
					continue;
				}
				
				var continueFlag:Boolean=true;
				//while遍历自己的直系格子；
				//直系不存在话，break，并推入旁系索引；
				while(continueFlag){
					var status:uint=checkGridStatus(row,col);
					switch(status)
					{
						case CANNOT:
						{
							//自己是个阻挡格子；
							var childIndex:int=m_mapData.getNextGridIndex(row,col);
							if(childIndex>=0){
								var childRow:uint=int(childIndex/m_cols);
								var childCol:uint=childIndex%m_cols;
								disappear_internal(childRow,childCol,arr);
							}
							continueFlag=false;
							break;
						}
						case CAN:{
							var cmp:FallComp=getCmp(row,col);
							cmp.readyToFall=true;
							pushToUpdate(cmp);
						}
						case UNKONW:
						{
							//自己不是阻挡格子；
							startGrid=m_mapData.isStartGrid(row,col);
							if(startGrid)continueFlag=false;
							
							//检查直系父格子的存在性；
							var parentIndex:int=m_mapData.getPreGridIndex(row,col);
							if(parentIndex>=0){
								//直系存在;
								if(arr.indexOf(parentIndex)>=0){
									arr.splice(arr.indexOf(parentIndex),1);
									CONFIG::DEBUG{
										s_log.info("::disappear()","有重复索引存在：",parentIndex);
									};
								}
								CONFIG::DEBUG{
									m_fallingDebugVo.checkedGridIndexs.push(parentIndex);
								};
								invovedIndexs.push(parentIndex);
								row=int(parentIndex/m_cols);
								col=parentIndex%m_cols;
							}else{
								//没有直系格子；从旁系查找；
								disappear_internal(row,col,arr);
								continueFlag=false;
							}
							break;
						}	
						default:
						{
							continueFlag=false;
							break;
						}
					}
				}
			}
			
			CONFIG::DEBUG{
				s_log.info("::disappear()",m_fallingDebugVo.checkedGridIndexs);
			};
		}
		
		private function disappear_internal(childRow:int,childCol:int,arr:Array):void{
			var uncleIndex:int=getConnectedUncleIndex(childRow,childCol);
			if(uncleIndex>=0){
				if(arr.indexOf(uncleIndex)<0){
					arr.push(uncleIndex);
					arr.sort(Array.NUMERIC);
				}
				setConnectivity(childRow,childCol,uncleIndex);
				
				CONFIG::DEBUG{
					s_log.info("::disappear(),有旁系加入，剩余遍历索引为（已排序）："+arr);
				};
			}
		}
		
		
		/**
		 * 设置指定格子的连通性； 
		 * @param row
		 * @param col
		 * @param index		可以是ANY
		 * 
		 */
		private function setConnectivity(row:uint,col:uint,index:int):void{
			if(row>=m_rows || row<0 || col>=m_cols || col<0)return ;
			m_unContactMap[row][col]=index;
		}
		/**
		 * 设置格子连通性； 
		 * @param row
		 * @param col
		 * @param type
		 * 
		 */
		/*private function setTargetConnectivity22(row:uint,col:uint,type:uint):void{
			if(row>=m_rows || row<0 || col>=m_cols || col<0)return ;
			var index:int;
			switch(type)
			{
				case CONN_FATHER:
				{
					index=row*m_cols+col;
					break;
				}
				case CONN_UNCLE_LEFT:
				{
					index=row*m_cols+col-1;
					if(col-1<0)index+=1
					break;
				}
				case CONN_UNCLE_RIGHT:
				{
					index=row*m_cols+col+1;
					if(col+1>=m_cols)index-=1
					break;
				}
				case CONN_ANDY:
				default:
				{
					index=ANY;
					break;
				}
			}
			m_unContactMap[row][col]=index;
		}*/
		
		/**
		 * 检查指定格子当前的状态；
		 *  状态有：
		 * CANNOT:这个格子不可以通过，比如是个不能下落的东西或者地图根本没有这个格子；
		 * CAN:可以通过；
		 * UNKONW：不存在下落组件，虽然地图格子存在，但不能确定其是否可通过；
		 * 
		 * @param row
		 * @param col
		 * @return 
		 * 
		 */
		private function checkGridStatus(row:uint,col:uint):uint{
			if(!m_mapData.isMapGridExist(row,col))return CANNOT;
			var cmp:FallComp=getCmp(row,col);
			if(cmp){
				if(cmp.isStatic)return CANNOT
				else return CAN;
			}else{
				CONFIG::DEBUG{
					s_log.info("::getConnectedUncleIndex(),不存在下落组件。");
				};
				return UNKONW;
			}
		}
		
		/**
		 * 检查指定格子的叔叔格子的下落性； 
		 * row与col是指定的格子T，
		 * T的直系格子是个阻挡格；
		 * 这种情况下，T及其直系子孙的填充靠左右叔叔格子；
		 * |─────|─────|─────|<br>
 		 * |uncle|Block|uncle|<br>
		 * |─────|─────|─────|<br>
		 * |     |   T |     |<br>
		 * |─────|─────|─────|<br>
		 * |─────|─────|─────|<br>
		 * @param row
		 * @param col
		 * @return 返回叔叔的索引；-1表示T与左右叔叔都不连通；
		 * 
		 */
		public function getConnectedUncleIndex(row:int,col:int):int{
			CONFIG::DEBUG{
				s_log.info("::getConnectedUncleIndex()"+getCoorString(row,col));
			};
			var ruIndex:int=m_mapData.getPreGridIndex(row,col+1);
			if(ruIndex>=0){
				var urow:int=int(ruIndex/m_cols);
				var ucol:int=ruIndex%m_cols;
				var rStatus:uint=checkGridStatus(urow,ucol);
				if(rStatus==CAN)return ruIndex;
			}else rStatus==CANNOT;	
			
			var luIndex:int=m_mapData.getPreGridIndex(row,col-1);
			if(luIndex>=0){
				urow=int(luIndex/m_cols);
				ucol=luIndex%m_cols;
				var lStatus:uint=checkGridStatus(urow,ucol);
				if(lStatus==CAN)return luIndex;
			}else lStatus==CANNOT;
			
			if(rStatus==CANNOT){
				if(lStatus==CANNOT){
					//哪个都不行；
					return -1;
				}else if(lStatus==UNKONW){
					return luIndex;
				}
			}else if(rStatus==UNKONW){
				if(lStatus==CANNOT){
					return ruIndex; 
				}else if(lStatus==UNKONW){
					//两个都行，首选右叔叔；
					return ruIndex;
				}
			}
			
			return -1;
		}
		
		/**
		 * 检查指定坐标下的格子是否存在，并且可以下落； 
		 * @param row
		 * @param col
		 * @return 
		 * 
		 */
		/*private function checkGridCanFall(row:int,col:int):int{
			if(m_mapData.isMapGridExist(row,col)){
				var cmp:FallComp=getCmp(row,col);
				if(cmp){
					if(cmp.canFall){
						return row*m_cols+col;
					}
				}
			}
			
			return -1;
		}*/
		
		/**
		 * 检查index所指的格子向上是否能连通到一个开始格子； 
		 * @param index
		 * @return 
		 * 
		 */
		public function isContactToStart(index:int):Boolean{
			
			var result:Boolean=false;
			/*var arr:Array=[index];
			var f:Boolean=false;
			while(arr.length>0){
				index=arr.shift();
				
				var row:int=int(index/m_cols);
				var col:int=index%m_cols;
				if(m_mapData.isStartGrid(row,col)){
					result=true;
					break;
				}
				if(m_mapData.isMapGridExist(row,col)){
					var cmp:FallComp=m_ocupyMap[row][col];
					if(cmp){
						if(cmp.canFall)f=false;
						else f=true;
					}else f=false;
					
					if(f){
						if(m_mapData.isMapGridExist(row,col+1)){
							cmp=m_ocupyMap[row][col];
							if(cmp){
								if(cmp.canFall)arr.push(row*m_cols+col+1);
								else break;
							}else arr.push(row*m_cols+col+1);
						}
						if(m_mapData.isMapGridExist(row,col-1)){
							cmp=m_ocupyMap[row][col];
							if(cmp){
								if(cmp.canFall)arr.push(row*m_cols+col-1);
								else break;
							}else arr.push(row*m_cols+col-1);
						}
						
					}else{
						index=m_mapData.getPreGridIndex(row,col);
						arr.push(index);
					}
				}
			}
			*/
			return result;
			
		}
		
		
		public function update():void{
			var removeVect:Vector.<int>=new Vector.<int>();
			for (var i:int=0;i<m_fallingCmps.length;i++){
				var cmp:FallComp=m_fallingCmps[i];
				cmp.y+=cmp.spdy;
				cmp.x+=cmp.spdx;
				if(cmp.y>=cmp.finishY){
					cmp.y=cmp.finishY;
					if(cmp.spdx!=0){
						cmp.x=cmp.finishX;
					}
					var col:uint=int(cmp.x/m_gridW);
					var row:uint=int(cmp.y/m_gridH);
					if(!canFallingDown(cmp,row,col)){
						//不能继续下落；
						setConnectivity(row,col,getIndex(row-1,col));
						cmp.readyToFall=false;
						m_ocupyMap[row][col]=cmp;
						removeVect.push(i);
						//todo:检查新填充的动物是否构成消除；
					}
				}
				
				cmp.disobj.x=cmp.x;
				cmp.disobj.y=cmp.y;
			}
			
			for each(i in removeVect){
				m_fallingCmps.splice(i,1);
			}
		}
		
		private function getIndex(row:int,col:int):int{return row*m_cols+col;}
		
		/**
		 * 检查cmp所在格子下面是否还有可移动的空间，有的话返回true，否在就是false；  
		 * @param cmp
		 * @param row
		 * @param col
		 * @return 
		 * 
		 */
		private function canFallingDown(cmp:FallComp,row:uint,col:uint):Boolean{
			
			var fallDownFlag:Boolean=false;
			var childRow:int=row+1;
			if(m_mapData.isMapGridExist(childRow,col)){
				var downCmp:FallComp=getCmp(childRow,col);
				if(downCmp){
					if(downCmp.readyToFall){
						fallDownFlag=true;
					}else{
						fallDownFlag=false;
					}
				}else{
					fallDownFlag=true;
				}
				
			}else{
				fallDownFlag=false;
			}
			
			if(fallDownFlag){
				cmp.finishY=calFinishY(childRow);
				cmp.spdx=0;
			}else{
				var c:uint=0;
				if(col-1>=0 && m_mapData.isMapGridExist(childRow,col-1)){
					var uncleIndex:int=m_unContactMap[childRow][col-1];
					if(uncleIndex==ANY || uncleIndex==row*m_cols+col){
						c+=LEFT;
					}
				}
				if(col+1<m_cols && m_mapData.isMapGridExist(childRow,col+1)){
					uncleIndex=m_unContactMap[childRow][col+1];
					if(uncleIndex==ANY || uncleIndex==row*m_cols+col){
						c+=RIGHT;
					}
				}
				
				if(c>=LEFT+RIGHT){
					//两边都能走，随机一条；
					var isLeft:Boolean=Math.random()>.5;
				}else if(c==LEFT){
					isLeft=true;
				}else if(c==RIGHT){
					isLeft=false;
				}else if(c==0){
					//左右都不能走，就只能停留在这里了；
					return false;
				}
				
				if(isLeft){
					cmp.spdx=-SPEED;
					cmp.finishX=(col-1)*m_gridH+m_gridH*.5;
				}else{
					cmp.spdx=SPEED;
					cmp.finishX=(col+1)*m_gridH+m_gridH*.5;
				}
				cmp.finishY=calFinishY(childRow);
			}
			return true;
		}
		
		
		private function getCmp(row:int,col:int):FallComp{
			//坐标超过了世界边界，肯定不允许；
			if(row>=m_rows || row<0 || col>=m_cols || col<0)return null;
			
			return m_ocupyMap[row][col];
		}
		
		private function calFinishY(row:int):int{
			return row*m_gridH+m_gridH*.5;
		}
		
		private function getCoorString(row:int,col:int):String{
			return " index,row,col=["+(row*m_cols+col)+','+row+","+col+"]";
		}
		
		private function getCoorString_index(index:int):String{
			return " index,row,col=["+index+','+(int(index/m_cols))+','+(index%m_cols)+"]";
		}
	}
}