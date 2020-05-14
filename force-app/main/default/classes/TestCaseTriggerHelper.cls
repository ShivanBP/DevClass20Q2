@isTest
public class TestCaseTriggerHelper {
    @testSetup
    public static void testSetup(){
        //Create Accounts
        List<Account> accList = new List<Account>();
        for(Integer i = 0; i < 200 ; i ++){
            accList.add(new Account(Name='TestAcc' + i));
        }
        
        insert accList;
        
        //Create Cases
        List<Case> caseList = new List<Case>();
        for(Integer i = 0; i < 200 ; i ++){
            if(i < 100){ //+100 Case
                caseList.add(new Case(Origin='Phone', Status='New', AccountId=accList[i].id));
            }
            if (i < 50){ //50 Case
            	caseList.add(new Case(Origin='Phone', Status='New', AccountId=accList[i].id));
            }
            if(i < 15){ //+50 Case
            	caseList.add(new Case(Origin='Phone', Status='New', AccountId=accList[i].id));
                caseList.add(new Case(Origin='Phone', Status='New', AccountId=accList[i].id));
            }
        }
        insert caseList;
    }
    
    @isTest 
    public static void testInsert(){
        Integer withNull = [SELECT Count() FROM Account WHERE Number_of_Open_Cases__c = null];
        System.assertEquals(100, withNull);
        Integer withOne = [SELECT Count() FROM Account WHERE Number_of_Open_Cases__c = 1];
        System.assertEquals(50, withOne);
        Integer withTwo = [SELECT Count() FROM Account WHERE Number_of_Open_Cases__c = 2];
        System.assertEquals(35, withTwo);
        Integer withThree = [SELECT Count() FROM Account WHERE Number_of_Open_Cases__c = 4];
        System.assertEquals(15, withThree);
    }
    
    @isTest 
    public static void testUpdateAddCase(){
        List<Case> caseList = new List<Case>();
        List<Account> accList = [SELECT Id FROM Account WHERE NAME LIKE '%TestAcc%'];
        for(Account acc : accList){
            caseList.add(new Case(Origin='Phone', Status='New', AccountId=acc.id));
            caseList.add(new Case(Origin='Phone', Status='New', AccountId=acc.id));
        }
        upsert caseList;
                
        Integer withTwo = [SELECT Count() FROM Account WHERE Number_of_Open_Cases__c = 2];
        System.assertEquals(100, withTwo);  
        Integer withThree = [SELECT Count() FROM Account WHERE Number_of_Open_Cases__c = 3];
        System.assertEquals(50, withThree);
        Integer withFour = [SELECT Count() FROM Account WHERE Number_of_Open_Cases__c = 4];
        System.assertEquals(35, withFour);
        Integer withSix = [SELECT Count() FROM Account WHERE Number_of_Open_Cases__c = 6];
        System.assertEquals(15, withSix);
    }
    
    @isTest 
    public static void testUpdateCloseAndReparent(){
        List<Account> accList = [SELECT Id, (SELECT Id, AccountId, Status FROM Cases) FROM Account WHERE NAME LIKE '%TestAcc%'];
        List<Case> caseList = new List<Case>();
        System.assertEquals(200, accList.size());
        Integer i = 0;
        for(Account acc : accList){
            for(Case c : acc.Cases){
                if(math.mod(i, 2) == 0){
                	c.Status = 'Closed';
                }else{
                    c.AccountId = null;
                }
            	caseList.add(c);
            }
            i++;
        }

        update caseList;
               
        Integer accsWithCases = [SELECT Count() FROM Account WHERE Number_of_Open_Cases__c > 1];
        System.assertEquals(0, accsWithCases);
    
    	//Reopen Cases
        accList = [SELECT Id, (SELECT Id, AccountId, Status FROM Cases) FROM Account WHERE NAME LIKE '%TestAcc%'];
        Set<String> howManyAccs = new Set<String>();
        caseList.clear();
    	for(Account acc : accList){
        	for(Case c : acc.Cases){
                c.Status = 'New';
                howManyAccs.add(c.accountId);
                caseList.add(c);
            }
        }
		
        try{
        	update caseList;
        }catch (exception e){
            System.debug('-------------->'+e);
        }        
        accsWithCases = [SELECT Count() FROM Account WHERE Number_of_Open_Cases__c > 0];
        System.assertEquals(howManyAccs.size(), accsWithCases);
    }
    
    @isTest
    public static void testDeleteUndelete(){
        List<Account> accList = [SELECT Id, (SELECT Id, AccountId FROM Cases) FROM Account WHERE Number_of_Open_Cases__c > 0];
        List<Case> caseList = new List<Case>();
        System.assertEquals(100, accList.size());
        for(Account acc : accList){
            for(Case c : acc.Cases){
                caseList.add(c);
            }
        }
        
        delete caseList;
        
        Integer accsWithCases = [SELECT Count() FROM Account WHERE Number_of_Open_Cases__c > 0];
        System.assertEquals(0, accsWithCases);
        
        caseList = [SELECT Id FROM Case WHERE IsDeleted = true ALL ROWS];
        System.debug(caseList.size());
        undelete caseList;
        
		accsWithCases = [SELECT Count() FROM Account WHERE Number_of_Open_Cases__c > 0];
        System.assertEquals(100, accsWithCases); 
    }
}