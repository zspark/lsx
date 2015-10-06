package z_spark.eliminatesystem
{
	final internal class EliminateCheck
	{
		private static var s_map:Array;
		private static var s_specialEntityIndex:Array=[];
		private static var s_eliminatedEntityIndex:Array=[];

		public static function get eliminatedEntityIndex():Array
		{
			return s_eliminatedEntityIndex;
		}
		
		private static var s_genFn:Function;
		internal static function init(map:Array,genEffectAnimalFn:Function):void{
			s_map=map;
			s_genFn=genEffectAnimalFn;
		}
		

		/**
		 *检查index位置的横、竖是否构成了消除（三个一样的），
		 * 或者形成了新的超级消除
		 * 或者触发了超级消除； 
		 * @param index
		 * 
		 */
		public static function check(indexa:int,indexb:int):void{
			s_specialEntityIndex.length=0;
			s_eliminatedEntityIndex.length=0;
			if(checkCombine(indexa,indexb)){
			}else{
				checkThree(indexa);
				checkThree(indexb);
			}
			
			checkIndirectlyEliminate();
			
			CONFIG::DEBUG{
				trace("最终消除的索引：\n"+s_eliminatedEntityIndex);
			};
		}
		
		public static function checkSingle(index:int):void{
			s_specialEntityIndex.length=0;
			s_eliminatedEntityIndex.length=0;
			
			checkThree(index);
			checkIndirectlyEliminate();
			
			CONFIG::DEBUG{
				trace("最终消除的索引：\n"+s_eliminatedEntityIndex);
			};
			
		}
		
		private static function checkThree(index:int):void{
			var rowEliminateArr:Array=[];
			var rowCount:uint=checkRow(index,rowEliminateArr);
			var colEliminateArr:Array=[];
			var colCount:uint=checkCol(index,colEliminateArr);
			
			if(s_genFn(rowEliminateArr,colEliminateArr,index)){
				rowEliminateArr.splice(rowEliminateArr.indexOf(index),1);
				colEliminateArr.splice(colEliminateArr.indexOf(index),1);
			}
			
			if(rowCount>=3){
				for (var i:int=0;i<rowEliminateArr.length;i++){
					var idx:int=rowEliminateArr[i];
					var entity:IEliminateEntity=getEntity_index(idx);
					if(entity){
						if(entity.type!=TypeConst.NORMAL){
							pushToSpecial_index(idx);
						}
					}
					pushToArr_index(idx,s_eliminatedEntityIndex);
				}
			}
			
			if(colCount>=3){
				for (i=0;i<colEliminateArr.length;i++){
					idx=colEliminateArr[i];
					entity=getEntity_index(idx);
					if(entity){
						if(entity.type!=TypeConst.NORMAL){
							pushToSpecial_index(idx);
						}
					}
					pushToArr_index(idx,s_eliminatedEntityIndex);
				}
			}
			
		}
		
		/**
		 * 检查组合消除，就是交换的2个都是特效动物； 
		 * 前提是2个动物都必须存在;
		 */
		private static function checkCombine(indexa:int,indexb:int):Boolean
		{
			var targetEntitya:IEliminateEntity=getEntity_index(indexa);
			if(targetEntitya==null)return false;
			var targetEntityb:IEliminateEntity=getEntity_index(indexb);
			if(targetEntityb==null)return false;
			
			var totalType:uint=targetEntitya.type+targetEntityb.type;
			switch(totalType)
			{
				case TypeConst.TWO_SUPER:
				{
					//全屏消除；
					pushSuper(ColorConst.ALL);
					return true;
					break;
				}
				case TypeConst.SUPER_BOOM:
				{
					return true;
					break;
				}
				case TypeConst.SUPER_LINEUD:
				case TypeConst.SUPER_LINELR:
				{
					return true;
					break;
				}
				case TypeConst.SUPER_NORMAL:
				{
					var iea:IEliminateEntity=s_map[indexa];
					if(iea.type==TypeConst.SUPER){
						pushSuper(s_map[indexb].color);
						pushToArr_index(indexa,s_eliminatedEntityIndex);
					}else{
						pushSuper(iea.color);
						pushToArr_index(indexb,s_eliminatedEntityIndex);
					}
					return true;
					break;
				}
				case TypeConst.TWO_BOOM:
				{
					pushCircle(indexa,3);
					return true;
					break;
				}
				case TypeConst.BOOM_LINELR:
				{
					pushBoomLineLR(indexa);
					return true;
					break;
				}
				case TypeConst.BOOM_LINEUD:
				{
					pushBoomLineUD(indexa);
					return true;
					break;
				}
				case TypeConst.TWO_LINELR:
				{
					pushLineLR(indexa);
					pushLineLR(indexb);
					return true;
					break;
				}
				case TypeConst.TWO_LINEUD:
				{
					pushLineUD(indexa);
					pushLineUD(indexb);
					return true;
					break;
				}
				case TypeConst.LINEUDLR:
				{
					pushLineLR(indexa);
					pushLineUD(indexb);
					return true;
					break;
				}
				default:
				{
					break;
				}
			}
			trace("checkCombine：failed");
			return false;
		}
		
		/**
		 * 推入数组arr中，重复项不推入，不合法、合约定row、col不推入； 
		 * @param row
		 * @param col
		 * @param arr
		 * 
		 */
		private static function pushToArr(row:int,col:int,arr:Array):void{
			if(row<=0 || row>=EConst.s_rows || col<0 || col>=EConst.s_cols)return;
			var index:int=row*EConst.s_cols+col;
			if(arr.indexOf(index)<0)arr.push(index);
		}
		
		private static function pushToArr_index(index:int,arr:Array):void{
			if(index<EConst.s_cols || index>=s_map.length)return;
			if(arr.indexOf(index)<0)arr.push(index);
		}
		
		private static function pushToSpecial(row:int,col:int):void{
			if(row<=0 || row>=EConst.s_rows || col<0 || col>=EConst.s_cols)return;
			var index:int=row*EConst.s_cols+col;
			if(s_specialEntityIndex.indexOf(index)<0)s_specialEntityIndex.push(index);
		}
		
		private static function pushToSpecial_index(index:int):void{
			if(index<EConst.s_cols || index>=s_map.length)return;
			if(s_specialEntityIndex.indexOf(index)<0)s_specialEntityIndex.push(index);
		}
		
		/**
		 * 以index所在位置为圆心，radius为半径（格子数），将圆里面的entity推入arr中； 
		 * @param index
		 * @param radius
		 * 
		 */
		private static function pushCircle(index:int,radius:int):void{
			var row:int=int(index/EConst.s_cols);
			var col:int=index%EConst.s_cols;
			const rsqr:int=radius*radius;
			for (var i:int=-radius;i<=radius;i++){
				for (var j:int=-radius;j<=radius;j++){
					if(i*i+j*j<=rsqr){
						pushToArr(row+i,col+j,s_eliminatedEntityIndex);
						var entity:IEliminateEntity=getEntity(row+i,col+j);
						if(entity && entity.type!=TypeConst.NORMAL){
							pushToSpecial(row+i,col+j);
						}
					}
				}
			}
		}
		
		/**
		 * 将index所在行的全部索引推入arr中； 
		 * @param index
		 * @param arr
		 * 
		 */
		private static function pushLineLR(index:int):void{
			var row:int=int(index/EConst.s_cols);
			if(row<1)return;
			var i:int=0;
			while(i<EConst.s_cols){
				pushToArr(row,i,s_eliminatedEntityIndex);
				var entity:IEliminateEntity=getEntity(row,i);
				if(entity && entity.type!=TypeConst.NORMAL){
					pushToSpecial(row,i);
				}
				i++;
			}
		}
		
		/**
		 * 将index所在列的全部索引推入arr中； 
		 * @param index
		 * @param arr
		 * 
		 */
		private static function pushLineUD(index:int):void{
			var col:int=index%EConst.s_cols;
			var i:int=1;
			while(i<EConst.s_rows){
				pushToArr(i,col,s_eliminatedEntityIndex);
				var entity:IEliminateEntity=getEntity(i,col);
				if(entity && entity.type!=TypeConst.NORMAL){
					pushToSpecial(i,col);
				}
				i++;
			}
		}
		
		/**
		 * 将index所在的行及其上下两行（共三行）推入arr中； 
		 * @param map
		 * @param arr
		 * @param index
		 * 
		 */
		private static function pushBoomLineLR(index:int):void{
			var row:int=int(index/EConst.s_cols);
			for (var j:int=-1;j<=1;j++){
				if(row+j<1 || row+j>=EConst.s_rows)continue;
				var i:int=0;
				while(i<EConst.s_cols){
					pushToArr(row+j,i,s_eliminatedEntityIndex);
					var entity:IEliminateEntity=getEntity(row+j,i);
					if(entity && entity.type!=TypeConst.NORMAL){
						pushToSpecial(row+j,i);
					}
					i++;
				}
			}
		}
		
		/**
		 * 将index所在的列及其上下两列（共三列）推入arr中； 
		 * @param map
		 * @param arr
		 * @param index
		 * 
		 */
		private static function pushBoomLineUD(index:int):void{
			var col:int=index%EConst.s_cols;
			for (var j:int=-1;j<=1;j++){
				if(col+j<0 || col+j>=EConst.s_cols)continue;
				var i:int=1;
				while(i<EConst.s_rows){
					pushToArr(i,col+j,s_eliminatedEntityIndex);
					var entity:IEliminateEntity=getEntity(i,col+j);
					if(entity && entity.type!=TypeConst.NORMAL){
						pushToSpecial(i,col+j);
					}
					i++;
				}
			}
		}
		
		/**
		 * 将全屏中与color相同的动物推入arr中
		 * （第0行除外） 
		 * @param color
		 * @param arr
		 * 
		 */
		private static function pushSuper(color:uint):void{
			for (var idx:int=EConst.s_cols;idx<s_map.length;idx++){
				var entity:IEliminateEntity=getEntity_index(idx);
				if(entity){
					if(color==ColorConst.ALL){
						pushToArr_index(idx,s_eliminatedEntityIndex);
					}else{
						if(entity.color==color ){
							pushToArr_index(idx,s_eliminatedEntityIndex);
							if(entity.type!=TypeConst.NORMAL){
								pushToSpecial_index(idx);
							}
						}
					}
				}
			}
		}
		
		/**
		 *间接消除检测；
		 * @param arr
		 * 
		 */
		private static function checkIndirectlyEliminate():void{
			for(var i:int=0;i<s_specialEntityIndex.length;i++){
				var index:int=s_specialEntityIndex[i];
				var entity:IEliminateEntity = getEntity_index(index);
				if(entity){
					switch(entity.type)
					{
						case TypeConst.BOOM:
						{
							pushCircle(index,2);
							break;
						}
						case TypeConst.LINE_LR:
						{
							pushLineLR(index);
							break;
						}
						case TypeConst.LINE_UD:
						{
							pushLineUD(index);
							break;
						}
						case TypeConst.SUPER:
						{
							var color:int=ColorConst.TOTAL[int(ColorConst.TOTAL.length*Math.random())];
							pushSuper(color);
							break;
						}
						case TypeConst.NORMAL:trace("有一个普通动物闯进了特效动物数组中，index="+index);
						default:
						{
							break;
						}
					}
				}
			}
		}
		
		/**
		 * 检查指定row。col下的entity颜色是否与指定color相同，相同的话推入arr中； 
		 * @param row
		 * @param col
		 * @param color
		 * @param arr
		 * @return 
		 * 
		 */
		private static function checkSameColor(row:int,col:int,color:uint,arr:Array):Boolean{
			var entity:IEliminateEntity=getEntity(row,col);
			if(entity && entity.color==color){
				pushToArr(row,col,arr);
				return true;
			}
			return false;
		}
		
		private static function getEntity(row:int,col:int):IEliminateEntity{
			if(row<1 || row>=EConst.s_rows || col<0 ||col>=EConst.s_cols)return null;
			return s_map[row*EConst.s_cols+col] as IEliminateEntity;
		}
		
		private static function getEntity_index(index:int):IEliminateEntity{
			if(index<EConst.s_cols || index>=s_map.length)return null;
			return s_map[index] as IEliminateEntity;
		}
		
		/**
		 * 检查index为中心，同一行内，将相连的相同颜色推入arr； 
		 * @param index
		 * @param arr
		 * @return 
		 * 
		 */
		private static function checkRow(index:int,arr:Array):int{
			//检查行
			var row:int=int(index/EConst.s_cols);
			var col:int=index%EConst.s_cols;
			var targetEntity:IEliminateEntity=getEntity_index(index);
			if(targetEntity){
				arr.push(index);
				var offset:int=0;
				do{
					offset++;
					var flag:Boolean=checkSameColor(row,col-offset,targetEntity.color,arr);
				}while(flag)
					
				offset=0;
				do{
					offset++;
					flag=checkSameColor(row,col+offset,targetEntity.color,arr);
				}while(flag)
					
			}
			return arr.length;
		}
		
		/**
		 * 检查index为中心，同一列内 将相连的相同颜色推入arr； 
		 * @param index
		 * @param arr
		 * @return 
		 * 
		 */
		private static function checkCol(index:int,arr:Array):int{
			//检查列
			var row:int=int(index/EConst.s_cols);
			var col:int=index%EConst.s_cols;
			var targetEntity:IEliminateEntity=s_map[index];
			if(targetEntity){
				arr.push(index);
				var offset:int=0;
				do{
					offset++;
					var flag:Boolean=checkSameColor(row-offset,col,targetEntity.color,arr);
				}while(flag)
				
				offset=0;
				do{
					offset++;
					flag=checkSameColor(row+offset,col,targetEntity.color,arr);
				}while(flag)
				
			}
			return arr.length;
		}
		
//		/**
//		 * 检查以index为中心，radius为半径的行内有否有相同颜色的，并推入arr； 
//		 * @param index
//		 * @param radius
//		 * @param color
//		 * @param arr
//		 * 
//		 */
//		private function checkLR(index:int,radius:int,color:int,arr:Array):void{
//			var row:int=int(index/EConst.s_cols);
//			if(row<1)return;
//			var col:int=index%EConst.s_cols;
//			var i:int=col-radius;
//			while(i<=col+radius){
//				var entity:IEliminateEntity=getEntity(row,i);
//				if(entity){
//					if(entity.color==color || color==ColorConst.ALL){
//						pushToArr(row,i,arr);
//					}
//					
//					if(entity.type!=TypeConst.NORMAL){
//						s_specialEntityIndex.push(row*EConst.s_cols+i);
//					}
//				}
//				i++;
//			}
//		}
//		
//		/**
//		 * 检查以index为中心，radius为半径的列内有否有相同颜色的，并推入arr； 
//		 * @param index
//		 * @param radius
//		 * @param color
//		 * @param arr
//		 * 
//		 */
//		private function checkUD(index:int,radius:int,color:int,arr:Array):void{
//			var col:int=index%EConst.s_cols;
//			var row:int=int(index/EConst.s_cols);
//			var i:int=row-radius;
//			while(i<=row+radius){
//				var entity:IEliminateEntity=getEntity(i,col);
//				if(entity){
//					if(entity.color==color || color==ColorConst.ALL){
//						pushToArr(i,col,arr);
//					}
//					
//					if(entity.type!=TypeConst.NORMAL){
//						s_specialEntityIndex.push(i*EConst.s_cols+col);
//					}
//				}
//				i++;
//			}
//		}
	}
}