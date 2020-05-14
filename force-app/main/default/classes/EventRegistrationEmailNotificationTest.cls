@isTest
public class EventRegistrationEmailNotificationTest {
	@isTest
    static void testOnRegistrationEmail(){
        Event__c event = new Event__c(Name = 'MegaRave');
        insert event;
    	Event_Registration__c er = new Event_Registration__c(FirstName__c = 'Doe',
                                                         	 LastName__c = 'John',
                                                         	 Email__c = 'notareal@email.com',
                                                         	 Event__c = event.id);
        Test.startTest();
      		Integer emailbefore = Limits.getEmailInvocations();
        	insert er;
      		system.assertNotEquals(emailbefore,Limits.getEmailInvocations(),'should have decreased');
      	Test.stopTest();
    }
    
    @isTest
    static void testRegistrationDeletionEmail(){
        Event__c event = new Event__c(Name = 'MegaRave');
        insert event;
    	Event_Registration__c er = new Event_Registration__c(FirstName__c = 'Doe',
                                                         	 LastName__c = 'John',
                                                         	 Email__c = 'notareal@email.com',
                                                         	 Event__c = event.id);
        insert er;
        RegistrationDeletionEmailAdress__c bossesEmail = new RegistrationDeletionEmailAdress__c(Name = 'BigBoss', Email__c = 'big@boss.com');
        insert bossesEmail;
        
        Test.startTest();
        	System.debug(er);
        	Integer emailbefore = Limits.getEmailInvocations();
        	delete er;
      		system.assertNotEquals(emailbefore,Limits.getEmailInvocations(),'should have decreased');
    	Test.stopTest();
    }
}