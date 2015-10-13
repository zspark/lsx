package z_spark.attractionsystem
{
	public class TweenExchange
	{
		private var m_firstCall:Function;
		private var m_secondCall:Function;
		private var m_delay:Number;
		public function TweenExchange(firstEndCall:Function,secondEndCall:Function,delay:Number=.3)
		{
			m_firstCall=firstEndCall;
			m_secondCall=secondEndCall;
			m_delay=delay;
		}
		
		public function start():void{
			
		}
	}
}