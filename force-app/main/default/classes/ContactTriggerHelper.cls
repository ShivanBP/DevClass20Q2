public class ContactTriggerHelper {
    public static void sumContactsOnAccount(List<Contact> newTrigger, Boolean isDeleted){
        Set<Id> idList = new Set<Id>();
        Set<Id> deletedConList = new Set<Id>();
        
        for(Contact con : newTrigger){
            idList.add(con.AccountId);
            if(isDeleted){
                deletedConList.add(con.Id);
            }
        }
        
        
        List<Account> accList = [SELECT Id, Number_of_Contacts__c, 
                                 	(SELECT Id
                                  	FROM Contacts
                                  	WHERE Id NOT IN :deletedConList) 
                                 FROM Account 
                                 WHERE Id IN :idList];
        
        for(Account acc : accList){
            acc.Number_of_Contacts__c = acc.Contacts.size();
        }
        
        upsert accList;
    }
}