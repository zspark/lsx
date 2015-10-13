package z_spark.fallingsystem
{
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.text.TextField;
	
	import z_spark.core.utils.KeyboardConst;
	import z_spark.kxxxlcore.GameSize;
	
	CONFIG::DEBUG{
	import flash.events.KeyboardEvent;
	import z_spark.core.utils.KeyboardConst;
	};

	public class FallingSystemDebugger
	{
		private static const INFO:String="p：暂停/开始掉落；     n：暂停状态下步进；" +
			"     a：显示所有节点；     f：显示父节点关系；    s：显示子节点关系；     q：显示特殊节点     c：清除;    -：减速    +：加速";
		
		private var m_debugLayer:Sprite;
		private var m_stage:Stage;
		private var m_statusTxt:TextField;
		private var m_paused:Boolean=false;
		
		public function FallingSystemDebugger(stage:Stage,layer:Sprite)
		{
			CONFIG::DEBUG{
			m_stage=stage;
			m_debugLayer=layer;
			
			m_stage.addEventListener(KeyboardEvent.KEY_DOWN,onKeyUp);
			m_stage.addEventListener(Event.RESIZE,onStageResize);
			
			m_statusTxt=new TextField();
			m_statusTxt.textColor=0xFFFFFF;
			m_statusTxt.mouseEnabled=false;
			m_statusTxt.multiline=true;
			m_statusTxt.width=m_stage.stageWidth;
			m_statusTxt.height=40;
			m_statusTxt.text=INFO+"\npaused:"+m_paused+'	speed:'+FallingSystem.s_ins.startSpeed;
			m_debugLayer.addChild(m_statusTxt);
			};
		}
		
		public function get paused():Boolean
		{
			return m_paused;
		}

		private function onStageResize(event:Event):void
		{
			m_statusTxt.width=m_stage.stageWidth;
		}
		
		CONFIG::DEBUG
		private function onKeyUp(event:KeyboardEvent):void
		{
			switch(event.keyCode)
			{
				case KeyboardConst.P:
				{
					m_paused=!m_paused;
					if(m_stage.hasEventListener(Event.ENTER_FRAME))m_stage.removeEventListener(Event.ENTER_FRAME,FallingSystem.s_ins.m_updateFn)}
					break;
				case KeyboardConst.N:
				{
					if(m_paused){
						FallingSystem.s_ins.m_updateFn(null);
						debugDrawOccupiedGrid();
					}
					break;
				}	
				case KeyboardConst.EQUAL:
				{
					FallingSystem.s_ins.startSpeed++;
					break;
				}
				case KeyboardConst.MINUS:
				{
					FallingSystem.s_ins.startSpeed--;
					break;
				}
				case KeyboardConst.F:
				{
					debugDrawElder();
					break;
				}
				case KeyboardConst.S:
				{
					debugDrawChildren();
					break;
				}
				case KeyboardConst.E:
				{
					debugDrawSupply();
					break;
				}
				case KeyboardConst.C:
				{
					clear();
					break;
				}
				case KeyboardConst.A:
				{
					debugDraw();
					break;
				}
				case KeyboardConst.Q:
				{
					debugDrawNode();
					break;
				}
				case KeyboardConst.G:
				{
					debugDrawOccupiedGrid();
					break;
				}
				default:
				{
					break;
				}
			}
			m_statusTxt.text=INFO+"\npaused:"+m_paused+'   speed:'+FallingSystem.s_ins.startSpeed;
		}
		
		CONFIG::DEBUG
		private function clear():void{
			m_debugLayer.graphics.clear();
		}
		
		CONFIG::DEBUG
		private function debugDrawOccupiedGrid():void{
			if(m_debugLayer==null)throw "先指定画布。";
			m_debugLayer.graphics.clear();
			m_debugLayer.graphics.beginFill(0x000000,.4);
			debugDrawOccupiedGrid_();
			m_debugLayer.graphics.endFill();
		}
		
		CONFIG::DEBUG
		private function debugDrawOccupiedGrid_():void{
			var nodeCtrl:NodeController=NodeController.s_ins;
			//画父节点的连通性；
			const SIZE:int=GameSize.s_gridw*.5-1;
			for each(var node:Node in nodeCtrl.dbg_nodeMap){
				if(node==null)continue;
				if(node.isOccupied){
					var index:int=node.index;
					var cy:int=int(index/GameSize.s_cols)*GameSize.s_gridh+GameSize.s_gridh*.5;
					var cx:int=int(index%GameSize.s_cols)*GameSize.s_gridw+GameSize.s_gridw*.5;
					m_debugLayer.graphics.drawCircle(cx,cy,SIZE);
				}
			}
		}
		
		CONFIG::DEBUG
		private function debugDraw():void{
			if(m_debugLayer==null)throw "先指定画布。";
			m_debugLayer.graphics.clear();
			m_debugLayer.graphics.lineStyle(1,0xFF0000);
			debugDrawElder_();
			m_debugLayer.graphics.lineStyle(1,0x00FF00);
			debugDrawChildren_();
			m_debugLayer.graphics.lineStyle(1,0x0000FF);
			debugDrawNode_();
			m_debugLayer.graphics.endFill();
		}
		
		CONFIG::DEBUG
		private function debugDrawElder():void{
			if(m_debugLayer==null)throw "先指定画布。";
			m_debugLayer.graphics.clear();
			m_debugLayer.graphics.lineStyle(1,0xFF0000);
			debugDrawElder_();
			m_debugLayer.graphics.endFill();
		}
		
		CONFIG::DEBUG
		private function debugDrawElder_():void{
			var nodeCtrl:NodeController=NodeController.s_ins;
			//画父节点的连通性；
			const FACTOR:Number=.8;
			for each(var node:Node in nodeCtrl.dbg_nodeMap){
				if(node==null)continue;
				var fNode:Node=node.elderNode;
				if(fNode){
					m_debugLayer.graphics.drawCircle(getCenterX(node)-2,getCenterY(node),2);
					m_debugLayer.graphics.moveTo(getCenterX(node)-2,getCenterY(node));
					var dx:Number=getCenterX(fNode)-getCenterX(node);
					var dy:Number=getCenterY(fNode)-getCenterY(node);
					m_debugLayer.graphics.lineTo(getCenterX(node)-2+dx*FACTOR,getCenterY(node)+dy*FACTOR);
					
				}
			}
		}
		
		
		CONFIG::DEBUG
		private function debugDrawChildren():void{
			if(m_debugLayer==null)throw "先指定画布。";
			m_debugLayer.graphics.clear();
			m_debugLayer.graphics.lineStyle(1,0x00FF00);
			debugDrawChildren_();
			m_debugLayer.graphics.endFill();
		}
		
		CONFIG::DEBUG
		private function debugDrawChildren_():void{
			var nodeCtrl:NodeController=NodeController.s_ins;
			//画子节点的连通性；
			const FACTOR:Number=.8;
			for each(var node:Node in nodeCtrl.dbg_nodeMap){
				if(node==null)continue;
				if(nodeCtrl.dbg_frozenNodes.indexOf(node.index)>=0)continue;
				var childrenArr:Array=[];
				node.getExistChildrenNodes(childrenArr);
				for each(var cNode:Node in childrenArr){
					m_debugLayer.graphics.drawCircle(getCenterX(node)+2,getCenterY(node),2);
					m_debugLayer.graphics.moveTo(getCenterX(node)+2,getCenterY(node));
					var dx:Number=getCenterX(cNode)-getCenterX(node);
					var dy:Number=getCenterY(cNode)-getCenterY(node);
					m_debugLayer.graphics.lineTo(getCenterX(node)+2+dx*FACTOR,getCenterY(node)+dy*FACTOR);
				}
			}
		}
		
		CONFIG::DEBUG
		private function debugDrawSupply():void{
			if(m_debugLayer==null)throw "先指定画布。";
			m_debugLayer.graphics.clear();
			debugDrawSupply_();
			m_debugLayer.graphics.endFill();
		}
		
		CONFIG::DEBUG
		private function debugDrawSupply_():void{
			var nodeCtrl:NodeController=NodeController.s_ins;
			var index:int;
			
			var FACTOR:Number=1;
			//画补给节点关系；
			m_debugLayer.graphics.lineStyle(2,0xAAAAAA);
			for each( var node:Node in nodeCtrl.dbg_nodeMap){
				if(node==null)continue;
				var childrenArr:Array=[];
				node.getExistSupplyNodes(childrenArr);
				for each(var cNode:Node in childrenArr){
					m_debugLayer.graphics.drawCircle(getCenterX(node),getCenterY(node),2);
					m_debugLayer.graphics.moveTo(getCenterX(node),getCenterY(node));
					var dx:Number=getCenterX(cNode)-getCenterX(node);
					var dy:Number=getCenterY(cNode)-getCenterY(node);
					m_debugLayer.graphics.lineTo(getCenterX(node)+dx*FACTOR,getCenterY(node)+dy*FACTOR);
				}
			}
			
		}
		
		CONFIG::DEBUG
		private function debugDrawNode():void{
			if(m_debugLayer==null)throw "先指定画布。";
			m_debugLayer.graphics.clear();
			debugDrawNode_();
			m_debugLayer.graphics.endFill();
		}
		
		CONFIG::DEBUG
		private function debugDrawNode_():void{
			var nodeCtrl:NodeController=NodeController.s_ins;
			var index:int;
			
			var FACTOR:Number=1;
			//画补给节点关系；
			m_debugLayer.graphics.lineStyle(2,0xAAAAAA);
			for each( var node:Node in nodeCtrl.dbg_nodeMap){
				if(node==null)continue;
				var childrenArr:Array=[];
				node.getExistSupplyNodes(childrenArr);
				for each(var cNode:Node in childrenArr){
					m_debugLayer.graphics.drawCircle(getCenterX(node),getCenterY(node),2);
					m_debugLayer.graphics.moveTo(getCenterX(node),getCenterY(node));
					var dx:Number=getCenterX(cNode)-getCenterX(node);
					var dy:Number=getCenterY(cNode)-getCenterY(node);
					m_debugLayer.graphics.lineTo(getCenterX(node)+dx*FACTOR,getCenterY(node)+dy*FACTOR);
				}
			}
			
			//画开始节点；
			m_debugLayer.graphics.lineStyle(2,0x666666);
			for each( index in nodeCtrl.dbg_roots){
				var node:Node=nodeCtrl.dbg_nodeMap[index];
				if(node==null)continue;
				m_debugLayer.graphics.drawCircle(getCenterX(node),getCenterY(node),4);
			}
			
			//画失联节点；
			m_debugLayer.graphics.lineStyle(2,0x00FFFF);
			for each( index in nodeCtrl.dbg_noElderNodes){
				node=nodeCtrl.dbg_nodeMap[index];
				if(node==null)continue;
				m_debugLayer.graphics.drawCircle(getCenterX(node),getCenterY(node),7);
			}
			
			//画冻结节点；
			FACTOR=.8;
			m_debugLayer.graphics.lineStyle(2,0x880088);
			for each( index in nodeCtrl.dbg_frozenNodes){
				node=nodeCtrl.dbg_nodeMap[index];
				m_debugLayer.graphics.drawRect(getCenterX(node)-5,getCenterY(node)-5,10,10);
				var eNode:Node=node.elderNode;
				if(eNode){
					m_debugLayer.graphics.moveTo(getCenterX(node),getCenterY(node));
					var dx:Number=getCenterX(eNode)-getCenterX(node);
					var dy:Number=getCenterY(eNode)-getCenterY(node);
					m_debugLayer.graphics.lineTo(getCenterX(node)+dx*FACTOR,getCenterY(node)+dy*FACTOR);
				}
				
				var sNode:Node=node.childrenNodes[Relation.SON];
				if(sNode){
					m_debugLayer.graphics.moveTo(getCenterX(node),getCenterY(node));
					dx=getCenterX(sNode)-getCenterX(node);
					dy=getCenterY(sNode)-getCenterY(node);
					m_debugLayer.graphics.lineTo(getCenterX(node)+dx*FACTOR,getCenterY(node)+dy*FACTOR);
				}
				
				var rNode:Node=node.childrenNodes[Relation.RIGHT_NEPHEW];
				if(rNode){
					m_debugLayer.graphics.moveTo(getCenterX(node),getCenterY(node));
					dx=getCenterX(rNode)-getCenterX(node);
					dy=getCenterY(rNode)-getCenterY(node);
					m_debugLayer.graphics.lineTo(getCenterX(node)+dx*FACTOR,getCenterY(node)+dy*FACTOR);
				}
				
				var lNode:Node=node.childrenNodes[Relation.LEFT_NEPHEW];
				if(lNode){
					m_debugLayer.graphics.moveTo(getCenterX(node),getCenterY(node));
					dx=getCenterX(lNode)-getCenterX(node);
					dy=getCenterY(lNode)-getCenterY(node);
					m_debugLayer.graphics.lineTo(getCenterX(node)+dx*FACTOR,getCenterY(node)+dy*FACTOR);
				}
			}
		}
		
		private function getCenterY(node:Node):int{return node.row*GameSize.s_gridh+GameSize.s_gridh*.5;}
		private function getCenterX(node:Node):int{return node.col*GameSize.s_gridw+GameSize.s_gridw*.5;}
	}
}