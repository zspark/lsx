package z_spark.eliminatesystem
{
	import z_spark.attractionsystem.Effector;
	import z_spark.kxxxlcore.GameSize;

	/**
	 * version 2 
	 * @author z_Spark
	 * 
	 */
	final internal class EliminateCheck2
	{
		private static var s_map:Array;
		private static var s_specialEntityIndex:Array=[];
		private static var s_eliminatedEntityIndex:Array=[];

		public static function get specialEntityIndex():Array
		{
			return s_specialEntityIndex;
		}

		public static function get eliminatedEntityIndex():Array
		{
			return s_eliminatedEntityIndex;
		}
		
		private static var s_filterArr:Array=[];
		private static var s_genFn:Function;
		internal static function init(map:Array,genEffectAnimalFn:Function):void{
			s_map=map;
			s_genFn=genEffectAnimalFn;
		}
		
		public static function set filterArr(arr:Array):void{s_filterArr=arr;}
		
		/**
		 *检查index位置的横、竖是否构成了消除，
		 * 或者形成了新的特效动物
		 * 或者触发了特效动物； 
		 * @param index
		 * 
		 */
		public static function check(indexa:int,indexb:int):Boolean{
			s_specialEntityIndex.length=0;
			s_eliminatedEntityIndex.length=0;
			var result:Boolean=checkCombine(indexa,indexb);
			if(result){
				return true;
			}else{
				checkThree(indexa);
				checkThree(indexb);
				checkIndirectlyEliminate(s_specialEntityIndex);
			}
			CONFIG::DEBUG{
				trace("最终消除的索引：\n"+s_eliminatedEntityIndex);
			};
			return false;
		}
		
		public static function checkArray(arr:Array):void{
			s_specialEntityIndex.length=0;
			s_eliminatedEntityIndex.length=0;
			while(arr.length>0){
				var index:int=arr.shift();
				if(s_filterArr.indexOf(index)>=0)continue;
				checkThree(index);
			}
			checkIndirectlyEliminate(s_specialEntityIndex);
			
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
			CONFIG::DEBUG{
				trace("::checkCombine,"+indexa+','+indexb);
			};
			var targetEntitya:IEliminateEntity=getEntity_index(indexa);
			if(targetEntitya==null)return 0;
			var targetEntityb:IEliminateEntity=getEntity_index(indexb);
			if(targetEntityb==null)return 0;
			
			var totalType:uint=targetEntitya.type+targetEntityb.type;
			switch(totalType)
			{
				case TypeConst.TWO_SUPER:
				{
					//全屏消除；
					pushSameColor(ColorConst.ALL);
					Effector.playSound("sound_swap_colorcolor_cleanAll");
					return true;
					break;
				}
				case TypeConst.SUPER_BOOM:
				{
					var iea:IEliminateEntity=s_map[indexa];
					if(iea.type==TypeConst.SUPER){
						var ieb:IEliminateEntity=s_map[indexb];
						changeNormalTo(ieb.color,TypeConst.BOOM);
						Effector.getGrowBigEffect(indexa,true,1);
					}else{
						changeNormalTo(iea.color,TypeConst.BOOM);
						Effector.getGrowBigEffect(indexb,true,1);
					}
					pushToArr_index(indexa,s_eliminatedEntityIndex);
					pushToArr_index(indexb,s_eliminatedEntityIndex);
					Effector.playSound("sound_swap_colorcolor_swap");
					return true;
					break;
				}
				case TypeConst.SUPER_LINEUD:
				case TypeConst.SUPER_LINELR:
				{
					Effector.playSound("sound_swap_colorcolor_swap");
					return true;
					break;
				}
				case TypeConst.SUPER_NORMAL:
				{
					Effector.playSound("sound_swap_colorcolor_swap");
					iea=s_map[indexa];
					if(iea.type==TypeConst.SUPER){
						pushSameColor(s_map[indexb].color);
						pushToArr_index(indexa,s_eliminatedEntityIndex);
					}else{
						pushSameColor(iea.color);
						pushToArr_index(indexb,s_eliminatedEntityIndex);
					}
					return true;
					break;
				}
				case TypeConst.TWO_BOOM:
				{
					Effector.playSound("sound_swap_wrapwrap");
					pushCircle(indexa,3);
					return false;
					break;
				}
				case TypeConst.BOOM_LINELR:
				{
					Effector.playSound("sound_swap_wrapline");
					pushBoomLineLR(indexa);
					return false;
					break;
				}
				case TypeConst.BOOM_LINEUD:
				{
					Effector.playSound("sound_swap_wrapline");
					pushBoomLineUD(indexa);
					return false;
					break;
				}
				case TypeConst.TWO_LINELR:
				{
					Effector.playSound("sound_swap_lineline");
					pushLineLR(indexa);
					pushLineLR(indexb);
					return false;
					break;
				}
				case TypeConst.TWO_LINEUD:
				{
					Effector.playSound("sound_swap_lineline");
					pushLineUD(indexa);
					pushLineUD(indexb);
					return false;
					break;
				}
				case TypeConst.LINEUDLR:
				{
					Effector.playSound("sound_swap_lineline");
					pushLineLR(indexa);
					pushLineUD(indexb);
					return false;
					break;
				}
				default:
				{
					break;
				}
			}
			CONFIG::DEBUG{
				trace("checkCombine：failed");
			};
			return false;
		}
		
		private static function changeNormalTo(normalColor:uint,toType:int):void{
			for (var idx:int=0;idx<s_map.length;idx++){
				var entity:IEliminateEntity=getEntity_index(idx);
				if(entity && entity.type==TypeConst.NORMAL){
					if(entity.color==normalColor){
						entity.type=toType;
						pushToSpecial_index(idx);
					}
				}
			}
		}
		
		/**
		 * 推入数组arr中，重复项不推入，不合法、合约定row、col不推入； 
		 * @param row
		 * @param col
		 * @param arr
		 * 
		 */
		private static function pushToArr(row:int,col:int,arr:Array):void{
			if(row<=0 || row>=GameSize.s_rows || col<0 || col>=GameSize.s_cols)return;
			var index:int=row*GameSize.s_cols+col;
			if(arr.indexOf(index)<0)arr.push(index);
		}
		
		private static function pushToArr_index(index:int,arr:Array):void{
			if(index<0 || index>=s_map.length)return;
			if(arr.indexOf(index)<0)arr.push(index);
		}
		
		private static function pushToSpecial(row:int,col:int):void{
			if(row<=0 || row>=GameSize.s_rows || col<0 || col>=GameSize.s_cols)return;
			var index:int=row*GameSize.s_cols+col;
			if(s_specialEntityIndex.indexOf(index)<0)s_specialEntityIndex.push(index);
		}
		
		private static function pushToSpecial_index(index:int):void{
			if(index<0 || index>=s_map.length)return;
			if(s_specialEntityIndex.indexOf(index)<0)s_specialEntityIndex.push(index);
		}
		
		/**
		 * 以index所在位置为圆心，radius为半径（格子数），将圆里面的entity推入arr中； 
		 * @param index
		 * @param radius
		 * 
		 */
		public static function pushCircle(index:int,radius:int):void{
			var row:int=int(index/GameSize.s_cols);
			var col:int=index%GameSize.s_cols;
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
			var row:int=int(index/GameSize.s_cols);
			var i:int=0;
			while(i<GameSize.s_cols){
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
			var col:int=index%GameSize.s_cols;
			var i:int=0;
			while(i<GameSize.s_rows){
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
			var row:int=int(index/GameSize.s_cols);
			for (var j:int=-1;j<=1;j++){
				if(row+j<1 || row+j>=GameSize.s_rows)continue;
				var i:int=0;
				while(i<GameSize.s_cols){
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
			var col:int=index%GameSize.s_cols;
			for (var j:int=-1;j<=1;j++){
				if(col+j<0 || col+j>=GameSize.s_cols)continue;
				var i:int=1;
				while(i<GameSize.s_rows){
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
		private static function pushSameColor(color:uint):void{
			for (var idx:int=0;idx<s_map.length;idx++){
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
		
		private static function checkIndirectlySpecialElimination(index:int):void{
			var entity:IEliminateEntity = getEntity_index(index);
			if(entity){
				switch(entity.type)
				{
					case TypeConst.BOOM:
					{
						pushCircle(index,2);
						Effector.playSound("sound_eliminate_wrap");
						break;
					}
					case TypeConst.LINE_LR:
					{
						pushLineLR(index);
						Effector.playSound("sound_eliminate_strip");
						break;
					}
					case TypeConst.LINE_UD:
					{
						pushLineUD(index);
						Effector.playSound("sound_eliminate_strip");
						break;
					}
					case TypeConst.SUPER:
					{
						var color:int=ColorConst.TOTAL[int(ColorConst.TOTAL.length*Math.random())];
						pushSameColor(color);
						Effector.playSound("sound_eliminate_color");
						break;
					}
					case TypeConst.NORMAL:trace("index为普通动物，不应该出现此情况，注意检查！index="+index);
					default:
					{
						break;
					}
				}
			}
		}
		
		/**
		 *间接消除检测；
		 * @param arr
		 * 
		 */
		private static function checkIndirectlyEliminate(specialEntityIndexes:Array):void{
			for(var i:int=0;i<specialEntityIndexes.length;i++){
				var index:int=specialEntityIndexes[i];
				checkIndirectlySpecialElimination(index);
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
			if(row<0 || row>=GameSize.s_rows || col<0 ||col>=GameSize.s_cols)return null;
			var index:int=row*GameSize.s_cols+col;
			if(s_filterArr.indexOf(index)>=0)return null;
			return s_map[index] as IEliminateEntity;
		}
		
		private static function getEntity_index(index:int):IEliminateEntity{
			if(index<0 || index>=s_map.length ||s_filterArr.indexOf(index)>=0)return null;
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
			var row:int=int(index/GameSize.s_cols);
			var col:int=index%GameSize.s_cols;
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
			var row:int=int(index/GameSize.s_cols);
			var col:int=index%GameSize.s_cols;
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
	}
}