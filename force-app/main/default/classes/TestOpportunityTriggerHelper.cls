@isTest
private class TestOpportunityTriggerHelper {
    
    private static final String ERROR_SUFFIX = 'role requirement for this stage is not fulfilled.';
    
    @TestSetup
    public static void createTestData() {
        //Create Stage Rules
        List<StageRules__c> stageRuleList = new List<StageRules__c>();
        StageRules__c stageRule1 = new StageRules__c(Name = 'Value Proposition', Mandatory_Roles__c = 'Business User');
        stageRuleList.add(stageRule1);
        StageRules__c stageRule2 = new StageRules__c(Name = 'Proposal//Price Quote', Mandatory_Roles__c = 'Business User;Decision Maker');
        stageRuleList.add(stageRule2);
        StageRules__c stageRule3 = new StageRules__c(Name = 'Closed Won', Mandatory_Roles__c = 'Business User;Decision Maker;Economic Buyer');
        stageRuleList.add(stageRule3);
        
        insert stageRuleList;
        
        //Create contacts
        List<Contact> conList = new List<Contact>();
        Contact con1 = new Contact(Salutation = 'Mr', LastName = 'BusinessUser');
        conList.add(con1);
        Contact con2 = new Contact(Salutation = 'Miss', LastName = 'DecisionMaker');       
        conList.add(con2);
        Contact con3 = new Contact(Salutation = 'Mrs', LastName = 'Economic Buyer');
        conList.add(con3);
        
        insert conList;
        
        //Create Opportunity
        List<Opportunity> oppList = new List<Opportunity>();
        
        for(Integer i = 0 ; i < 200 ; i++){
            Opportunity opp = new Opportunity(Name = 'TestOpp' + i, StageName = 'notARealPicklistValue', CloseDate = Date.today());
            oppList.add(opp);
        }
        
        insert oppList;
        
        //Add Contact Roles to Opportunites
        List<OpportunityContactRole> opcList = new List<OpportunityContactRole>();
        for(Integer i = 0 ; i < oppList.size() ; i++) {
            if(i < 100){
                OpportunityContactRole opc = new OpportunityContactRole(ContactId = con1.Id, OpportunityId = oppList[i].Id, Role = 'Business User');
                opcList.add(opc);                
                if( i < 50){
                    OpportunityContactRole opc2 = new OpportunityContactRole(ContactId = con2.Id, OpportunityId = oppList[i].Id, Role = 'Decision Maker');                
                    opcList.add(opc2);
                }
                if(i < 25){
                    OpportunityContactRole opc3 = new OpportunityContactRole(ContactId = con3.Id, OpportunityId = oppList[i].Id, Role = 'Economic Buyer');
                    opcList.add(opc3);
                }
            }
        }
        
        Database.SaveResult[] resultList;        
        try{
            resultList = Database.insert(opcList, false);
        }catch(Exception e){
            Boolean expectedExceptionThrown =  e.getMessage().contains(ERROR_SUFFIX);
            System.AssertEquals(true, expectedExceptionThrown);
        }
    }
    
    @isTest
    public static void testInsert(){
        Integer gotInserted = [SELECT Count() FROM Opportunity WHERE NAME LIKE 'TestOpp%'];
        System.assertEquals(200, gotInserted);
    }
    
    @isTest
    public static void testFirstStage(){
        List<Opportunity> oppList = [SELECT Id, StageName FROM Opportunity WHERE NAME LIKE 'TestOpp%'];
        System.debug(oppList.size());
        for(Opportunity opp : oppList){
            opp.StageName = 'Value Proposition';  
        }
        
        Database.SaveResult[] resultList;        
        try{
            resultList = Database.update(oppList, false);
        }catch(Exception e){
            Boolean expectedExceptionThrown =  e.getMessage().contains(ERROR_SUFFIX);
            System.AssertEquals(true, expectedExceptionThrown);
        }
        
        Integer gotToFirstStage = [SELECT Count() FROM Opportunity WHERE NAME LIKE 'TestOpp%' AND StageName = 'Value Proposition'];
        System.assertEquals(100, gotToFirstStage);
    }
    
    @isTest
    public static void testSecondStage(){
        List<Opportunity> oppList = [SELECT Id, StageName FROM Opportunity WHERE NAME LIKE 'TestOpp%'];
        System.debug(oppList.size());
        for(Opportunity opp : oppList){
            opp.StageName = 'Proposal//Price Quote';  
        }
        
        Database.SaveResult[] resultList;        
        try{
            resultList = Database.update(oppList, false);
        }catch(Exception e)
        {
            Boolean expectedExceptionThrown =  e.getMessage().contains(ERROR_SUFFIX);
            System.AssertEquals(true, expectedExceptionThrown);
        }
        
        Integer gotToSecondStage = [SELECT Count() FROM Opportunity WHERE NAME LIKE 'TestOpp%' AND StageName = 'Proposal//Price Quote'];
        System.assertEquals(50, gotToSecondStage);
    }
    
    @isTest
    public static void testThirdStage(){
        List<Opportunity> oppList = [SELECT Id, StageName FROM Opportunity WHERE NAME LIKE 'TestOpp%'];
        System.debug(oppList.size());
        for(Opportunity opp : oppList){
            opp.StageName = 'Closed Won';  
        }
        
        Database.SaveResult[] resultList;        
        try{
            resultList = Database.update(oppList, false);
        }catch(Exception e){
            Boolean expectedExceptionThrown =  e.getMessage().contains(ERROR_SUFFIX);
            System.AssertEquals(true, expectedExceptionThrown);
        }
        
        Integer gotToThirdStage = [SELECT Count() FROM Opportunity WHERE NAME LIKE 'TestOpp%' AND StageName = 'Closed Won'];
        System.assertEquals(25, gotToThirdStage);
    }
    
    @isTest
    public static void testNoRuleStage(){
        List<Opportunity> oppList = [SELECT Id, StageName FROM Opportunity];
        for(Opportunity opp : oppList){
            opp.StageName = 'Qualification';
        }
        upsert oppList;
        Integer gotToNoRuleStage = [SELECT Count() FROM Opportunity WHERE NAME LIKE 'TestOpp%' AND StageName = 'Qualification'];
        System.assertEquals(200, gotToNoRuleStage);
    }
    
    @isTest
    public static void testUndelete(){
        List<Opportunity> oppList = [SELECT Id, StageName FROM Opportunity];
        for(Integer i = 0 ; i < oppList.size() ; i++) {
            if(i < 100){
            	oppList[i].StageName = 'Qualification';
            }else{
            	oppList[i].StageName = 'Prospecting';
            }
        }
        upsert oppList;
        delete oppList;

        StageRules__c stageRule4 = new StageRules__c(Name = 'Qualification', Mandatory_Roles__c = 'Evaluator');
        insert stageRule4;
        
        System.debug('-------' + oppList.size());
        
        try{
			Database.undelete(oppList, false);	
        }catch(DmlException e){
            Boolean expectedExceptionThrown =  e.getMessage().contains(ERROR_SUFFIX);
            System.AssertEquals(true, expectedExceptionThrown);
        }
        Integer gotToNoRuleStage = [SELECT Count() FROM Opportunity WHERE NAME LIKE 'TestOpp%'];
        System.assertEquals(100, gotToNoRuleStage);
    }
}