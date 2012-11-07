package tests
{
	import org.flexunit.Assert;
	import org.flexunit.runner.manipulation.filters.IncludeAllFilter;
	
	import production.BasicClass;
	
	public class BasicTests
	{
		public function BasicTests(){}
		private var basicClass:BasicClass;
		private var flexUnit:FlexUnit;
		
		[Before]
		public function before():void
		{
			basicClass = new BasicClass();
			flexUnit = new FlexUnit();
		}
		
		[Test]
		public function Verifica_Se_As_Duas_Strings_Sao_Iguais():void
		{
			var str:String = "MinhaString";
			
			Assert.assertTrue(basicClass.areStringsEqual(str,"MinhaString"));
		}
		
		[Test]
		public function Verifica_Se_A_Soma_Retorna_Resultado_Correto():void
		{
			var soma:int = 10;
			//var soma:String = '110';
			Assert.assertEquals(soma,basicClass.somar(2,8));
		}
		
		[Test]
		public function VerificaSePopupEstaAberta():void
		{
			Assert.assertFalse(basicClass.isEditPopup());
		}
		
		[Test( description = "Verifica se esta retornando data" )]
		public function VerificaSeRecebeuData():void
		{
			Assert.assertTrue( true );
		}
		
		
		[After]
		public function after():void
		{
			//codigo de after
		}
	}
}