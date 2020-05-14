public class CaseTriggerHelper {
    public static void sumCasesOnAccount(List<Case> newTrigger, Boolean isDeleted){
  		Set<Id> idList = new Set<Id>();
        Set<Id> deletedCaseList = new Set<Id>();
        
        for(case ca : newTrigger){
            idList.add(ca.AccountId);
            if(isDeleted){
            	deletedCaseList.add(ca.Id);
            }
        }
        
        List<Account> accList = [SELECT Id, Number_of_Open_Cases__c,
                                       		(SELECT Id
                                             FROM Cases
                                             WHERE Id NOT IN :deletedCaseList AND isClosed = False) 
                                 FROM Account 
                                 WHERE Id IN :idList];
        
        for(Account acc : accList){
                acc.Number_of_Open_Cases__c = acc.Cases.size();
        }
        
        upsert accList;
    }
}