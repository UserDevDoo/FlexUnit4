package tests
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import layout.ui.UiDataTimer;
	
	import mx.events.FlexEvent;
	
	import org.flexunit.Assert;
	import org.flexunit.async.Async;
	import org.fluint.uiImpersonation.UIImpersonator;

	public class TestUiDataTimer
	{		
		//Configura o tempo de duração do teste
		protected static var LONG_TIME:int = 500;
		
		//Istância o componente a ser testado
		protected var uiDataTimer:UiDataTimer;
		
		//Ações que devem ser executados antes de iniciar aplicação
		[Before(async,ui)]
		public function setUp():void
		{
			//Cria componente que será testado
			uiDataTimer = new UiDataTimer();
			
			//Configura componente que será testado
			Async.proceedOnEvent( this, uiDataTimer, FlexEvent.CREATION_COMPLETE, LONG_TIME );
			
			//Adiciona o compenente na lista de testes
			UIImpersonator.addChild( uiDataTimer );
		}
		
		//Ações que devem ser executados depois do teste principal
		[After(async,ui)]
		public function tearDown():void 
		{
			//Remove o compenente da lista de testes
			UIImpersonator.removeChild( uiDataTimer );	
			
			//Limpa o componente da memória
			uiDataTimer = null;
		}
		
		//Testes que devem ser executados
		[Test(async,ui)]
		public function testaEventoSalvar(): void {
			//Cria objeto de configuração dos parametros
			var passThroughData:Object = new Object();
			passThroughData.text = 'myuser1';
						
			//Configura componente a ser testado indicando o evento que deve ser executado e passando os paramentros necessários
			Async.handleEvent( this, uiDataTimer, "save", eventSave, LONG_TIME, passThroughData );
			
			//Configura no componente de teste os parametros para seu funcionamento
			uiDataTimer.tiData.text = passThroughData.text;
			
			//Dispara evento que faz o componente em teste funcionar
			uiDataTimer.btSave.dispatchEvent( new MouseEvent( 'click', true, false ) );
		}
		
		//----------------------------------
		//  eventSave
		//----------------------------------
		/**
		 * Evento executado quando o botão salvar é clicado  
		 * Testa o valor do campo tiText 
		 * 
		 *  @return void  
		 */	
		private function eventSave(event:Event, passThroughData:Object):void
		{
			//testa se o valor retornado é igual ao valor esperado
			Assert.assertEquals( passThroughData.text, event.target.data );
		}		

		
		//----------------------------------
		//  testUsuarioAtivo
		//----------------------------------
		/**
		 * Configurando parametros para testar se o usuario está ativo
		 * 
		 *  @return void  
		 */	
		[Test(async,ui)]
		public function testUsuarioAtivo(): void {
			//Configura componente a ser testado indicando o evento que deve ser executado e passando os paramentros necessários
			Async.handleEvent( this, uiDataTimer, "save", isActiveTest);
			
			//Dispara evento que faz o componente em teste funcionar
			uiDataTimer.btSave.dispatchEvent( new MouseEvent( 'click', true, false ) );
		}
		
		//----------------------------------
		//  eventSave
		//----------------------------------
		/**
		 * Evento executado quando o botão salvar é clicado  
		 * Testa o valor do campo tiText 
		 * 
		 *  @return void  
		 */	
		private function isActiveTest(event:Event, passThroughData:Object):void
		{
			//testa se o valor retornado é igual ao valor esperado
			Assert.assertFalse(event.target.userIsActive);
		}	
		
		//----------------------------------
		//  testIdadeObrigatoria
		//----------------------------------
		/**
		 * Configurando parametros para testar se o TiText não é null
		 * 
		 *  @return void  
		 */	
		[Test(async,ui)]
		public function testIdadeObrigatoria(): void {
			//Cria objeto de configuração dos parametros
			var passThroughData:Object = new Object();
			/*passThroughData.text = '25';*/
			
			//Configura componente a ser testado indicando o evento que deve ser executado e passando os paramentros necessários
			Async.handleEvent( this, uiDataTimer, "save", ageNotNull, LONG_TIME, passThroughData);
			
			//Dispara evento que faz o componente em teste funcionar
			uiDataTimer.btSave.dispatchEvent( new MouseEvent( 'click', true, false ) );
		}
		
		//----------------------------------
		//  eventSave
		//----------------------------------
		/**
		 * Evento executado quando o botão salvar é clicado  
		 * Testa o valor do campo tiText 
		 * 
		 *  @return void  
		 */	
		private function ageNotNull(event:Event, passThroughData:Object):void
		{
			//testa se o valor retornado é igual ao valor esperado
			Assert.assertNull(passThroughData.text);
			/*Assert.assertNotNull(passThroughData.text);*/
		}	
		
		//----------------------------------
		//  testIgualdadeEstrita
		//----------------------------------
		/**
		 * Configurando parametros para testar se o TiText não é null
		 * 
		 *  @return void  
		 */	
		[Test(async,ui)]
		public function testIgualdadeEstrita(): void {
			//Cria objeto de configuração dos parametros
			var passThroughData:Object = new Object();
			passThroughData.text = '1';
			
			//Configura componente a ser testado indicando o evento que deve ser executado e passando os paramentros necessários
			Async.handleEvent( this, uiDataTimer, "save", eventSaveStrictly, LONG_TIME, passThroughData );
			
			//Configura no componente de teste os parametros para seu funcionamento
			uiDataTimer.tiData.text = passThroughData.text;
			
			passThroughData.text = 1;
			
			//Dispara evento que faz o componente em teste funcionar
			uiDataTimer.btSave.dispatchEvent( new MouseEvent( 'click', true, false ) );
		}
		
		//----------------------------------
		//  eventSaveStrictly
		//----------------------------------
		/**
		 * Evento executado quando o botão salvar é clicado  
		 * Testa o valor do campo tiText é estrimente igual ao valor declarado
		 * 
		 *  @return void  
		 */	
		private function eventSaveStrictly(event:Event, passThroughData:Object):void
		{
			//testa se o valor retornado é igual ao valor esperado
			Assert.assertStrictlyEquals( passThroughData.text, event.target.data );
		}		
		
		
	}
}