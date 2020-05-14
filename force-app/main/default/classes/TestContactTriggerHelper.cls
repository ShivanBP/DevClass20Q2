@isTest
public class TestContactTriggerHelper {
    @testSetup
    public static void testSetup(){
        //Create Accounts
        List<Account> accList = new List<Account>();
        for(Integer i = 0; i < 200 ; i ++){
            accList.add(new Account(Name='TestAcc' + i));
        }
        insert accList;
        
        //Create Contacts
        List<Contact> conList = new List<Contact>();
        for(Integer i = 0; i < 200 ; i ++){
            if(100 <= i && i < 150 ){
                conList.add(new Contact(LastName='TestCon'+ i, AccountId=accList[i].id));
            }else if( 150 <= i && i < 170 ){ 
                conList.add(new Contact(LastName='TestConA'+ i, AccountId=accList[i].id));
                conList.add(new Contact(LastName='TestConB'+ i, AccountId=accList[i].id));               
            }else if ( 170 <= i && i <= 200 ){
                conList.add(new Contact(LastName='TestConA'+ i, AccountId=accList[i].id));
                conList.add(new Contact(LastName='TestConB'+ i, AccountId=accList[i].id));               
                conList.add(new Contact(LastName='TestConC'+ i, AccountId=accList[i].id));               
            }
        }
        insert conList;
    }
    
    @isTest 
    public static void testInsert(){
        	Integer withNull = [SELECT Count() FROM Account WHERE Number_of_Contacts__c = null];
        	System.assertEquals(100, withNull);
        	Integer withOne = [SELECT Count() FROM Account WHERE Number_of_Contacts__c = 1];
        	System.assertEquals(50, withOne);
        	Integer withTwo = [SELECT Count() FROM Account WHERE Number_of_Contacts__c = 2];
        	System.assertEquals(20, withTwo);
        	Integer withThree = [SELECT Count() FROM Account WHERE Number_of_Contacts__c = 3];
        	System.assertEquals(30, withThree);
    }
    
   @isTest 
	public static void testUpdate(){
		List<Contact> conList = new List<Contact>();
		
        List<Account> AccWithOne = [SELECT Id FROM Account WHERE Number_of_Contacts__c = 1];
        for(Integer i = 0 ; i < AccWithOne.size() ; i++){
            conList.add(new Contact(LastName='TestConA'+ i, AccountId=AccWithOne[i].id));
            conList.add(new Contact(LastName='TestConB'+ i, AccountId=AccWithOne[i].id));

        }

        List<Account> AccWithTwo = [SELECT Id, (SELECT Id, AccountId FROM Contacts) FROM Account WHERE Number_of_Contacts__c = 2];
        for(Account acc : AccWithTwo){
            for(Contact con : acc.Contacts){
                con.AccountId = null;
                conList.add(con);
            }
        }
        
        List<Account> AccWithThree = [SELECT Id, (SELECT Id, AccountId FROM Contacts) FROM Account WHERE Number_of_Contacts__c = 3];
        for(Account acc : AccWithThree){
            	conList.add(new Contact(LastName='TestConG', AccountId=acc.id));
                conList.add(new Contact(LastName='TestConK', AccountId=acc.id));
        }
        try{
        	upsert conList;
        }catch (exception e){
            System.debug('-------------->'+e);
        }
            
        Integer withOne = [SELECT Count() FROM Account WHERE Number_of_Contacts__c = 1];
        	System.assertEquals(0, withOne);
        	Integer withTwo = [SELECT Count() FROM Account WHERE Number_of_Contacts__c = 2];
        	System.assertEquals(0, withTwo);
        	Integer withFive = [SELECT Count() FROM Account WHERE Number_of_Contacts__c > 3];
        	System.assertEquals(30, withFive);
	}

	@isTest
    public static void testDeleteUndelete(){
        List<Account> accList = [SELECT Id, (SELECT Id, AccountId FROM Contacts) FROM Account WHERE Number_of_Contacts__c > 0];
        List<Contact> conList = new List<Contact>();
        for(Account acc : accList){
            for(Contact con : acc.Contacts){
                con.AccountId = null;
                conList.add(con);
            }
        }
		System.assertEquals(100, accList.size());

        delete conList;

        Integer accsWithContacts = [SELECT Count() FROM Account WHERE Number_of_Contacts__c > 0];
        System.assertEquals(0, accsWithContacts);
        
        conList = [SELECT Id, IsDeleted FROM Contact WHERE IsDeleted = true ALL ROWS];
        System.debug(conList.size());
        try{
        	undelete conList;
        }catch(DmlException e){
            System.debug(e);
        }
		Integer accsWithContacts2 = [SELECT Count() FROM Account WHERE Number_of_Contacts__c > 0];
        System.assertEquals(100, accsWithContacts2);
    }
}