/**
 * Copyright (c) 2007 Digital Primates IT Consulting Group
 * 
 * Permission is hereby granted, free of charge, to any person
 * obtaining a copy of this software and associated documentation
 * files (the "Software"), to deal in the Software without
 * restriction, including without limitation the rights to use,
 * copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the
 * Software is furnished to do so, subject to the following
 * conditions:
 * 
 * The above copyright notice and this permission notice shall be
 * included in all copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
 * OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
 * HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
 * WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
 * OTHER DEALINGS IN THE SOFTWARE.
 **/ 
package tests
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import layout.ui.UiLogin;
	
	import mx.collections.ArrayCollection;
	import mx.events.FlexEvent;
	import mx.events.ValidationResultEvent;
	import mx.states.AddItems;
	
	import org.flexunit.Assert;
	import org.flexunit.async.Async;
	import org.fluint.sequence.SequenceCaller;
	import org.fluint.sequence.SequenceEventDispatcher;
	import org.fluint.sequence.SequenceRunner;
	import org.fluint.sequence.SequenceSetter;
	import org.fluint.sequence.SequenceWaiter;
	import org.fluint.uiImpersonation.UIImpersonator;

    /**
     * @private
     */
	public class TestUiLogin {
		//Configura o tempo de duração do teste
		protected static var LONG_TIME:int = 500;

		//Istância o componente a ser testado
		protected var uiLogin:UiLogin;

		//Ações que devem ser executados antes de iniciar aplicação
		[Before(async,ui)]
		public function setUp():void {
			//Cria componente que será testado
			uiLogin = new UiLogin();
			
			//Configura componente que será testado
			Async.proceedOnEvent( this, uiLogin, FlexEvent.CREATION_COMPLETE, LONG_TIME );
			
			//Adiciona o compenente na lista de testes
			UIImpersonator.addChild( uiLogin );
		}
		
		//Ações que devem ser executados depois do teste principal
		[After(async,ui)]
		public function tearDown():void {
			//Remove o compenente da lista de testes
			UIImpersonator.removeChild( uiLogin );	
			
			//Limpa o componente da memória
			uiLogin = null;
		}

		//Testes que devem ser executados
		[Test(async,ui)]
	    public function testLoginEventStandard() : void {
			//Cria objeto de configuração dos parametros
	    	var passThroughData:Object = new Object();
				passThroughData.username = 'myuser1';
	    		passThroughData.password = 'somepsswd';
	    	
			//Configura componente a ser testado indicando o evento que deve ser executado e passando os paramentros necessários
	    	Async.handleEvent( this, uiLogin, "loginRequested", handleLoginEvent, LONG_TIME, passThroughData );
			
			//Configura no componente de teste os parametros para seu funcionamento
			uiLogin.usernameTI.text = passThroughData.username;
	    	uiLogin.passwordTI.text = passThroughData.password;
			
			//Dispara evento que faz o componente em teste funcionar
	    	uiLogin.loginBtn.dispatchEvent( new MouseEvent( 'click', true, false ) );
	    }

		//Testes que devem ser executados
		[Test(async,ui)]
	    public function testLoginEventSequence() : void {
			//Cria objeto de configuração dos parametros
	    	var passThroughData:Object = new Object();
	    		passThroughData.username = 'myuser1';
	    		passThroughData.password = 'somepsswd';

	    	//Configura sequencia de testes
			var sequence:SequenceRunner = new SequenceRunner( this );
	    	
			//Realiza sequencia de teste
	    	with ( sequence ) {
				//Adiciona componente e parametros para teste
				addStep( new SequenceSetter( uiLogin.usernameTI, {text:passThroughData.username} ) );
				addStep( new SequenceWaiter( uiLogin.usernameTI, FlexEvent.VALUE_COMMIT, LONG_TIME ) );
	
				addStep( new SequenceSetter( uiLogin.passwordTI, {text:passThroughData.password} ) );
				addStep( new SequenceWaiter( uiLogin.passwordTI, FlexEvent.VALUE_COMMIT, LONG_TIME ) );
	
				//Adiciona componente e evento para teste
				addStep( new SequenceEventDispatcher( uiLogin.loginBtn, new MouseEvent( MouseEvent.CLICK, true, false ) ) );
				addStep( new SequenceWaiter( uiLogin, 'loginRequested', LONG_TIME ) );
				
				//Prepara evento de retorno da conclusão do teste 
				addAssertHandler( handleLoginEvent, passThroughData );
				
				//Executa o teste
				run();	    		
	    	}
	    }

		//Testa o validador de tamanho de username
		[Test(async,ui)]
	    public function testValidationSequence() : void {
	    	var passThroughData:Object = new Object();
	    	passThroughData.username = 'myuser1';
	    	passThroughData.password = 'teste';

	    	//Sequencias de teste
			var sequence:SequenceRunner = new SequenceRunner( this );

			//Realiza teste na sequência
			with ( sequence ) {
				addStep( new SequenceSetter( uiLogin.usernameTI, {text:passThroughData.username} ) );
				addStep( new SequenceWaiter( uiLogin.usernameTI, FlexEvent.VALUE_COMMIT, LONG_TIME ) );
	
				addStep( new SequenceSetter( uiLogin.passwordTI, {text:passThroughData.password} ) );
				addStep( new SequenceWaiter( uiLogin.passwordTI, FlexEvent.VALUE_COMMIT, LONG_TIME ) );
	
				addStep( new SequenceEventDispatcher( uiLogin.loginBtn, new MouseEvent( MouseEvent.CLICK, true, false ) ) );
				addStep( new SequenceWaiter( uiLogin.svUserName, ValidationResultEvent.VALID, LONG_TIME ) );
				
				addAssertHandler( handleValidEvent, passThroughData );
				
				run();
			}
	    }

		//Testa o validador tamanho de senha
		[Test(async,ui)]
	    public function testInValidationSequence() : void {
	    	var passThroughData:Object = new Object();
	    	passThroughData.username = 'myuser1';
	    	passThroughData.password = 'a';

	    	var sequence:SequenceRunner = new SequenceRunner( this );

			with ( sequence ) {
				addStep( new SequenceSetter( uiLogin.usernameTI, {text:passThroughData.username} ) );
				addStep( new SequenceWaiter( uiLogin.usernameTI, FlexEvent.VALUE_COMMIT, LONG_TIME ) );
	
				addStep( new SequenceSetter( uiLogin.passwordTI, {text:passThroughData.password} ) );
				addStep( new SequenceWaiter( uiLogin.passwordTI, FlexEvent.VALUE_COMMIT, LONG_TIME ) );
	
				addStep( new SequenceEventDispatcher( uiLogin.loginBtn, new MouseEvent( MouseEvent.CLICK, true, false ) ) );
				addStep( new SequenceWaiter( uiLogin.svUserPassword, ValidationResultEvent.INVALID, LONG_TIME ) );
				
				addAssertHandler( handleValidEvent, passThroughData );
				
				run();
			}
	    }

		[Test(async,ui)]
	    public function testWithValidateNowSequence() : void {
	    	var passThroughData:Object = new Object();
	    	passThroughData.username = 'myuser1';
	    	passThroughData.password = 'a';

	    	var sequence:SequenceRunner = new SequenceRunner( this );
			
			with ( sequence ) {
				addStep( new SequenceSetter( uiLogin.usernameTI, {text:passThroughData.username} ) );
				addStep( new SequenceCaller( uiLogin.usernameTI, uiLogin.validateNow ) );

				addStep( new SequenceSetter( uiLogin.passwordTI, {text:passThroughData.password} ) );
				addStep( new SequenceCaller( uiLogin.passwordTI, uiLogin.validateNow ) );

				addStep( new SequenceCaller( uiLogin, uiLogin.setSomeValue, ['mike'] ) );
				addStep( new SequenceCaller( uiLogin, uiLogin.setSomeValue, null, getMyArgs ) );

				addStep( new SequenceEventDispatcher( uiLogin.loginBtn, new MouseEvent( MouseEvent.CLICK, true, false ) ) );
				addStep( new SequenceWaiter( uiLogin.svUserPassword, ValidationResultEvent.INVALID, LONG_TIME ) );

				addAssertHandler( handleValidEvent, passThroughData );
			
				run();
			}
	    }
	    
	    private function getMyArgs():Array {
	    	return ['steve'];
	    }

	    protected function handleLoginEvent( event:Event, passThroughData:Object ):void {
	    	//trace("Login Event Occurred " + event.type );
	    	Assert.assertEquals( passThroughData.username, event.target.username );
	    	Assert.assertEquals( passThroughData.password, event.target.password );
	    }

	    protected function handleValidEvent( event:Event, passThroughData:Object ):void {
	    	//trace("Valid Event Occurred " + event.type );
	    	Assert.assertEquals( passThroughData.username, uiLogin.username );
	    	Assert.assertEquals( passThroughData.password, uiLogin.password );
	    }
	}
}