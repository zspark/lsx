package z_spark.fallingsystem
{
	import z_spark.kxxxlcore.GameSize;

	public class FUtil
	{
		public static function isSameRow(indexA:int,indexB:int):Boolean{
			return int(indexA/GameSize.s_cols)==int(indexB/GameSize.s_cols);
		}
		
		public static function APriorityBiggerThanB(a:Node,b:Node):Boolean{
			return a.relationToElderNode<b.relationToElderNode;
		}
		
		/*
		waiting for usage;
		public static function convertToIndex(x:Number,y:Number):int{
			return int(y/GameSize.s_gridh)*GameSize.s_cols+int(x/GameSize.s_gridw);
		}*/
		
		/*public static function getColoredSprite(hw:int,hh:int):Sprite{
			var sp:Sprite=new Sprite();
			sp.graphics.beginFill(0x333333);
			sp.graphics.drawRect(-hw,-hh,hw*2,hh*2);
			sp.graphics.endFill();
			return sp;
		}*/
		
		/**
		 * 前后序遍历，
		 * node为三叉树；
		 * 三个子节点之间前序遍历：中，左，右
		 * 最后遍历根节点； 
		 * 
		 * 注意：数据结构中应该没有这种叫法的遍历，这里仅仅是个人为了明确遍历顺序而言；
		 * @param node 要遍历的根节点;
		 * @return 返回遍历后的所有节点的index；
		 * 
		 */
		/*public static function prePoseTraversal(node:Node):Array{
			
			var result:Array=[];
			var subNode:Node;
			var arr:Array=[node];
			while(arr.length>0){
				node=arr.shift();
				result.push(node.index);
				subNode=node.childrenNodes[Relation.SON];
				if(subNode)arr.push(subNode);
				subNode=node.childrenNodes[Relation.LEFT_NEPHEW];
				if(subNode)arr.push(subNode);
				subNode=node.childrenNodes[Relation.RIGHT_NEPHEW];
				if(subNode)arr.push(subNode);
			}
			
			return result;
			
		}*/
		
	}
}